//
//  ABAlertDemoVC.swift
//  ABAlert
//
//  Created by Ankit Bhana on 08/06/19.
//  Copyright © 2019 Ankit Bhana. All rights reserved.
//

import UIKit

class ABAlertDemoVC: UIViewController {
    
    @IBOutlet weak var stackColorView: UIStackView!
    @IBOutlet var btnsColorView: [UIButton]!
    @IBOutlet var sliderColors: [UISlider]!
    @IBOutlet weak var tfNumOfButtons: UITextField!
    @IBOutlet weak var tfDialogCornerRadius: UITextField!
    @IBOutlet weak var tfButtonsHeight: UITextField!
    
    var selectedBtn = UIButton()
    var titleColor = ColorConfig(red: 0, green: 0, blue: 0) {
        didSet {
            let ttlColor = UIColor(red: titleColor.red/255, green: titleColor.green/255, blue: titleColor.blue/255, alpha: 1)
            btnsColorView[0].backgroundColor = ttlColor
            abAlertAppearanceManager.alertTitleColor = ttlColor
        }
    }
    
    var messageColor = ColorConfig(red: 0, green: 0, blue: 0) {
        didSet {
            let msgColor = UIColor(red: messageColor.red/255, green: messageColor.green/255, blue: messageColor.blue/255, alpha: 1)
            btnsColorView[1].backgroundColor = msgColor
            abAlertAppearanceManager.alertMessageColor = msgColor
        }
    }
    
    var dialogColor = ColorConfig(red: 0, green: 0, blue: 0) {
        didSet {
            let dlgColor = UIColor(red: dialogColor.red/255, green: dialogColor.green/255, blue: dialogColor.blue/255, alpha: 1)
            btnsColorView[2].backgroundColor = dlgColor
            abAlertAppearanceManager.alertDialogColor = dlgColor
        }
    }
    
    var backgroundColor = ColorConfig(red: 0, green: 0, blue: 0) {
        didSet {
            let bgColor = UIColor(red: backgroundColor.red/255, green: backgroundColor.green/255, blue: backgroundColor.blue/255, alpha: 0.5)
            btnsColorView[3].backgroundColor = bgColor
            abAlertAppearanceManager.alertBackgroundColor = bgColor
        }
    }
    
    let abAlertAppearanceManager = ABAlert.appearanceManager
    var tempRed: CGFloat = 0
    var tempGreen: CGFloat = 0
    var tempBlue: CGFloat = 0
    
    var randomColor: UIColor {
        let randomRed = CGFloat(Int.random(in: 0...200))/255
        let randomGreen = CGFloat(Int.random(in: 0...200))/255
        let randomBlue = CGFloat(Int.random(in: 0...200))/255
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialSetup()
    }
    
    func initialSetup() {
        titleColor = ColorConfig(red: 0, green: 0, blue: 0)
        messageColor = ColorConfig(red: 200, green: 200, blue: 200)
        dialogColor = ColorConfig(red: 100, green: 100, blue: 100)
        backgroundColor = ColorConfig(red: 0, green: 0, blue: 0)
        stackColorView.subviews.forEach { $0.layer.cornerRadius = $0.bounds.height / 2 }
        setSelected(btn: btnsColorView[0])
    }
    
    func setSelected(btn: UIButton) {
        selectedBtn = btn
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 5
        
        switch btn.tag {
        case 1:
            setSliderValueOnSelection(colorConfig: titleColor)
        case 2:
            setSliderValueOnSelection(colorConfig: messageColor)
        case 3:
            setSliderValueOnSelection(colorConfig: dialogColor)
        case 4:
            setSliderValueOnSelection(colorConfig: backgroundColor)
        default:
            break
        }
        
    }
    
    func setDeSelected(btn: UIButton) {
        btn.layer.borderWidth = 0
    }
    
    func setSliderValueOnSelection(colorConfig: ColorConfig) {
        tempRed = colorConfig.red
        tempGreen = colorConfig.green
        tempBlue = colorConfig.blue
        sliderColors[0].value = Float(colorConfig.red)
        sliderColors[1].value = Float(colorConfig.green)
        sliderColors[2].value = Float(colorConfig.blue)
    }
    
    @IBAction func btnsColorView(_ sender: UIButton) {
        btnsColorView.forEach { $0.tag == sender.tag ? setSelected(btn: $0) : setDeSelected(btn: $0)}
    }
    
