//
//  PrepareJSON.swift
//  calendar
//
//
// swiftlint:disable line_length

import UIKit

class PrepareJSON {
    var taskId = [Int]()
    var taskBegin = [String]()
    var taskEnd = [String]()
    var taskName = [String]()
    var taskDescription = [String]()
    var taskHoursBegin = [String]()
    var taskHoursEnd = [String]()
    var taskMinetsBegin = [String]()
    var taskMinetsEnd = [String]()

    func readJSONFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }

    func parseJSON(jsonData: Data) {

        do {
            let decodedData = try JSONDecoder().decode(TaskData.self, from: jsonData)

            for task in decodedData {
                formatter.dateFormat = "dd-MM-yyyy"
                taskId.append(task.id)
                taskBegin.append(formatter.string(from: NSDate(timeIntervalSince1970: Double(task.dateStart)!) as Date))
                taskEnd.append(formatter.string(from: NSDate(timeIntervalSince1970: Double(task.dateFinish)!) as Date))
                taskName.append(task.name)
                taskDescription.append(task.taskDatumDescription)

                formatter.dateFormat = "HH"
                taskHoursBegin.append(formatter.string(from: NSDate(timeIntervalSince1970: Double(task.dateStart)!) as Date))
                taskHoursEnd.append(formatter.string(from: NSDate(timeIntervalSince1970: Double(task.dateFinish)!) as Date))

                formatter.dateFormat = "mm"
                taskMinetsBegin.append(formatter.string(from: NSDate(timeIntervalSince1970: Double(task.dateStart)!) as Date))
                taskMinetsEnd.append(formatter.string(from: NSDate(timeIntervalSince1970: Double(task.dateFinish)!) as Date))
            }
        } catch {
            print("decode error")
        }
    }
}
