//
//  VehicleView.swift
//  DriverApp
//
//  Created by Indo Office4 on 16/11/20.
//

import UIKit

class VehicleView: UIViewController {
    
    //MARK: - Component
    lazy var driverLicenseLable: UILabel = {
        let lable = UILabel()
        lable.text = "DRIVER LICENSE"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor(named: "orangeKasumi")
        return lable
    }()
    
    lazy var vehicleDataLable: UILabel = {
        let lable = UILabel()
        lable.text = "VEHICLE DATA"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor(named: "orangeKasumi")
        return lable
    }()
    
    
    lazy var vehiclePhotoLable: UILabel = {
        let lable = UILabel()
        lable.text = "Vehicle Photo"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var imageView: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFit
        img.backgroundColor = .lightGray
        return img
    }()
    
    
    lazy var containerSelectImage: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.backgroundColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.1)
        return view
    }()
    
    //MARK:- License Number
    lazy var licenseNumberLable: UILabel = {
        let lable = UILabel()
        lable.text = "License Number"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var licenseNumber: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "License Number"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    //MARK:- License Expiration Date
    lazy var licenseExpiretionDateLable: UILabel = {
        let lable = UILabel()
        lable.text = "Driver's License Expiration Date"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var licenseExpiration: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Driver's License Expiration Date"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    
    //MARK:- Vehicle Data
    //MARK:- Insurance Company
    lazy var insuranceCompanyLable: UILabel = {
        let lable = UILabel()
        lable.text = "Insurance Company"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var insuranceCompany: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Insurance Company Name"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    //MARK:- Personal Coverage
    lazy var personalCoverageLable: UILabel = {
        let lable = UILabel()
        lable.text = "Personal Coverage"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var personalCoverage: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Personal Coverage"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    //MARK:- Compensation Range-Objective
    lazy var compensationLable: UILabel = {
        let lable = UILabel()
        lable.text = "Compensation Range-Objective"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var compensation: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Compensation Range-Objective"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    //MARK:- Insurance Expiration Date
    lazy var insuranceExpirationDateLabel: UILabel = {
        let lable = UILabel()
        lable.text = "Insurance Expiration Date"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var insuranceExpirationDate: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Insurance Expiration Date"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    //MARK: - Vehicle Name
    lazy var vehicleNameLable: UILabel = {
        let lable = UILabel()
        lable.text = "Vehicle Name"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var vehicleName: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Vehicle Name"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    //MARK: - Vehicle Type
    lazy var vehicleTypeLable: UILabel = {
        let lable = UILabel()
        lable.text = "Vehicle Type"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var vehicleType: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Vehicle Type"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    //MARK: - Vehicle Number Plate
    lazy var vehicleNumberPlateLable: UILabel = {
        let lable = UILabel()
        lable.text = "Vehicle Number Plate"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var vehicleNumberPlate: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Vehicle Number Plate"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    //MARK: - Vehicle Year
    lazy var vehicleYearLable: UILabel = {
        let lable = UILabel()
        lable.text = "Vehicle Year"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var vehicleYear: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Vehicle Year"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    //MARK:- Vehicle Ownership
    lazy var vehicleOwnershipLable: UILabel = {
        let lable = UILabel()
        lable.text = "Vehicle Ownership"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var vehicleOwnership: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Vehicle Ownership"
        field.paddingLeft(10)
        field.paddingRight(10)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        return field
    }()
    
    
//   MARK: - Next button
    private let finishButton: UIButton={
        let loginButton = UIButton()
        loginButton.setTitle("Finish Registration", for: .normal)
        loginButton.backgroundColor = UIColor(named: "orangeKasumi")
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitleColor(.lightGray, for: .highlighted)
        loginButton.layer.cornerRadius = 2
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold )
        loginButton.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        return loginButton
    }()
    
    
    
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    
    //MARK: - Scroll View
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.contentSize = contentViewSize
        scroll.autoresizingMask = .flexibleHeight
        scroll.showsHorizontalScrollIndicator = true
        scroll.bounces = true
        scroll.frame = self.view.bounds
        return scroll
    }()
    
    lazy var stakView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    //MARK:- lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureUi()
    }
    
    //MARK: - FUNC
    @objc
    func onNext(){
        print("Finish input")
    }
    
    private func configureNavigationBar(){
        navigationItem.title = "Sign Up"
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(back))
        navigationController?.navigationBar.tintColor = .white
    }
    
    
//    MARK: - Configuring UI
    private func configureUi(){
        view.addSubview(scrollView)
        
        scrollView.addSubview(stakView)
        stakView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, paddingTop: 16, paddingBottom: 16, paddingLeft: 16, paddingRight: 16,width: view.frame.width - 32, height: 55*23)

        stakView.addSubview(driverLicenseLable)
        driverLicenseLable.anchor(top: stakView.topAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor)
        
        stakView.addSubview(licenseNumberLable)
        licenseNumberLable.anchor(top: driverLicenseLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(licenseNumber)
        licenseNumber.anchor(top: licenseNumberLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
        
        stakView.addSubview(licenseExpiretionDateLable)
        licenseExpiretionDateLable.anchor(top: licenseNumber.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(licenseExpiration)
        licenseExpiration.anchor(top: licenseExpiretionDateLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
        
        stakView.addSubview(vehicleDataLable)
        vehicleDataLable.anchor(top: licenseExpiration.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor,paddingTop: 15)
        
        stakView.addSubview(insuranceCompanyLable)
        insuranceCompanyLable.anchor(top: vehicleDataLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(insuranceCompany)
        insuranceCompany.anchor(top: insuranceCompanyLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
        
        stakView.addSubview(personalCoverageLable)
        personalCoverageLable.anchor(top: insuranceCompany.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(personalCoverage)
        personalCoverage.anchor(top: personalCoverageLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
        
        stakView.addSubview(personalCoverageLable)
        personalCoverageLable.anchor(top: insuranceCompany.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(personalCoverage)
        personalCoverage.anchor(top: personalCoverageLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)

        stakView.addSubview(compensationLable)
        compensationLable.anchor(top: personalCoverage.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(compensation)
        compensation.anchor(top: compensationLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
        
        stakView.addSubview(insuranceExpirationDateLabel)
        insuranceExpirationDateLabel.anchor(top: compensation.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(insuranceExpirationDate)
        insuranceExpirationDate.anchor(top: insuranceExpirationDateLabel.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
        
        stakView.addSubview(vehicleNameLable)
        vehicleNameLable.anchor(top: insuranceExpirationDate.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(vehicleName)
        vehicleName.anchor(top: vehicleNameLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
        
        stakView.addSubview(vehicleTypeLable)
        vehicleTypeLable.anchor(top: vehicleName.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(vehicleType)
        vehicleType.anchor(top: vehicleTypeLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
        
        stakView.addSubview(vehicleNumberPlateLable)
        vehicleNumberPlateLable.anchor(top: vehicleType.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(vehicleNumberPlate)
        vehicleNumberPlate.anchor(top: vehicleNumberPlateLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)

        stakView.addSubview(vehicleYearLable)
        vehicleYearLable.anchor(top: vehicleNumberPlate.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(vehicleYear)
        vehicleYear.anchor(top: vehicleYearLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
        
        stakView.addSubview(vehicleOwnershipLable)
        vehicleOwnershipLable.anchor(top: vehicleYear.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(vehicleOwnership)
        vehicleOwnership.anchor(top: vehicleOwnershipLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 45)
        
        stakView.addSubview(vehiclePhotoLable)
        vehiclePhotoLable.anchor(top: vehicleOwnership.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(containerSelectImage)
        containerSelectImage.anchor(top: vehiclePhotoLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 2, height: 200)
        
        stakView.addSubview(finishButton)
        finishButton.anchor(top: containerSelectImage.bottomAnchor,paddingTop: 40,width: view.frame.width/2, height: 45)
        finishButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    
    
    @objc
    func back(){
        dismiss(animated: true, completion: nil)
    }
}


    //MARK: - EXTENSION

extension VehicleView{
    
}
