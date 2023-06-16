//
//  CPUtil.swift
//  CPLunarDatePicker
//
//  Created by Company on 2023/6/16.
//

import UIKit

/// 有参数的闭包
public typealias CPParamClosure<T> = (_ res: T?) -> Void
/// 无参数的闭包
public typealias CPParamlessClosure = () -> Void

struct CP {
    public static func getWindow() -> UIWindow? {
        if #available(iOS 13.0, *){
            if let window = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).compactMap({$0 as? UIWindowScene}).first?.windows.filter({$0.isKeyWindow}).first{
                return window
            } else if let window = UIApplication.shared.delegate?.window {
                return window
            } else {
                return nil
            }
        } else {
            if let window = UIApplication.shared.delegate?.window {
                return window
            } else {
                return nil
            }
        }
    }
    
    /// 屏幕宽度
    public static var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    /// 屏幕高度
    public static var screenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    #if os(iOS)
    public static var screenOrientation: UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }
    /// 状态栏高度
    public static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }

    /// 屏幕底部间距
    public static var bottomSafeHeight: CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0
        } else {
            return 0
        }
    }

    public static var pixel: CGFloat {
        return 8.0
    }

    public static var pixel4: CGFloat {
        return 4.0
    }

    public static var pixel6: CGFloat {
        return 6.0
    }
    
    public static var pixel8: CGFloat {
        return 8.0
    }

    public static var pixel16: CGFloat {
        return 16.0
    }

    public static var pixel10: CGFloat {
        return 10.0
    }

    public static var pixel12: CGFloat {
        return 12.0
    }

    public static var pixel14: CGFloat {
        return 14.0
    }

    public static var pixel18: CGFloat {
        return 18.0
    }

    public static var pixel20: CGFloat {
        return 20.0
    }

    public static var pixel22: CGFloat {
        return 22.0
    }

    public static var keyWindow: UIWindow {
        return self.getWindow()!
    }

    /// 横屏状态栏高度
    public static var heightWithoutStatusBar: CGFloat {
        if screenOrientation.isPortrait {
            return UIScreen.main.bounds.size.height - statusBarHeight
        } else {
            return UIScreen.main.bounds.size.width - statusBarHeight
        }
    }

    /// 顶部状态栏高度
    public static var statusHeight: CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let statusBarManager = windowScene.statusBarManager else { return 0 }
            statusBarHeight = statusBarManager.statusBarFrame.height
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }

    /// 导航栏高度
    public static var navigationBarHeight: CGFloat {
        return 44
    }

    /// 导航栏+状态栏高度
    public static var safeTopHeight: CGFloat {
        return self.navigationBarHeight + self.statusHeight
    }

    /// 底部间距 + tabbar高度
    public static var safeTabbarHeight: CGFloat {
        return self.tabBarHeight + self.bottomSafeHeight
    }

    /// 底部tabBar高度
    public static var tabBarHeight: CGFloat {
        return 49
    }

    public static var safeAreaInsets: UIEdgeInsets {
        var safeAreaInsets = UIEdgeInsets.zero
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return safeAreaInsets }
            guard let window = windowScene.windows.first else { return safeAreaInsets }
            safeAreaInsets = window.safeAreaInsets
        } else if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.windows.first else { return safeAreaInsets }
            safeAreaInsets = window.safeAreaInsets
        }
        return safeAreaInsets
    }

    /// 底部bottom边距
    public static var safeBottomHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        } else if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        }
        return 0
    }
    #endif
}

//MARK: --- view Frame Extensions ---
extension UIView {
    /// 添加多个View
    public func addChildViews(_ views: [UIView]) {
        views.forEach { [weak self] eachView in
            self?.addSubview(eachView)
        }
    }

    //TODO: 自适应方法
    /// 调整此视图的大小，使其适合最大的子视图
    public func resizeToFitSubviews() {
        var width: CGFloat = 0
        var height: CGFloat = 0
        for someView in self.subviews {
            let aView = someView
            let newWidth = aView.cp_x + aView.cp_width
            let newHeight = aView.cp_y + aView.cp_height
            width = max(width, newWidth)
            height = max(height, newHeight)
        }
        frame = CGRect(x: cp_x, y: cp_y, width: width, height: height)
    }

