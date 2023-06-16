//
//  CPLunarDatePickerView.swift
//  ClanPedigree
//
//  Created by Company on 2023/6/13.
//

import UIKit

class CPLunarDatePickerView: CPBasePickerView {
    
    struct CPDateConstant {
        static let unknownWidth: CGFloat = 60
        static let menuViewWidth: CGFloat = CP.screenWidth - unknownWidth - CP.pixel16 * 2 - CP.pixel8
        static let menuHeight: CGFloat = 35.0
        static let menuTFMaxHeight: CGFloat = 200.0
        static let dateHeaderViewHeight: CGFloat = 40
        static let contentHeight: CGFloat = (CP.pixel14 + menuHeight + CP.pixel16 + dateHeaderViewHeight)
    }
    
    var centuryMenuArray: [(CPCentury, UIImage?)] {
        get {
            return getCenturyArray()
        }
    }
    
    var isUnknown: Bool = false {
        didSet {
            unknowBtn.isSelected = isUnknown
            centuryMenuTF.isUserInteractionEnabled = !isUnknown
            mCenturyTF.textColor = isUnknown ? .darkGray : .black
            pickerView.isUserInteractionEnabled = !isUnknown
            unkonwnAlphaView.isHidden = !isUnknown
        }
    }
    
    var sureResultClourse: CPParamClosure<CPDate>?
    
    private var allYears: [CPDateYear] = []
    private var allMonths: [CPDateMonth] = []
    private var allDays: [CPDateDay] = []
    private var allTimes: [CPDateTime] = []
    
    public var startEndYear: (startYear: Int, endYear: Int) = (1, 2200) {
        didSet {
            reloadAllYears()
        }
    }
    
    public var selectDate: CPDate = CPDate()

    func setUnknowBtnEvents() {
        unknowBtn.addTarget(self, action: #selector(unknowBtnAction), for: .touchUpInside)
    }
    
    @objc func unknowBtnAction() {
        self.unknowBtn.isSelected = !self.unknowBtn.isSelected
        self.isUnknown = self.unknowBtn.isSelected
    }
    
    //MARK: --- lazy ---
    lazy var centuryMenuTF: CPDropBoxTextField = {
        let centuryMenuTF = CPDropBoxTextField(frame: CGRect(x: CP.pixel16, y: Constant.pickerViewTop + CP.pixel14, width: CPDateConstant.menuViewWidth, height: CPDateConstant.menuHeight), customTextField: mCenturyTF)
        centuryMenuTF.backgroundColor = .rgba(248, 248, 248)
        centuryMenuTF.layer.cornerRadius = CPDateConstant.menuHeight / 2.0
        centuryMenuTF.clipsToBounds = true
        centuryMenuTF.maxViewHeight = CPDateConstant.menuTFMaxHeight
        centuryMenuTF.rowCount = centuryMenuArray.count
        centuryMenuTF.itemDataForRowAt = {(index) -> (String, UIImage?) in
            let title: String = self.centuryMenuArray[index].0.value ?? ""
            return (title, nil)
        }
        centuryMenuTF.itemDidSelectedRowAt = {(index, title, textField) in
            textField.pullUp()
            let century = self.centuryMenuArray[index].0
            self.startEndYear = ((century.start ?? 0), (century.end ?? 0) + 1)
        }
        return centuryMenuTF
    }()
    
    lazy var mCenturyTF: UITextField = {
        let mCenturyTF = UITextField()
        mCenturyTF.font = .font(AplC: 18)
        mCenturyTF.textAlignment = .left
        return mCenturyTF
    }()
    
    lazy var unknowBtn: UIButton = {
        let unknowBtn = UIButton(type: .custom)
        unknowBtn.frame = CGRect(x: centuryMenuTF.cp_right + CP.pixel16, y: centuryMenuTF.cp_y, width: CPDateConstant.unknownWidth, height: centuryMenuTF.cp_height)
        unknowBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: CP.pixel4, bottom: 0, right: 0)
        unknowBtn.setTitle("不详", for: .normal)
        unknowBtn.setImage(.init(named: "box_default"), for: .normal)
        unknowBtn.setImage(.init(named: "box_select"), for: .selected)
        unknowBtn.titleLabel?.font = .font(AplC: 18)
        unknowBtn.setTitleColor(.black, for: .normal)
        unknowBtn.contentHorizontalAlignment = .left
        return unknowBtn
    }()
    
    lazy var unkonwnAlphaView: UIView = {
        let unkonwnAlphaView = UIView.init(frame: CGRect(x: 0, y: dateHeaderView.cp_y, width: contentView.cp_width, height: (pickerView.cp_bottom - dateHeaderView.cp_y)))
        unkonwnAlphaView.backgroundColor = .rgba(255, 255, 255, 0.6)
        unkonwnAlphaView.isHidden = true
        return unkonwnAlphaView
    }()
    
