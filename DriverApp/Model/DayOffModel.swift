//
//  DayOffModel.swift
//  DriverApp
//
//  Created by BMG MacbookPro on 06/11/20.
//

import Foundation

struct DayOffModel: Decodable {
    let data: DayOfParent
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

struct DayOffPlanModel: Decodable {
    let data: DayOfPlan
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

struct DayOfParent: Decodable {
    let dayOfStatus: DayOffStatus
    
    enum CodingKeys: String, CodingKey {
        case dayOfStatus = "day_off_status"
    }
}

struct DayOfPlan: Decodable {
    let dayOfStatus: DayOffStatus?
    let workingStatus: String
    
    enum CodingKeys: String, CodingKey {
        case dayOfStatus = "day_off_status_plan"
        case workingStatus = "working_status"
    }
}

struct DayOffStatus: Decodable {
    let week1: DayOfWeek
    let week2: DayOfWeek
    let week3: DayOfWeek
    let week4: DayOfWeek
    let week5: DayOfWeek
    
    enum CodingKeys: String, CodingKey {
        case week1 = "1"
        case week2 = "2"
        case week3 = "3"
        case week4 = "4"
        case week5 = "5"
    }
}

struct DayOfWeek:Decodable {
    let Sun: [Int]?
    let Mon: [Int]?
    let Tue: [Int]?
    let Wed: [Int]?
    let Thu: [Int]?
    let Fri: [Int]?
    let Sat: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case Sun = "Sunday"
        case Mon = "Monday"
        case Tue = "Tuesday"
        case Wed = "Wednesday"
        case Thu = "Thurdday"
        case Fri = "Friday"
        case Sat = "Saturday"
    }
}

struct DayOffPostDay {
    var Sunday: Any?
    var Monday: Any?
    var Tuesday: Any?
    var Wednesday: Any?
    var Thursday: Any?
    var Friday: Any?
    var Saturday: Any?
}

struct DayOffPost {
    let id_driver: Int
    let day_off_status_plan: [String: DayOffPostDay]
}

