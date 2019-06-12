//
//  ABAlert.swift
//  ABAlert
//
//  Created by Ankit Bhana on 26/05/19.
//  Copyright © 2019 Ankit Bhana. All rights reserved.
//

import UIKit

class ABAlert: UIView {
    
    
    //MARK: - IBOutlets
    @IBOutlet fileprivate weak var lblTitle: UILabel!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var lblMessage: UILabel!
    @IBOutlet fileprivate weak var stackButtons: UIStackView!
    @IBOutlet fileprivate weak var alertDialog: UIView!
    @IBOutlet fileprivate weak var alertBGView: UIView!
    
    
    //MARK: - Type Properties
    static let appearanceManager = ABAlertAppearanceManager()
    fileprivate static var abAlert: ABAlert?
    
    
    //MARK: - Instance Properties
//    fileprivate var callback: ((ButtonType) ->())?
    fileprivate var abAlertButtons = [ABAlertButton]()
    
    
    //MARK: - Public Helper Methods
    
    /**
     Use this method to instantiate an instance of ABAlert with provided arguments.
     */
    static func instanceWith(title: String? = nil, message: String, image: UIImage? = nil, alertTransition: ABAlertTransitionManager.TransitionStyle? = nil) -> ABAlert {
        loadAndSetupWith(title: title, message: message, image: image, convenienceAlertTransition: alertTransition)
        return abAlert!
    }
    
    /**
     Use this instance method to add ABAlertButton objects to ABAlert.
     */
    func addButtons(alertButtons: [ABAlertButton]) {
//        guard !ABAlert.appearanceManager.alertEnableToastMode else { return }
        self.abAlertButtons = alertButtons
        guard let alert = ABAlert.abAlert else { return }
        alertButtons.forEach { alert.stackButtons.addArrangedSubview($0) }
    }
    
    /**
     This instance method add the created alert on keyWindow and set ABAlert appearance using ABAlertAppearanceManager.
     */
    func show() {
        guard let alert = ABAlert.abAlert else { return }
        alert.frame = UIScreen.main.bounds
        UIApplication.shared.keyWindow?.addSubview(alert)
        UIApplication.shared.keyWindow?.layoutIfNeeded()
        setAppearance()
        animateFor(animationDirection: .in)
    }
    
//    func show() {
//        guard let alert = ABAlert.abAlert else { return }
//        guard let keyWindow = UIApplication.shared.keyWindow else { return }
//        //        alertDialog.center = center
//        //        alert.frame.size = CGSize(width: 240, height: 59.5)//UIScreen.main.bounds
//        keyWindow.addSubview(alert.alertDialog)
//        keyWindow.layoutIfNeeded()
//        alertDialog.bounds.size = CGSize(width: UIScreen.main.bounds.width * 0.75 , height: alertDialog.bounds.height)//center
//        let toastCenterX = keyWindow.center.x - alertDialog.bounds.width / 2
//        let tostCenterY = keyWindow.frame.maxY - 200
//        alertDialog.frame.origin = CGPoint(x: toastCenterX, y: tostCenterY)
//        print(alertDialog.frame)
//
//        setAppearance()
//        animateFor(animationDirection: .in)
//    }


    /**
     Use this instance method to remove ABAlert from keyWindow.
     */
    static func remove() {
        guard let abAlert = abAlert else { return }
        abAlert.animateFor(animationDirection: .out)
    }

    
    //MARK: - Private Helper Methods
    
    /**
     Load ABAlert from xib and does initial setup.
     */
    private static func loadAndSetupWith(title: String?, message: String, image: UIImage?, convenienceAlertTransition: ABAlertTransitionManager.TransitionStyle?) {
        
        if abAlert != nil {
            abAlert!.removeFromSuperview()
            abAlert = nil
        }
        abAlert = UINib(nibName: "ABAlert", bundle: nil).instantiate(withOwner: abAlert, options: nil).first as? ABAlert
//        abAlert!.frame = appearanceManager.alertEnableToastMode ? abAlert!.alertDialog.bounds : UIScreen.main.bounds
        abAlert!.removeUnusedOutletsAndAddConstrains(title: title, message: message, image: image)
        abAlert!.feedAlertProperties(title: title, message: message, image: image)
        abAlert!.setupStackButton()
        abAlert!.setupTapToDissmiss()
        appearanceManager.convenienceAlertTransition = convenienceAlertTransition
        appearanceManager.abAlert = abAlert
    }
    