    lazy var dateHeaderView: CPDatePickerHeaderView = {
        let dateHeaderView = CPDatePickerHeaderView.init(frame:  CGRect(x: 0, y: (centuryMenuTF.cp_bottom + CP.pixel16), width: contentView.cp_width, height: CPDateConstant.dateHeaderViewHeight))
        dateHeaderView.backgroundColor = .white
        dateHeaderView.mode = .LYMDH
        return dateHeaderView
    }()
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView.init(frame: CGRect(x: 0, y: dateHeaderView.cp_bottom, width: contentView.cp_width, height: Constant.pickerViewHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
}

extension CPLunarDatePickerView {
    
    /// 获取世纪数据
    func getCenturyArray() -> [(CPCentury, UIImage?)] {
        var start = -50
        var end = 0
        let thisYear = String.getCurrentYear()
        var flag: Bool = true
        var isUP: Bool = true
        var centuryArray: [(CPCentury, UIImage?)] = []
        while flag {
            start += 50
            end = start + 49
            if start == 0 {
                start = 1
            }
            if end > thisYear {
                end = thisYear
                flag = false
            }
            let centuryInt = start / 100 + 1
            var updownString = ""
            if isUP {
                updownString = "上叶"
                isUP = false
            } else {
                updownString = "下叶"
                isUP = true
            }
            var century = CPCentury()
            century.start = start
            century.end = end
            century.value = "\(centuryInt)世纪" + updownString + "[\(start)-\(end)]"
            centuryArray.append((century,nil))
            if start == 1 {
                start = 0
            }
        }
        return centuryArray.reversed()
    }
    
    /// 根据年份返回世纪字符串 start end
    func getCentury(year: Int) -> CPCentury {
        for menu in centuryMenuArray.reversed() {
            let century = menu.0
            let start = century.start ?? 0
            let end = century.end ?? 0
            if year >= start && year <= end {
                return century
            }
        }
        return CPCentury()
    }
    
    struct CPCentury {
        var value: String?
        var start: Int?
        var end: Int?
    }
    
    func setSelectDate(dateString: String, timeStr: String) {
        if dateString.isEmpty {
            setSelectDateValue(date: Date())
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let date = formatter.date(from: dateString) ?? Date()
            setSelectDateValue(date: date, timeStr: timeStr)
        }
    }
    
    func setSelectDateValue(date: Date, timeStr: String = "") {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = CPPickerManager.chinaTimeZone!
        let comps = cal.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        var selectYear = CPDateYear()
        let solarYear = String(comps.year ?? startEndYear.startYear)
        selectYear.solarYear = solarYear
        var date = CPDate()
        date.dateYear = selectYear
        let lunarYear = CPPickerManager.getLunarYearMonthDayString(date: date, type: .YY, returnType: .YY)
        selectYear.solarYear = solarYear
        selectYear.lunarYear = lunarYear
        selectDate.dateYear = selectYear
        
        var selectMonth = CPDateMonth()
        selectMonth.solarMonth = String(comps.month ?? 1)
        date.dateMonth = selectMonth
        let lunarMonth = CPPickerManager.getLunarYearMonthDayString(date: date, type: .YM, returnType: .YM)
        selectMonth.lunarMonth = lunarMonth
        selectDate.dateMonth = selectMonth
        
        var selectDay = CPDateDay()
        selectDay.solarDay = String(comps.day ?? 1)
        date.dateDay = selectDay
        let lunarDay = CPPickerManager.getLunarYearMonthDayString(date: date, type: .YMD, returnType: .YMD)
        selectDay.lunarDay = lunarDay
        selectDate.dateDay = selectDay
        
        var selectTime = CPDateTime()
        if timeStr.isEmpty == false {
            let index = getTimeSelectIndex(timeStr: timeStr)
            selectTime.solarTime = CPPickerManager.solarTimes[index]
            selectTime.lunarTime = CPPickerManager.lunarTimes[index]
        } else {
            selectTime.solarTime = CPPickerManager.solarTimes[0]
            selectTime.lunarTime = CPPickerManager.lunarTimes[0]
        }
        selectDate.dateTime = selectTime
        reloadAllYears()
    }
    
    func reloadAllYears() {
        allYears.removeAll()
        allYears = CPPickerManager.getAllYeaers(startYear: startEndYear.startYear, endYear: startEndYear.endYear)
        reloadSelectDate()
    }
    
    func reloadSelectDate() {
        reloadAllMonths()
        reloadAllDays()
        reloadAllTimes()
        var selectYearRow = (selectDate.year ?? 0) - startEndYear.startYear
        if selectYearRow < 0 || selectYearRow >= allYears.count {
            selectYearRow = allYears.count - 1
        }
        var selectMonthRow = (selectDate.month ?? 0) - 1
        if selectMonthRow < 0 {
            selectMonthRow = 0
        }
        var selectDayRow = (selectDate.day ?? 0) - 1
        if selectDayRow < 0 {
            selectDayRow = 0
        }
        var selectTimeRow = getTimeSelectIndex(timeStr: selectDate.time ?? "")
        if selectTimeRow < 0 {
            selectTimeRow = 0
        }
        selectDate.dateYear = allYears[selectYearRow]
        selectDate.dateMonth = allMonths[selectMonthRow]
        selectDate.dateDay = allDays[selectDayRow]
        selectDate.dateTime = allTimes[selectTimeRow]
        
        reloadlunarYear()
        reloadlunarMonth()
        reloadlunarDay()
        pickerView.reloadAllComponents()
        
        pickerView.selectRow(selectYearRow, inComponent: 0, animated: false)
        pickerView.selectRow(selectMonthRow, inComponent: 1, animated: false)
        pickerView.selectRow(selectDayRow, inComponent: 2, animated: false)
        pickerView.selectRow(selectTimeRow, inComponent: 3, animated: false)
        
        setupSelectDateString()
    }
    
    func getTimeSelectIndex(timeStr: String) -> Int {
        var timeIndex = 0
        for (index, time) in CPPickerManager.lunarTimes.enumerated() {
            if timeStr == time {
                timeIndex = index
                break
            }
        }
        return timeIndex
    }
    
    func reloadAllMonths() {
        let dateYear = selectDate.dateYear ?? CPDateYear()
        allMonths = CPPickerManager.getAllMonths(dateYear: dateYear)
    }
    
    func reloadAllDays() {
        let dateYear = selectDate.dateYear ?? CPDateYear()
        let dateMonth = selectDate.dateMonth ?? CPDateMonth()
        allDays = CPPickerManager.getAllDays(dateYear: dateYear, dateMonth: dateMonth)
    }
    
    func reloadAllTimes() {
        allTimes = CPPickerManager.getAllTimes()
    }
    
    func reloadlunarYear() {
        for (index, year) in allYears.enumerated() {
            var year = year
            if year.solarYear == selectDate.dateYear?.solarYear {
                let lunarYear = CPPickerManager.getLunarYearMonthDayString(date: selectDate, type: .YMD, returnType: .YY)
                year.lunarYear = lunarYear
                allYears[index] = year
            }
        }
    }
    
    func reloadlunarMonth() {
        for (index, month) in allMonths.enumerated() {
            var month = month
            if month.solarMonth == selectDate.dateMonth?.solarMonth {
                let lunarMonth = CPPickerManager.getLunarYearMonthDayString(date: selectDate, type: .YMD, returnType: .YM)
                month.lunarMonth = lunarMonth
                allMonths[index] = month
            }
        }
    }
    
    func reloadlunarDay() {
        for (index, day) in allDays.enumerated() {
            var day = day
            if day.solarDay == selectDate.dateDay?.solarDay {
                let lunarDay = CPPickerManager.getLunarYearMonthDayString(date: selectDate, type: .YMD, returnType: .YMD)
                day.lunarDay = lunarDay
                allDays[index] = day
            }
        }
    }
    
    func setupSelectDateString() {
        
        let solarYear = selectDate.year ?? 0
        let solarMonth = selectDate.month ?? 0
        let solarDay = selectDate.day ?? 0
        let solarTime = selectDate.dateTime?.solarTime ?? ""
        let solarDateString = "公历：" + ("\(solarYear)" + "年" + "\(solarMonth)" + "月" + "\(solarDay)" + "日" + "\(solarTime)")
        selectDate.value = solarDateString
        
        let lunarYear = CPPickerManager.getLunarYearMonthDayString(date: selectDate, type: .YMD, returnType: .YY) ?? ""
        let lunarMonth = CPPickerManager.getLunarYearMonthDayString(date: selectDate, type: .YMD, returnType: .YM) ?? ""
        let lunarDay = CPPickerManager.getLunarYearMonthDayString(date: selectDate, type: .YMD, returnType: .YMD) ?? ""
        let lunarTime = (selectDate.dateTime?.lunarTime ?? "")
        let lunarDateString = "农历：" + (lunarYear + "年" + lunarMonth + "月" + lunarDay + lunarTime)
        selectDate.value1 = lunarDateString
    }
}

//MARK: --- UIPickerViewDelegate ---
extension CPLunarDatePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 4 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return allYears.count
        case 1:
            return allMonths.count
        case 2:
            return allDays.count
        case 3:
            return allTimes.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.textAlignment = .center
            pickerLabel?.numberOfLines = 2
        }
        var str = ""
        var lunarStr = ""
        if component == 0 {
            let dateYear = allYears[row]
            str = (dateYear.solarYear ?? "") + "年"
            lunarStr = (dateYear.lunarYear ?? "") + "年"
        } else if component == 1 {
            let dateMonth = allMonths[row]
            str = (dateMonth.solarMonth ?? "") + "月"
            lunarStr = (dateMonth.lunarMonth ?? "") + "月"
        } else if component == 2 {
            let dateDay = allDays[row]
            str = (dateDay.solarDay ?? "") + "日"
            lunarStr = dateDay.lunarDay ?? ""
        } else if component == 3 {
            let dateTime = allTimes[row]
            str = dateTime.solarTime ?? ""
            lunarStr = dateTime.lunarTime ?? ""
        } else {
            str = String(row)
        }
        
