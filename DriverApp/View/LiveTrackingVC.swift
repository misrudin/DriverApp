//
//  LiveTrackingVC.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 18/10/20.
//

import UIKit
import GoogleMaps
import CoreLocation

class LiveTrackingVC: UIViewController {
    
//    loading
    let pop = PopUpView()
    
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
    
    var order:Order? = nil
    var mapsViewModel = MapsViewModel()
    var orderViewModel = OrderViewModel()
    
    private var manager: CLLocationManager?
    
    var originMarker = GMSMarker()
    
    let mapView: GMSMapView = {
        let mapView = GMSMapView()

        return mapView
    }()
    
    
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
        
        
        guard let orderDestinationLat = order?.latitude,
              let orderDestinationLng = order?.longitude,
              let storeDestinationLat = order?.storeDetail.latitude,
              let storeDestinationLng = order?.storeDetail.longitude,
              let statusOrder = order?.statusTracking else {
            return
        }
        
        if statusOrder == "wait for pickup" || statusOrder == "on pickup process" {
            destination = Destination(latitude: CLLocationDegrees(storeDestinationLat)!, longitude: CLLocationDegrees(storeDestinationLng)!)
        } else {
            destination = Destination(latitude: CLLocationDegrees(orderDestinationLat)!, longitude: CLLocationDegrees(orderDestinationLng)!)
        }
        
//        guard let origin = origin, let destination = destination else {
//            return
//        }
//        let direction: DirectionData = DirectionData(origin: origin, destination: destination)
//
//        DispatchQueue.main.async {
//            self.mapsViewModel.drawDirection(direction: direction)
//        }

        getCurrentPosition()
//        originMarker.map = mapView
        
        
        //cek status order
 
    }
    
    
    func setupCard() {
        guard let orderNo = order?.orderNumber else {
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
        manager?.delegate = self
    }
    
    
    func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipses.bubble.fill"), style: .plain, target: self, action: #selector(onClickChatButton))
    }
    
    @objc
    func onClickChatButton(){
        let vc = ChatViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK - maps direction
extension LiveTrackingVC: MapsViewModelDelegate {
    func didDrawDirection(_ viewModel: MapsViewModel, direction: GMSPolyline, markerOrigin: GMSMarker, markerDestination: GMSMarker, camera: GMSCameraPosition) {
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
extension LiveTrackingVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let coordinate = location.coordinate
            
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
}


//Mark - Func animate

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


extension LiveTrackingVC: CardViewControllerDelegate {
    func didTapButton(_ viewModel: CardViewController, type: TypeDelivery) {
        guard let orderNo = order?.orderNumber else {
            return
        }
        switch type {
        case .start_pickup:
            self.view.addSubview(pop)
            self.pop.show = true
            let data = Delivery(order_number: orderNo, type: "start")
            self.orderViewModel.statusOrder(data: data, status: "pickup") { (result) in
                self.handleResult(result: result)
            }
        case .done_pickup:
            self.view.addSubview(pop)
            self.pop.show = true
            let data = Delivery(order_number: orderNo, type: "end")
            self.orderViewModel.statusOrder(data: data, status: "pickup") { (result) in
                self.handleResult(result: result)
            }
        case .start_delivery:
            self.view.addSubview(pop)
            self.pop.show = true
            let data = Delivery(order_number: orderNo, type: "start")
            self.orderViewModel.statusOrder(data: data, status: "delivery") { (result) in
                self.handleResult(result: result)
            }
        case .pending:
            let vc = PendingNoteVc()
            vc.orderData = order
            let navVc = UINavigationController(rootViewController: vc)
            
            present(navVc, animated: true, completion: nil)
        case .done_delivery:
            self.view.addSubview(pop)
            self.pop.show = true
            let data = Delivery(order_number: orderNo, type: "end")
            self.orderViewModel.statusOrder(data: data, status: "delivery") { (result) in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.pop.show = false
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
        }
    }
    
    
    func handleResult(result: Result<Bool, Error>){
        guard let orderNo = order?.orderNumber else {
            return
        }
        switch result {
        case .success(_):
            DispatchQueue.main.async {
                self.pop.show = false
                self.cardViewController.orderNo = orderNo
                self.cardViewController.status = !self.cardViewController.status
            }
        case .failure(let error):
            DispatchQueue.main.async {
                self.pop.show = false
                self.cardViewController.orderNo = orderNo
                self.cardViewController.status = !self.cardViewController.status
                print(error)
            }
        }
    }
}


//        visualEffectView = UIVisualEffectView()
//        visualEffectView.frame = self.view.frame
//        self.view.addSubview(visualEffectView)

//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(recognzier:)))
//        cardViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)


//            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
//                switch state {
//                case .expanded:
//                    self.visualEffectView.effect = UIBlurEffect(style: .dark)
//                case .collapsed:
//                    self.visualEffectView.effect = nil
//                }
//            }
//
//            blurAnimator.startAnimation()
//            runningAnimations.append(blurAnimator)
