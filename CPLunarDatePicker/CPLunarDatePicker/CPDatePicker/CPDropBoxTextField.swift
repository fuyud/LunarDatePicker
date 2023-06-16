//
//  CPDropBoxTextField.swift
//  ClanGenealogy
//
//  Created by Company on 2023/3/15.
//

import UIKit

class CPDropBoxTextField: UIView {
    
    open var rowCount: Int = 0
    
    open var itemDataForRowAt: ((Int) -> (String, UIImage?))!
    
    open var itemDidSelectedRowAt: ((Int, String, CPDropBoxTextField) -> Void)?
    
    open var didPullDownChanged: ((Bool) -> Void)?
    
    open var maxViewHeight: CGFloat = CGFloat(Int.max)
    
    open var isPullDown: Bool {
        get { return _isPullDown }
        set {
            if (newValue == _isPullDown) { return }
            if (newValue) {
                pullDwonAction()
            } else {
                pullUp()
            }
            _isPullDown = newValue
        }
    }
    
    open var itemRowHeight: CGFloat = 44 {
        didSet {
            _contentTableView.reloadData()
        }
    }
    
    open var animationDuration: TimeInterval = 0.3
    
    open var textFieldText: String? {
        get {
            return _contentTextField.text
        }
    }
    
    private var _isPullDown: Bool = false {
        didSet {
            if self.didPullDownChanged != nil {
                self.didPullDownChanged!(_isPullDown)
            }
            if (_isPullDown) {
                UIView.animate(withDuration: animationDuration) { [weak self] () in
                    let transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi))
                    self?._pullDownImgView.transform = transform
                }
            } else {
                UIView.animate(withDuration: animationDuration) { [weak self] () in
                    let transform = CGAffineTransform.init(rotationAngle: CGFloat(0))
                    self?._pullDownImgView.transform = transform
                }
            }
        }
    }
    
    var _contentTableView: UITableView!
    
    private var _contentTextField: UITextField!
    
    open var _pullDownImgView: UIImageView!
    private var _clickView: UIView = UIView()
    
    var selfWidth: CGFloat = 0 {
        didSet {
            self.cp_width = selfWidth
            self.cp_height = 24.0
            _pullDownImgView.frame = CGRect(x: bounds.width - bounds.height, y: 0, width: bounds.height, height: bounds.height)
            _contentTextField.frame = CGRect(x: 10, y: 0, width: bounds.width - _pullDownImgView.frame.width - 10, height: bounds.height)
            _contentTableView.frame = CGRect(x: 0, y: bounds.height, width: bounds.width, height: 0)
            _clickView.frame = _contentTextField.frame
        }
    }
    
    init(frame: CGRect, customTextField: UITextField? = nil) {
        super.init(frame: frame)
        creatSubViews(customTextField: customTextField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func creatSubViews(customTextField: UITextField?) {
        
        backgroundColor = .clear;
        
        if let textField = customTextField {
            _contentTextField = textField
        } else {
            _contentTextField = UITextField()
        }
        _contentTextField.font = .font(AplC: 18)
        _contentTextField.isUserInteractionEnabled = false
        
        _pullDownImgView = UIImageView(image: UIImage(named: "icon_pull-down"))
        _pullDownImgView.contentMode = .center;
        _pullDownImgView.isUserInteractionEnabled = true
        _pullDownImgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickAction)))
        
        _contentTableView = UITableView(frame: .zero, style: .plain)
        _contentTableView.delegate = self
        _contentTableView.dataSource = self
        _contentTableView.separatorStyle = .none
        _contentTableView.backgroundColor = .clear
        _contentTableView.showsVerticalScrollIndicator = false
        _contentTableView.register(CGSimplePullDownBoxCell.self)
        
        _pullDownImgView.frame = CGRect(x: bounds.width - 20 - CP.pixel8, y: 0, width: 20, height: bounds.height)
        _contentTextField.frame = CGRect(x: 8, y: 0, width: bounds.width - _pullDownImgView.frame.width - 8, height: bounds.height)
        _contentTableView.frame = CGRect(x: 0, y: bounds.height, width: bounds.width, height: 0)
        
        addSubview(_contentTextField)
        addSubview(_contentTableView)
        addSubview(_pullDownImgView)
        
        _clickView = UIView.init(frame: _contentTextField.frame)
        _clickView.backgroundColor = .clear
        _clickView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickAction)))
        addSubview(_clickView)
    }
    
    @objc private func clickAction() {
        isPullDown = !isPullDown
    }
    
    open func pullDwonAction() {
        if(_isPullDown) {
            return
        }
        _isPullDown = true
        
        UIView.animate(withDuration: animationDuration, animations: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            var h = CGFloat(weakSelf.rowCount) * weakSelf.itemRowHeight
            if( h > weakSelf.maxViewHeight) {
                weakSelf._contentTableView.isScrollEnabled = true
                h = weakSelf.maxViewHeight
            } else {
                weakSelf._contentTableView.isScrollEnabled = false
            }
            weakSelf._contentTableView.frame.size.height = h
            weakSelf.frame.size.height = weakSelf.frame.size.height + h
        })
        
        superview?.bringSubviewToFront(self)
    }
    
    open func pullUp() {
        if(!_isPullDown) {
            return
        }
        _isPullDown = false
        
        UIView.animate(withDuration: animationDuration / 2, animations: { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let selfHeight = weakSelf._contentTableView.frame.size.height
            weakSelf.frame.size.height = weakSelf.frame.size.height - selfHeight
            weakSelf._contentTableView.frame.size.height = 0.0
        })
    }
    
}

//MARK: --- TableView DataSource and Delegate ---
extension CPDropBoxTextField: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(CGSimplePullDownBoxCell.self) as! CGSimplePullDownBoxCell
        cell.backgroundColor = backgroundColor
        cell.setIconAngText( text: itemDataForRowAt(indexPath.row).0, img: itemDataForRowAt(indexPath.row).1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.itemRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _contentTextField.text = itemDataForRowAt(indexPath.row).0
        itemDidSelectedRowAt?(indexPath.row, itemDataForRowAt(indexPath.row).0, self)
    }
}

private class CGSimplePullDownBoxCell: UITableViewCell {
    
    private var iconImageView: UIImageView!
    private var titleTextLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        let selectImgView = UIImageView(image: UIImage(named: "check"))
        selectImgView.contentMode = .right
        selectedBackgroundView = selectImgView
        
        // 左边图标
        iconImageView = UIImageView(frame: .zero)
        iconImageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(iconImageView)
        
        // 文字标题
        titleTextLabel = UILabel(frame: .zero)
        titleTextLabel.font = .font(AplC: 18)
        self.contentView.addSubview(titleTextLabel)
        
        let separateView = UIView()
        separateView.backgroundColor = .lightGray
        separateView.frame = CGRect(x: 0, y: 0, width: self.cp_width, height: 0.5)
        self.contentView.addSubview(separateView)
    }
    
    func setIconAngText(text: String, img: UIImage?) {
        iconImageView.image = img
        titleTextLabel.text = text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.frame = CGRect(x: 10, y: 12, width: 20, height: 20)
        if (iconImageView.image == nil) {
            iconImageView.frame = .zero
        }
        titleTextLabel.frame = CGRect(x: iconImageView.frame.maxX + 10, y: 0, width: self.frame.width, height: 44)
        selectedBackgroundView?.frame = CGRect(x: 0, y: 0, width: frame.width - 10, height: 44)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