        let attStr = NSMutableAttributedString(elements: [
            (str: str, attr: [NSAttributedString.Key.font: UIFont.font(AplCMD: 18), NSAttributedString.Key.foregroundColor: UIColor.black]),
            (str: "\n\(lunarStr)", attr: [NSAttributedString.Key.font: UIFont.font(AplCMD: 16), NSAttributedString.Key.foregroundColor: UIColor.rgba(133, 92, 92)])
        ])
        pickerLabel?.attributedText = attStr
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let timeLabelWidth: CGFloat = 138/375.0 * CP.screenWidth
        let labelWidth: CGFloat = floor(( CP.screenWidth - timeLabelWidth - 3) / 3)
        switch component {
        case 0, 1, 2:
            return labelWidth
        default:
            return timeLabelWidth
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 55
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectDate.dateYear = allYears[row]
            reloadAllMonths()
            reloadAllDays()
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
        } else if component == 1 {
            selectDate.dateMonth = allMonths[row]
            reloadAllDays()
            
            let solarYearInt = Int(selectDate.dateYear?.solarYear ?? "0") ?? 0
            let solarMonthInt = Int(selectDate.dateMonth?.solarMonth ?? "0") ?? 0
            let daysCount = CPPickerManager.getSolarDaysCount(inYear: solarYearInt, month: solarMonthInt)
            if (Int(selectDate.dateDay?.solarDay ?? "0") ?? 0) > daysCount {
                selectDate.dateDay?.solarDay = String(daysCount)
            }
            pickerView.reloadComponent(2)
        } else if component == 2 {
            var row = row
            if row > allDays.count {
                row = allDays.count - 1
            }
            selectDate.dateDay = allDays[row]
            reloadAllTimes()
            
        } else {
            selectDate.dateTime = allTimes[row]
        }
        reloadlunarYear()
        reloadlunarMonth()
        reloadlunarDay()
        pickerView.reloadComponent(0)
        pickerView.reloadComponent(1)
        setupSelectDateString()
    }
}

