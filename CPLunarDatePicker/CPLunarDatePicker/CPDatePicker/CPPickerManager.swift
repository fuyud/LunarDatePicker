//
//  CPPickerManager.swift
//  ClanPedigree
//
//  Created by Company on 2023/6/8.
//

import UIKit

struct CPPickerManager {
    
    static let jiaziYears = [
        "甲子", "乙丑", "丙寅", "丁卯", "戊辰", "己巳", "庚午", "辛未", "壬申", "癸酉",
        "甲戌", "乙亥", "丙子", "丁丑", "戊寅", "己卯", "庚辰", "辛巳", "壬午", "癸未",
        "甲申", "乙酉", "丙戌", "丁亥", "戊子", "己丑", "庚寅", "辛卯", "壬辰", "癸巳",
        "甲午", "乙未", "丙申", "丁酉", "戊戌", "己亥", "庚子", "辛丑", "壬寅", "癸卯",
        "甲辰", "乙巳", "丙午", "丁未", "戊申", "己酉", "庚戌", "辛亥", "壬子", "癸丑",
        "甲寅", "乙卯", "丙辰", "丁巳", "戊午", "己未", "庚申", "辛酉", "壬戌", "癸亥"]

    static let lunarMonths = ["正", "二", "三", "四", "五", "六", "七", "八", "九", "十", "冬", "腊"]

    static let lunarDays = ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十", "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十", "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"]

    static let lunarTimes = ["子时", "丑时", "寅时", "卯时", "辰时", "巳时", "午时", "未时", "申时", "酉时", "戌时", "亥时"]

    static let solarTimes = ["23:00-00:59", "01:00-02:59", "03:00-04:59", "05:00-06:59", "07:00-08:59", "09:00-10:59", "11:00-12:59", "13:00-14:59", "15:00-16:59", "17:00-18:59", "19:00-20:59", "21:00-22:59"]
    
    static let chinaTimeZone = TimeZone(identifier: "Asia/Shanghai")
    
    static func getAllYeaers(startYear: Int, endYear: Int) -> [CPDateYear] {
        var allYears: [CPDateYear] = []
        let allYearCount = endYear - startYear
        for i in 0..<allYearCount {
            var date: CPDate = CPDate()
            var dateYear: CPDateYear = CPDateYear()
            let solarYearInt = i + startYear
            dateYear.solarYear = String(solarYearInt)
            date.dateYear = dateYear
            let lunarYear = getLunarYearMonthDayString(date: date, type: .YY, returnType: .YY)
            dateYear.lunarYear = lunarYear
            allYears.append(dateYear)
        }
        return allYears
    }
    
    /// 获取月份数组
    static func getAllMonths(dateYear: CPDateYear) -> [CPDateMonth] {
        var months: [CPDateMonth] = []
        for i in 0..<12 {
            var date: CPDate = CPDate()
            var dateMonth: CPDateMonth = CPDateMonth()
            let solarMonthInt = i + 1
            dateMonth.solarMonth = String(solarMonthInt)
            date.dateYear = dateYear
            date.dateMonth = dateMonth
            let lunarMonth = getLunarYearMonthDayString(date: date, type: .YM, returnType: .YM)
            dateMonth.lunarMonth = lunarMonth
            months.append(dateMonth)
        }
        return months
    }
    
    ///获取 天数 数组
    static func getAllDays(dateYear: CPDateYear, dateMonth: CPDateMonth) -> [CPDateDay] {
        let solarYearInt = Int(dateYear.solarYear ?? "0") ?? 0
        let solarMonthInt = Int(dateMonth.solarMonth ?? "0") ?? 0
        let daysCount = getSolarDaysCount(inYear: solarYearInt, month: solarMonthInt)
        var days: [CPDateDay] = []
        for i in 0..<daysCount {
            var date: CPDate = CPDate()
            var dateDay: CPDateDay = CPDateDay()
            dateDay.solarDay = String(i + 1)
            date.dateYear = dateYear
            date.dateMonth = dateMonth
            date.dateDay = dateDay
            let lunarDay = getLunarYearMonthDayString(date: date, type: .YMD, returnType: .YMD)
            dateDay.lunarDay = lunarDay
            days.append(dateDay)
        }
        return days
    }
    
    ///获取时辰数组
    static func getAllTimes() -> [CPDateTime] {
        var times: [CPDateTime] = []
        for i in 0..<solarTimes.count {
            var dateTime: CPDateTime = CPDateTime()
            dateTime.solarTime = solarTimes[i]
            dateTime.lunarTime = lunarTimes[i]
            times.append(dateTime)
        }
        return times
    }
    
