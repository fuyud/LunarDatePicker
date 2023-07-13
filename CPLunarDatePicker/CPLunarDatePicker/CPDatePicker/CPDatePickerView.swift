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
    
//    /// 开始年-结束年，默认1800-2200。支持公元后的任意年 选择世纪时使用
//    var startEndYear: (startYear: Int, endYear: Int) = (1, 2200) { didSet { reloadAllYears() } }
    
    var minDate: Date = Date.distantPast
    
    var maxDate: Date = Date.distantFuture
    
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
            reloadAllYears()
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
        return CPNormalDate(year: comps.year ?? minDate.cp_year(),
                            month: comps.month ?? 1,
                            day: comps.day ?? 1,
                            hour: comps.hour ?? 0,
                            minute: comps.minute ?? 0,
                            second: comps.second ?? 0,
                            isLeapMonth: false)
    }()
    
    /// 更新年份数据
    private func reloadAllYears() {
        allYears.removeAll()
        let maxYear = maxDate.cp_year()
        let minYear = minDate.cp_year()
        for i in minYear...maxYear {
            allYears.append(i)
        }
        reloadAllMonths(year: _sD.year)
        reloadAllDays(year: _sD.year, month: _sD.month)
        reloadAllHours(year: _sD.year, month: _sD.month, day: _sD.day)
        reloadAllMins(year: _sD.year, month: _sD.month, day: _sD.day, hour: _sD.hour)
        reloadAllSeconds(year: _sD.year, month: _sD.month, day: _sD.day, hour: _sD.hour, minute: _sD.minute)
        reloadSelectDate()
    }
    
    /// 更新月份数据
    private func reloadAllMonths(year: Int) {
        allMonths.removeAll()
        var startMonth: Int = 1
        var endMonth: Int = 12
        if year == minDate.cp_year() {
            startMonth = minDate.cp_month()
        }
        if year == self.maxDate.cp_year() {
            endMonth = maxDate.cp_month()
        }
        var arr: [Int] = []
        for i in startMonth...endMonth { arr.append(i) }
        allMonths = arr
    }
    
    /// 更新天数数据
    private func reloadAllDays(year: Int, month: Int) {
        allDays.removeAll()
        var startDay: Int = 1
        var endDay: Int = CPPickerManager.getSolarDaysCount(inYear: year, month: month)
        if (year == minDate.cp_year() && month == minDate.cp_month()) {
            startDay = minDate.cp_day()
        }
        if (year == maxDate.cp_year() && month == maxDate.cp_month()) {
            endDay = self.maxDate.cp_day()
        }
        var arr: [Int] = []
        for i in startDay...endDay { arr.append(i) }
        allDays = arr
    }
    
    /// 更新小时数据
    private func reloadAllHours(year: Int, month: Int, day: Int) {
        allHours.removeAll()
        var startHour: Int = 0
        var endHour: Int = 23
        if (year == minDate.cp_year() && month == minDate.cp_month() && day == minDate.cp_day()) {
            startHour = minDate.cp_hour()
        }
        if (year == maxDate.cp_year() && month == maxDate.cp_month() && day == maxDate.cp_day()) {
            endHour = maxDate.cp_hour()
        }
        var arr: [Int] = []
        for i in startHour...endHour { arr.append(i) }
        allHours = arr
    }
    
    /// 更新分钟数据
    private func reloadAllMins(year: Int, month: Int, day: Int, hour: Int) {
        allMins.removeAll()
        var startMinute: Int = 0
        var endMinute: Int = 59
        if (year == minDate.cp_year() && month == minDate.cp_month() && day == minDate.cp_day() && hour == minDate.cp_hour()) {
            startMinute = minDate.cp_minute()
        }
        if (year == maxDate.cp_year() && month == maxDate.cp_month() && day == maxDate.cp_day() && hour == maxDate.cp_hour()) {
            endMinute = maxDate.cp_minute()
        }
        var arr: [Int] = []
        for i in startMinute...endMinute { arr.append(i) }
        allMins = arr
    }
    
    /// 更新秒钟数据
    private func reloadAllSeconds(year: Int, month: Int, day: Int, hour: Int, minute: Int) {
        allSecs.removeAll()
        var startSecond: Int = 0
        var endSecond: Int = 59
        if (year == minDate.cp_year() && month == minDate.cp_month() && day == minDate.cp_day() && hour == minDate.cp_hour() && minute == minDate.cp_minute()) {
            startSecond = minDate.cp_second()
        }
        if (year == maxDate.cp_year() && month == maxDate.cp_month() && day == maxDate.cp_day() && hour == maxDate.cp_hour() && minute == maxDate.cp_minute()) {
            endSecond = maxDate.cp_second()
        }
        var arr: [Int] = []
        for i in startSecond...endSecond { arr.append(i) }
        allSecs = arr
    }
    
    private func reloadSelectDate() {
        pickerView.reloadAllComponents()
        setupSelectDateString()
        comps.forEach {
            switch $0 {
            case .year:
                var selectYear = _sD.year - minDate.cp_year()
                if selectYear < 0 {
                    selectYear = minDate.cp_year()
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
    
    private lazy var allDays: [Int] = []
    
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
    static func showPickerView(title: String = "请选择", minDate: Date = Date.distantPast, maxDate: Date = Date.distantFuture, dateMode: CPDateType = .YMDHMS, selectValue: String = "", _ sureClourse: @escaping CPParamClosure<String>) {
        let pickerView = CPDatePickerView()
        pickerView.titleLabel.text = title
        pickerView.dateHeaderView.mode = dateMode
        pickerView.dateMode = dateMode
//        let endYear = (end == 0) ? (String.getCurrentYear() + 100) : end
//        pickerView.startEndYear = (start, endYear)
        pickerView.minDate = minDate
        pickerView.maxDate = maxDate
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: selectValue) ?? Date()
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = CPPickerManager.chinaTimeZone!
        let comps = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        pickerView.selectDate = CPNormalDate(year: comps.year ?? minDate.cp_year(),
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
            return allDays.count
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
            str = "\(allDays[row])"
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
            
            if dateMode == .YM {
                reloadAllMonths(year: _sD.year)
                pickerView.reloadComponent(CPNormalDateType.month.rawValue)
            }
            
            if dateMode == .YMD {
                reloadAllMonths(year: _sD.year)
                reloadAllDays(year: _sD.year, month: _sD.month)
                pickerView.reloadComponent(CPNormalDateType.month.rawValue)
                pickerView.reloadComponent(CPNormalDateType.day.rawValue)
            }
            
            if dateMode == .YMDH {
                reloadAllMonths(year: _sD.year)
                reloadAllDays(year: _sD.year, month: _sD.month)
                reloadAllHours(year: _sD.year, month: _sD.month, day: _sD.day)
                pickerView.reloadComponent(CPNormalDateType.month.rawValue)
                pickerView.reloadComponent(CPNormalDateType.day.rawValue)
                pickerView.reloadComponent(CPNormalDateType.hour.rawValue)
            }
            
            if dateMode == .YMDHM {
                reloadAllMonths(year: _sD.year)
                reloadAllDays(year: _sD.year, month: _sD.month)
                reloadAllHours(year: _sD.year, month: _sD.month, day: _sD.day)
                reloadAllMins(year: _sD.year, month: _sD.month, day: _sD.day, hour: _sD.hour)
                pickerView.reloadComponent(CPNormalDateType.month.rawValue)
                pickerView.reloadComponent(CPNormalDateType.day.rawValue)
                pickerView.reloadComponent(CPNormalDateType.hour.rawValue)
                pickerView.reloadComponent(CPNormalDateType.min.rawValue)
            }
            
            if dateMode == .YMDHMS {
                reloadAllMonths(year: _sD.year)
                reloadAllDays(year: _sD.year, month: _sD.month)
                reloadAllHours(year: _sD.year, month: _sD.month, day: _sD.day)
                reloadAllMins(year: _sD.year, month: _sD.month, day: _sD.day, hour: _sD.hour)
                reloadAllSeconds(year: _sD.year, month: _sD.month, day: _sD.day, hour: _sD.hour, minute: _sD.minute)
                pickerView.reloadComponent(CPNormalDateType.month.rawValue)
                pickerView.reloadComponent(CPNormalDateType.day.rawValue)
                pickerView.reloadComponent(CPNormalDateType.hour.rawValue)
                pickerView.reloadComponent(CPNormalDateType.min.rawValue)
                pickerView.reloadComponent(CPNormalDateType.sec.rawValue)
            }
            
        } else if component == CPNormalDateType.month.rawValue {
            _sD.isLeapMonth = false
            _sD.month = allMonths[row]
            
            if dateMode == .YMD {
                reloadAllDays(year: _sD.year, month: _sD.month)
                let daysCount = allDays.count
                if _sD.day > daysCount {
                    _sD.day = daysCount
                }
                pickerView.reloadComponent(CPNormalDateType.day.rawValue)
            }
            
            if dateMode == .YMDH {
                reloadAllDays(year: _sD.year, month: _sD.month)
                let daysCount = allDays.count
                if _sD.day > daysCount {
                    _sD.day = daysCount
                }
                reloadAllHours(year: _sD.year, month: _sD.month, day: _sD.day)
                pickerView.reloadComponent(CPNormalDateType.day.rawValue)
                pickerView.reloadComponent(CPNormalDateType.hour.rawValue)
            }
            
            if dateMode == .YMDHM {
                reloadAllDays(year: _sD.year, month: _sD.month)
                let daysCount = allDays.count
                if _sD.day > daysCount {
                    _sD.day = daysCount
                }
                reloadAllHours(year: _sD.year, month: _sD.month, day: _sD.day)
                reloadAllMins(year: _sD.year, month: _sD.month, day: _sD.day, hour: _sD.hour)
                pickerView.reloadComponent(CPNormalDateType.day.rawValue)
                pickerView.reloadComponent(CPNormalDateType.hour.rawValue)
                pickerView.reloadComponent(CPNormalDateType.min.rawValue)
            }
            
            if dateMode == .YMDHMS {
                reloadAllDays(year: _sD.year, month: _sD.month)
                let daysCount = allDays.count
                if _sD.day > daysCount {
                    _sD.day = daysCount
                }
                reloadAllHours(year: _sD.year, month: _sD.month, day: _sD.day)
                reloadAllMins(year: _sD.year, month: _sD.month, day: _sD.day, hour: _sD.hour)
                reloadAllSeconds(year: _sD.year, month: _sD.month, day: _sD.day, hour: _sD.hour, minute: _sD.minute)
                pickerView.reloadComponent(CPNormalDateType.day.rawValue)
                pickerView.reloadComponent(CPNormalDateType.hour.rawValue)
                pickerView.reloadComponent(CPNormalDateType.min.rawValue)
                pickerView.reloadComponent(CPNormalDateType.sec.rawValue)
            }
        } else if component == CPNormalDateType.day.rawValue {
            _sD.day = allDays[row]
            if dateMode == .YMDH {
                reloadAllHours(year: _sD.year, month: _sD.month, day: _sD.day)
                pickerView.reloadComponent(CPNormalDateType.hour.rawValue)
            }
            
            if dateMode == .YMDHM {
                reloadAllHours(year: _sD.year, month: _sD.month, day: _sD.day)
                reloadAllMins(year: _sD.year, month: _sD.month, day: _sD.day, hour: _sD.hour)
                pickerView.reloadComponent(CPNormalDateType.hour.rawValue)
                pickerView.reloadComponent(CPNormalDateType.min.rawValue)
            }
            
            if dateMode == .YMDHMS {
                reloadAllHours(year: _sD.year, month: _sD.month, day: _sD.day)
                reloadAllMins(year: _sD.year, month: _sD.month, day: _sD.day, hour: _sD.hour)
                reloadAllSeconds(year: _sD.year, month: _sD.month, day: _sD.day, hour: _sD.hour, minute: _sD.minute)
                pickerView.reloadComponent(CPNormalDateType.hour.rawValue)
                pickerView.reloadComponent(CPNormalDateType.min.rawValue)
                pickerView.reloadComponent(CPNormalDateType.sec.rawValue)
            }
        } else if component == CPNormalDateType.hour.rawValue {
            _sD.hour = allHours[row]
            
            if dateMode == .YMDHM {
                reloadAllMins(year: _sD.year, month: _sD.month, day: _sD.day, hour: _sD.hour)
                pickerView.reloadComponent(CPNormalDateType.min.rawValue)
            }
            
            if dateMode == .YMDHMS {
                reloadAllMins(year: _sD.year, month: _sD.month, day: _sD.day, hour: _sD.hour)
                reloadAllSeconds(year: _sD.year, month: _sD.month, day: _sD.day, hour: _sD.hour, minute: _sD.minute)
                pickerView.reloadComponent(CPNormalDateType.min.rawValue)
                pickerView.reloadComponent(CPNormalDateType.sec.rawValue)
            }
        } else if component == CPNormalDateType.min.rawValue {
            _sD.minute = allMins[row]
            if dateMode == .YMDHMS {
                reloadAllSeconds(year: _sD.year, month: _sD.month, day: _sD.day, hour: _sD.hour, minute: _sD.minute)
                pickerView.reloadComponent(CPNormalDateType.sec.rawValue)
            }
        } else {
            _sD.second = allSecs[row]
        }
        
        setupSelectDateString()
    }
}