    /// 调整此视图的大小，使其适合最大的子视图
    public func resizeToFitSubviews(_ tagsToIgnore: [Int]) {
        var width: CGFloat = 0
        var height: CGFloat = 0
        for someView in self.subviews {
            let aView = someView
            if !tagsToIgnore.contains(someView.tag) {
                let newWidth = aView.cp_x + aView.cp_width
                let newHeight = aView.cp_y + aView.cp_height
                width = max(width, newWidth)
                height = max(height, newHeight)
            }
        }
        frame = CGRect(x: cp_x, y: cp_y, width: width, height: height)
    }

    /// 调整此视图的大小以适应其宽度。
    public func resizeToFitWidth() {
        let currentHeight = self.cp_height
        self.sizeToFit()
        self.cp_height = currentHeight
    }

    /// 调整此视图的大小以适应其高度。
    public func resizeToFitHeight() {
        let currentWidth = self.cp_width
        self.sizeToFit()
        self.cp_width = currentWidth
    }

    /// 子视图重新布局
    public func resetSubViews(_ reorder: Bool = false, tagsToIgnore: [Int] = []) -> CGFloat {
        var currentHeight: CGFloat = 0
        for someView in subviews {
            if !tagsToIgnore.contains(someView.tag) && !(someView ).isHidden {
                if reorder {
                    let aView = someView
                    aView.frame = CGRect(x: aView.frame.origin.x, y: currentHeight, width: aView.frame.width, height: aView.frame.height)
                }
                currentHeight += someView.frame.height
            }
        }
        return currentHeight
    }
    
    /// 移除所有子视图
    public func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }

    /// 在superview中水平居中
    public func centerXInSuperView() {
        guard let parentView = superview else {
            assertionFailure("EZSwiftExtensions Error: The view \(self) doesn't have a superview")
            return
        }

        self.cp_x = parentView.cp_width/2 - self.cp_width/2
    }

    /// 在superview中垂直居中
    public func centerYInSuperView() {
        guard let parentView = superview else {
            assertionFailure("EZSwiftExtensions Error: The view \(self) doesn't have a superview")
            return
        }
        
        self.cp_y = parentView.cp_height/2 - self.cp_height/2
    }

    /// 在superview中水平和垂直居中视图
    public func centerInSuperView() {
        self.centerXInSuperView()
        self.centerYInSuperView()
    }
}

extension UIView {
    /// 视图原点的x坐标的getter和setter
    @objc
    public var cp_x: CGFloat {
        get {
            return self.frame.origin.x
        } set(value) {
            self.frame = CGRect(x: value, y: self.cp_y, width: self.cp_width, height: self.cp_height)
        }
    }

    /// 视图原点的y坐标的getter和setter。
    @objc
    public var cp_y: CGFloat {
        get {
            return self.frame.origin.y
        } set(value) {
            self.frame = CGRect(x: self.cp_x, y: value, width: self.cp_width, height: self.cp_height)
        }
    }

    /// 视图的宽度的getter和setter
    @objc
    public var cp_width: CGFloat {
        get {
            return self.frame.size.width
        } set(value) {
            self.frame = CGRect(x: self.cp_x, y: self.cp_y, width: value, height: self.cp_height)
        }
    }

    /// 视图的高度的getter和setter
    @objc
    public var cp_height: CGFloat {
        get {
            return self.frame.size.height
        } set(value) {
            self.frame = CGRect(x: self.cp_x, y: self.cp_y, width: self.cp_width, height: value)
        }
    }

    /// 视图最左边的x坐标的getter和setter。
    @objc
    public var cp_left: CGFloat {
        get {
            return self.cp_x
        } set(value) {
            self.cp_x = value
        }
    }

    /// 视图最右边的x坐标的getter和setter。
    @objc
    public var cp_right: CGFloat {
        get {
            return self.cp_x + self.cp_width
        } set(value) {
            self.cp_x = value - self.cp_width
        }
    }

    /// 视图最上边y坐标的getter和setter。
    @objc
    public var cp_top: CGFloat {
        get {
            return self.cp_y
        } set(value) {
            self.cp_y = value
        }
    }

    /// 视图最底部边缘的y坐标的getter和setter。
    @objc
    public var cp_bottom: CGFloat {
        get {
            return self.cp_y + self.cp_height
        } set(value) {
            self.cp_y = value - self.cp_height
        }
    }

    /// 获取和设置视图原点。
    @objc
    public var cp_origin: CGPoint {
        get {
            return self.frame.origin
        } set(value) {
            self.frame = CGRect(origin: value, size: self.frame.size)
        }
    }

