//
//  RPicker.swift
//  RPicker
//
//  Created by Rheyansh on 4/25/18.
//  Copyright © 2018 Raj Sharma. All rights reserved.
//

import UIKit

@objc enum RDatePickerStyle: Int {
    //Only for iOS 14 and above
    case wheel, inline, compact
}

enum RPickerType {
    case date, option
}

@objc open class RPicker: NSObject {
    
    private static let sharedInstance = RPicker()
    private var isPresented = false
    
    /**
     Show UIDatePicker with various constraints.
     
     - Parameters:
     - title: Title visible to user above UIDatePicker.
     - cancelText: By default button is hidden. Set text to show cancel button.
     - doneText: Set done button title customization. A default title "Done" is used.
     - datePickerMode: default is Date.
     - selectedDate: default is current date.
     - minDate: default is nil.
     - maxDate: default is nil.
     - style: default is wheel.

     - returns: closure with selected date.
     */
    
    @objc class func selectDate(title: String? = nil,
                                cancelText: String? = nil,
                                doneText: String = "Done",
                                datePickerMode: UIDatePicker.Mode = .date,
                                selectDte: Date = Date(),
                                minDate: Date? = nil,
                                maxDate: Date? = nil,
                                style: RDatePickerStyle = .wheel,
                                didSelectDate : ((_ date: Date)->())?) {
        guard let viewController = controller(title: title, cancelTxt: cancelText, doneTxt: doneText, dtPkrMode: datePickerMode, selectDte: selectDte, mnDate: minDate, mxDate: maxDate, type: .date, style: style) else { return }
        viewController.onDateSelected = { (selectedData) in
            didSelectDate?(selectedData)
        }
    }
    
    /**
    Show UIDatePicker with various constraints.
    
    - Parameters:
    - title: Title visible to user above UIDatePicker.
    - cancelText: By default button is hidden. Set text to show cancel button.
    - doneText: Set done button title customization. A default title "Done" is used.
    - dataArray: Array of string items.
    - selectedIndex: default is nil. If set then picker will show selected index

    - returns: closure with selected text and index.
    */
    
    class func selectOption(title: String? = nil,
                            cancelText: String? = nil,
                            doneText: String = "Done",
                            dataArr: Array<String>?,
                            selectedIndex: Int? = nil,
                            didSelectValue : ((_ value: String, _ atIndex: Int)->())?)  {
        
        guard let arr = dataArr, let viewController = controller(title: title, cancelTxt: cancelText, doneTxt: doneText, dataArr: arr, selIndex: selectedIndex, type: .option) else { return }
        
        viewController.onOptionSelected = { (selectedValue, selectedIndex) in
            didSelectValue?(selectedValue, selectedIndex)
        }
    }
    
    /**
    Show UIDatePicker with various constraints.
    
    - Parameters:
    - title: Title visible to user above UIDatePicker.
    - cancelText: By default button is hidden. Set text to show cancel button.
    - doneText: Set done button title customization. A default title "Done" is used.
    - dataArray: Array of string items.
    - selectedIndex: default is nil. If set then picker will show selected index

    - returns: closure with selected text and index.
    */
    // --> For exposing to Objective C. Same as swift
    @objc class func pickOption(title: String? = nil,
                            cancelText: String? = nil,
                            doneText: String = "Done",
                            dataArr: Array<String>?,
                            selectedIndex: NSNumber? = nil,
                            didSelectValue : ((_ value: String, _ atIndex: Int)->())?)  {
        
        var selIndex: Int?
        if let index = selectedIndex {
         selIndex = Int(truncating: index)
        }
        
        guard let arr = dataArr, let viewController = controller(title: title, cancelTxt: cancelText, doneTxt: doneText, dataArr: arr, selIndex: selIndex, type: .option) else { return }
        
        viewController.onOptionSelected = { (selectedValue, selectedIndex) in
            didSelectValue?(selectedValue, selectedIndex)
        }
    }
    
    private class func controller(title: String? = nil,
                                  cancelTxt: String? = nil,
                                  doneTxt: String = "Done",
                                  dtPkrMode: UIDatePicker.Mode = .date,
                                  selectDte: Date = Date(),
                                  mnDate: Date? = nil,
                                  mxDate: Date? = nil,
                                  dataArr:Array<String> = [],
                                  selIndex: Int? = nil,
                                  type: RPickerType = .date,
                                  style: RDatePickerStyle = .wheel) -> RPickerController? {
        if let currentController = UIWindow.currentController {
            if RPicker.sharedInstance.isPresented == false {
                RPicker.sharedInstance.isPresented = true
                
                let vwController = RPickerController(title: title, cancelTxt: cancelTxt, doneTxt: doneTxt, dtPkrMode: dtPkrMode, selectDte: selectDte, mnDate: mnDate, mxDate: mxDate, dataArr: dataArr, selIndex: selIndex, type: type, style: style)
                
                vwController.modalPresentationStyle = .overCurrentContext
                vwController.modalTransitionStyle = .crossDissolve
                currentController.present(vwController, animated: true, completion: nil)
                
                vwController.onWillDismiss = {
                    RPicker.sharedInstance.isPresented = false
                }
                
                return vwController
            }
        }
        
        return nil
    }
}

