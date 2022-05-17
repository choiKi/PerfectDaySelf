//
//  ViewController.swift
//  PerfectDay
//
//  Created by 최기훈 on 2022/05/15.
//

import UIKit
import RealmSwift
import FSCalendar

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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func addBtnPress(_ sender: UIButton) {
        let addVC = UIStoryboard(name: "AddView", bundle: nil).instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        
        addVC.selectedDay = todayLabel.text!
        navigationController?.pushViewController(addVC, animated: true)
    }


}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let scheduleByDate = realm.objects(ScheduleByDate1.self)
        let selectedCnt = scheduleByDate.filter("date = '\(selectedDay)'")
        
        return selectedCnt.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let scheduleListArray = realm.objects(ScheduleList1.self)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ScheduleTableViewCell
        
         cell.titleLabel.text = scheduleListArray.first?.scheduleList.filter("date = '\(selectedDay)'")[indexPath.row].title
         cell.timeLabel.text = scheduleListArray.first?.scheduleList.filter("date = '\(selectedDay)'")[indexPath.row].time
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let scheduleListArray = realm.objects(ScheduleList1.self)
        
        let editVC = UIStoryboard(name: "EditView", bundle: nil).instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        
        editVC.paramTitle = (scheduleListArray.first?.scheduleList.filter("date = '\(selectedDay)'")[indexPath.row].title)!
        editVC.paramTime = (scheduleListArray.first?.scheduleList.filter("date = '\(selectedDay)'")[indexPath.row].time)!
        editVC.paramSuccess = (scheduleListArray.first?.scheduleList.filter("date = '\(selectedDay)'")[indexPath.row].success)!
        editVC.selectedDay = todayLabel.text!
        
        self.navigationController?.pushViewController(editVC, animated: true)
        
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










//MARK:- 안쓰는거


