//
//  DeliveryOrderVc.swift
//  DriverApp
//
//  Created by Indo Office4 on 09/02/21.
//

import UIKit
import GoogleMaps
import CoreLocation
import JGProgressHUD
import LanguageManager_iOS

enum MapsTypeDelivery {
    case folowing
    case bounds
    case free
}

enum CardStateDelivery {
    case expanded
    case collapsed
}

@available(iOS 13.0, *)
class DeliveryOrderVc: UIViewController {
    
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading".localiz()
        
        return spin
    }()
    
    var currentOrder: String!
    
    var cardViewController:DeliveryDetail!
    
    let cardHeight:CGFloat = UIScreen.main.bounds.height / 2
    var cardHandleAreaHeight:CGFloat = 130
    
    var cardVisible = false
    var nextState:CardStateDelivery {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    var order:NewOrderData? = nil
    var mapsViewModel = MapsViewModel()
    var orderViewModel = OrderViewModel()
    var inOutVm = InOutViewModel()
    var databaseM = DatabaseManager()
    var appear: Bool = false
    
    
    var shift: ShiftTime! {
        didSet {
            getDataOrder(id_shift_time: shift.id_shift_time, cek: false, waypoints: true)
            appear = true
        }
    }
    
    var deliveryList: [NewDelivery]!
    var pickupList: [Pickup]!
    
    var mapsType: MapsTypeDelivery = .free
    
    var oldPolyLines = [GMSPolyline]()
    var oldMarkers = [GMSMarker]()
    
    var currentStore: Pickup!
    
    var databaseManager = DatabaseManager()
    
    var origin: Origin?
    var destination: Destination?
    var positions = [CLLocationCoordinate2D]()
    
    private var manager: CLLocationManager?
    private var locationManager: CLLocationManager?
    
    var originMarker: GMSMarker = {
        let marker = GMSMarker()
        let car = UIImage(named: "car")
        let carIcon = car?.resizeImage(CGSize(width: 25, height: 25))
        let icon: UIImageView = {
            let i = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 40))
            i.image = carIcon
            return i
        }()
        marker.groundAnchor = CGPoint(x: 0.25, y: 0.5)
        marker.isFlat = true
        marker.iconView = icon
        return marker
    }()
    
    lazy var mapsButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "location")
        let baru = image?.resizeImage(CGSize(width: 25, height: 25))
        button.backgroundColor = UIColor(named: "whiteKasumi")
        button.setImage(baru, for: .normal)
        button.layer.cornerRadius = 50/2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(myPosition), for: .touchUpInside)
        return button
    }()
    
    @objc
    func myPosition(){
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
        mapsType = .free
    }
    
    lazy var directionButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "upload")
        let baru = image?.resizeImage(CGSize(width: 25, height: 25))
        button.backgroundColor = UIColor(named: "whiteKasumi")
        button.setImage(baru, for: .normal)
        button.layer.cornerRadius = 50/2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(dire), for: .touchUpInside)
        return button
    }()
    
    @objc func dire(){
        mapsType = .folowing
    }
    
    let mapView: GMSMapView = {
        let mapView = GMSMapView()
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor(named: "whiteKasumi")
        title = "Live Tracking".localiz()
        
        
        view.insertSubview(mapView, at: 0)
        view.insertSubview(mapsButton, at: 1)
        view.insertSubview(directionButton, at: 2)
        
        mapsButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 20, paddingRight: 16, width: 50, height: 50)
        directionButton.anchor(top: mapsButton.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingRight: 16, width: 50, height: 50)

        
        mapView.frame = view.bounds
        myPosition()
        
        configureNavigationBar()
        
        mapsViewModel.delegate = self
        
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mapsButton.dropShadow(color: .black, opacity: 0.5, offSet: CGSize(width: 2, height: 2), radius: 50/2, scale: true)
        directionButton.dropShadow(color: .black, opacity: 0.5, offSet: CGSize(width: 2, height: 2), radius: 50/2, scale: true)
        
        if cardViewController != nil {
            cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
            cardVisible = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        manager?.stopUpdatingLocation()
        manager?.stopUpdatingHeading()
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func cekOrderWaiting(){
        currentOrder = nil
        getDataOrder(id_shift_time: shift.id_shift_time, cek: true)
        cardViewController.view.frame.origin.y = view.frame.height - cardHandleAreaHeight
        cardVisible = false
    }
    
    func backToStore(){
        myPosition()
        manager?.stopUpdatingLocation()
        manager?.stopUpdatingHeading()
        
        cardViewController.view.frame.origin.y = view.frame.height - cardHandleAreaHeight
        cardVisible = false
        
        cardViewController.display = .done
        
        guard let storeSession = UserDefaults.standard.value(forKey: "queue1") as? [String: Any],
              let pickup_store_name = storeSession["pickup_store_name"] as? String,
              let storeAddress =  storeSession["store_address"] as? String,
              let lat = storeSession["lat"] as? String,
              let long = storeSession["long"] as? String,
              let orderNo = storeSession["order_number"] as? String,
              let status = storeSession["status_tracking"] as? String,
              let activeDate = storeSession["active_date"] as? String,
              let queue = storeSession["queue"] as? Int,
              let distance =  storeSession["distance"] as? Double,
              let pendingStatus = storeSession["pending_by_system"] as? Bool,
              let idShiftTime = storeSession["id_shift_time"] as? Int
              else {
            print("No data")
            return
        }
        let store: Pickup = Pickup(pickup_store_name: pickup_store_name,
                                   store_address: storeAddress,
                                   lat: lat,
                                   long: long,
                                   pickup_item: nil,
                                   order_number: orderNo,
                                   classification: nil,
                                   status_tracking: status,
                                   active_date: activeDate,
                                   queue: queue,
                                   distance: distance,
                                   pending_by_system: pendingStatus,
                                   id_shift_time: idShiftTime)
        let destinationStore = Destination(latitude: CLLocationDegrees(store.lat)!, longitude: CLLocationDegrees(store.long)!)
        cardViewController.store = store
        destination = destinationStore
        
        upateLocation()
    }
    
    private func CekWaiting(){
        let filterStatus = deliveryList.filter({$0.status_tracking == "waiting delivery"})
        let sortedList = filterStatus.sorted(by: {$0.queue < $1.queue})
        
        if sortedList.count != 0 {
            guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
                  let codeDriver = userData["codeDriver"] as? String else {
                print("No user data")
                return
            }
            
            let destinationPickup = Destination(latitude: CLLocationDegrees(sortedList[0].lat)!, longitude: CLLocationDegrees(sortedList[0].long)!)
            destination = destinationPickup
            myPosition()
            getCurrentPosition()
            cardViewController.order = sortedList[0]
            cardViewController.display = .start_pickup
            self.navigationItem.hidesBackButton = true
            spiner.show(in: view)
            let data = Delivery(status: "delivery", order_number: sortedList[0].order_number, type: "start")
            self.orderViewModel.statusOrder(data: data) { (result) in
                self.handleResult(result: result)
                self.databaseM.setCurrentOrder(orderNo: sortedList[0].order_number, status: "delivery", codeDriver: codeDriver) { (re) in
                    print(re)
                }
            }
        }
    }
    
    private func cekCurrentOrder(){
        let filterStatus = deliveryList.filter({$0.order_number == currentOrder})
        let sortedList = filterStatus.sorted(by: {$0.queue < $1.queue})
        
        let destinationPickup = Destination(latitude: CLLocationDegrees(sortedList[0].lat)!, longitude: CLLocationDegrees(sortedList[0].long)!)
        destination = destinationPickup
        myPosition()
        getCurrentPosition()
        cardViewController.order = sortedList[0]
        cardViewController.display = .start_pickup
    }
    
    private func setupCard() {
        cardViewController = DeliveryDetail()
        self.addChild(cardViewController)
        self.view.addSubview(cardViewController.view)
        cardViewController.delegate = self
        cardViewController.display = .initial
        
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        
        cardViewController.view.clipsToBounds = false
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
        
        cardViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc
    private func handleCardPan(recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
            
            switch recognizer.direction{
            case .topToBottom:
                print("top to botom")
            case .bottomToTop:
                print("btm to top")
            default:
                print("default")
            }
        case .changed:
            let translation = recognizer.translation(in: self.cardViewController.handleArea)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
            
           
        case .ended:
            continueInteractiveTransition()
            
        default:
            break
        }
        
    }
    
    private func getDataOrder(id_shift_time: Int, cek: Bool? = false, waypoints: Bool? = false){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        spiner.show(in: view)
        
        orderViewModel.getDataOrder(codeDriver: codeDriver, shift: id_shift_time) {[weak self] (res) in
            switch res {
            case .failure(_):
                DispatchQueue.main.async {
                    self?.deliveryList = []
                    self?.spiner.dismiss()
                }
            case .success(let order):
                DispatchQueue.main.async {
                    self?.pickupList = order.pickup_list
                    let filteredPickup = order.delivery_list?.filter({$0.distance != 0})
                    let sortPickup = filteredPickup?.sorted(by: {$0.queue < $1.queue})
                    let list = order.delivery_list!.sorted(by: {$0.queue < $1.queue})
                    self?.deliveryList = list
                    let newPositions = sortPickup?.map({ CLLocationCoordinate2D(latitude: CLLocationDegrees($0.lat)!, longitude: CLLocationDegrees($0.long)!) })
                    self?.positions = newPositions!
                    
                    if waypoints == true {
                        self?.drawWaypoints()
                    }
                    
                    self?.spiner.dismiss()
                    
                    self?.setupCard()
                    
                    if cek! == true {
                        self?.CekWaiting()
                    }
                    
                    if self?.currentOrder != nil {
                        self?.cekCurrentOrder()
                    }
                }
            }
        }
    }
    
    private func drawWaypoints(){
        mapsViewModel.getDotsToDrawRoute(positions: positions) {markers, poli  in
            DispatchQueue.main.async {
                if let poli = poli {
                    _ = poli.map { p in
                        p.map = self.mapView
                        self.oldPolyLines.append(p)
                    }
                }
                
                if let markers = markers {
                    _ = markers.map { marker in
                        marker.map = self.mapView
                        self.oldMarkers.append(marker)
                    }
                }
                
                self.focusMapToShowAllMarkers(arrMarkers: markers!)
            }
        }
    }
    
    private func focusMapToShowAllMarkers(arrMarkers: [GMSMarker]) {

        if arrMarkers.count > 0 {
            let firstLocation = (arrMarkers.first!).position
            var bounds = GMSCoordinateBounds(coordinate: firstLocation, coordinate: firstLocation)

            for marker in arrMarkers {
              bounds = bounds.includingCoordinate(marker.position)
            }

            let update = GMSCameraUpdate.fit(bounds, withPadding: CGFloat(150))
            self.mapView.animate(with: update)
        }
    }
    
    func getCurrentPosition(){
        manager = CLLocationManager()
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.requestWhenInUseAuthorization()
        manager?.startUpdatingLocation()
        manager?.delegate = self
    }
    
    private func upateLocation(){
        print("update Location")
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String,
              let lat = origin?.latitude,
              let long = origin?.longitude  else {
            print("No user data")
            return
        }
        let data: CheckinData = CheckinData(code_driver: codeDriver, lat: String(lat), long: String(long))
        spiner.show(in: view)
        inOutVm.updateLastPosition(data: data) { (res) in
            switch res {
            
            case .success(_):
                DispatchQueue.main.async {
                    self.spiner.dismiss()
                }
            case .failure(_):
                self.spiner.dismiss()
            }
        }
    }
    
    
    func configureNavigationBar(){
        let image = UIImage(named: "chatIcon")
        let baru = image?.resizeImage(CGSize(width: 25, height: 25))
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: baru, style: .plain, target: self, action: #selector(onClickChatButton))
    }
    
    @objc
    func onClickChatButton(){
        let vc = ChatView()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK - maps direction
@available(iOS 13.0, *)
extension DeliveryOrderVc: MapsViewModelDelegate {
    func didDrawDirection(_ viewModel: MapsViewModel, direction: GMSPolyline, markerOrigin: GMSMarker, markerDestination: GMSMarker, camera: GMSCameraPosition) {
        
        if self.oldPolyLines.count > 0 {
            for polyline in self.oldPolyLines {
                polyline.map = nil
            }
        }
        
        if self.oldMarkers.count > 0 {
            for marker in self.oldMarkers {
                marker.map = nil
            }
        }
        
        
        self.oldPolyLines.append(direction)
        self.oldMarkers.append(markerDestination)
        direction.map = mapView
        markerDestination.map = mapView
    }
    
    func didFailedDrawDirection(_ error: Error) {
        print(error)
    }
    
    
}


//MARK: - CORE LOCATION DELEGATE
@available(iOS 13.0, *)
extension DeliveryOrderVc: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let coordinate = location.coordinate
            
            //MARK: - INITIAL POSITION
            if manager == locationManager {
                let camera = GMSCameraPosition(latitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 19)
                mapView.animate(to: camera)
                
                mapView.animate(toZoom: 17.0)
                mapView.animate(toViewingAngle: 0)
                mapView.animate(toBearing: location.course)
                let point = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                   longitude: location.coordinate.longitude)
                originMarker.position = point
                originMarker.map = mapView
                updateMarkerWith(position: point, angle: location.course)
                locationManager?.stopUpdatingLocation()
            }
            
            //MARK: -   DATA UPDATE LOCATION TO FIREBASE
            let status: String = "active"
            guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
                  let codeDriver = userData["codeDriver"] as? String,
                  let idDriver = userData["idDriver"] as? Int else {
                print("No user data")
                return
            }
            
            //MARK: -   UPDATE LOCATION TO FIREBASE
            databaseManager.updateData(idDriver: String(idDriver), codeDriver: codeDriver, lat: coordinate.latitude, lng: coordinate.longitude, status: status,bearing: location.course) { (res) in
                switch res {
                case .failure(let err):
                    print(err)
                case .success(let oke):
                    if oke {
                        print("succes update location to firebase")
                    }
                }
            }
            
            
            //MARK: -   MARKER AND DIRECTION
            origin = Origin(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            guard let origin = origin, let destination = destination else {
                return
            }
            
            let direction: DirectionData = DirectionData(origin: origin, destination: destination)
            
            self.mapsViewModel.drawDirection(direction: direction)
            
            
            let point = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                               longitude: location.coordinate.longitude)
            let dest = CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude)
            updateMarkerWith(position: point, angle: location.course)
            
            switch mapsType {
            case .bounds:
                fitToBounds(origin: point, destination: dest)
            case .folowing:
                mapView.animate(toBearing: location.course)
                mapView.animate(toViewingAngle: 40)
                folowUser(point: point)
            default:
                print("free")
            }
            
            CATransaction.commit()
            