private extension UIView {
    
    func pinConstraints(_ byView: UIView, left: CGFloat? = nil, right: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil, height: CGFloat? = nil, width: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let lelfConstant = left { leftAnchor.constraint(equalTo: byView.leftAnchor, constant: lelfConstant).isActive = true }
        if let rightConstant = right { rightAnchor.constraint(equalTo: byView.rightAnchor, constant: rightConstant).isActive = true }
        if let topConstant = top { topAnchor.constraint(equalTo: byView.topAnchor, constant: topConstant).isActive = true }
        if let bottomConstant = bottom { bottomAnchor.constraint(equalTo: byView.bottomAnchor, constant: bottomConstant).isActive = true }
        if let heightConstant = height { heightAnchor.constraint(equalToConstant: heightConstant).isActive = true }
        if let widthConstant = width { widthAnchor.constraint(equalToConstant: widthConstant).isActive = true }
    }
    
    func surroundConstraints(_ byView: UIView, left: CGFloat = 0, right: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0) {
        pinConstraints(byView, left: left, right: right, top: top, bottom: bottom)
    }
}

class RPickerController: UIViewController {
    
    //MARK: - Public closuers
    var onDateSelected : ((_ date: Date) -> Void)?
    var onOptionSelected : ((_ value: String, _ atIndex: Int) -> Void)?
    var onWillDismiss : (() -> Void)?

    //MARK: - Public variables
    var selIndex: Int?
    var selectDte = Date()
    var mxDate: Date?
    var mnDate: Date?
    var titleTxt: String?
    var cancelTxt: String?
    var doneTxt: String = "Done"
    var dtPkrMode: UIDatePicker.Mode = .date
    var dtPkrStyle: RDatePickerStyle = .wheel //Only for iOS 14 and above

    var pickerType: RPickerType = .date
    var dataArr: Array<String> = []
    
