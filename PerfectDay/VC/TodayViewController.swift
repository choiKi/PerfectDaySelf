//
//  TodayViewController.swift
//  PerfectDay
//
//  Created by 최기훈 on 2022/05/18.
//

import UIKit
import RealmSwift

class TodayViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var today: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let dateFormatter = DateFormatter()
    let realm = try! Realm()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateFormat = "YY년 MM월 dd일"
        let toda = dateFormatter.string(from: Date())
        today.text = toda
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dateFormatter.dateFormat = "YY년 MM월 dd일"
        let toda = dateFormatter.string(from: Date())
        
        let scheduleByDate = realm.objects(ScheduleByDate1.self)
        let todaySchedule = scheduleByDate.filter("date = '\(toda)'")
        
        return todaySchedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell", for: indexPath) as! TodayTableViewCell
        
        let scheduleListArray = realm.objects(ScheduleList1.self)
        
        dateFormatter.dateFormat = "YY년 MM월 dd일"
        
        let toda = dateFormatter.string(from: Date())
        
        var selectedDayArray = realm.objects(ScheduleByDate1.self).filter("date = '\(toda)'")
        selectedDayArray = selectedDayArray.sorted(byKeyPath: "time", ascending: true)
        
        /*
         cell.titleLabel.text = scheduleListArray.first?.scheduleList.filter("date = '\(selectedDay)'")[indexPath.row].title
         cell.timeLabel.text = scheduleListArray.first?.scheduleList.filter("date = '\(selectedDay)'")[indexPath.row].time
        */
        
        cell.title.text = selectedDayArray[indexPath.row].title
        cell.time.text = selectedDayArray[indexPath.row].time
        
        return cell
        /*
        cell.title.text = scheduleListArray.first?.scheduleList.filter("date = '\(toda)'")[indexPath.row].title
        cell.time.text = scheduleListArray.first?.scheduleList.filter("date = '\(toda)'")[indexPath.row].time
        */
        return cell
    }
    

    

}
