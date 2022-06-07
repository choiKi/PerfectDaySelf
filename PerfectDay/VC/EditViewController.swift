//
//  EditViewController.swift
//  PerfectDay
//
//  Created by 최기훈 on 2022/05/17.
//

import UIKit
import RealmSwift

class EditViewController: UIViewController {

    
    @IBOutlet weak var editTextField: UITextField!
    @IBOutlet weak var editDatePicker: UIDatePicker!
    @IBOutlet weak var selectedDateLabel: UILabel!
    
    var paramDate = 0
    var paramTitle = ""
    var paramTime = ""
    var paramSuccess: Bool = false
    var selectedDay = ""
    var selectTime = ""
    var successNow: Bool = false
    
    let realm = try! Realm()
    let vc = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        editTextField.text = paramTitle
        selectTime = paramTime
        successNow = paramSuccess
        
        selectedDateLabel.text = selectedDay
        print(paramTitle)
        print(selectTime)
        print(successNow)
    }
    
    @IBAction func changedDatePicker(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "HH:mm"
        selectTime = formatter.string(from: sender.date)
        print(selectTime)
    }
    
    @IBAction func pressDeleteBtn(_ sender: UIButton) {
        
        let scheduleByDate = realm.objects(ScheduleByDate1.self)
        let deleteTitle = scheduleByDate.filter("title == '\(paramTitle)'")
        let deleteTime = scheduleByDate.filter("time == '\(paramTime)'")
        // let deleteSuccess = scheduleByDate.filter("success == '\(paramSuccess)'")
        
        if deleteTitle.count != 1 {
            print("oops")
        }
        
        try! realm.write{
            realm.delete(deleteTitle)
            realm.delete(deleteTime)
            //realm.delete(deleteSuccess)
        }
        navigationController?.popViewController(animated: true)
        vc.tableView?.reloadData()
    }
    
    @IBAction func pressEditButton(_ sender: UIButton) {
        
        overlapTest()
        navigationController?.popViewController(animated: true)
        vc.tableView?.reloadData()
        
    }
    
    @IBAction func successChange(_ sender: UIButton) {
        
        if successNow == false {
            successNow = true
        } else {
            successNow = false
        }
        print(successNow)
        
    }
    func overlapTest() {
        
        let selectedDayArray = realm.objects(ScheduleByDate1.self).filter("date = '\(selectedDay)'")
        let selectedDayArrayExistTime = selectedDayArray.filter("time = '\(selectTime)' && title !='\(paramTitle)'")
        
        let scheduleByDate = realm.objects(ScheduleByDate1.self)
        let updateScheduleTitle = scheduleByDate.filter("title =='\(paramTitle)' && date =='\(selectedDay)'")
        let updateScheduleTime = scheduleByDate.filter("time =='\(paramTime)' && date =='\(selectedDay)'")
        let updateSuccess = scheduleByDate.filter("date == '\(selectedDay)' && time =='\(paramTime)' && title == '\(paramTitle)'")
        
        print("성공 타겟: \(updateSuccess)")
        if editTextField.text != "" {
            
            
            print("선택된 날짜들 :  \(selectedDayArray)")
            print("선택된 날짜의 시간 :  \(selectedDayArrayExistTime)")
            print("현재 성공 유무: \(successNow)")
        
            if selectedDayArrayExistTime.isEmpty {
                
                print("겹치는 시간 없음")
                try! realm.write{
                    updateScheduleTitle.first?.title = editTextField.text!
                    updateScheduleTime.first?.time = selectTime
                    updateSuccess.first?.success = successNow
                }
            } else {
                alert2()
            }
        }else {
            alert()
        }
        
    }
    func alert() {
        let nilAlert = UIAlertController(title: " 계획을 입력해주세요 ",
                                         message: "",
                                         preferredStyle: .alert)
        let onAction = UIAlertAction(title: "네, 알겠습니다.", style: .cancel , handler: nil)
                   
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