    //MARK: - Private variables
    private let barViewHeight: CGFloat = 44
    private let pickerHeight: CGFloat = 216
    private let buttonWidth: CGFloat = 84
    private let lineHeight: CGFloat = 0.5
    private let buttonColor = UIColor(red: 72/255, green: 152/255, blue: 240/255, alpha: 1)
    private let lineColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    
    //MARK: - Init
    init(title: String? = nil,
         cancelTxt: String? = nil,
         doneTxt: String = "Done",
         dtPkrMode: UIDatePicker.Mode = .date,
         selectDte: Date = Date(),
         mnDate: Date? = nil,
         mxDate: Date? = nil,
         dataArr:Array<String> = [],
         selIndex: Int? = nil,
         type: RPickerType = .date,
         style: RDatePickerStyle = .wheel) {
        
        self.titleTxt = title
        self.cancelTxt = cancelTxt
        self.doneTxt = doneTxt
        self.dtPkrMode = dtPkrMode
        self.selectDte = selectDte
        self.mnDate = mnDate
        self.mxDate = mxDate
        self.dataArr = dataArr
        self.selIndex = selIndex
        self.pickerType = type
        self.dtPkrStyle = style

        super.init(nibName: nil, bundle: nil)
        
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // Trait collection has already changed
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        // Trait collection will change. Use this one so you know what the state is changing to.
      if #available(iOS 12.0, *) {
         if newCollection.userInterfaceStyle != traitCollection.userInterfaceStyle {
            if newCollection.userInterfaceStyle == .dark {
               setUpThemeMode(isDark: true)
            } else {
                setUpThemeMode(isDark: false)
            }
         }
      } else {
         // Fallback on earlier versions
        setUpThemeMode(isDark: false)
      }
    }
    
    //MARK: - Private functions
    private func initialSetup() {
        
        view.backgroundColor = UIColor.clear
        let bgView = transView
        view.addSubview(bgView)
        bgView.surroundConstraints(view)
        
        // Stack View
        stackView.addArrangedSubview(lineLabel)
        stackView.addArrangedSubview(toolBarView)
        stackView.addArrangedSubview(lineLabel)
                
        var height = barViewHeight + (2*lineHeight)

        if pickerType == .date {
            stackView.addArrangedSubview(datePicker)
            if #available(iOS 14.0, *) {
                if dtPkrStyle == .wheel {
                    height += pickerHeight
                } else if dtPkrStyle == .compact {
                    height += pickerHeight
                } else {
                    if datePicker.datePickerMode == .dateAndTime {
                        height += 428
                    } else if datePicker.datePickerMode == .date {
                        height += 386
                    } else {
                        height += pickerHeight
                    }
                }
            } else {
                // restrict to use wheel mode
                dtPkrStyle = .wheel
                height += pickerHeight
            }
        
        } else {
            stackView.addArrangedSubview(optionPicker)
            height += pickerHeight
        }
        
        self.view.addSubview(stackView)
                
        stackView.pinConstraints(view, left: 0, right: 0, bottom: 0, height: height)
        // stackView.pinConstraints(view, left: 0, right: 0, top: 0, bottom: 0)
        
      if #available(iOS 12.0, *) {
         if traitCollection.userInterfaceStyle == .dark {
            setUpThemeMode(isDark: true)
         } else {
            setUpThemeMode(isDark: false)
         }
      } else {
         // Fallback on earlier versions
        setUpThemeMode(isDark: false)
      }
    }
    
    private func setUpThemeMode(isDark: Bool) {

        if isDark {
            titleLabel.textColor = UIColor.white
            stackView.backgroundColor = UIColor.black
            transView.backgroundColor = UIColor(white: 1, alpha: 0.3)
            if pickerType == .date {
                datePicker.backgroundColor = UIColor.black
            } else {
                optionPicker.backgroundColor = UIColor.black
            }
            toolBarView.backgroundColor = UIColor.black

        } else {
            titleLabel.textColor = UIColor.darkGray
            stackView.backgroundColor = UIColor.white
            transView.backgroundColor = UIColor(white: 0.1, alpha: 0.3)
            if pickerType == .date {
                datePicker.backgroundColor = UIColor.white
            } else {
                optionPicker.backgroundColor = UIColor.white
            }
            toolBarView.backgroundColor = UIColor.white
        }
    }
    
    private func dismissVC() {
        onWillDismiss?()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTap() { dismissVC() }
    
    //MARK: - Private properties

    private lazy var transView: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.fill
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 0.0
        return stackView
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.pinConstraints(view, width: view.frame.width)
        picker.minimumDate = mnDate
        picker.maximumDate = mxDate
        picker.date = selectDte
        picker.datePickerMode = dtPkrMode
        picker.locale = Locale.init(identifier: "en_gb")

        if #available(iOS 14, *) {
            if dtPkrStyle == .wheel {
                picker.preferredDatePickerStyle = .wheels
            } else if dtPkrStyle == .compact {
                picker.preferredDatePickerStyle = .compact
            } else {
                picker.preferredDatePickerStyle = .inline
            }
        }

        return picker
    }()
    
    private lazy var optionPicker: UIPickerView = {
        
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.pinConstraints(view, width: view.frame.width)
        
        if let selectedIndex = selIndex {
            if (selectedIndex < dataArr.count) {
                picker.selectRow(selectedIndex, inComponent: 0, animated: false)
            }
        }
        
        return picker
    }()
    
    private lazy var toolBarView: UIView = {
        
        let barView = UIView()
        barView.pinConstraints(view, height: barViewHeight, width: view.frame.width)
        
        //add done button
        let doneButton = self.doneButton
        let cancelButton = self.cancelButton
        
        barView.addSubview(doneButton)
        barView.addSubview(cancelButton)
        
        cancelButton.pinConstraints(barView, left: 0, top: 0, bottom: 0, width: buttonWidth)
        doneButton.pinConstraints(barView, right: 0, top: 0, bottom: 0, width: buttonWidth)
        
        if let text = titleTxt {
            let titleLabel = self.titleLabel
            titleLabel.text = text
            barView.addSubview(titleLabel)
            titleLabel.surroundConstraints(barView, left: buttonWidth, right: -buttonWidth)
        }
        
        doneButton.setTitle(doneTxt, for: .normal)
        
        if let text = cancelTxt {
            cancelButton.setTitle(text, for: .normal)
        } else {
            cancelButton.isHidden = true
        }
        
        return barView
    }()
    
    private lazy var lineLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = lineColor
        label.pinConstraints(view, height: lineHeight, width: view.frame.width)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(buttonColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        button.addTarget(self, action: #selector(onDoneButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(buttonColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        button.addTarget(self, action: #selector(onCancelButton), for: .touchUpInside)
        return button
    }()
    
    @objc func onDoneButton(sender : UIButton) {
        
        if pickerType == .date {
            onDateSelected?(datePicker.date)
        } else {
            let selectedValueIndex = self.optionPicker.selectedRow(inComponent: 0)
            onOptionSelected?(dataArr[selectedValueIndex], selectedValueIndex)
        }
        
        dismissVC()
    }
    
    @objc func onCancelButton(sender : UIButton) { dismissVC() }
}

//MARK: - UIPickerViewDataSource, UIPickerViewDelegate

extension RPickerController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return dataArr.count }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel
        
        if (pickerLabel == nil) {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "OpenSans-Semibold", size: 16)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        
        pickerLabel?.text = dataArr[row]
        
        return pickerLabel!
    }
}

//MARK: - Private Extensions

private extension UIApplication {
    static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
         return UIApplication.shared.windows.filter {$0.isKeyWindow}.first
         } else {
            return UIApplication.shared.delegate?.window ?? nil
         }
    }
}

private extension UIWindow {
    
    static var currentController: UIViewController? {
        return UIApplication.keyWindow?.currentController
    }
    
    var currentController: UIViewController? {
        if let viewController = self.rootViewController {
            return topViewController(controller: viewController)
        }
        return nil
    }
    
    func topViewController(controller: UIViewController? = UIApplication.keyWindow?.rootViewController) -> UIViewController? {
        if let navController = controller as? UINavigationController {
            if !navController.viewControllers.isEmpty {
                return topViewController(controller: navController.viewControllers.last!)
            } else {
                return navController
            }
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
