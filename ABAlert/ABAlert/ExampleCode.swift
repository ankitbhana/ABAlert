//
//  ExampleCode.swift
//  ABAlert
//
//  Created by Ankit Bhana on 06/06/19.
//  Copyright © 2019 Ankit Bhana. All rights reserved.
//

import UIKit

/**
 Assign this class to any of your storyboard scene and play around with ABAlert, only you have to add button to your scene in storyboard and connect the IBActions defined below.
 */
class AnyController: UIViewController {
    
    //MARK: - ViewController's View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Comment below method to see the default behaviour.
        configureABAlertAppearanceManager()
    }
    
    
    //MARK: - Helper Methods
    
    /**
     Use ABAlertAppearanceManager singleton anywhere you want to setup the alert appearance as per the requirments. Set properties once and after it will be same for whole application until you change properties later on. Prefered location to configure the ABAlertAppearanceManager is in the didFinishLaunchingWithOption method in AppDelegate.
     
     Note :- ABAlertAppearanceManager configuration is fully optional, if you dont configure it, you will get the default behaviour.
     */
    private func configureABAlertAppearanceManager() {
        
        let alertAppearanceManager = ABAlert.appearanceManager
        
        alertAppearanceManager.alertTitleColor = .black
        alertAppearanceManager.alertTitleFont = UIFont.systemFont(ofSize: 20, weight: .semibold)
        alertAppearanceManager.alertMessageColor = .black
        alertAppearanceManager.alertMessageFont = UIFont.systemFont(ofSize: 16, weight: .regular)
        alertAppearanceManager.alertDialogColor = .white
        alertAppearanceManager.alertDialogCornerRadius = 10
        alertAppearanceManager.alertBackgroundColor = UIColor(white: 0, alpha: 0.5)
        alertAppearanceManager.alertButtonFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        alertAppearanceManager.alertButtonPreferedHeight = 40
        alertAppearanceManager.alertTransition = .bounceUP
        alertAppearanceManager.alertButtonAlignment = .horizontal
    }
    
    
    //MARK: - The standard way to use ABAlert.
    //Note :- Dont forget to perform everything under main thread.
    func showStandardAlert() {
        // Step - 1 Instantiate an ABAlert object by calling the instanceWith menthod. Image and Title properties are optional and you can omit arguments which you don't need.
        let abAlert = ABAlert.instanceWith(title: "Title", message: "The message goes here.")
        
        // Step - 2 Make ABAlertButton with title, tint and, background color.
        let button1 = ABAlertButton(buttonConfiguration: ButtonConfiguration(title: "Button 1", tint: .cyan, backgroundColor: .black)) {
            print("Button 1 tapped")
        }
        let button2 = ABAlertButton(buttonConfiguration: ButtonConfiguration(title: "Button 2", tint: .white, backgroundColor: .darkGray)) {
            print("Button 2 tapped")
        }
        
        // Step - 3 Add buttons to ABAlert object by calling its addButtons method.
        abAlert.addButtons(alertButtons: [button1, button2])
        
        // Step - 4 Finally call the show mwthod to get the alert on screen.
        abAlert.show()
    }
    
    //MARK: - Convenience alert defined in Alert.swift using ABAlert.The convenience way to use ABAlert.
    //Type 1 - Only Message
    func showAlertWithOnlyMessage() {
        Alert.showWith(message: "Alert with only message.")
    }
    
    //Type 2 - Title + Message
    func showAlertWithTitleAndMessage() {
        Alert.showWith(title: "Alerts", message: "Alert with a title and message.")
        
    }
    
    //Type 3 - Title + Message + Image + two buttons
    func showAlertWithMessageAndImage() {
        Alert.showWith(title: "Swift News!", message: "A brand new SwiftUI framework is launched in WWDC2019.", image: UIImage(named: "ic_instagram_small"), firstButton: ButtonConfiguration(title: "View Features", tint: .cyan, backgroundColor: .black), secondButton: ButtonConfiguration(title: "Cancel", tint: .white, backgroundColor: .darkGray)) { (btnType) in
            switch btnType {
            case .firstButton:
                print("firstButton Tapped")
            case .secondButton:
                print("secondButton Tapped")
            }
        }
        
    }
    
    
    //MARK: - IBActions
    @IBAction func btnStandardAlert() {
        showStandardAlert()
    }
    
    @IBAction func btnMessage(_ sender: UIButton) {
        showAlertWithOnlyMessage()
    }
    
    @IBAction func btnTitleMessage(_ sender: UIButton) {
        showAlertWithTitleAndMessage()
    }
    
    @IBAction func btnTitleMessageImage(_ sender: UIButton) {
        showAlertWithMessageAndImage()
    }
    
}
