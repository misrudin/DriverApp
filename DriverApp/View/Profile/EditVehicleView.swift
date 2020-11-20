//
//  EditVehicleView.swift
//  DriverApp
//
//  Created by Indo Office4 on 19/11/20.
//

import UIKit
import JGProgressHUD
import AlamofireImage

class EditVehicleView: UIViewController {
    
    private let spiner: JGProgressHUD = {
        let spin = JGProgressHUD()
        spin.textLabel.text = "Loading"
        
        return spin
    }()
    
    var userData: UserModel? = nil
    var vehicleData: VehicleData?
    var bioData: Bio? = nil
    var codeDriver: String?
    
    var profileVm = ProfileViewModel()
    
    //MARK: - variable
    
    var vehicleY = [VehicleYear]()
    
    var selectedImageView: UIImageView?
    
    //MARK: - Toolbar done button function
    @objc func onClickDoneButton() {
        self.view.endEditing(true)
    }
    
    lazy var toolBar: UIToolbar = {
        let tool = UIToolbar()
        tool.barStyle = .default
        tool.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onClickDoneButton))
        tool.setItems([space, doneButton], animated: false)
        tool.isUserInteractionEnabled = true
        tool.sizeToFit()
        return tool
    }()
    
    //MARK:- Vehicle Data
    
    //MARK:- Personal Coverage
    
    //MARK:- Insurance Company
    lazy var insuranceCompanyLable: UILabel = {
        let lable = UILabel()
        lable.text = "Insurance Company"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor.black
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
        field.layer.borderColor = UIColor.black.cgColor
        field.returnKeyType = .continue
        return field
    }()
    
    //MARK:- Personal Coverage
    lazy var personalCoverageLable: UILabel = {
        let lable = UILabel()
        lable.text = "Personal Coverage"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor.black
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
        field.layer.borderColor = UIColor.black.cgColor
        field.returnKeyType = .continue
        return field
    }()
    
    //MARK:- Compensation Range-Objective
    lazy var compensationLable: UILabel = {
        let lable = UILabel()
        lable.text = "Compensation Range-Objective"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor.black
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
        field.layer.borderColor = UIColor.black.cgColor
        field.returnKeyType = .continue
        return field
    }()
    
    //MARK:- Insurance Expiration Date
    lazy var insuranceExpirationDateLabel: UILabel = {
        let lable = UILabel()
        lable.text = "Insurance Expiration Date"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor.black
        return lable
    }()
    
    lazy var datePickerInsurance: UIDatePicker = {
        let date = UIDatePicker()
        date.datePickerMode = .date
        date.addTarget(self, action: #selector(handleDatePickerInsurance), for: .valueChanged)
        date.frame = CGRect(x: 10, y: 50, width: self.view.frame.width, height: 200)
        date.timeZone = NSTimeZone.local
        date.backgroundColor = .white
            if #available(iOS 13.4, *) {
                date.preferredDatePickerStyle = UIDatePickerStyle.wheels
            } else {
                // Fallback on earlier versions
            }
        return date
    }()
    
    @objc func handleDatePickerInsurance() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate = dateFormatter.string(from: datePickerInsurance.date)
        insuranceExpirationDate.text = strDate
    }
    
    lazy var insuranceExpirationDate: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Insurance Expiration Date"
        field.paddingLeft(10)
        let image = UIImage(named: "calendarIcon")
        let baru = image?.resizeImage(CGSize(width: 20, height: 20))
        field.setRightViewIcon(icon: baru!)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.inputView = datePickerInsurance
        field.inputAccessoryView = toolBar
        return field
    }()
    
    //MARK: - Vehicle Name
    lazy var vehicleNameLable: UILabel = {
        let lable = UILabel()
        lable.text = "Vehicle Name"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor.black
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
        field.layer.borderColor = UIColor.black.cgColor
        field.returnKeyType = .continue
        return field
    }()
    
    //MARK: - Vehicle Number Plate
    lazy var vehicleNumberPlateLable: UILabel = {
        let lable = UILabel()
        lable.text = "Vehicle Number Plate"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor.black
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
        field.layer.borderColor = UIColor.black.cgColor
        field.returnKeyType = .continue
        return field
    }()
    
    //MARK: - Vehicle Year
    lazy var vehicleYearLable: UILabel = {
        let lable = UILabel()
        lable.text = "Vehicle Year"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor.black
        return lable
    }()
    
    lazy var pickerView3: UIPickerView = {
        let pik = UIPickerView()
        
        return pik
    }()
    
    lazy var vehicleYear: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Vehicle Year"
        field.paddingLeft(10)
        let image = UIImage(named: "calendarIcon")
        let baru = image?.resizeImage(CGSize(width: 20, height: 20))
        field.setRightViewIcon(icon: baru!)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.inputView = pickerView3
        field.inputAccessoryView = toolBar
        return field
    }()
    
    //MARK:- Vehicle Ownership
    lazy var vehicleOwnershipLable: UILabel = {
        let lable = UILabel()
        lable.text = "Vehicle Ownership"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor.black
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
        field.layer.borderColor = UIColor.black.cgColor
        field.returnKeyType = .continue
        return field
    }()
    
    //MARK:- Vehicle Inspection Exp. Date
    lazy var vehicleInspectionExpDateLable: UILabel = {
        let lable = UILabel()
        lable.text = "Vehicle Inspection Exp. Date"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor.black
        return lable
    }()
    
    lazy var datePickerInspection: UIDatePicker = {
        let date = UIDatePicker()
        date.datePickerMode = .date
        date.addTarget(self, action: #selector(handleDatePickerInspection), for: .valueChanged)
        date.frame = CGRect(x: 10, y: 50, width: self.view.frame.width, height: 200)
        date.timeZone = NSTimeZone.local
        date.backgroundColor = .white
            if #available(iOS 13.4, *) {
                date.preferredDatePickerStyle = UIDatePickerStyle.wheels
            } else {
                // Fallback on earlier versions
            }
        return date
    }()
    
    @objc func handleDatePickerInspection() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate = dateFormatter.string(from: datePickerInspection.date)
        vehicleInspectionExpDate.text = strDate
    }
    
    lazy var vehicleInspectionExpDate: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 2
        field.placeholder = "Insurance Expiration Date"
        field.paddingLeft(10)
        let image = UIImage(named: "calendarIcon")
        let baru = image?.resizeImage(CGSize(width: 20, height: 20))
        field.setRightViewIcon(icon: baru!)
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.inputView = datePickerInspection
        field.inputAccessoryView = toolBar
        return field
    }()
    
    
