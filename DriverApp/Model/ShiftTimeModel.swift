//
//  ShiftTimeModel.swift
//  DriverApp
//
//  Created by Indo Office4 on 24/11/20.
//

import Foundation

struct AllShiftTime: Decodable {
    let data: [ShiftTime]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}


struct ShiftTime: Decodable {
    let id_shift_time: Int
    let label_data: String
    let time_end_shift: String
    let time_start_shift: String
    
    enum KodingKeys: String, CodingKey {
        case id_shift_time
        case label_data
        case time_end_shift
        case time_start_shift
    }
}