    @IBAction func sliderColor(_ sender: UISlider) {
        
        switch sender.tag {
        case 1:
            tempRed = CGFloat(sender.value)
        case 2:
            tempGreen = CGFloat(sender.value)
        case 3:
            tempBlue = CGFloat(sender.value)
        default:
            break
        }
        
        switch selectedBtn.tag {
        case 1:
            titleColor = ColorConfig(red: tempRed, green: tempGreen, blue: tempBlue)
        case 2:
            messageColor = ColorConfig(red: tempRed, green: tempGreen, blue: tempBlue)
        case 3:
            dialogColor = ColorConfig(red: tempRed, green: tempGreen, blue: tempBlue)
        case 4:
            backgroundColor = ColorConfig(red: tempRed, green: tempGreen, blue: tempBlue)
        default:
            break
        }
    }
    
    @IBAction func segTransitionStyle(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            abAlertAppearanceManager.alertTransition = .bounceUP
        case 1:
            abAlertAppearanceManager.alertTransition = .fadeIn
        case 2:
            abAlertAppearanceManager.alertTransition = .zoomIn
        case 3:
            abAlertAppearanceManager.alertTransition = .bounceDown
        default:
            break
        }
        
    }
    
    @IBAction func segButtonsAlignment(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            abAlertAppearanceManager.alertButtonAlignment = .horizontal
        case 1:
            abAlertAppearanceManager.alertButtonAlignment = .vertical
        default:
            break
        }
        
    }
    
}

extension ABAlertDemoVC {
    
    @IBAction func btnMessage() {
        configAppearanceManager()
        let abAlert = ABAlert.instanceWith(message: "The message goes here.")
        guard let abAlertButtons = getButtons() else { return }
        abAlert.addButtons(alertButtons: abAlertButtons)
        abAlert.show()
    }
    
    @IBAction func btnTitleMessage() {
        configAppearanceManager()
        let abAlert = ABAlert.instanceWith(title: "Title",message: "The message goes here.")
        guard let abAlertButtons = getButtons() else { return }
        abAlert.addButtons(alertButtons: abAlertButtons)
        abAlert.show()
    }
    
    @IBAction func btnTitleMessageImage() {
        configAppearanceManager()
        let abAlert = ABAlert.instanceWith(title: "Title", message: "The message goes here.", image: UIImage(named: "ic_placeholder.png"))
        guard let abAlertButtons = getButtons() else { return }
        abAlert.addButtons(alertButtons: abAlertButtons)
        abAlert.show()
    }
    
    @IBAction func switchTapToDissmiss(_ sender: UISwitch) {
        sender.isOn = !sender.isOn
        abAlertAppearanceManager.alertTapToDismiss = sender.isOn
    }
    
    private func getButtons() -> [ABAlertButton]? {
        let numberOfBtnText = tfNumOfButtons.text!
        guard let numberOfButtons = Int(numberOfBtnText.isEmpty ? "1" : numberOfBtnText), numberOfButtons > 0 else {
            Alert.showWith(message: "Please enter valid Number Of Buttons")
            return nil
        }
        
        var abAlertbuttons = [ABAlertButton]()
        
        (1...numberOfButtons).forEach { abAlertbuttons.append(ABAlertButton(buttonConfiguration: ButtonConfiguration(title: "Button \($0)", tint: .white, backgroundColor: randomColor))) }
        return abAlertbuttons
    }
    
    private func configAppearanceManager() {
        setDialogCornerRadius()
        setAlertButtonsPreferedHeight()
    }
    
    private func setDialogCornerRadius() {
        let cornerRadiusText = tfDialogCornerRadius.text!
        if let dialogCornerRadius = Double(cornerRadiusText), dialogCornerRadius >= 0 {
            abAlertAppearanceManager.alertDialogCornerRadius = CGFloat(dialogCornerRadius)
        }
        
    }
    
    private func setAlertButtonsPreferedHeight() {
        
        let buttonHeightText = tfButtonsHeight.text!
        if let buttonHeight = Double(buttonHeightText), buttonHeight >= 0 {
            abAlertAppearanceManager.alertButtonPreferedHeight = CGFloat(buttonHeight)
        }
    }
    
}

struct ColorConfig {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat? = 1.0
}
