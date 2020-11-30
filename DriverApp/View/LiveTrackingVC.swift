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

@available(iOS 13.0, *)
class LiveTrackingVC: UIViewController {
    
//    loading
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading"
        
        return spin
    }()
    
//    card
    
    enum CardState {
           case expanded
           case collapsed
       }
       
       var cardViewController:CardViewController!
       var visualEffectView:UIVisualEffectView!
       
       let cardHeight:CGFloat = 400
       let cardHandleAreaHeight:CGFloat = 110
       
       var cardVisible = false
       var nextState:CardState {
           return cardVisible ? .collapsed : .expanded
       }
       
       var runningAnimations = [UIViewPropertyAnimator]()
       var animationProgressWhenInterrupted:CGFloat = 0
    
//    order
    
    var order:NewOrderData? = nil
    var mapsViewModel = MapsViewModel()
    var orderViewModel = OrderViewModel()
    var inOutVm = InOutViewModel()
    
    var isCheckin: Bool = false
    
    private var manager: CLLocationManager?
    
    var originMarker = GMSMarker()
    
    let mapView: GMSMapView = {
        let mapView = GMSMapView()

        return mapView
    }()
    
    var currentStore: PickupDestination!
    
    var databaseManager = DatabaseManager()
    
    
    //origin
    var origin: Origin?
    var destination: Destination?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Live Tracking"
        
       
       
        view.addSubview(mapView)
       
        DispatchQueue.main.async {
            self.setupCard()
        }
        
        mapView.frame = view.frame
        
        configureNavigationBar()
        
        mapsViewModel.delegate = self
        
        guard let orderDetailString = order?.order_detail,
              let orderNo = order?.order_number,
              let orderDetail = orderViewModel.decryptOrderDetail(data: orderDetailString, OrderNo: orderNo),
              let statusOrder = order?.status_tracking else {
            
            return
        }
        
        let orderDestinationLat = orderDetail.delivery_destination.lat
        let orderDestinationLng =  orderDetail.delivery_destination.long
        let storeDestinationLat = orderDetail.pickup_destination[0].lat
        let storeDestinationLng = orderDetail.pickup_destination[0].long
      
        
        if statusOrder == "wait for pickup" || statusOrder == "on pickup process" {
            destination = Destination(latitude: CLLocationDegrees(storeDestinationLat)!, longitude: CLLocationDegrees(storeDestinationLng)!)
        } else {
            destination = Destination(latitude: CLLocationDegrees(orderDestinationLat)!, longitude: CLLocationDegrees(orderDestinationLng)!)
        }
        
        getCurrentPosition()

 
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cekStatusDriver()
        self.cardViewController.status = !self.cardViewController.status
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        manager?.stopUpdatingLocation()
        manager?.stopUpdatingHeading()
    }
    
    private func cekStatusDriver(){
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        spiner.show(in: view)
        
        inOutVm.cekStatusDriver(codeDriver: codeDriver) { (res) in
            switch res {
            case .success(let response):
                DispatchQueue.main.async {
                    self.spiner.dismiss()
                    if response.isCheckin == true {
                        self.isCheckin = true
                    }
                }
            case .failure(let err):
                self.spiner.dismiss()
                print(err.localizedDescription)
                self.isCheckin = false
            }
        }
        
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
        
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        
        cardViewController.view.clipsToBounds = false
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))

        cardViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
        
        
    }
    
    @objc
        func handleCardTap(recognzier:UITapGestureRecognizer) {
            switch recognzier.state {
            case .ended:
                animateTransitionIfNeeded(state: nextState, duration: 0.9)
            default:
                break
            }
        }
        
        @objc
        func handleCardPan (recognizer:UIPanGestureRecognizer) {
            switch recognizer.state {
            case .began:
                startInteractiveTransition(state: nextState, duration: 0.9)
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
        manager?.requestWhenInUseAuthorization()
        manager?.startUpdatingLocation()
        manager?.startUpdatingHeading()
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
        let vc = ChatViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK - maps direction
@available(iOS 13.0, *)
extension LiveTrackingVC: MapsViewModelDelegate {
    func didDrawDirection(_ viewModel: MapsViewModel, direction: GMSPolyline, markerOrigin: GMSMarker, markerDestination: GMSMarker, camera: GMSCameraPosition) {
        mapView.clear()
        direction.map = mapView
        markerOrigin.map = mapView
        markerDestination.map = mapView
        mapView.animate(to: camera)
    }

    func didFailedDrawDirection(_ error: Error) {
        print(error)
    }


}


//MARK - core location
@available(iOS 13.0, *)
extension LiveTrackingVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let coordinate = location.coordinate
            
            ///update position to firebase
            let status: String = "Out for delivery"
            guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
                  let codeDriver = userData["codeDriver"] as? String,
                  let idDriver = userData["idDriver"] as? Int else {
                print("No user data")
                return
            }
            databaseManager.updateData(idDriver: String(idDriver), codeDriver: codeDriver, lat: coordinate.latitude, lng: coordinate.longitude, status: status) { (res) in
                switch res {
                case .failure(let err):
                    print(err)
                case .success(let oke):
                    if oke {
                        print("succes update location to firebase")
                    }
                }
            }
            
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(2.0)
//            originMarker.position = coordinate
            origin = Origin(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            guard let origin = origin, let destination = destination else {
                return
            }
            
            
            let direction: DirectionData = DirectionData(origin: origin, destination: destination)
            
        
            self.mapsViewModel.drawDirection(direction: direction)
            
            
            CATransaction.commit()
            
            updateMapLocation(lattitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
    
    func updateMapLocation(lattitude:CLLocationDegrees,longitude:CLLocationDegrees){
        let camera = GMSCameraPosition.camera(withLatitude: lattitude, longitude: longitude, zoom: 16)
        mapView.camera = camera
        mapView.animate(to: camera)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let bearing = newHeading.magneticHeading
        guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
              let codeDriver = userData["codeDriver"] as? String else {
            print("No user data")
            return
        }
        databaseManager.updateHeading(codeDriver: codeDriver, bearing: bearing) { (res) in
            switch res {
            case .failure(let err):
                print(err)
            case .success(let oke):
                if oke {
                    print("succes update heading to firebase")
                }
            }
        }
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
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.cardViewController.view.layer.cornerRadius = 12
                case .collapsed:
                    self.cardViewController.view.layer.cornerRadius = 0
                }
            }
            
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
            
            
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
        
        updateMapLocation(lattitude: origin.latitude, longitude: origin.longitude)
    }
    
    func scan(_ viewC: CardViewController, store: PickupDestination?) {
        guard let orderNo = order?.order_number else {
            return
        }
        let vc = ListScanView()
        vc.store = store
        vc.orderNo = orderNo
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapButton(_ viewModel: CardViewController, type: TypeDelivery) {
        guard let orderNo = order?.order_number else {
            return
        }
        switch type {
        case .start_pickup:
            spiner.show(in: view)
            let data = Delivery(status: "pickup", order_number: orderNo, type: "start")
            self.orderViewModel.statusOrder(data: data) { (result) in
                self.handleResult(result: result)
            }
        case .done_pickup:
            guard let userData = UserDefaults.standard.value(forKey: "userData") as? [String: Any],
                  let codeDriver = userData["codeDriver"] as? String, let lat = origin?.latitude, let long = origin?.longitude else {
                print("No user data")
                return
            }
            spiner.show(in: view)
            
            if self.isCheckin == false {
                print("belum cekin")
                self.inOutVm.checkinDriver(with: codeDriver, lat: String(lat), long: String(long)) { (res) in
                    switch res {
                    case .success(let oke):
                        DispatchQueue.main.async {
                            if oke == true {
                                self.donePickupOrder()
                            }
                        }
                    case .failure(let err):
                        print(err)
                        Helpers().showAlert(view: self, message: "Something when wrong !")
                    }
                }
            }else {
                print("Sudah cekin")
                donePickupOrder()
            }
        case .start_delivery:
            spiner.show(in: view)
            let data = Delivery(status: "delivery", order_number: orderNo, type: "start")
            self.orderViewModel.statusOrder(data: data) { (result) in
                self.handleResult(result: result)
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
        
        let orderDestinationLat = orderDetail.delivery_destination.lat
        let orderDestinationLng =  orderDetail.delivery_destination.long
        
        destination = Destination(latitude: CLLocationDegrees(orderDestinationLat)!, longitude: CLLocationDegrees(orderDestinationLng)!)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(2.0)

        guard let origin = origin, let destination = destination else {
            return
        }
        
        
        let direction: DirectionData = DirectionData(origin: origin, destination: destination)
        
    
        self.mapsViewModel.drawDirection(direction: direction)
        
        
        CATransaction.commit()
        
        updateMapLocation(lattitude: origin.latitude, longitude: origin.longitude)
    }
}

