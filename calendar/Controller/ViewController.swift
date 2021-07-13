// swiftlint:disable line_length
//copy

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,
                      UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var calendarView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var timeTable: UITableView!

    let months = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август",
                  "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    let dayOfMonths = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье" ]
    var daysInMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    var timeOfDay = ["00.00 - 01.00", "01.00 - 02.00", "02.00 - 03.00", "03.00 - 04.00",
                     "04.00 - 05.00", "05.00 - 06.00", "06.00 - 07.00", "07.00 - 08.00",
                     "08.00 - 09.00", "09.00 - 10.00", "10.00 - 11.00", "11.00 - 12.00",
                     "12.00 - 13.00", "13.00 - 14.00", "14.00 - 15.00", "15.00 - 16.00",
                     "16.00 - 17.00", "17.00 - 18.00", "18.00 - 19.00", "19.00 - 20.00",
                     "20.00 - 21.00", "21.00 - 22.00", "22.00 - 23.00", "23.00 - 00.00"]
    var taskDetail = [String](repeating: "", count: 24)
    let taskDetailDefault = [String](repeating: "", count: 24)

    var sendTask = [String](repeating: "", count: 4)

    var currentMonth = String()

    var numberOfEmptyDay = Int()
    var nextNumberOfEmptyDay = Int()
    var prevNumberOfEmptyDay = 0
    var directionOfDay = 0
    var positionDayInMonth = 0

    var yearCounter = 1
    var dayCounter = 0

    var dateString = String()
    var timestamp = String()

    let myJSON = PrepareJSON()

    var direction = Int()

    var compareDateString = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "ru_RU")

        currentMonth = months[month]
        monthLabel.text = "\(currentMonth) \(year)"
        if weekday == 0 {
            weekday = 0
        }
        getStartDayPosition()

        if let localData = myJSON.readJSONFile(forName: "jCal") {
            myJSON.parseJSON(jsonData: localData)
        }
    }

    @IBAction func forwardMonth(_ sender: UIButton) {
        switch  currentMonth {
        case "Декабрь":
            month = 0
            year += 1

            directionOfDay = 1

            if yearCounter < 5 {
                yearCounter += 1
            }
            if yearCounter == 4 {
                daysInMonths[1] = 29
            }
            if yearCounter == 5 {
                yearCounter = 1
                daysInMonths[1] = 28
            }

            getStartDayPosition()

            currentMonth = months[month]

            monthLabel.text = "\(currentMonth) \(year)"
            calendarView.reloadData()
        default:

            directionOfDay = 1

            getStartDayPosition()

            month += 1

            currentMonth = months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            calendarView.reloadData()
        }

        taskDetail = taskDetailDefault
        timeTable.reloadData()
    }
    @IBAction func backMonth(_ sender: Any) {
        switch  currentMonth {
        case "Январь":
            month = 11
            year -= 1

            directionOfDay = -1

            if yearCounter > 0 {
                yearCounter -= 1
            }
            if yearCounter == 0 {
                daysInMonths[1] = 29
                yearCounter = 4
            } else {
                daysInMonths[1] = 28
            }

            getStartDayPosition()

            currentMonth = months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            calendarView.reloadData()
        default:
            month -= 1
            directionOfDay = -1

            getStartDayPosition()

            currentMonth = months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            calendarView.reloadData()
        }

        taskDetail = taskDetailDefault
        timeTable.reloadData()
    }

    func getStartDayPosition() {
        switch directionOfDay {
        case 0:
            numberOfEmptyDay = weekday
            dayCounter = day
            while dayCounter > 0 {
                if numberOfEmptyDay == 0 {
                    numberOfEmptyDay = 7
                }
                numberOfEmptyDay -= 1
                dayCounter -= 1
            }
            if numberOfEmptyDay == 7 {
                numberOfEmptyDay = 0
            }
            positionDayInMonth = numberOfEmptyDay

        case 1:
            nextNumberOfEmptyDay = (positionDayInMonth + daysInMonths[month]) % 7
            positionDayInMonth = nextNumberOfEmptyDay

        case -1:
            prevNumberOfEmptyDay = (7 - (daysInMonths[month] - positionDayInMonth) % 7)
            if prevNumberOfEmptyDay == 7 {
                prevNumberOfEmptyDay = 0
            }
            positionDayInMonth = prevNumberOfEmptyDay
        default:
            fatalError()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        switch directionOfDay {
        case 0:
            return daysInMonths[month] + numberOfEmptyDay
        case 1:
            return daysInMonths[month] + nextNumberOfEmptyDay
        case -1:
            return daysInMonths[month] + prevNumberOfEmptyDay
        default:
            fatalError()
        }

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar",
                   for: indexPath) as! DateCollectionViewCell// swiftlint:disable:this force_cast
        cell.backgroundColor = UIColor.clear

        if cell.isHidden {
            cell.isHidden = false
        }

        switch directionOfDay {
        case 0:
            direction = numberOfEmptyDay
        case 1:
            direction = nextNumberOfEmptyDay
        case -1:
            direction = prevNumberOfEmptyDay
        default:
            fatalError()
        }

        cell.dayLabel.text = "\(indexPath.row + 1 - direction)"

        if Int(cell.dayLabel.text!)! < 1 {
            cell.isHidden = true        }
        if currentMonth == months[calendar.component(.month, from: date) - 1] &&
            year == calendar.component(.year, from: date) &&
            indexPath.row + 1 - numberOfEmptyDay == day {
            cell.backgroundColor = .red
        }

            let monthIndex = months.firstIndex(of: currentMonth)! + 1

            if monthIndex < 10 {
                compareDateString = "\(indexPath.row + 1 - direction)-0\(monthIndex)-\(year)"
            } else {
                compareDateString = "\(indexPath.row + 1 - direction)-\(monthIndex)-\(year)"
            }
            if indexPath.row + 1 - direction < 10 {
                compareDateString = "0\(compareDateString)"
            }
        if  myJSON.taskBegin.contains(compareDateString) {
            if cell.backgroundColor == .red {
                cell.backgroundColor = .purple
            } else {
                cell.backgroundColor = .green
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        taskDetail = taskDetailDefault

            let monthIndex = months.firstIndex(of: currentMonth)! + 1

            if monthIndex < 10 {
                compareDateString = "\(indexPath.row + 1 - direction)-0\(monthIndex)-\(year)"
            } else {
                compareDateString = "\(indexPath.row + 1 - direction)-\(monthIndex)-\(year)"
            }
            if indexPath.row + 1 - direction < 10 {
                compareDateString = "0\(compareDateString)"
            }

        if myJSON.taskBegin.contains(compareDateString) {

            for count in 0..<myJSON.taskBegin.count where myJSON.taskBegin[count] == compareDateString {
                guard let indexHour: Int = Int(myJSON.taskHoursBegin[count]) else { continue }
                taskDetail[indexHour] = myJSON.taskName[count]
            }
        }
        timeTable.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeOfDay.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")

        cell?.textLabel?.text = timeOfDay[indexPath.row]
        cell?.detailTextLabel?.text = taskDetail[indexPath.row]

        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var hourString = ""
        if indexPath.row < 10 {
            hourString = "0\(indexPath.row)"
        } else {
            hourString = "\(indexPath.row)"        }

        if  myJSON.taskHoursBegin.contains(hourString) {
            for idx in 0..<myJSON.taskHoursBegin.count {
                if myJSON.taskBegin[idx] == compareDateString && myJSON.taskHoursBegin[idx] == hourString {
                    sendTask[0] = myJSON.taskName[idx]
                    sendTask[1] = "\(myJSON.taskBegin[idx]) "
                    sendTask[2] = "\(myJSON.taskHoursBegin[idx]):\(myJSON.taskMinetsBegin[idx]) - \(myJSON.taskHoursEnd[idx]):\(myJSON.taskMinetsEnd[idx])"
                    sendTask[3] = myJSON.taskDescription[idx]

                    performSegue(withIdentifier: "detailSegue", sender: nil)
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dvc = segue.destination as? DetailViewController else { return }
        dvc.nameTask = sendTask[0]
        dvc.dateTask = sendTask[1]
        dvc.timeTask = sendTask[2]
        dvc.descriptionTask = sendTask[3]
    }

    @IBAction func unwindSegueToMainScreen(segue: UIStoryboardSegue) {
    }

}
