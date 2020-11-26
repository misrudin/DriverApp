//
//  Helpers.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 17/10/20.
//

import UIKit
import Alamofire



extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat? = 0, paddingBottom: CGFloat? = 0, paddingLeft: CGFloat? = 0, paddingRight: CGFloat? = 0, width: CGFloat? = nil, height: CGFloat? = nil){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop!).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft!).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom!).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight!).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
    
    enum ViewSide {
           case Left, Right, Top, Bottom
       }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
            
            let border = CALayer()
            border.backgroundColor = color
            
            switch side {
            case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
            case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
            case .Top: border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness);
                break
            case .Bottom: border.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: thickness); break
            }
            
            layer.addSublayer(border)
        }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
}


extension UIColor {
    static func rgba(red: CGFloat,green: CGFloat, blue: CGFloat, alpha: CGFloat = 1)-> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    static func rgb(red: CGFloat,green: CGFloat, blue: CGFloat)-> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let mainBlue = UIColor.rgb(red: 0, green: 150, blue: 255)
}

extension UIView {
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}


struct Helpers {
    func showAlert(view: UIViewController,message:String,customTitle: String? = nil,customAction1: UIAlertAction? = nil,customAction2: UIAlertAction? = nil){
        
        let alert = UIAlertController(title: customTitle == nil ? "Woopss !" : customTitle, message: message, preferredStyle: .alert)

        if let action1 = customAction1 {
            alert.addAction(action1)
        }
        
        if let action2 = customAction2 {
            alert.addAction(action2)
        }
        
        if customAction2 == nil && customAction1 == nil {
            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
        }

        view.present(alert, animated: true)
    }
    

    func convertImageToBase64String (img: UIImage) -> String {
        return "data:image/png;base64,\(img.jpegData(compressionQuality: 0.7)?.base64EncodedString() ?? "")"
    }
    
    
    func resizeImageUpload(image: UIImage) -> UIImage {
        var actualHeight: Float = Float(image.size.height)
        var actualWidth: Float = Float(image.size.width)
        let maxHeight: Float = 1000.0
        let maxWidth: Float = 1000.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = 0.2
        //50 percent compression

        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }

        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img!.jpegData(compressionQuality: CGFloat(compressionQuality))
        print(imageData)
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!)!
    }
    
}

extension Date {

    func daysInMonth(_ monthNumber: Int? = nil, _ year: Int? = nil) -> Int {
        var dateComponents = DateComponents()
        dateComponents.year = year ?? Calendar.current.component(.year,  from: self)
        dateComponents.month = monthNumber ?? Calendar.current.component(.month,  from: self)
        if
            let d = Calendar.current.date(from: dateComponents),
            let interval = Calendar.current.dateInterval(of: .month, for: d),
            let days = Calendar.current.dateComponents([.day], from: interval.start, to: interval.end).day
        { return days } else { return -1 }
    }
    
    static func dayNameFromCustomDate(customDate: Int, year:Int? = nil, month: Int? = nil) -> String {
        let year = year ?? Calendar.current.component(.year, from: Date())
        let month = month ?? Calendar.current.component(.month, from: Date())
        let dateNow = customDate < 10 ? "\(year)-\(month)-\(0)\(customDate)" : "\(year)-\(month)-\(customDate)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateFor = DateFormatter()
        dateFor.dateFormat = "EE"
        
        let date = dateFormatter.date(from: dateNow)
        let dayString = dateFor.string(from: date!)
        
        
        return dayString
    }
    
    static func dayStringFromStringDate(customDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateFor = DateFormatter()
        dateFor.dateFormat = "EE, dd MMM Y"
        
        let date = dateFormatter.date(from: customDate)
        let dayString = dateFor.string(from: date!)
        
        
        return dayString
    }
    
    
    static func dateStringFrom(customDate: Int) -> String {
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let dateNow = customDate < 10 ? "\(year)-\(month)-\(0)\(customDate)" : "\(year)-\(month)-\(customDate)"
        
        return dateNow
    }
    
    static func dateStringNextMonthFrom(customDate: Int, year: Int, month: Int) -> String {
        let dateNow = customDate < 10 ? "\(year)-\(month)-\(0)\(customDate)" : "\(year)-\(month)-\(customDate)"
        
        return dateNow
    }
    
    
    static func monthNumber()->Int{
        return Calendar.current.component(.month, from: Date())
    }
    
    static func yearNumber()->Int{
        return Calendar.current.component(.year, from: Date())
    }
}


