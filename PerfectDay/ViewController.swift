//
//  ViewController.swift
//  PerfectDay
//
//  Created by 최기훈 on 2022/05/15.
//

import UIKit
import RealmSwift
import FSCalendar
import Foundation

class ViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    
    let dateFormatter = DateFormatter()
    let realm = try! Realm()
    var selectedDay = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.calendar.delegate = self
        self.calendar.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        print(realm.configuration.fileURL!)
        calendarSetting()
        daySetting()
        dataFutureToPast()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        sortedDate()
        tableView.reloadData()
    }
    
    @IBAction func addBtnPress(_ sender: UIButton) {
        let addVC = UIStoryboard(name: "AddView", bundle: nil).instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        
        addVC.selectedDay = todayLabel.text!
        navigationController?.pushViewController(addVC, animated: true)
    }
    

    // 현재일로 부터 지나면 데이터를 HistoryDB로 옮김
    func dataFutureToPast() {
        
        let schedulePast = realm.objects(ScheduleByDate1.self)
        // let scheduleHistory = realm.objects(HistoryByDate1.self)
        
        dateFormatter.dateFormat = "YYMMdd"
        let today = dateFormatter.string(from: Date())
        let yesterday = dateFormatter.string(from: Date().dayBefore)
        
        
        print("today = \(today)")
        print("yesterday = \(yesterday)")
        // db에 있는 YY년 MM월 dd일 을 YYMMdd형태로 바꿈
        
        // 여기 작성해야됨 !!
        // db의 있는 날들 array로 다 받아오고 (for)
        // array에서 오늘보다 과거의날이 있을경우 (while)
        // 그 date해당 데이터 싹다 history 로 넘김
        // 그 date해당 데이터 싹다 현재데이터에서 삭제!
        // 오늘 기준으로 30일 이 지나면 history에서도 삭제!
                
        let sepDay =  schedulePast.first?.date.components(separatedBy: [" ", "년", "월", "일"])
        let yymmddDay = sepDay?.joined(separator: "")
        print(yymmddDay!)
        
        guard let ymdDay = yymmddDay else { return }
        // 데이터의 날짜가 오늘보다 전날인 데이터가 존재하면
        if Int(ymdDay)! < Int(today)! {
            print("past exist")
            
            // while Int(ymdDay)! < Int(today)!
            var filterPast = schedulePast.first?.date.components(separatedBy: [" ", "년", "월", "일"])
            var joinFilterPast = filterPast?.joined(separator: "")
            
            // realm에 schedulePast.first?의 값들을 History에 저장
            // realm에 schedulePast.first의 값들을 ScheduleByDate에서 삭제
            // 더이상 삭제할 데이터가 없다면 종료
            
        }else {
            print("no past")
        }
    }

}

// TableView 관련 모음

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let scheduleByDate = realm.objects(ScheduleByDate1.self)
        let selectedCnt = scheduleByDate.filter("date = '\(selectedDay)'")
        
        return selectedCnt.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var selectedDayArray = realm.objects(ScheduleByDate1.self).filter("date = '\(selectedDay)'")
        selectedDayArray = selectedDayArray.sorted(byKeyPath: "time", ascending: true)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ScheduleTableViewCell
        
        /*
         let scheduleListArray = realm.objects(ScheduleList1.self)
         cell.titleLabel.text = scheduleListArray.first?.scheduleList.filter("date = '\(selectedDay)'")[indexPath.row].title
         cell.timeLabel.text = scheduleListArray.first?.scheduleList.filter("date = '\(selectedDay)'")[indexPath.row].time
        */
        
        cell.titleLabel.text = selectedDayArray[indexPath.row].title
        cell.timeLabel.text = selectedDayArray[indexPath.row].time
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let scheduleListArray = realm.objects(ScheduleList1.self)
        
        var selectedDayArray = realm.objects(ScheduleByDate1.self).filter("date = '\(selectedDay)'")
        selectedDayArray = selectedDayArray.sorted(byKeyPath: "time", ascending: true)
        
        let editVC = UIStoryboard(name: "EditView", bundle: nil).instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        
        editVC.paramTitle = selectedDayArray[indexPath.row].title
        editVC.paramTime = selectedDayArray[indexPath.row].time
        editVC.paramSuccess = selectedDayArray[indexPath.row].success
        editVC.selectedDay = todayLabel.text!
        /*
        editVC.paramTitle = (scheduleListArray.first?.scheduleList.filter("date = '\(selectedDay)'")[indexPath.row].title)!
        editVC.paramTime = (scheduleListArray.first?.scheduleList.filter("date = '\(selectedDay)'")[indexPath.row].time)!
        editVC.paramSuccess = (scheduleListArray.first?.scheduleList.filter("date = '\(selectedDay)'")[indexPath.row].success)!
        editVC.selectedDay = todayLabel.text!
         */
        
        self.navigationController?.pushViewController(editVC, animated: true)
        
    }
    func removeTarget(target: String ,Rmtarget string : String) -> String {
        return target.components(separatedBy: string).joined()
    }
    
    func sortedDate() {
        var beforeSort = realm.objects(ScheduleByDate1.self)
        beforeSort =  beforeSort.sorted(byKeyPath: "date", ascending: true)
        //  print(beforeSort)
    }

    
    
   
    
    
}
extension ViewController {
    
    func calendarSetting() {
        // 선택된 날짜 색
        calendar.appearance.selectionColor = UIColor(red: 38/255, green: 153/255, blue: 251/255, alpha: 1)
        // 오늘 날짜 색
        calendar.appearance.todayColor = UIColor(red: 188/255, green: 224/255, blue: 253/255, alpha: 1)
        // 달력 스크롤 수직
        calendar.scrollDirection = .vertical
        calendar.appearance.titleWeekendColor = .red
        calendar.appearance.headerDateFormat = "YYYY년  M월"
        
        
    }
    
    func daySetting() {
        dateFormatter.dateFormat = "YY년 MM월 dd일"
        let today = dateFormatter.string(from: Date())
        todayLabel.text = today
        
    }
    
    public func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "YY년 MM월 dd일"
         todayLabel.text = dateFormatter.string(from: date)
         selectedDay = dateFormatter.string(from: date)
         tableView.reloadData()
        
     }
    
    // 지난 날 클릭 금지
    
    /*
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if date .compare(Date()) == .orderedAscending {
            // 지난 날짜 달력 클릭 금지
            // 한달 이상 뒤 날짜 달력 클릭 금지
            return false
        }else {
            return true
        }
    }
     */
    

}
extension Date {
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    var deleteDay: Date {
        return Calendar.current.date(byAdding: .day, value: -30, to: self)!
    }
}


class ScheduleByDate1: Object {
    @objc dynamic var date: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var time: String = ""
    @objc dynamic var success: Bool = false
}

class ScheduleList1: Object {
    var scheduleList = List<ScheduleByDate1>()
}

class HistoryByDate1: Object {
    @objc dynamic var date: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var time: String = ""
    @objc dynamic var success: Bool = false
}

class HistoryList1: Object {
    var historyList = List<HistoryByDate1>()
}






//MARK:- 안쓰는거


