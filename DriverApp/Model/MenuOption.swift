//
//  MenuOption.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 14/10/20.
//

import UIKit

enum MenuOption: Int, CustomStringConvertible {
    case Jobs
    case History
    case Notes
    case Profile
    case DayOff
    case Logout

    var description: String {
        switch self {
        case .Jobs:
            return "Jobs Detail"
        case .History:
            return "History"
        case .Notes:
            return "Notes"
        case .Profile:
            return "Profile"
        case .DayOff:
            return "Day Off"
        case .Logout:
            return "Logout"
        }
    }
    
    var image: UIImage {
        switch self {
        case .Jobs:
            return UIImage(systemName: "bag.fill") ?? UIImage()
        case .History:
            return UIImage(systemName: "clock.fill") ?? UIImage()
        case .Notes:
            return UIImage(systemName: "book.circle.fill") ?? UIImage()
        case .Profile:
            return UIImage(systemName: "person.fill") ?? UIImage()
        case .DayOff:
            return UIImage(systemName: "clock.fill") ?? UIImage()
        case .Logout:
            return UIImage(systemName: "xmark.circle.fill") ?? UIImage()
        }
    }
}
