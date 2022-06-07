//
//  AddViewController.swift
//  PerfectDay
//
//  Created by 최기훈 on 2022/05/16.
//

import UIKit
import RealmSwift
import Foundation

class AddViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var selectedDateLabel: UILabel!
    
    
    let realm = try! Realm()
    let vc = ViewController()
    
    let timeStringFormatter = DateFormatter()
    let timeIntFormatter = DateFormatter()
    
    var selectTime: String = ""
    var selectedDay: String = "dd"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        selectedDateLabel.text = selectedDay
        
    }
    
    @IBAction func pressSaveBtn(_ sender: UIButton) {
        
        saveData()
        vc.tableView?.reloadData()
        navigationController?.popViewController(animated: true)
        
    }
   
    @IBAction func changedDatePicker(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "HH:mm"
        selectTime = formatter.string(from: sender.date)
        print(selectTime)
    }
    
    
    func saveData() {
        
        let selectedDayArray = realm.objects(ScheduleByDate1.self).filter("date = '\(selectedDay)'")
        let selectedDayArrayExistTime = selectedDayArray.filter("time = '\(selectTime)'")
        if titleTextField.text != "" , selectTime != "" {
            
            let scheduleByDate = ScheduleByDate1()
            let scheduleListArray = ScheduleList1()
            
            scheduleByDate.date = selectedDay
            scheduleByDate.title = titleTextField.text!
            scheduleByDate.time = selectTime
            scheduleByDate.success = false
            
            print("선택된 날짜들 :  \(selectedDayArray)")
            print("선택된 날짜의 시간 :  \(selectedDayArrayExistTime)")
            
            if selectedDayArrayExistTime.isEmpty {
                print("겹치는 시간이 없음")
                if realm.objects(ScheduleList1.self).isEmpty == true {
                        let scheduleListArray = ScheduleList1()
                        scheduleListArray.scheduleList.append(scheduleByDate)
                        
                        try! realm.write{
                            realm.add(scheduleListArray)
                        }
                    } else {
                        try! realm.write {
                                        let scheduleListArray = realm.objects(
                                            ScheduleList1.self)
                                        scheduleListArray.first?.scheduleList.append(scheduleByDate)
                                }
                        }
                    
                } else {
                    alert2()
                }
            }else {
                alert1()
            }
                
            
    }
    
    func alert1() {
        let nilAlert = UIAlertController(title: " 계획을 입력해주세요 ",
                                         message: "시간은 설정하셨나요?",
                                         preferredStyle: .alert)
        let onAction = UIAlertAction(title: "알겠습니다", style: .cancel , handler: nil)
                   
        nilAlert.addAction(onAction)
        present(nilAlert, animated: true, completion: nil)
    }
    
    func alert2() {
        let nilAlert = UIAlertController(title: " 이미 계획된 시간입니다. ",
                                         message: "시간을 다시 확인해주세요",
                                         preferredStyle: .alert)
        let onAction = UIAlertAction(title: "알겠습니다", style: .cancel , handler: nil)
                   
        nilAlert.addAction(onAction)
        present(nilAlert, animated: true, completion: nil)
    }
    

}