//   MARK: - Next button
    private let nextButton: UIButton={
        let loginButton = UIButton()
        loginButton.setTitle("Save Change", for: .normal)
        loginButton.backgroundColor = UIColor(named: "orangeKasumi")
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitleColor(.lightGray, for: .highlighted)
        loginButton.layer.cornerRadius = 2
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold )
        loginButton.addTarget(self, action: #selector(editClick), for: .touchUpInside)
        return loginButton
    }()
    
    //MARK:- vehiclePhotoLable
    lazy var vehiclePhotoLable: UILabel = {
        let lable = UILabel()
        lable.text = "Vehicle Inspection Certificate Photo"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor.black
        return lable
    }()
    
    //MARK:- vehiclePhotoLable2
    lazy var vehiclePhotoLable2: UILabel = {
        let lable = UILabel()
        lable.text = "Vehicle Photo"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lable.textColor = UIColor.black
        return lable
    }()
    
    //MARK:- vehicleCertifiateImage
    lazy var vehicleCertifiateImage: UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 5
        img.layer.borderWidth = 1
        img.clipsToBounds = false
        img.layer.borderColor = UIColor.black.cgColor
        img.contentMode = .scaleAspectFit
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectVCI)))
        return img
    }()
    
    @objc
    func selectVCI(){
        selectedImageView = vehicleCertifiateImage
        presentPhotoActionSheet()
    }
    
    //MARK: - Vehicle Photo
    lazy var containerPhoto: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
