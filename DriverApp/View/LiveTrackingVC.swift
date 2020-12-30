//
//  LiveTrackingVC.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 18/10/20.
//

import UIKit
import GoogleMaps
import CoreLocation
import JGProgressHUD
import LanguageManager_iOS

@available(iOS 13.0, *)
class LiveTrackingVC: UIViewController {
    
    //    loading
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading".localiz()
        
        return spin
    }()
    
    //    card
    
    enum CardState {
        case expanded
        case collapsed
        case full
    }
    
    var cardViewController:CardViewController!
    var visualEffectView:UIVisualEffectView!
    
    let cardHeight:CGFloat = UIScreen.main.bounds.height - 110
    let cardFullHeight:CGFloat = UIScreen.main.bounds.height - 110
    var cardHandleAreaHeight:CGFloat = 110
    
    var cardVisible = false
    var cardFull = false
    var nextState:CardState {
        return cardVisible ? .collapsed : cardFull ? .full : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    //    order
    
    var order:NewOrderData? = nil
    var mapsViewModel = MapsViewModel()
    var orderViewModel = OrderViewModel()
    var inOutVm = InOutViewModel()
    var databaseM = DatabaseManager()
    
    enum MapsType {
        case folowing
        case bounds
        case free
    }
    
    var mapsType: MapsType = .free
    
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
        button.backgroundColor = UIColor(named: "grayKasumi")
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
        button.backgroundColor = UIColor(named: "grayKasumi")
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
    
    var oldPolyLines = [GMSPolyline]()
    var oldMarkers = [GMSMarker]()
    
    var currentStore: PickupDestination!
    
    var databaseManager = DatabaseManager()
    
    
    //origin
    var origin: Origin?
    var destination: Destination?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .white
        title = "Live Tracking".localiz()
        
        
        view.insertSubview(mapView, at: 0)
        view.insertSubview(mapsButton, at: 1)
        view.insertSubview(directionButton, at: 2)
        
        mapsButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 20, paddingRight: 16, width: 50, height: 50)
        directionButton.anchor(top: mapsButton.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingRight: 16, width: 50, height: 50)

        
        
        guard let orderDetailString = order?.order_detail,
              let orderNo = order?.order_number,
              let orderDetail = orderViewModel.decryptOrderDetail(data: orderDetailString, OrderNo: orderNo),
              let statusOrder = order?.status_tracking else {
            
            return
        }
        
        //MARK: - GET DETAIL ORDER
        spiner.show(in: view)
        orderViewModel.getDetailOrder(orderNo: orderNo) {[weak self] (result) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.order = data
                    self?.setupCard()
                    self?.spiner.dismiss()
                    print(data)
                }
            case .failure(_):
                self?.spiner.dismiss()
            }
        }
        
        let orderDestinationLat = orderDetail.delivery_destination.lat
        let orderDestinationLng =  orderDetail.delivery_destination.long
        let storeDestinationLat = orderDetail.pickup_destination[0].lat
        let storeDestinationLng = orderDetail.pickup_destination[0].long
        
        
        if statusOrder == "wait for pickup" || statusOrder == "on pickup process" {
            cardHandleAreaHeight = 110
            if let destinationLat = CLLocationDegrees(storeDestinationLat!),
               let destinatoinLong = CLLocationDegrees(storeDestinationLng!) {
                destination = Destination(latitude: destinationLat, longitude: destinatoinLong)
            }
        } else {
            if statusOrder == "waiting delivery" || statusOrder == "pending"  {
                cardHandleAreaHeight = 110
            }else {
                cardHandleAreaHeight = 190
            }
            if let destinationLat = CLLocationDegrees(orderDestinationLat!),
               let destinationLong = CLLocationDegrees(orderDestinationLng!) {
                destination = Destination(latitude: destinationLat, longitude: destinationLong)
            }
            
            
        }
        
        mapView.frame = view.bounds
        myPosition()
        
        configureNavigationBar()
        
        mapsViewModel.delegate = self
        
        getCurrentPosition()
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if cardViewController != nil {
            cardViewController.status = !cardViewController.status
        }
        
        
        
        mapsButton.dropShadow(color: .black, opacity: 0.5, offSet: CGSize(width: 2, height: 2), radius: 50/2, scale: true)
        directionButton.dropShadow(color: .black, opacity: 0.5, offSet: CGSize(width: 2, height: 2), radius: 50/2, scale: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        manager?.stopUpdatingLocation()
        manager?.stopUpdatingHeading()
    }
    
    
    func setupCard() {
        guard let orderNo = order?.order_number else {
            return
        }
        cardViewController = CardViewController()
        cardViewController.orderData = order
        self.cardViewController.orderNo = orderNo
        self.cardViewController.status = !self.cardViewController.status
        cardViewController.status = true
        self.addChild(cardViewController)
        self.view.addSubview(cardViewController.view)
        cardViewController.delegate = self
        
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardFullHeight)
        
        cardViewController.view.clipsToBounds = false
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
        
        cardViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
        
        
    }

    
    @objc
    func handleCardPan (recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
            
            switch recognizer.direction{
            case .topToBottom:
                print("top to botom")
//                if cardFull {
//                    cardFull = false
//                    cardVisible = true
//                }else {
//                    cardVisible = true
//                    cardFull = false
//                }
            case .bottomToTop:
                print("btm to top")
//                if cardVisible {
//                    cardFull = true
//                    cardVisible = false
//                }else {
//                    cardVisible = false
//                    cardFull = false
//                }
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
extension LiveTrackingVC: MapsViewModelDelegate {
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
extension LiveTrackingVC: CLLocationManagerDelegate {
    
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
            CATransaction.begin()
            CATransaction.setAnimationDuration(2.0)
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
        }
    }
    
    func updateMarkerWith(position: CLLocationCoordinate2D, angle: Double) {
        originMarker.position = position
        
        guard angle >= 0 && angle < 360 else {
            return
        }
        let angleInRadians: CGFloat = CGFloat(angle) * .pi / CGFloat(180)
        originMarker.iconView?.transform = CGAffineTransform.identity.rotated(by: angleInRadians)
        
        //            directionButton.transform = CGAffineTransform.identity.rotated(by: angleInRadians)
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


//Mark - Func animate

@available(iOS 13.0, *)
extension LiveTrackingVC {
    func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                case .full:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardFullHeight
                }
            }
            
            frameAnimator.addCompletion { _ in
//                if !self.cardFull {
//                    self.cardVisible = !self.cardVisible
//                }
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
        }
    }
    
    func startInteractiveTransition(state:CardState, duration:TimeInterval) {
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
extension LiveTrackingVC: CardViewControllerDelegate {
    func seeDetail(_ viewC: CardViewController, order: NewOrderDetail?, userInfo: NewUserInfo?) {
        //        let vi = DetailView()
        //        vi.orderDetail = order
        //        vi.userInfo = userInfo
        //        navigationController?.pushViewController(vi, animated: true)
        //        let vc = PendingNoteVc()
        //        vc.orderData = order
        //        let navVc = UINavigationController(rootViewController: vc)
        //
        //        present(navVc, animated: true, completion: nil)
    }
    
    func next(_ viewC: CardViewController, store: PickupDestination?) {
        self.cardViewController.status = !self.cardViewController.status
        
        guard let storeDestinationLat = store?.lat,
              let storeDestinationLng = store?.long else {return}
        
        destination = Destination(latitude: CLLocationDegrees(storeDestinationLat)!, longitude: CLLocationDegrees(storeDestinationLng)!)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(2.0)
        
        guard let origin = origin, let destination = destination else {
            return
        }
        
        
        let direction: DirectionData = DirectionData(origin: origin, destination: destination)
        
        
        self.mapsViewModel.drawDirection(direction: direction)
        
        
        CATransaction.commit()
    }
    
    func scan(_ viewC: CardViewController, store: PickupDestination?, extra: AnotherPickup?) {
        guard let orderNo = order?.order_number else {
            return
        }
        let vc = ListScanView()
        vc.store = store
        vc.orderNo = orderNo
        vc.origin = origin
        vc.extraItem = extra
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapButton(_ viewModel: CardViewController, type: TypeDelivery) {
        guard let orderNo = order?.order_number else {
            return
        }
        switch type {
        case .start_pickup:
            guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
                  let codeDriver = userData["codeDriver"] as? String else {
                print("No user data")
                return
            }
            spiner.show(in: view)
            let data = Delivery(status: "pickup", order_number: orderNo, type: "start")
            self.orderViewModel.statusOrder(data: data) { (result) in
                self.handleResult(result: result)
                self.navigationItem.hidesBackButton = true
                self.databaseM.setCurrentOrder(orderNo: orderNo, codeDriver: codeDriver) { (re) in
                    print(re)
                }
            }
        case .done_pickup:
            spiner.show(in: view)
            donePickupOrder()
        case .start_delivery:
            spiner.show(in: view)
            let data = Delivery(status: "delivery", order_number: orderNo, type: "start")
            self.orderViewModel.statusOrder(data: data) { (result) in
                self.handleResult(result: result)
                self.cardHandleAreaHeight = 190
            }
        case .pending:
            let vc = PendingNoteVc()
            vc.orderData = order
            let navVc = UINavigationController(rootViewController: vc)
            
            present(navVc, animated: true, completion: nil)
        case .done_delivery:
            spiner.show(in: view)
            let data = Delivery(status: "delivery", order_number: orderNo, type: "done")
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
                        self.databaseM.removeCurrentOrder(orderNo: orderNo, codeDriver: codeDriver) { (res) in
                            print(res)
                        }
                        self.upateLocation()
                        self.spiner.dismiss()
                        let vc = DoneViewController()
                        let navVc = UINavigationController(rootViewController: vc)
                        
                        self.present(navVc, animated: true, completion: nil)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print(error)
                    }
                }
            }
            
        case .none:
            print("Status Undefined")
        case .next:
            print("Next store")
        case .scan:
            print("Start Scan")
        case .nostatus:
            print("no status")
        }
    }
    
    
    private func handleResult(result: Result<Bool, Error>){
        guard let orderNo = order?.order_number else {
            return
        }
        switch result {
        case .success(_):
            DispatchQueue.main.async {
                self.spiner.dismiss()
                self.cardViewController.orderNo = orderNo
                self.cardViewController.status = !self.cardViewController.status
            }
        case .failure(let error):
            DispatchQueue.main.async {
                self.spiner.dismiss()
                self.cardViewController.orderNo = orderNo
                self.cardViewController.status = !self.cardViewController.status
                print(error)
            }
        }
    }
    
    private func donePickupOrder(){
        guard let orderDetailString = order?.order_detail,
              let orderNo = order?.order_number,
              let orderDetail = orderViewModel.decryptOrderDetail(data: orderDetailString, OrderNo: orderNo) else {
            return
        }
        
        let data = Delivery(status: "pickup", order_number: orderNo, type: "done")
        self.orderViewModel.statusOrder(data: data) { (result) in
            self.handleResult(result: result)
        }
        
        if let orderDestinationLat = CLLocationDegrees(orderDetail.delivery_destination.lat!),
           let orderDestinationLng =  CLLocationDegrees(orderDetail.delivery_destination.long!) {
            destination = Destination(latitude: orderDestinationLat, longitude: orderDestinationLng)
        }
        
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(2.0)
        
        guard let origin = origin, let destination = destination else {
            return
        }
        
        
        let direction: DirectionData = DirectionData(origin: origin, destination: destination)
        
        
        self.mapsViewModel.drawDirection(direction: direction)
        
        
        CATransaction.commit()
        
    }
}