//          MARK:- DISTANCE MATRIX
            mapsViewModel.getDistance(origin: origin, destination: destination) { (res) in
                switch res {
                case .failure(let err):
                    print(err)
                case .success(let data):
                    DispatchQueue.main.async {
                        if self.cardViewController !== nil {
                            self.cardViewController.estLabel.text = "\(data.time)"
                            self.cardViewController.distanceLabel.text = "\(data.distance)"
                        }
                    }
                }
            }
        }
    }
    
    func updateMarkerWith(position: CLLocationCoordinate2D, angle: Double) {
        originMarker.position = position
        
        guard angle >= 0 && angle < 360 else {
            return
        }
        let angleInRadians: CGFloat = CGFloat(angle) * .pi / CGFloat(180)
        originMarker.iconView?.transform = CGAffineTransform.identity.rotated(by: angleInRadians)
    }
    
    //MARK: - fit two markers
    func fitToBounds(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D){
        CATransaction.begin()
        CATransaction.setAnimationDuration(2.0)
        let bounds = GMSCoordinateBounds(coordinate: origin, coordinate: destination)
        mapView.camera(for: bounds, insets: UIEdgeInsets())
        CATransaction.commit()
    }
    
    //MARK: - FOLOW CAR
    func folowUser(point: CLLocationCoordinate2D){
        CATransaction.begin()
        CATransaction.setAnimationDuration(2.0)
        mapView.animate(toLocation: point)
        CATransaction.commit()
    }
}