extension CPLunarDatePickerView {
    
    func show() {
        sureClourse = {[weak self] in
            guard let self = self else { return }
            if self.sureResultClourse != nil {
                self.selectDate.isUnkonwn = self.isUnknown
                self.sureResultClourse!(self.selectDate)
            }
        }
        setUnknowBtnEvents()
        contentHeight += CPDateConstant.contentHeight
        contentView.addChildViews([centuryMenuTF, unknowBtn, dateHeaderView, pickerView, unkonwnAlphaView])
        initUI()
    }
    
    /// Parameters
    ///  -title:  标题
    ///  -selctDate:  选择日期  未设置默认为当前日期
    ///  -sureClourse：点击确认回调
    static func showPickerView(title: String = "请选择", selctDate: CPDate = CPDate(), _ sureClourse: @escaping CPParamClosure<CPDate>) {
        let pickerView = CPLunarDatePickerView()
        pickerView.style = CPPickerStyle(isHiddenTitle: true)
        pickerView.sureResultClourse = sureClourse
        let solarYear = selctDate.year ?? 0
        let solarMonth = selctDate.month ?? 0
        let solarDay = selctDate.day ?? 0
        let solarTime = selctDate.time ?? ""
        var selectDateStr = ""
        if solarYear != 0 {
            selectDateStr = "\(solarYear)-\(solarMonth)-\(solarDay)"
        }
        let selctType = selctDate.type ?? 0
        pickerView.isUnknown = (selctType == 3)
        pickerView.setSelectDate(dateString: selectDateStr, timeStr: solarTime)
        let century = pickerView.getCentury(year: solarYear)
        if century.value?.isEmpty == false {
            pickerView.mCenturyTF.text = century.value
            pickerView.startEndYear = ((century.start ?? 0), (century.end ?? 0) + 1)
        } else {
            if pickerView.centuryMenuArray.isEmpty == false {
                let century = pickerView.centuryMenuArray[0].0
                pickerView.mCenturyTF.text = century.value
                pickerView.startEndYear = ((century.start ?? 0), (century.end ?? 0) + 1)
            }
        }
        pickerView.show()
    }
}
