//
//  Alert.swift
//  ABAlert
//
//  Created by Ankit Bhana on 06/06/19.
//  Copyright © 2019 Ankit Bhana. All rights reserved.
//

import UIKit

/**
 You can make a class to fullfill your custom requirements like making a method that can take one or two buttons along with the default parameters like title, message and image.
 */
class Alert {
    
    /*
     Defines the button type.
     **/
    enum ButtonType {
        case firstButton, secondButton
    }
    
    //MARK: - Properties
    private static var abAlert: ABAlert?
    private static var callback: ((ButtonType) ->())?
    
    //MARK: - Helper Methods
    /**
     Use this convenience method to instantiate and show alert with one or two buttons. Also you will get a completion with their respective type defined in ButtonType
     */
    static func showWith(title: String? = nil, message: String, image: UIImage? = nil, alertTransition: ABAlertTransitionManager.TransitionStyle? = nil, firstButton: ButtonConfiguration = ButtonConfiguration(title: "OK", tint: .cyan, backgroundColor: .black), secondButton: ButtonConfiguration? = nil, completion: ((_ buttonType: ButtonType) -> ())? = nil) {
        DispatchQueue.main.async {
            abAlert = ABAlert.instanceWith(title: title, message: message, image: image, alertTransition: alertTransition)
            Alert.callback = completion
            addButtonsWithConfig(firstButton, secondButton)
            abAlert?.show()
        }
    }
    
    /**
     Add buttons to alert.
     */
    private static func addButtonsWithConfig(_ firstButtonWithConfig: ButtonConfiguration,_ secondButtonWithConfig: ButtonConfiguration?) {
        
        var alertButtons = [ABAlertButton]()
        
        let firstButton = ABAlertButton(buttonConfiguration: firstButtonWithConfig) {
            callback?(.firstButton)
        }
        alertButtons.append(firstButton)
        if let secondButtonWithConfig = secondButtonWithConfig {
            let secondButton = ABAlertButton(buttonConfiguration: secondButtonWithConfig) {
                callback?(.secondButton)
            }
            alertButtons.append(secondButton)
        }
        
        abAlert?.addButtons(alertButtons: alertButtons)
    }
    
}