class CustomTap: UITapGestureRecognizer {
    var ourCustomValue: Any?
    var day: String?
    var index: Int?
}


extension UITextField {
    func paddingLeft(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func paddingRight(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setRightViewIcon(icon: UIImage) {
        let btnView = UIButton(frame: CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25)))
        btnView.setImage(icon, for: .normal)
        btnView.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        self.rightViewMode = .always
        self.rightView = btnView
    }
}


public let kShapeDashed : String = "kShapeDashed"

extension UIView {
    
    func removeDashedBorder(_ view: UIView) {
        view.layer.sublayers?.forEach {
            if kShapeDashed == $0.name {
                $0.removeFromSuperlayer()
            }
        }
    }

    func addDashedBorder(width: CGFloat? = nil, height: CGFloat? = nil, lineWidth: CGFloat = 2, lineDashPattern:[NSNumber]? = [6,3], strokeColor: UIColor = UIColor.red, fillColor: UIColor = UIColor.clear) {
        
        
        var fWidth: CGFloat? = width
        var fHeight: CGFloat? = height
        
        if fWidth == nil {
            fWidth = self.frame.width
        }
        
        if fHeight == nil {
            fHeight = self.frame.height
        }
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()

        let shapeRect = CGRect(x: 0, y: 0, width: fWidth!, height: fHeight!)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: fWidth!/2, y: fHeight!/2)
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = lineDashPattern
        shapeLayer.name = kShapeDashed
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
}

//MARK: - UI IMAGE
extension UIImage {
    func imageResized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    func scaled(with scale: CGFloat) -> UIImage? {
            // size has to be integer, otherwise it could get white lines
            let size = CGSize(width: floor(self.size.width * scale), height: floor(self.size.height * scale))
            UIGraphicsBeginImageContext(size)
            draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
    }
    
    func resizeImage(_ newSize: CGSize) -> UIImage? {
            func isSameSize(_ newSize: CGSize) -> Bool {
                return size == newSize
            }

            func scaleImage(_ newSize: CGSize) -> UIImage? {
                func getScaledRect(_ newSize: CGSize) -> CGRect {
                    let ratio   = max(newSize.width / size.width, newSize.height / size.height)
                    let width   = size.width * ratio
                    let height  = size.height * ratio
                    return CGRect(x: 0, y: 0, width: width, height: height)
                }

                func _scaleImage(_ scaledRect: CGRect) -> UIImage? {
                    UIGraphicsBeginImageContextWithOptions(scaledRect.size, false, 0.0);
                    draw(in: scaledRect)
                    let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
                    UIGraphicsEndImageContext()
                    return image
                }
                return _scaleImage(getScaledRect(newSize))
            }

            return isSameSize(newSize) ? self : scaleImage(newSize)!
        }
    
//    MARK: - Resize
        func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
            let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
            let format = imageRendererFormat
            format.opaque = isOpaque
            return UIGraphicsImageRenderer(size: canvas, format: format).image {
                _ in draw(in: CGRect(origin: .zero, size: canvas))
            }
        }

//    MARK: - Compress
        func compress(to kb: Int, allowedMargin: CGFloat = 0.2) -> Data {
            let bytes = kb * 1024
            var compression: CGFloat = 1.0
            let step: CGFloat = 0.05
            var holderImage = self
            var complete = false
            while(!complete) {
                if let data = holderImage.jpegData(compressionQuality: 1.0) {
                    let ratio = data.count / bytes
                    if data.count < Int(CGFloat(bytes) * (1 + allowedMargin)) {
                        complete = true
                        return data
                    } else {
                        let multiplier:CGFloat = CGFloat((ratio / 5) + 1)
                        compression -= (step * multiplier)
                    }
                }
                
                guard let newImage = holderImage.resized(withPercentage: compression) else { break }
                holderImage = newImage
            }
            return Data()
        }
    
    //mm
    
    func resizeByByte(maxByte: Int)-> Data {
        var compressQuality: CGFloat = 1
        var imageData = Data()
        var imageByte = self.jpegData(compressionQuality: 1)?.count

        while imageByte! > maxByte {
            imageData = self.jpegData(compressionQuality: compressQuality)!
            imageByte = self.jpegData(compressionQuality: compressQuality)?.count
            compressQuality -= 0.1
        }

        if maxByte > imageByte! {
            return imageData
        } else {
            return self.jpegData(compressionQuality: 1)!
        }
    }
    
}