@available(iOS 13.0, *)
extension DeliveryOrderVc {
    func animateTransitionIfNeeded (state:CardStateDelivery, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
        }
    }
    
    func startInteractiveTransition(state:CardStateDelivery, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}


@available(iOS 13.0, *)
extension DeliveryOrderVc: DeliveryDetailDelegate {
    func doneBackToStore(_ viewC: DeliveryDetail) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        UserDefaults.standard.removeObject(forKey: "queue1")
    }
    
    func pending(_ viewC: DeliveryDetail, order: NewDelivery?) {
        let filterStatus = pickupList.filter({$0.status_tracking == "waiting delivery"})
        let vc = PendingNoteVc()
        vc.orderNo = order?.order_number
        vc.idShiftTime = order?.id_shift_time
        vc.delegate2 = self
        vc.isLast = filterStatus.count <= 1
        let navVc = UINavigationController(rootViewController: vc)
        navVc.modalPresentationStyle = .fullScreen
        present(navVc, animated: true, completion: nil)
    }
    
    func scan(_ viewC: DeliveryDetail, order: NewDelivery?) {
        spiner.show(in: view)
        let data = Delivery(status: "delivery", order_number: order!.order_number, type: "done")
        self.orderViewModel.statusOrder(data: data) { (result) in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.navigationItem.hidesBackButton = false
                    guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
                          let codeDriver = userData["codeDriver"] as? String else {
                        print("No user data")
                        return
                    }
                    let filterStatus = self.deliveryList.filter({$0.status_tracking == "waiting delivery"})
                    self.databaseM.removeCurrentOrder(orderNo: order!.order_number, codeDriver: codeDriver) { (res) in
                        print(res)
                    }
                    self.upateLocation()
                    self.spiner.dismiss()
                    let vc = DoneViewController()
                    vc.delegate = self
                    vc.isLast = filterStatus.count <= 1
                    let navVc = UINavigationController(rootViewController: vc)
                    
                    self.present(navVc, animated: true, completion: nil)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error)
                }
            }
        }
    }
    
    func didTapButton(_ viewModel: DeliveryDetail, type: TypeDelivery) {
        print("oke")
    }
    
    //start delivery
    func startPickup(_ viewC: DeliveryDetail) {
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        let filterStatus = deliveryList.filter({$0.status_tracking == "waiting delivery"})
        let sortedList = filterStatus.sorted(by: {$0.queue < $1.queue})
        
        let destinationPickup = Destination(latitude: CLLocationDegrees(sortedList[0].lat)!, longitude: CLLocationDegrees(sortedList[0].long)!)
        destination = destinationPickup
        myPosition()
        getCurrentPosition()
        cardViewController.order = sortedList[0]
        cardViewController.display = .start_pickup
        self.navigationItem.hidesBackButton = true
        spiner.show(in: view)
        let data = Delivery(status: "delivery", order_number: sortedList[0].order_number, type: "start")
        self.orderViewModel.statusOrder(data: data) { (result) in
            self.handleResult(result: result)
            self.databaseM.setCurrentOrder(orderNo: sortedList[0].order_number, status: "delivery", codeDriver: codeDriver) { (re) in
                print(re)
            }
        }
    }
    
    private func handleResult(result: Result<Bool, Error>){
        switch result {
        case .success(_):
            DispatchQueue.main.async {
                self.spiner.dismiss()
            }
        case .failure(let error):
            DispatchQueue.main.async {
                self.spiner.dismiss()
                print(error)
            }
        }
    }
}