    /**
     Set the appearance of alert using properties configures in ABAlertAppearanceManager.
     */
    private func setAppearance() {
        let appearanceManager = ABAlert.appearanceManager
        lblTitle.textColor = appearanceManager.alertTitleColor
        lblTitle.font = appearanceManager.alertTitleFont
        lblMessage.textColor = appearanceManager.alertMessageColor
        lblMessage.font = appearanceManager.alertMessageFont
        appearanceManager.setAlertButtonsFont(abAlertButtons)
        alertDialog.backgroundColor = appearanceManager.alertDialogColor
        alertDialog.layer.cornerRadius = appearanceManager.alertDialogCornerRadius
        alertBGView.backgroundColor = appearanceManager.alertBackgroundColor
        appearanceManager.setAlertButtonsHeight(abAlertButtons)
        stackButtons.axis = appearanceManager.alertButtonAlignment == .horizontal ? .horizontal : .vertical
    }

    /**
     This private instance method animate the ABAlert using ABAlertTransitionManager.
     */
    private func animateFor(animationDirection: ABAlertTransitionManager.AnimationDirection) {
        guard let transitionManager = ABAlert.appearanceManager.abAlertTransitionManager else { return }
        transitionManager.animateFor(animationDirection: animationDirection)
    }
    
    /**
     This private instance method remove unused outlets and manage the alert spacing using NSLayoutConstraint.
     */
    private func removeUnusedOutletsAndAddConstrains(title: String?, message: String, image: UIImage?) {
        
        if title == nil && image == nil /*|| ABAlert.appearanceManager.alertEnableToastMode*/ {
            lblTitle.removeFromSuperview()
            imageView.removeFromSuperview()
            lblMessage.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: lblMessage, attribute: .top, relatedBy: .equal, toItem: alertDialog, attribute: .top, multiplier: 1, constant: 20).isActive = true
//            guard ABAlert.appearanceManager.alertEnableToastMode else { return }
//            alertBGView.removeFromSuperview()
            return
        }
        
        if title == nil {
            lblTitle.removeFromSuperview()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: alertDialog, attribute: .top, multiplier: 1, constant: 30).isActive = true
        }
        if image == nil {
            imageView.removeFromSuperview()
            lblMessage.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: lblMessage, attribute: .top, relatedBy: .equal, toItem: lblTitle, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
            
        }
    }
    
    /**
     This private instance method feeds the outlets.
     */
    private func feedAlertProperties(title: String?, message: String, image: UIImage?) {
        lblMessage.text = message
        
        if lblTitle != nil {
            lblTitle.text = title
        }
        
        if imageView != nil {
            imageView.image = image
        }
        
    }
    
    /**
     Configures the stack.
     */
    private func setupStackButton() {
        stackButtons.axis = .horizontal
        stackButtons.distribution = .fillEqually
    }
    
    /**
     If tapToDissmiss is set to true, add the tap on background view and assigned a selector to it.
     */
    private func setupTapToDissmiss() {
        guard ABAlert.appearanceManager.alertTapToDismiss else { return }
        alertBGView.isUserInteractionEnabled = true
        alertBGView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bgViewTapped)))
    }
    
    /**
     Method is called when background view is tapped.
     */
    @objc private func bgViewTapped() {
        //guard !ABAlert.appearanceManager.alertEnableToastMode else { return }
        ABAlert.remove()
    }
    
}

//MARK: - This class controls the ABAlert appearance.
class ABAlertAppearanceManager {
    
    /**
     Type that specifies the ABAlertButton alignment.
     */
    enum AlertButtonAlignment {
        case vertical, horizontal
    }
    
    
    //MARK: - Private Properties
    
    fileprivate var abAlert: ABAlert? {
        didSet {
            guard let alert = abAlert else { return }
            abAlertTransitionManager = ABAlertTransitionManager(alert: alert, alertTransition: alertTransition, alertDialog: alert.alertDialog, alertBGView: alert.alertBGView, convenienceAlertTransition: convenienceAlertTransition)
        }
    }
    
    /**
     If this property is not nil then alert will use this property's value for transition animation.
     */
    fileprivate var convenienceAlertTransition: ABAlertTransitionManager.TransitionStyle?
    
    /**
     ABAlertTransitionManager object which is use to manage the different ABAlert animations.
     */
    fileprivate var abAlertTransitionManager: ABAlertTransitionManager?
    
