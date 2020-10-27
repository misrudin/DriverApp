//
//  PopUpView.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 24/10/20.
//

import UIKit
import NVActivityIndicatorView

class PopUpView: UIView {
    
    var show: Bool? {
        didSet {
            guard let showLoading = show else { return }
            if showLoading {
                animateIn()
            } else {
                animateOut()
            }
        }
    }
    
    let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0,
                                                          width: 50,
                                                          height: 50),
                                            type: .ballPulseSync,
                                            color: .red,
                                            padding: 5)
    
    let lableDetail: UILabel = {
        let l = UILabel()
        l.text = "Loading"
        l.textColor = .gray
        l.font = UIFont(name: "Avenir", size: 18)
        return l
    }()
    
    let container: UIView = {
       let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 10
        return v
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.5
        return view
    }()
    
    @objc
    fileprivate func animateOut(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
//            self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
            self.container.transform = CGAffineTransform(translationX: 0, y: -10)
            self.alpha = 0
            self.indicator.stopAnimating()
        }) { (complete) in
            if complete {
                self.removeFromSuperview()
            }
        }
    }
    
    @objc
    fileprivate func animateIn(){
        self.indicator.startAnimating()
//        self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
        self.container.transform = CGAffineTransform(translationX: 0, y: 10)
        self.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = .identity
            self.alpha = 1
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(visualEffectView)
        addSubview(container)
        self.frame = UIScreen.main.bounds
        visualEffectView.frame = self.bounds
        container.addSubview(indicator)
        container.addSubview(lableDetail)
        
        
        // layout
        container.anchor( left: leftAnchor, right: rightAnchor, paddingLeft: 16, paddingRight: 16, height: 170)
        container.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.anchor(top: container.topAnchor, paddingTop: container.frame.height/2 + indicator.frame.height)
        indicator.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true

        lableDetail.anchor(top: indicator.bottomAnchor, paddingTop: 10)
        lableDetail.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        
        animateIn()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

