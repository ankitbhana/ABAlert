//
//  ABAlertButton.swift
//  ABAlert
//
//  Created by Ankit Bhana on 28/05/19.
//  Copyright © 2019 Ankit Bhana. All rights reserved.
//

import UIKit

class ABAlertButton: UIButton {

    
    //MARK: - Private Properties
    private var callback: (() ->())?
    private let alertAppearanceManager = ABAlert.appearanceManager
    
    //Title of the button
    private var title: String! {
        didSet {
            setTitle(title, for: .normal)
        }
    }
    
    //Title color of the button
    private var titleColor: UIColor! {
        didSet {
            setTitleColor(titleColor, for: .normal)
            setTitleColor(titleColor.withAlphaComponent(0.5), for: .highlighted)
        }
    }
    
    //Background color of the button
    private var buttonBGColor: UIColor! {
        didSet {
            backgroundColor = buttonBGColor
        }
    }
    
    // Height of the button
    private var height: CGFloat {
        return alertAppearanceManager.alertButtonPreferedHeight
    }
    
    /**
     Initializes the ABAlertButton with ButtonConfiguration and an optional completion handler.
     */
    init(buttonConfiguration: ButtonConfiguration, _ completion: (() -> ())? = nil) {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        heightConstraint.identifier = "AlertButtonHeight"
        heightConstraint.isActive = true
        self.callback = completion
        setPropertiesWith(buttonConfiguration)
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Initialization through storyboard is invalid.")
    }

    //This method sets the properties of ABAlertButton.
    private func setPropertiesWith(_ buttonConfiguration: ButtonConfiguration) {
        self.title = buttonConfiguration.title
        self.titleColor = buttonConfiguration.tint
        self.buttonBGColor = buttonConfiguration.backgroundColor
        addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        titleLabel?.lineBreakMode = .byTruncatingTail
    }
    
    //Called when ABAlertButton tapped.
    @objc func btnTapped(_ sender: UIButton) {
        callback?()
        ABAlert.remove()
    }
    
}
