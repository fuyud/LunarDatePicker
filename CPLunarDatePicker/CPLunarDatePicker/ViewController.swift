//
//  ViewController.swift
//  CPLunarDatePicker
//
//  Created by Company on 2023/6/16.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func lunrDateAction(_ sender: UIButton) {
        
        CPLunarDatePickerView.showPickerView(title: "请选择") { res in
            if res?.isUnkonwn ?? false {
                print("不详")
                return
            }
            print("阳历" + (res?.value ?? ""))
            print("农历" + (res?.value1 ?? ""))
        }
        
    }
    
    @IBAction func normalDate(_ sender: UIButton) {
        let minDate = self.stringToDate("2022-8-22 12:34:50")
        let maxDate = self.stringToDate("2026-9-13 08:20:50")
        CPDatePickerView.showPickerView(minDate: minDate, maxDate: maxDate) { res in
            print("选择日期" + (res ?? ""))
        }
    }
    
    /// 字符串转Date
    func stringToDate(_ string:String, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: string)
        return date!
    }
    
    @IBAction func stringSelect(_ sender: UIButton) {
        CPStringPickerView.showPickerView(stringDatasource: CPPickerManager.lunarMonths) { res in
            print("选择index：" + "\(res?.index ?? 0)")
            print("选择value：" + (res?.value ?? ""))
        }
    }
    
}

