//
//  CPBasePickerView.swift
//  ClanPedigree
//
//  Created by Company on 2023/6/13.
//

import UIKit

class CPBasePickerView: UIView {
    
    struct Constant {
        static let buttonWidth: CGFloat = 90
        static let buttonHeight: CGFloat = 30
        static let pickerViewTop: CGFloat = buttonHeight + CP.pixel + CP.pixel16
        static let pickerViewHeight: CGFloat = 216
        static let contentHeight: CGFloat = (pickerViewTop + pickerViewHeight + CP.safeBottomHeight)
    }
    
    var sureClourse: CPParamlessClosure?
    
    var cancleClourse: CPParamlessClosure?
    
    var style: CPPickerStyle = CPPickerStyle()
    
    var contentHeight: CGFloat = Constant.contentHeight
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let currentPoint = touches.first?.location(in: self)
        if !contentView.frame.contains(currentPoint ?? CGPoint()) {
            hiddenView()
        }
    }
    
    func initUI() {
        frame = CP.keyWindow.bounds
        
        // 设置子视图的宽度随着父视图变化
        autoresizingMask = [.flexibleBottomMargin, .flexibleRightMargin, .flexibleWidth, .flexibleHeight]
        
        bgView.frame = CGRect(x: 0, y: 0, width: cp_width, height: cp_height)
        
        contentView.cp_height = contentHeight
        
        cancleBtn.frame = CGRect(x: 0, y: CP.pixel, width: Constant.buttonWidth, height: Constant.buttonHeight)
        
        sureBtn.frame = CGRect(x: (contentView.cp_width - Constant.buttonWidth), y: cancleBtn.cp_y, width: Constant.buttonWidth, height: Constant.buttonHeight)
        
        if !style.isHiddenTitle {
            titleLabel.frame = CGRect(x: (cancleBtn.cp_right + CP.pixel4), y: CP.pixel, width: (sureBtn.cp_x - (cancleBtn.cp_right + CP.pixel4 * 2)), height: cancleBtn.cp_height)
        }
        contentView.addChildViews([cancleBtn, sureBtn])
        if !style.isHiddenTitle {
            contentView.addSubview(titleLabel)
        }
        addChildViews([bgView, contentView])
        
        setEvents()
        
        CP.keyWindow.addSubview(self)
        bgView.alpha = 0
        UIView.animate(withDuration: 0.25) {[weak self] in
            guard let self = self else { return }
            self.bgView.alpha = 1
            self.contentView.cp_bottom = CP.screenHeight
        }
    }
    
    func setEvents() {
        
        cancleBtn.addTarget(self, action: #selector(cancleBtnAction), for: .touchUpInside)
        
        sureBtn.addTarget(self, action: #selector(sureBtnAction), for: .touchUpInside)
    }
    
    @objc func cancleBtnAction() {
        self.hiddenView()
        if self.cancleClourse != nil {
            self.cancleClourse!()
        }
    }
    
    @objc func sureBtnAction() {
        self.hiddenView()
        if self.sureClourse != nil {
            self.sureClourse!()
        }
    }
    
    func hiddenView() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
            self.alpha = 0
        } completion: { complete in
            if complete {
                self.removeFromSuperview()
            }
        }
    }
    
    //MARK: --- lazy ---
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .rgba(0, 0, 0, 0.4)
        return bgView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView.init(frame: CGRect(x: 0, y: CP.screenHeight, width: CP.screenWidth, height: contentHeight))
        contentView.backgroundColor = .white
        contentView.autoresizingMask = [.flexibleBottomMargin, .flexibleRightMargin, .flexibleWidth, .flexibleHeight]
        return contentView
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton(type: .custom)
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(.black, for: .normal)
        sureBtn.titleLabel?.font = .font(AplC: 20)
        return sureBtn
    }()
    
    lazy var cancleBtn: UIButton = {
        let cancleBtn = UIButton(type: .custom)
        cancleBtn.setTitle("取消", for: .normal)
        cancleBtn.setTitleColor(.black, for: .normal)
        cancleBtn.titleLabel?.font = .font(AplC: 20)
        return cancleBtn
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = .font(AplCMD: 18)
        titleLabel.textAlignment = .center
        titleLabel.text = "请选择"
        return titleLabel
    }()
}
