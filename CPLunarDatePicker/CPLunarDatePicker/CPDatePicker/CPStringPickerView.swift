//
//  CPStringPickerView.swift
//  ClanPedigree
//
//  Created by Company on 2023/6/13.
//

import UIKit

struct CPStringResultModel {
    var index: Int = 0
    var value: String = ""
}

class CPStringPickerView: CPBasePickerView {
    
    var sureResultClourse: CPParamClosure<CPStringResultModel>?
    
    var stringDataSource: [String] = [] {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    
    var selectIndex: Int = 0 {
        didSet {
            selectValue = stringDataSource[selectIndex]
            pickerView.selectRow(selectIndex, inComponent: 0, animated: false)
            selectModel.index = selectIndex
        }
    }
    
    var selectValue: String = "" {
        didSet {
            selectModel.value = stringDataSource[selectIndex]
        }
    }
    
    var selectModel: CPStringResultModel = CPStringResultModel()

    func show() {
        sureClourse = {[weak self] in
            guard let self = self else { return }
            if self.sureResultClourse != nil {
                self.sureResultClourse!(self.selectModel)
            }
        }
        contentView.addSubview(pickerView)
        initUI()
    }
    
    /// - Parameters:
    ///  - stringDatasource: 字符串数组
    ///  - selectIndex:  选中行索引
    ///  - sureResultClourse:  确认回调
    /// - Returns: void
    static func showPickerView(title: String = "请选择", stringDatasource: [String], selectIndex: Int = 0, _ sureResultClourse: @escaping CPParamClosure<CPStringResultModel>) {
        let pickerView = CPStringPickerView()
        pickerView.stringDataSource = stringDatasource
        pickerView.selectIndex = selectIndex
        pickerView.sureResultClourse = sureResultClourse
        pickerView.titleLabel.text = title
        pickerView.show()
    }
    
    //MARK: --- lazy ---
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView.init(frame: CGRect(x: 0, y: Constant.pickerViewTop, width: contentView.cp_width, height: Constant.pickerViewHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
}

extension CPStringPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stringDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = .font(AplCMD: 18)
            pickerLabel?.textColor = .black
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = stringDataSource[row]
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectIndex = row
    }
}