    fileprivate init() {}
    
    
    //MARK: - Instance Properties
    
    /**
     Use this property to set the 'Title Color'. Default is black.
     */
    var alertTitleColor: UIColor = .black {
        didSet {
            abAlert?.lblTitle.textColor = alertTitleColor
        }
    }
    
    /**
     Use this property to set the 'Title Font'. Default value is system medium 20.
     */
    var alertTitleFont: UIFont = UIFont.systemFont(ofSize: 20, weight: .medium) {
        didSet {
            abAlert?.lblTitle.font = alertTitleFont
        }
    }
    
    /**
     Use this property to set the 'Message Color'. Default is black.
     */
    var alertMessageColor: UIColor = .black {
        didSet {
            abAlert?.lblMessage.textColor = alertMessageColor
        }
    }
    
    /**
     Use this property to set the 'Message Font'. Default is system regular 16.
     */
    var alertMessageFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .regular) {
        didSet {
            abAlert?.lblMessage.font = alertMessageFont
        }
    }
    
    /**
     Use this property to set the 'ABAlertButton Font'. Default value is system medium 16.
     */
    var alertButtonFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .medium) {
        didSet {
            guard let alert = abAlert else { return }
            let alertButtons = alert.abAlertButtons
            setAlertButtonsFont(alertButtons)
        }
    }
    
    /**
     Use this property to set the 'Dialog color'. Default value is white.
     */
    var alertDialogColor: UIColor = .white {
        didSet {
            abAlert?.alertDialog.backgroundColor = alertDialogColor
        }
    }
    
    /**
     Use this property to set the 'Dialog Corner Radius'. Default value is 10.
     */
    var alertDialogCornerRadius: CGFloat = 10.0 {
        didSet {
            abAlert?.alertDialog.clipsToBounds = true
            abAlert?.alertDialog.layer.cornerRadius = alertDialogCornerRadius
        }
    }
    
    /**
     Use this property to set the 'Background Color'. Default value is white with 0.3 alpha.
     */
    var alertBackgroundColor: UIColor = UIColor(white: 0.0, alpha: 0.3) {
        didSet {
            abAlert?.alertBGView.backgroundColor = alertBackgroundColor
        }
    }
    
    /**
     Use this property to set the 'ABAlertButton Height'. Default value is 40.
     */
    var alertButtonPreferedHeight: CGFloat = 40 {
        didSet {
            guard let alertButtons = abAlert?.abAlertButtons else { return }
            setAlertButtonsHeight(alertButtons)
        }
    }
    
    /**
     Use this property to set the 'ABAlertButton's Alignment'. Default value is horizontal.
     */
    var alertButtonAlignment: AlertButtonAlignment = .horizontal {
        didSet {
            guard let alert = abAlert else { return }
            alert.stackButtons.axis = alertButtonAlignment == .horizontal ? .horizontal : .vertical
        }
    }
    
    /**
     Use this property to set the 'Alert Transition Animation Style'. Default value is bounceUP.
     */
    var alertTransition: ABAlertTransitionManager.TransitionStyle = .bounceUP {
        didSet {
            guard let alert = abAlert else { return }
            abAlertTransitionManager = ABAlertTransitionManager(alert: alert, alertTransition: alertTransition, alertDialog: alert.alertDialog, alertBGView: alert.alertBGView)
        }
    }
    
    /**
     Use this property to dismiss the alert when background view is tapped. Default value is false.
     */
    var alertTapToDismiss: Bool = false
    
    /**
     When this property is set to true the alert will present itself as a toast from bottom only with provided message. Default value is false.
     */
    //var alertEnableToastMode = false
    
    
    //MARK: - Private Helper Methods
    
    /**
     Use this method to set the buttons font.
     */
    fileprivate func setAlertButtonsFont(_ alertButtons: [ABAlertButton]) {
        alertButtons.forEach { $0.titleLabel?.font = alertButtonFont }
    }
    
    /**
     Use this method to set the buttons height.
     */
    fileprivate func setAlertButtonsHeight(_ alertButtons: [ABAlertButton]) {
        alertButtons.forEach { (alertButton) in
            let alertButtonHeightContraint = alertButton.constraints.filter { $0.identifier == "AlertButtonHeight"}.first
            guard let alertButtonHeight = alertButtonHeightContraint  else { return }
            alertButton.translatesAutoresizingMaskIntoConstraints = false
            alertButtonHeight.constant = alertButtonPreferedHeight
        }
    }
    
}
