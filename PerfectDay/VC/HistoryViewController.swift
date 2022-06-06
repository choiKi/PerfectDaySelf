//
//  HistoryViewController.swift
//  PerfectDay
//
//  Created by 최기훈 on 2022/05/23.
//

import UIKit
import RealmSwift

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var viewContainer: UIStackView!
    @IBOutlet weak var textViewContainer: UIView!
    @IBOutlet weak var infoText: UILabel!
    @IBOutlet weak var segmentView: UISegmentedControl!
    
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewContainer.layer.cornerRadius = 10
        infoTextSetting()
        
    }
    
    func infoTextSetting() {
        
        infoText.translatesAutoresizingMaskIntoConstraints = false
        infoText.centerXAnchor.constraint(equalTo: textViewContainer.centerXAnchor).isActive = true
        infoText.centerYAnchor.constraint(equalTo: textViewContainer.centerYAnchor).isActive = true
        
        textViewContainer.layer.cornerRadius = 15
        infoText.text = "점수 = 성공 / 전체"
        infoText.numberOfLines = 5
    }

    func scoreCalculator() {
        
        let scheduleListArray = realm.objects(ScheduleList1.self)
        
        
        
        
    }
    

}
