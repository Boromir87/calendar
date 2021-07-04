//
//  TaskData.swift
//  calendar
//
//  Created by FINT on 30.06.2021.
//

import Foundation

// MARK: - TaskDatum
struct TaskDatum: Codable {
    let id: Int
    let dateStart, dateFinish, name, taskDatumDescription: String

    enum CodingKeys: String, CodingKey {
        case id
        case dateStart = "date_start"
        case dateFinish = "date_finish"
        case name
        case taskDatumDescription = "description"
    }
}

typealias TaskData = [TaskDatum]