    /// 根据阳历年月日 获取农历 年月日 返回 Int类型
    static func getLunarYearMonthDay(date: CPDate, type: CPDateType, returnType: CPDateType) -> Int? {
        let formatter = DateFormatter()
        let solarYear = date.dateYear?.solarYear ?? ""
        let solarMonth = date.dateMonth?.solarMonth ?? ""
        let solarDay = date.dateDay?.solarDay ?? ""
        var dateString = ""
        if type == .YY {
            formatter.dateFormat = "yyyy"
            dateString = solarYear
        }
        if type == .YM {
            formatter.dateFormat = "yyyy-MM"
            dateString = solarYear + "-" + solarMonth
        }
        if type == .YMD {
            formatter.dateFormat = "yyyy-MM-dd"
            dateString = solarYear + "-" + solarMonth + "-" + solarDay
        }
        let date = formatter.date(from: dateString)
        let lunar = Calendar(identifier: .chinese)
        let convComp = lunar.dateComponents([.year, .month, .day, .hour], from: date!)
        if returnType == .YY {
            return convComp.year
        }
        if returnType == .YM {
            return convComp.month
        }
        if returnType == .YMD {
            return convComp.day
        }
        return .zero
    }
    
    /// 根据阳历年月日 获取农历 年月日 返回 String类型
    static func getLunarYearMonthDayString(date: CPDate, type: CPDateType, returnType: CPDateType) -> String? {
        let formatter = DateFormatter()
        let solarYear = date.dateYear?.solarYear ?? ""
        let solarMonth = date.dateMonth?.solarMonth ?? ""
        let solarDay = date.dateDay?.solarDay ?? ""
        var dateString = ""
        if type == .YY {
            formatter.dateFormat = "yyyy"
            dateString = solarYear
        }
        if type == .YM {
            formatter.dateFormat = "yyyy-MM"
            dateString = solarYear + "-" + solarMonth
        }
        if type == .YMD {
            formatter.dateFormat = "yyyy-MM-dd"
            dateString = solarYear + "-" + solarMonth + "-" + solarDay
        }
        let date = formatter.date(from: dateString) ?? Date()
        let lunar = Calendar(identifier: .chinese)
        let convComp = lunar.dateComponents([.year, .month, .day, .hour], from: date)
        if returnType == .YY {
            var year = convComp.year ?? 0
            if year == 60 {
                year = 1
            }
            let yeatStr = jiaziYears[year - 1]
            return yeatStr
        }
        if returnType == .YM {
            var monthStr = lunarMonths[(convComp.month ?? 0) - 1]
            if convComp.isLeapMonth ?? false {
                monthStr = "闰" + monthStr
            }
            return monthStr
        }
        if returnType == .YMD {
            let day = convComp.day ?? 0
            let dayStr = lunarDays[day - 1]
            return dayStr
        }
        return ""
    }
    
    /// 获取公历某年某月的天数
    /// - Parameters:
    ///   - year: 公历年
    ///   - month: 公历月
    /// - Returns: 天数
    static func getSolarDaysCount(inYear year: Int, month: Int) -> Int {
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            return 31
        case 4, 6, 9, 11:
            return 30
        case 2:
            let isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
            return isLeapYear ? 29 : 28
        default:
            return 0
        }
    }
}

enum CPDateType: Int {
    /// 年
    case YY = 1
    /// 年月
    case YM
    /// 年月日
    case YMD
    /// 年月日时
    case YMDH
    /// 年月日时分
    case YMDHM
    /// 年月日时分秒
    case YMDHMS
    /// 农历年月日时辰
    case LYMDH
}

struct CPDate: Codable {
    
    var dateYear: CPDateYear? {
        didSet {
            year = Int(dateYear?.solarYear ?? "0")
        }
    }
    var dateMonth: CPDateMonth?{
        didSet {
            month = Int(dateMonth?.solarMonth ?? "0")
        }
    }
    var dateDay: CPDateDay?{
        didSet {
            day = Int(dateDay?.solarDay ?? "0")
        }
    }
    var dateTime: CPDateTime?{
        didSet {
            time = dateTime?.lunarTime ?? ""
        }
    }
    
    /// 1、农历 2、阳历、3、不详
    var type: Int?
    /// 年
    var year: Int?
    /// 月
    var month: Int?
    /// 日
    var day: Int?
    /// 阳历时辰
    var time: String?
    /// 阳历
    var value: String?
    /// 农历
    var value1: String?
    /// 是否不详
    var isUnkonwn: Bool? {
        didSet {
            if isUnkonwn ?? false {
                type = 3
            }
        }
    }
}

/// 年
struct CPDateYear: Codable {
    ///阳历
    var solarYear: String?
    ///农历
    var lunarYear: String?
}

/// 月
struct CPDateMonth: Codable {
    ///阳历
    var solarMonth: String?
    ///农历
    var lunarMonth: String?
}

/// 日
struct CPDateDay: Codable {
    ///阳历
    var solarDay: String?
    ///农历
    var lunarDay: String?
}

/// 十二时辰
struct CPDateTime: Codable {
    ///阳历
    var solarTime: String?
    ///农历
    var lunarTime: String?
}

struct CPNormalDate {
    var year: Int
    var month: Int
    var day: Int
    var hour: Int
    var minute: Int
    var second: Int
    /// 是否闰月
    var isLeapMonth: Bool
    
    /// 是否是同一天，不用考虑小时、分钟、秒
    func isSameDay(_ date: CPNormalDate) -> Bool {
        year == date.year && month == date.month && day == date.day && isLeapMonth == date.isLeapMonth
    }
}

enum CPNormalDateType: Int, CaseIterable {
    case year
    case month
    case day
    case hour
    case min
    case sec
}
