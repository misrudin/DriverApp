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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Live Tracking"
        
       
       
        view.addSubview(mapView)
       
        
        
        mapView.frame = view.frame
        
        configureNavigationBar()
        
        mapsViewModel.delegate = self
        
        
        guard let originLat = order?.latitude,
              let originLng = order?.longitude,
              let destinationLat = order?.storeDetail.latitude,
              let destinationLng = order?.storeDetail.longitude else {
            return
        }
        
        
        
        let origin = Origin(latitude: CLLocationDegrees(originLat)!, longitude: CLLocationDegrees(originLng)!)
        let destination = Destination(latitude: CLLocationDegrees(destinationLat)!, longitude: CLLocationDegrees(destinationLng)!)
        
        let direction: DirectionData = DirectionData(origin: origin, destination: destination)
        
        mapsViewModel.drawDirection(direction: direction)

//        getCurrentPosition()
        originMarker.map = mapView
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        guard let orderNo = order?.orderNumber else {
            return
        }
        getDetailOrder(orderNo: orderNo)
        
    }
    
    func getDetailOrder(orderNo: String){
        view.addSubview(pop)
        self.cardViewController.view.removeFromSuperview()
        pop.show = true
        orderViewModel.getDetailOrder(orderNo: orderNo) {[weak self] (result) in
            switch result {
            case .success(let orderData):
                DispatchQueue.main.async {
                    self?.order = orderData
                    self?.setupCard()
                    self?.pop.show = false
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.dismiss(animated: true, completion: nil)
                    self?.pop.show = false
                    print(error)
                }
            }
        }
    }
    
    
    func setupCard() {
        cardViewController = CardViewController()
        cardViewController.orderData = order
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
        manager?.allowsBackgroundLocationUpdates = true
        manager?.requestWhenInUseAuthorization()
        manager?.startUpdatingLocation()
        manager?.delegate = self
    }
    
    
    func configureNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(didTapBack))
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc func didTapBack(){
        dismiss(animated: true, completion: nil)
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
            originMarker.position = coordinate
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
            print("Pending Delivery")
        case .done_delivery:
            self.view.addSubview(pop)
            self.pop.show = true
            let data = Delivery(order_number: orderNo, type: "end")
            self.orderViewModel.statusOrder(data: data, status: "delivery") { (result) in
                self.handleResult(result: result)
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
        case .success(let success):
            DispatchQueue.main.async {
                self.pop.show = false
                print("Order Status : \(success)")
                self.getDetailOrder(orderNo: orderNo)
            }
        case .failure(let error):
            DispatchQueue.main.async {
                self.pop.show = false
                print(error)
                self.getDetailOrder(orderNo: orderNo)
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