//        view.backgroundColor = .red
        view.spacing = 10
        view.distribution = .fillEqually
        return view
    }()
    
    func createView()-> UIView{
       let viewC = UIView()
        let lable = UILabel()
        let img = UIImageView()
        img.image = UIImage(named: "cameraIcon2")
        lable.text = "Upload Foto"
        lable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        lable.textColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.5)
        lable.textAlignment = .center
        viewC.addSubview(lable)
        viewC.addSubview(img)
        img.anchor(top: viewC.topAnchor, width: 30, height: 30)
        img.centerXAnchor.constraint(equalTo: viewC.centerXAnchor).isActive = true
        lable.anchor(top: img.bottomAnchor, left: viewC.leftAnchor, right: viewC.rightAnchor, paddingTop: 5)
       return viewC
    }
    
    lazy var vehicleImage1: UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 5
        img.layer.borderWidth = 1
        img.clipsToBounds = false
        img.layer.borderColor = UIColor.black.cgColor
        img.contentMode = .scaleAspectFit
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectVI1)))
        return img
    }()
    
    @objc
    func selectVI1(){
        selectedImageView = vehicleImage1
        presentPhotoActionSheet()
    }
    
    lazy var vehicleImage2: UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 5
        img.layer.borderWidth = 1
        img.layer.borderColor = UIColor.black.cgColor
        img.clipsToBounds = false
        img.contentMode = .scaleAspectFit
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectVI2)))
        return img
    }()
    
    @objc
    func selectVI2(){
        selectedImageView = vehicleImage2
        presentPhotoActionSheet()
    }
    
    lazy var vehicleImage3: UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 5
        img.layer.borderWidth = 1
        img.layer.borderColor = UIColor.black.cgColor
        img.clipsToBounds = false
        img.contentMode = .scaleAspectFit
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectVI3)))
        return img
    }()
    
    @objc
    func selectVI3(){
        selectedImageView = vehicleImage3
        presentPhotoActionSheet()
    }
    
