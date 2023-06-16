//
//  CPDatePickerHeaderView.swift
//  ClanPedigree
//
//  Created by Company on 2023/6/12.
//

import UIKit

class CPDatePickerHeaderView: UIView {
    
    struct Constant {
        static let timeWidthScale: CGFloat = 138/375.0
    }
    
    var mode: CPDateType = .LYMDH {
        didSet {
            switch mode {
            case .LYMDH:
                timeLabel.text = "时辰"
                addChildViews([yearLabel, monthLabel, dayLabel, timeLabel])
            case .YY:
                addChildViews([yearLabel])
            case .YM:
                addChildViews([yearLabel, monthLabel])
            case .YMD:
                addChildViews([yearLabel, monthLabel, dayLabel])
            case .YMDH:
                timeLabel.text = "时"
                addChildViews([yearLabel, monthLabel, dayLabel, timeLabel])
            case .YMDHM:
                timeLabel.text = "时"
                addChildViews([yearLabel, monthLabel, dayLabel, timeLabel, minuteLabel])
            default:
                timeLabel.text = "时"
                addChildViews([yearLabel, monthLabel, dayLabel, timeLabel, minuteLabel, secondLabel])
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addChildViews([yearLabel, monthLabel, dayLabel, timeLabel])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        /// 时辰label宽度
        let timeLabelWidth: CGFloat = Constant.timeWidthScale * cp_width
        var labelWidth: CGFloat = 0
        switch mode {
        case .LYMDH:
            labelWidth = floor((cp_width - timeLabelWidth - 3) / 3)
            yearLabel.frame = CGRect(x: 0, y: 0, width: labelWidth, height: cp_height)
            monthLabel.frame = CGRect(x: yearLabel.cp_right + 1, y: 0, width: labelWidth, height: cp_height)
            dayLabel.frame = CGRect(x: monthLabel.cp_right + 1, y: 0, width: labelWidth, height: cp_height)
            timeLabel.frame = CGRect(x: dayLabel.cp_right + 1, y: 0, width: timeLabelWidth, height: cp_height)
        case .YY:
            labelWidth = floor((cp_width - CGFloat(mode.rawValue - 1)) / CGFloat(mode.rawValue))
            yearLabel.frame = CGRect(x: 0, y: 0, width: labelWidth, height: cp_height)
        case .YM:
            labelWidth = floor((cp_width - CGFloat(mode.rawValue - 1)) / CGFloat(mode.rawValue))
            yearLabel.frame = CGRect(x: 0, y: 0, width: labelWidth, height: cp_height)
            monthLabel.frame = CGRect(x: yearLabel.cp_right + 1, y: 0, width: labelWidth, height: cp_height)
        case .YMD:
            labelWidth = floor((cp_width - CGFloat(mode.rawValue - 1)) / CGFloat(mode.rawValue))
            yearLabel.frame = CGRect(x: 0, y: 0, width: labelWidth, height: cp_height)
            monthLabel.frame = CGRect(x: yearLabel.cp_right + 1, y: 0, width: labelWidth, height: cp_height)
            dayLabel.frame = CGRect(x: monthLabel.cp_right + 1, y: 0, width: labelWidth, height: cp_height)
        case .YMDH:
            labelWidth = floor((cp_width - CGFloat(mode.rawValue - 1)) / CGFloat(mode.rawValue))
            yearLabel.frame = CGRect(x: 0, y: 0, width: labelWidth, height: cp_height)
            monthLabel.frame = CGRect(x: yearLabel.cp_right + 1, y: 0, width: labelWidth, height: cp_height)
            dayLabel.frame = CGRect(x: monthLabel.cp_right + 1, y: 0, width: labelWidth, height: cp_height)
            timeLabel.frame = CGRect(x: dayLabel.cp_right + 1, y: 0, width: labelWidth, height: cp_height)
        case .YMDHM:
            labelWidth = floor((cp_width - CGFloat(mode.rawValue - 1)) / CGFloat(mode.rawValue))
            yearLabel.frame = CGRect(x: 0, y: 0, width: labelWidth, height: cp_height)
            monthLabel.frame = CGRect(x: yearLabel.cp_right + 1, y: 0, width: labelWidth, height: cp_height)
            dayLabel.frame = CGRect(x: monthLabel.cp_right + 1, y: 0, width: labelWidth, height: cp_height)
            timeLabel.frame = CGRect(x: dayLabel.cp_right + 1, y: 0, width: labelWidth, height: cp_height)
            minuteLabel.frame = CGRect(x: timeLabel.cp_right + 1, y: 0, width: labelWidth, height: cp_height)
        default:
            labelWidth = floor((cp_width - CGFloat(mode.rawValue - 1)) / CGFloat(mode.rawValue))
            yearLabel.frame = CGRect(x: 0, y: 0, width: labelWidth, height: cp_height)
            monthLabel.frame = CGRect(x: yearLabel.cp_right + 1, y: 0, width: labelWidth, height: cp_height)
            dayLabel.frame = CGRect(x: monthLabel.cp_right + 1, y: 0, width: labelWidth, height: cp_height)
            timeLabel.frame = CGRect(x: dayLabel.cp_right + 1, y: 0, width: labelWidth, height: cp_height)
            minuteLabel.frame = CGRect(x: timeLabel.cp_right + 1, y: 0, width: labelWidth, height: cp_height)
            secondLabel.frame = CGRect(x: minuteLabel.cp_right + 1, y: 0, width: labelWidth, height: cp_height)
        }
    }
    
    //MARK: --- lazy ---
    lazy var yearLabel: UILabel = {
        let yearLabel = UILabel()
        yearLabel.textColor = .black
        yearLabel.font = .font(AplCB: 18)
        yearLabel.textAlignment = .center
        yearLabel.backgroundColor = .rgba(248, 248, 248)
        yearLabel.text = "年"
        return yearLabel
    }()
    
    lazy var monthLabel: UILabel = {
        let monthLabel = UILabel()
        monthLabel.textColor = .black
        monthLabel.font = .font(AplCB: 18)
        monthLabel.textAlignment = .center
        monthLabel.backgroundColor = .rgba(248, 248, 248)
        monthLabel.text = "月"
        return monthLabel
    }()
    
    lazy var dayLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.textColor = .black
        dayLabel.font = .font(AplCB: 18)
        dayLabel.textAlignment = .center
        dayLabel.backgroundColor = .rgba(248, 248, 248)
        dayLabel.text = "日"
        return dayLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textColor = .black
        timeLabel.font = .font(AplCB: 18)
        timeLabel.textAlignment = .center
        timeLabel.backgroundColor = .rgba(248, 248, 248)
        timeLabel.text = "时辰"
        return timeLabel
    }()
    
    lazy var minuteLabel: UILabel = {
        let minuteLabel = UILabel()
        minuteLabel.textColor = .black
        minuteLabel.font = .font(AplCB: 18)
        minuteLabel.textAlignment = .center
        minuteLabel.backgroundColor = .rgba(248, 248, 248)
        minuteLabel.text = "分"
        return minuteLabel
    }()
    
    lazy var secondLabel: UILabel = {
        let secondLabel = UILabel()
        secondLabel.textColor = .black
        secondLabel.font = .font(AplCB: 18)
        secondLabel.textAlignment = .center
        secondLabel.backgroundColor = .rgba(248, 248, 248)
        secondLabel.text = "秒"
        return secondLabel
    }()
}
