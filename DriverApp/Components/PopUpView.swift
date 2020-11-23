//
//  PopUpView.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 24/10/20.
//

import UIKit

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
    
    let stackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 16
        v.alignment = .center
        v.distribution = .fillEqually
        return v
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(named: "successIcon")
        return iv
    }()
    
    let lableDetail: UILabel = {
        let l = UILabel()
        l.text = "Loading"
        l.textColor = .gray
        l.font = UIFont(name: "Avenir", size: 18)
        return l
    }()
    
    private let nextButton: UIButton={
        let loginButton = UIButton()
        loginButton.setTitle("Ok", for: .normal)
        loginButton.backgroundColor = UIColor(named: "orangeKasumi")
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitleColor(.lightGray, for: .highlighted)
        loginButton.layer.cornerRadius = 2
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold )
        loginButton.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        return loginButton
    }()
    
    
    @objc
    func onClick(){
        print("oke")
    }
    
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
//            self.stackView.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
            self.stackView.transform = CGAffineTransform(translationX: 0, y: -10)
            self.alpha = 0
        }) { (complete) in
            if complete {
                self.removeFromSuperview()
            }
        }
    }
    
    @objc
    fileprivate func animateIn(){
//        self.stackView.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
        self.stackView.transform = CGAffineTransform(translationX: 0, y: 10)
        self.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.stackView.transform = .identity
            self.alpha = 1
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(visualEffectView)
        addSubview(stackView)
        self.frame = UIScreen.main.bounds
        visualEffectView.frame = self.bounds
        stackView.addSubview(lableDetail)
        
        
        // layout
        stackView.anchor( left: leftAnchor, right: rightAnchor, paddingLeft: 16, paddingRight: 16, height: 170)
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        lableDetail.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true
        lableDetail.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        
        animateIn()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