//    MARK:- dummy
    lazy var dumyC = createView()
    lazy var dumy1 = createView()
    lazy var dumy2 = createView()
    lazy var dumy3 = createView()
    
    
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
    

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureNavigationBar()
        view.addSubview(scrollView)
        pickerView3.delegate = self
        
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        let formattedDate = format.string(from: Date())
        
        for i in (2000..<Int(formattedDate)!+20).reversed() {
            vehicleY.append(VehicleYear(year: String(i)))
        }
        
        configureInputValue()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureUi()
    }
    
    //MARK: - configure input
    private func configureInputValue(){
        guard let insuranceCompanyName = vehicleData?.insurance_company_name,
              let prsonalCov = vehicleData?.coverage_personal,
              let comRangeObj = vehicleData?.compensation_range_objective,
              let insuranceExpDate = vehicleData?.insurance_expiration_date,
              let vehicleName = vehicleData?.vehicle_name,
              let vehiclePlate = vehicleData?.vehicle_number_plate,
              let vehicleYear = vehicleData?.vehicle_year,
              let vehicleOwnership = vehicleData?.vehicle_ownership,
              let vehicleInsExpDate = vehicleData?.vehicle_inspection_certificate_expiration_date,
              let vehicleFoto1 = vehicleData?.vehicle_photo_data[0],
              let vehicleFoto2 = vehicleData?.vehicle_photo_data[1],
              let vehicleFoto3 = vehicleData?.vehicle_photo_data[2],
              let certiUrl = vehicleData?.vehicle_inspection_certificate_photo_url,
              let certiName = vehicleData?.vehicle_inspection_certificate_photo_name,
              let urlCertificate = URL(string: "\(certiUrl)\(certiName)"),
              let urlPhoto1 = URL(string: "\(vehicleFoto1.vehicle_photo_url)\(vehicleFoto1.vehicle_photo_name)"),
              let urlPhoto2 = URL(string: "\(vehicleFoto2.vehicle_photo_url)\(vehicleFoto2.vehicle_photo_name)"),
              let urlPhoto3 = URL(string: "\(vehicleFoto3.vehicle_photo_url)\(vehicleFoto3.vehicle_photo_name)")
              else {
            print("data vehicle is empty !")
            return
        }
        
        insuranceCompany.text = insuranceCompanyName
        personalCoverage.text = prsonalCov
        compensation.text = comRangeObj
        insuranceExpirationDate.text = insuranceExpDate
        self.vehicleName.text = vehicleName
        self.vehicleYear.text = vehicleYear
        self.vehicleOwnership.text = vehicleOwnership
        vehicleInspectionExpDate.text = vehicleInsExpDate
        vehicleNumberPlate.text = vehiclePlate
        
        vehicleCertifiateImage.af.setImage(withURL: urlCertificate)
        dumyC.isHidden = true
        vehicleImage1.af.setImage(withURL: urlPhoto1)
        dumy1.isHidden = true
        vehicleImage2.af.setImage(withURL: urlPhoto2)
        dumy2.isHidden = true
        vehicleImage3.af.setImage(withURL: urlPhoto3)
        dumy3.isHidden = true
        
    }
    
    private func configureNavigationBar(){
        navigationItem.title = "Edit Vehicle Data"
        navigationController?.navigationBar.barTintColor = UIColor(named: "orangeKasumi")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
    }
    
    
    //MARK: - Ui configure
    private func configureUi(){
        scrollView.addSubview(stakView)
        stakView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingBottom: 16, paddingLeft: 16, paddingRight: 16, height:(55*23))
        
        stakView.addSubview(insuranceCompanyLable)
        insuranceCompanyLable.anchor(top: stakView.topAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(insuranceCompany)
        insuranceCompany.anchor(top: insuranceCompanyLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
        
        stakView.addSubview(personalCoverageLable)
        personalCoverageLable.anchor(top: insuranceCompany.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(personalCoverage)
        personalCoverage.anchor(top: personalCoverageLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
        
        stakView.addSubview(personalCoverageLable)
        personalCoverageLable.anchor(top: insuranceCompany.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(personalCoverage)
        personalCoverage.anchor(top: personalCoverageLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)

        stakView.addSubview(compensationLable)
        compensationLable.anchor(top: personalCoverage.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(compensation)
        compensation.anchor(top: compensationLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
        
        stakView.addSubview(insuranceExpirationDateLabel)
        insuranceExpirationDateLabel.anchor(top: compensation.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(insuranceExpirationDate)
        insuranceExpirationDate.anchor(top: insuranceExpirationDateLabel.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
        
        stakView.addSubview(vehicleNameLable)
        vehicleNameLable.anchor(top: insuranceExpirationDate.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(vehicleName)
        vehicleName.anchor(top: vehicleNameLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
        
        
        stakView.addSubview(vehicleNumberPlateLable)
        vehicleNumberPlateLable.anchor(top: vehicleName.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(vehicleNumberPlate)
        vehicleNumberPlate.anchor(top: vehicleNumberPlateLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)

        stakView.addSubview(vehicleYearLable)
        vehicleYearLable.anchor(top: vehicleNumberPlate.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(vehicleYear)
        vehicleYear.anchor(top: vehicleYearLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
        
        stakView.addSubview(vehicleOwnershipLable)
        vehicleOwnershipLable.anchor(top: vehicleYear.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(vehicleOwnership)
        vehicleOwnership.anchor(top: vehicleOwnershipLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
        
        stakView.addSubview(vehicleInspectionExpDateLable)
        vehicleInspectionExpDateLable.anchor(top: vehicleOwnership.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(vehicleInspectionExpDate)
        vehicleInspectionExpDate.anchor(top: vehicleInspectionExpDateLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 45)
        
        stakView.addSubview(vehiclePhotoLable)
        vehiclePhotoLable.anchor(top: vehicleInspectionExpDate.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        
        stakView.addSubview(vehicleCertifiateImage)
        vehicleCertifiateImage.anchor(top: vehiclePhotoLable.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 150)
        
        
        vehicleCertifiateImage.addSubview(dumyC)
        dumyC.anchor(width: 100, height: 50)
        dumyC.centerYAnchor.constraint(equalTo: vehicleCertifiateImage.centerYAnchor).isActive = true
        dumyC.centerXAnchor.constraint(equalTo: vehicleCertifiateImage.centerXAnchor).isActive = true
        
        stakView.addSubview(vehiclePhotoLable2)
        vehiclePhotoLable2.anchor(top: vehicleCertifiateImage.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 15)
        stakView.addSubview(containerPhoto)
        containerPhoto.anchor(top: vehiclePhotoLable2.bottomAnchor, left: stakView.leftAnchor, right: stakView.rightAnchor, paddingTop: 5, height: 70)
        
        containerPhoto.addArrangedSubview(vehicleImage1)
        vehicleImage1.anchor(top: containerPhoto.topAnchor, bottom: containerPhoto.bottomAnchor)
        containerPhoto.addArrangedSubview(vehicleImage2)
        containerPhoto.addArrangedSubview(vehicleImage3)
        
        stakView.addSubview(nextButton)
        nextButton.anchor(top: containerPhoto.bottomAnchor, right: stakView.rightAnchor, paddingTop: 40, width: view.frame.width-32, height: 45)
        
        vehicleImage2.addSubview(dumy2)
        dumy2.anchor(width: 100, height: 50)
        dumy2.centerYAnchor.constraint(equalTo: vehicleImage2.centerYAnchor).isActive = true
        dumy2.centerXAnchor.constraint(equalTo: vehicleImage2.centerXAnchor).isActive = true
        
        vehicleImage1.addSubview(dumy1)
        dumy1.anchor(width: 100, height: 50)
        dumy1.centerYAnchor.constraint(equalTo: vehicleImage1.centerYAnchor).isActive = true
        dumy1.centerXAnchor.constraint(equalTo: vehicleImage1.centerXAnchor).isActive = true
        
        vehicleImage1.addSubview(dumy3)
        dumy3.anchor(width: 100, height: 50)
        dumy3.centerYAnchor.constraint(equalTo: vehicleImage3.centerYAnchor).isActive = true
        dumy3.centerXAnchor.constraint(equalTo: vehicleImage3.centerXAnchor).isActive = true
        
    }
}


//MARK: - EXTENSION

extension EditVehicleView: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
func presentPhotoActionSheet(){
    let actionSheet = UIAlertController(title: "Profile Picture",
                                        message: "How would you like to select a picture?",
                                        preferredStyle: .actionSheet)
    
    actionSheet.addAction(UIAlertAction(title: "Cancel",
                                        style: .cancel,
                                        handler: nil))
    actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                        style: .default,
                                        handler: { [weak self] _ in
                                            
                                            self?.presentCamera()
                                        }))
    actionSheet.addAction(UIAlertAction(title: "Choose Phote",
                                        style: .default,
                                        handler: { [weak self] _ in
                                            self?.presetPhotoPicker()
                                        }))
    
    present(actionSheet, animated: true)
}

func presentCamera(){
    let vc = UIImagePickerController()
    vc.sourceType = .camera
    vc.delegate = self
    vc.allowsEditing = true
    present(vc,animated: true)
}

func presetPhotoPicker(){
    let vc = UIImagePickerController()
    vc.sourceType = .photoLibrary
    vc.delegate = self
    vc.allowsEditing = true
    present(vc,animated: true)
    
}

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    print(picker)
    picker.dismiss(animated: true, completion: nil)
    guard let selectdedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
        return
    }
    
    
    let hasil = Helpers().resizeImageUpload(image: selectdedImage)
    selectedImageView?.image = hasil
    
    
     if selectedImageView == vehicleCertifiateImage {
        dumyC.isHidden = true
    }else if selectedImageView == vehicleImage1 {
        dumy1.isHidden = true
    }else if selectedImageView == vehicleImage2 {
        dumy2.isHidden = true
    }else if selectedImageView == vehicleImage3 {
        dumy3.isHidden = true
    }else {
        print("not devined")
    }
}

func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
}
}

extension EditVehicleView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return vehicleY.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return vehicleY[row].year
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        vehicleYear.text = vehicleY[row].year
    }
}


extension EditVehicleView {
    @objc func editClick(){
        spiner.show(in: view)
        guard let insuranceCom = self.insuranceCompany.text,
              let personalCov = self.personalCoverage.text,
              let comRangeObj = self.compensation.text,
              let insuranceExpDate = self.insuranceExpirationDate.text,
              let vName = self.vehicleName.text,
              let vPlate = self.vehicleNumberPlate.text,
              let vYear = self.vehicleYear.text,
              let vOwner = self.vehicleOwnership.text,
              let vCerExp = self.vehicleInspectionExpDate.text,
              let codeDriver = codeDriver,
              let firstName = bioData?.first_name,
              let lastName = bioData?.last_name,
              let email = userData?.email else {
            
            print("Masih ada yang kosong")
            return
        }
        
        let data: VehicleEdit = VehicleEdit(code_driver: codeDriver,
                                            vehicle_name: vName,
                                            vehicle_number_plate: vPlate,
                                            vehicle_year: vYear,
                                            vehicle_ownership: vOwner,
                                            vehicle_inspection_certificate_expiration_date: vCerExp,
                                            insurance_company_name: insuranceCom,
                                            coverage_personal: personalCov,
                                            compensation_range_objective: comRangeObj,
                                            insurance_expiration_date: insuranceExpDate,
                                            first_name: firstName,last_name: lastName,email: email)
        
        
        profileVm.validateEdit(data: data) { (res) in
            switch res {
            case.failure(let err):
                Helpers().showAlert(view: self, message: err.localizedDescription)
                return
            case .success(let oke):
                if oke == true {
                    print("Next Save")
                }
            }
        }
        
        guard let vCerPhotoTemp = self.vehicleCertifiateImage.image else {
            Helpers().showAlert(view: self, message: "Vehicle certification photo must be entered !")
            return}
        
        
        guard let vPhotoTemp1 = self.vehicleImage1.image,
              let vPhotoTemp2 = self.vehicleImage2.image,
              let vPhotoTemp3 = self.vehicleImage3.image
              else {
            Helpers().showAlert(view: self, message: "Vehicle photo must be entered !")
            return}
        
        
        let vCerPhoto = Helpers().convertImageToBase64String(img: vCerPhotoTemp)
        let vPhoto1 = Helpers().convertImageToBase64String(img: vPhotoTemp1)
        let vPhoto2 = Helpers().convertImageToBase64String(img: vPhotoTemp2)
        let vPhoto3 = Helpers().convertImageToBase64String(img: vPhotoTemp3)
        
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateAdd = formater.string(from: Date())
        
        let dataToPost: [String:Any] = [
            "code_driver": codeDriver,
            "vehicle_name": vName,
            "vehicle_number_plate": vPlate,
            "vehicle_year": vYear,
            "vehicle_ownership": vOwner,
            "vehicle_inspection_certificate_expiration_date": vCerExp,
            "vehicle_inspection_certificate_photo": vCerPhoto,
            "insurance_company_name": insuranceCom,
            "coverage_personal": personalCov,
            "compensation_range_objective": comRangeObj,
            "insurance_expiration_date": insuranceExpDate,
            "date_edit": dateAdd,
            "vehicle_photo1": vPhoto1,
            "vehicle_photo2": vPhoto2,
            "vehicle_photo3": vPhoto3,
            "first_name": firstName,
            "last_name": lastName,
            "email": email
        ]
        
        spiner.dismiss()
        let action1 = UIAlertAction(title: "Yes", style: .default) {[weak self] (_) in
            self?.submitEdit(data: dataToPost)
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Helpers().showAlert(view: self, message: "Continue to send data ?",
                            customTitle: "The data is correct ?", customAction1: action2, customAction2: action1)
    }
    
    func submitEdit(data: [String: Any]){
        spiner.show(in: view)
        profileVm.editVehicleData(data: data) { (res) in
            switch res {
            case .success(let oke):
                DispatchQueue.main.async {
                    if oke == true {
                        self.spiner.dismiss()
                        let action = UIAlertAction(title: "Oke", style: .default) {[weak self] (_) in
                            self?.navigationController?.popViewController(animated: true)
                        }
                        Helpers().showAlert(view: self, message: "Please wait for approval from Kasumi", customTitle: "Register success",customAction1: action)
                    }
                }
            case .failure(let error):
                self.spiner.dismiss()
                Helpers().showAlert(view: self, message: error.localizedDescription)
            }
        }
    }
}
