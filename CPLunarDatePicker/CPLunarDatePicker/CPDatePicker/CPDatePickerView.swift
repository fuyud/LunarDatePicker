//
//  CPDatePickerView.swift
//  ClanPedigree
//
//  Created by Company on 2023/6/13.
//

import UIKit

class CPDatePickerView: CPBasePickerView {
    
    struct CPDateConstant {
        static let dateHeaderViewHeight: CGFloat = 40
    }
    
    /// *************************** public **************************
    
    /// 开始年-结束年，默认1800-2200。支持公元后的任意年
    var startEndYear: (startYear: Int, endYear: Int) = (1, 2200) { didSet { reloadAllYears() } }
    
    var dateMode: CPDateType = .YMDHMS {
        didSet {
            switch dateMode {
            case .YY:
                comps = [.year]
                solarDateFormat = "yyyy"
            case .YM:
                comps = [.year, .month]
                solarDateFormat = "yyyy-MM"
            case .YMD:
                comps = [.year, .month, .day]
                solarDateFormat = "yyyy-MM-dd"
            case .YMDH:
                comps = [.year, .month, .day, .hour]
                solarDateFormat = "yyyy-MM-dd HH"
            case .YMDHM:
                comps = [.year, .month, .day, .hour, .min]
                solarDateFormat = "yyyy-MM-dd HH:mm"
            case .YMDHMS:
                comps = [.year, .month, .day, .hour, .min, .sec]
                solarDateFormat = "yyyy-MM-dd HH:mm:ss"
            default:
                comps = [.year, .month, .day, .hour]
                solarDateFormat = "yyyy-MM-dd HH"
            }
        }
    }
    