    /// 获取和设置视图的center x。
    @objc
    public var centerX: CGFloat {
        get {
            return self.center.x
        } set(value) {
            self.center.x = value
        }
    }

    /// 获取和设置视图的center y。
    @objc
    public var centerY: CGFloat {
        get {
            return self.center.y
        } set(value) {
            self.center.y = value
        }
    }

    /// 获取和设置视图的size。
    @objc
    public var cp_size: CGSize {
        get {
            return self.frame.size
        } set(value) {
            self.frame = CGRect(origin: self.frame.origin, size: value)
        }
    }
}

extension UIView {
    @objc
    class var reuseIdentifier: String {
        NSStringFromClass(Self.self) + #function
    }
}

extension UIColor {
    class func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> UIColor {
        UIColor.init(r, g, b, a)
    }
    
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1)
    {
        let red = r / 255.0
        let green = g / 255.0
        let blue = b / 255.0
        self.init(red: red, green: green, blue: blue, alpha: a)
    }
}

//MARK: --- UIFontExtesion ---
extension UIFont {
    
    struct CPFont {
        
        enum CPFontName {
            enum FontName: String {
                case pingFangSC
            }
            enum CPFontStyle: String {
                case medium
                case regular
                case semiBold
            }
            case fontName(FontName, CPFontStyle)
            var fontName: String {
                var fontName: String
                switch self {
                    case .fontName(let name, let style):
                        fontName = name.rawValue + "-" + style.rawValue
                }
                return fontName
            }
        }
        
        let fontName: String
        let fontSize: Float
        
        var font: UIFont {
            return UIFont.init(name: fontName, size: CGFloat(self.fontSize))!
        }
        
        init(_ fontSize: Float, _ fontName: CPFontName) {
            self.fontSize = fontSize
            self.fontName = fontName.fontName
        }
        
        init(AplC fontSize: Float) {
            self.init(fontSize, CPFontName.fontName(.pingFangSC, .regular))
        }
        
        init(AplCMD fontSize: Float) {
            self.init(fontSize, CPFontName.fontName(.pingFangSC, .medium))
        }
        
        init(AplCB fontSize: Float) {
            self.init(fontSize, CPFontName.fontName(.pingFangSC, .semiBold))
        }
    }
    
    static func font(AplC size: Float) -> Self {
        return CPFont.init(AplC: size).font as! Self
    }
    
    static func font(AplCMD size: Float) -> Self {
        return CPFont.init(AplCMD: size).font as! Self
    }
    
    static func font(AplCB size: Float) -> Self {
        return CPFont.init(AplCB: size).font as! Self
    }
}

extension UITableView {
    //注册
    func register(_ cellClass: AnyClass) {
        self.register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    //重用
    func dequeueReusableCell(_ cellClass: AnyClass) -> UITableViewCell? {
        self.dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier)
    }
    
    func reloadSection(_ section: Int, animation: RowAnimation) {
        let indexSet: IndexSet = [section]
        self.reloadSections(indexSet, with: animation)
    }
    
    func deleteRow(row: Int, section: Int, animation: RowAnimation) {
        let indexPath = IndexPath.init(row: row, section: section)
        self.deleteRows(at: [indexPath], with: animation)
    }
}

extension String {
    /// 获取当前时间 年
    static func getCurrentYear() -> Int{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let timezone = TimeZone.init(identifier: "Asia/Beijing")
        formatter.timeZone = timezone
        let dateTime = formatter.string(from: Date.init())
        let dates:[String] = dateTime.components(separatedBy: "-")
        let currentYear  = Int(dates[0]) ?? 0
        return currentYear
    }
}

extension NSMutableAttributedString {
    /// 便捷设置AttributedString
    convenience init?(elements: [(str: String, attr: [NSAttributedString.Key: Any])]){
        
        guard !elements.isEmpty else{
            return nil
        }
        let allString: String = elements.reduce("") { (res, ele) -> String in
            return res + ele.str
        }
        self.init(string: allString)
        for ele in elements {
            let eleStr = ele.str
            if !eleStr.isEmpty {
                let range: Range = allString.range(of: eleStr)!
                let nsRange: NSRange = NSRange(range, in: allString)
                self.addAttributes(ele.attr, range: nsRange)
            }
        }
    }
}