    /// 显示哪些列，包含：年、月、日、时、分、秒，默认全部包含
    var comps: [CPNormalDateType] = CPNormalDateType.allCases {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    
    /// 公历字符串的配置方式
    var solarDateFormat: String = "yyyy-MM-dd HH:mm:ss"
    
    /// 当前选中的年，默认当前时间
    var selectDate: CPNormalDate {
        get { return _sD }
        set {
            _sD = newValue
            reloadSelectDate()
        }
    }
    
    /// 标准时间字符串： 公历根据`solarDateFormat`设置；农历全部返回，例如`2022年八月十七 23:29:34`
    private(set) var selectDateString: String?
    
    /// 字体
    var pickerFont = UIFont.font(AplCMD: 18)
    
    /// 文本颜色
    var pickerTextColor = UIColor.black
    
    var sureResultClourse: CPParamClosure<String>?
    
    /// *************************** private **************************
    
//    private let chinaLocal = Locale(identifier: "zh_CN")
    private let chinaTimeZone = TimeZone(identifier: "Asia/Shanghai")
    
    private lazy var _sD: CPNormalDate = {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = chinaTimeZone!
        let comps = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        return CPNormalDate(year: comps.year ?? startEndYear.startYear,
                            month: comps.month ?? 1,
                            day: comps.day ?? 1,
                            hour: comps.hour ?? 0,
                            minute: comps.minute ?? 0,
                            second: comps.second ?? 0,
                            isLeapMonth: false)
    }()
    
    private func reloadAllYears() {
        // 更新年份数据
        allYears.removeAll()
        let allYearCount = startEndYear.endYear - startEndYear.startYear
        for i in 0..<allYearCount {
            allYears.append(i + startEndYear.startYear)
        }
        reloadSelectDate()
    }
    
    private func reloadSelectDate() {
        pickerView.reloadAllComponents()
        setupSelectDateString()
        comps.forEach {
            switch $0 {
            case .year:
                var selectYear = _sD.year - startEndYear.startYear
                if selectYear < 0 {
                    selectYear = startEndYear.startYear
                }
                pickerView.selectRow(selectYear, inComponent: CPNormalDateType.year.rawValue, animated: false)
            case .month:
                let selectMonth = _sD.month-1
                pickerView.selectRow(selectMonth, inComponent: CPNormalDateType.month.rawValue, animated: false)
            case .day:
                pickerView.selectRow(_sD.day-1, inComponent: CPNormalDateType.day.rawValue, animated: false)
            case .hour:
                pickerView.selectRow(_sD.hour, inComponent: CPNormalDateType.hour.rawValue, animated: false)
            case .min:
                pickerView.selectRow(_sD.minute, inComponent: CPNormalDateType.min.rawValue, animated: false)
            case .sec:
                pickerView.selectRow(_sD.second, inComponent: CPNormalDateType.sec.rawValue, animated: false)
            }
        }
    }
    
    /// 根据当前选中的年月日时分秒，配置一个标准的时间字符串
    private func setupSelectDateString() {
        let dateComps = DateComponents(calendar: Calendar(identifier: .gregorian),
                                       timeZone: chinaTimeZone,
                                       year: _sD.year,
                                       month: _sD.month,
                                       day: _sD.day,
                                       hour: _sD.hour,
                                       minute: _sD.minute,
                                       second: _sD.second)
        guard let date = dateComps.date else { return }
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = solarDateFormat
        timeFormatter.timeZone = chinaTimeZone
        selectDateString = timeFormatter.string(from: date)
        
//        print("当前选择时间：" + (selectDateString ?? ""))
    }

    //MARK: --- lazy ---
    lazy var dateHeaderView: CPDatePickerHeaderView = {
        let dateHeaderView = CPDatePickerHeaderView.init(frame: CGRect(x: 0, y: Constant.pickerViewTop, width: contentView.cp_width, height: CPDateConstant.dateHeaderViewHeight))
        dateHeaderView.backgroundColor = .white
        return dateHeaderView
    }()
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView.init(frame: CGRect(x: 0, y: dateHeaderView.cp_bottom, width: contentView.cp_width, height: Constant.pickerViewHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    private lazy var allYears: [Int] = []
    
    private lazy var allMonths: [Int] = {
        var arr: [Int] = []
        for i in 1...12 { arr.append(i) }
        return arr
    }()
    
    private lazy var allHours: [Int] = {
        var arr: [Int] = []
        for i in 0..<24 { arr.append(i) }
        return arr
    }()
    
    private lazy var allMins: [Int] = {
        var arr: [Int] = []
        for i in 0..<60 { arr.append(i) }
        return arr
    }()
    
    private lazy var allSecs: [Int] = {
        var arr: [Int] = []
        for i in 0..<60 { arr.append(i) }
        return arr
    }()
}

extension CPDatePickerView {
    func show() {
        sureClourse = {[weak self] in
            guard let self = self else { return }
            if self.sureResultClourse != nil {
                self.sureResultClourse!(self.selectDateString)
            }
        }
        contentHeight += CPDateConstant.dateHeaderViewHeight
        contentView.addChildViews([dateHeaderView, pickerView])
        initUI()
    }
    
    /// - Parameters:
    ///  - start:     开始年
    ///  - end:       结束年
    ///  - dateMode:  年月日时分秒
    ///  - selectValue: 选择时间
    /// - Returns: void
    static func showPickerView(title: String = "请选择", start: Int = 1, end: Int = 0, dateMode: CPDateType = .YMDHMS, selectValue: String = "", _ sureClourse: @escaping CPParamClosure<String>) {
        let pickerView = CPDatePickerView()
        pickerView.titleLabel.text = title
        pickerView.dateHeaderView.mode = dateMode
        pickerView.dateMode = dateMode
        let endYear = (end == 0) ? (String.getCurrentYear() + 100) : end
        pickerView.startEndYear = (start, endYear)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: selectValue) ?? Date()
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = CPPickerManager.chinaTimeZone!
        let comps = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        pickerView.selectDate = CPNormalDate(year: comps.year ?? start,
                                                     month: comps.month ?? 1,
                                                     day: comps.day ?? 1,
                                                     hour: comps.hour ?? 0,
                                                     minute: comps.minute ?? 0,
                                                     second: comps.second ?? 0,
                                                     isLeapMonth: false)
        pickerView.sureResultClourse = sureClourse
        pickerView.show()
    }
}

// MARK: --- UIPickerViewDelegate, UIPickerViewDataSource ---
extension CPDatePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { comps.count }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == CPNormalDateType.year.rawValue {
            return allYears.count
        } else if component == CPNormalDateType.month.rawValue {
            return allMonths.count
        } else if component == CPNormalDateType.day.rawValue {
            return CPPickerManager.getSolarDaysCount(inYear: _sD.year, month: _sD.month)
        } else if component == CPNormalDateType.hour.rawValue {
            return allHours.count
        } else if component == CPNormalDateType.min.rawValue {
            return allMins.count
        } else if component == CPNormalDateType.sec.rawValue {
            return allSecs.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = pickerFont
            pickerLabel?.textColor = pickerTextColor
            pickerLabel?.textAlignment = .center
        }
        var str = ""
        if component == CPNormalDateType.year.rawValue {
            str = "\(allYears[row])"
        } else if component == CPNormalDateType.month.rawValue {
            str = "\(allMonths[row])"
        } else if component == CPNormalDateType.day.rawValue {
            str = "\(row+1)"
        } else if component == CPNormalDateType.hour.rawValue {
            str = "\(allHours[row])"
        } else if component == CPNormalDateType.min.rawValue {
            str = "\(allMins[row])"
        } else if component == CPNormalDateType.sec.rawValue {
            str = "\(allSecs[row])"
        } else {
            str = String(row)
        }
        pickerLabel?.text = str
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == CPNormalDateType.year.rawValue {
            _sD.year = allYears[row]
            pickerView.reloadComponent(CPNormalDateType.month.rawValue)
            pickerView.reloadComponent(CPNormalDateType.day.rawValue)
        } else if component == CPNormalDateType.month.rawValue {
            _sD.isLeapMonth = false
            _sD.month = allMonths[row]
            
            //更改月份时，如果当前选中日(31)超过了当前月份的总天数(30)，则选中日置为当前月最后一天(30)
            let daysCount = CPPickerManager.getSolarDaysCount(inYear: _sD.year, month: _sD.month)
            if _sD.day > daysCount {
                _sD.day = daysCount
            }
            pickerView.reloadComponent(CPNormalDateType.day.rawValue)
        } else if component == CPNormalDateType.day.rawValue {
            _sD.day = row+1
        } else if component == CPNormalDateType.hour.rawValue {
            _sD.hour = allHours[row]
        } else if component == CPNormalDateType.min.rawValue {
            _sD.minute = allMins[row]
        }
        
        setupSelectDateString()
    }
}
