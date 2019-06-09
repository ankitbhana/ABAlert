//
//  AlertAnimationManager.swift
//  ABAlert
//
//  Created by Ankit Bhana on 02/06/19.
//  Copyright © 2019 Ankit Bhana. All rights reserved.
//

import UIKit

class ABAlertTransitionManager {
    
    /**
     Define different trasition styles.
     */
    enum TransitionStyle {
        case fadeIn, zoomIn, bounceUP, bounceDown
    }
    
    /**
     Define the animation direction.
     */
    enum AnimationDirection {
        case `in`, out
    }

    
    fileprivate var abAlert: ABAlert
    fileprivate var alertDialog: UIView
    fileprivate var alertBGView: UIView
    fileprivate var alertTransition: TransitionStyle
    fileprivate var convenienceAlertTransition: TransitionStyle?
    
    /**
     Initializes the ABAlertTransitionManager with TransitionStyle.
     */
    init(alert: ABAlert, alertTransition: TransitionStyle, alertDialog: UIView, alertBGView: UIView, convenienceAlertTransition: TransitionStyle? = nil) {
        self.abAlert = alert
        self.alertTransition = alertTransition
        self.alertDialog = alertDialog
        self.alertBGView = alertBGView
        self.convenienceAlertTransition = convenienceAlertTransition
    }
    
    /**
     Animate the ABAlert with the given transion style.
     */
    func animateFor(animationDirection: AnimationDirection) {
        let alertTransition = convenienceAlertTransition != nil ? convenienceAlertTransition! : self.alertTransition
        switch alertTransition {
        case .fadeIn:
            fadeIn(animationDirection: animationDirection)
        case .zoomIn:
            zoomIn(animationDirection: animationDirection)
        case .bounceUP:
            bounceUP(animationDirection: animationDirection)
        case .bounceDown:
            bounceDown(animationDirection: animationDirection)
        }
        
    }
    
    /**
     Animate the ABAlert fadeIn transion style.
     */
    private func fadeIn(animationDirection: AnimationDirection) {
        
        switch animationDirection {
            
        case .in:
            abAlert.alpha = 0
            UIView.animate(withDuration: 0.4) {
                self.abAlert.layer.opacity = 1
            }
            
        case .out:
            UIView.animate(withDuration: 0.2, animations: {
                self.abAlert.layer.opacity = 0
            }) { (_) in
                self.abAlert.removeFromSuperview()
            }
        }
        
    }
    
    /**
     Animate the ABAlert zoomIn transion style.
     */
    private func zoomIn(animationDirection: AnimationDirection) {
        
        switch animationDirection {
            
        case .in:
            let scaleTransform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            alertDialog.transform = scaleTransform
            alertBGView.alpha = 0
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
                self.alertBGView.alpha = 1
                self.alertDialog.transform = .identity

            })
            
        case .out:
            let scaleTransform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self.alertBGView.alpha = 0
                self.alertDialog.transform = scaleTransform
            }){ (_) in
                self.abAlert.removeFromSuperview()
            }
        }
    }
    
    /**
     Animate the ABAlert bounceUP transion style.
     */
    private func bounceUP(animationDirection: AnimationDirection) {
        
        guard let keyWindow = UIApplication.shared.keyWindow else { return }

        switch animationDirection {
            
        case .in:
            
            let initalX = keyWindow.center.x - keyWindow.bounds.width / 2
            let initialY = keyWindow.frame.maxY
            
            let translateTransform = CGAffineTransform(translationX: initalX, y: initialY)
            alertDialog.transform = translateTransform
            alertBGView.alpha = 0
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self.alertBGView.alpha = 1
                self.alertDialog.transform = .identity

            })
            
        case .out:
            
            let finalX = keyWindow.center.x - keyWindow.bounds.width / 2
            let finalY = keyWindow.frame.maxY
            
            let translateTransform = CGAffineTransform(translationX: finalX, y: finalY)
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self.alertBGView.alpha = 0
                self.alertDialog.transform = translateTransform
            }){ (_) in
                self.abAlert.removeFromSuperview()
            }

        }
    }

    /**
     Animate the ABAlert bounceDown transion style.
     */
    private func bounceDown(animationDirection: AnimationDirection) {
        
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        
        switch animationDirection {
            
        case .in:
            
            let initalX = keyWindow.center.x - keyWindow.bounds.width / 2
            let initialY = keyWindow.frame.minY - keyWindow.frame.height / 2
            
            let translateTransform = CGAffineTransform(translationX: initalX, y: initialY)
            alertDialog.transform = translateTransform
            alertBGView.alpha = 0
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self.alertBGView.alpha = 1
                self.alertDialog.transform = .identity
                
            })
            
        case .out:
            
            let finalX = keyWindow.center.x - keyWindow.bounds.width / 2
            let finalY = keyWindow.frame.minY - keyWindow.frame.height / 2
            
            let translateTransform = CGAffineTransform(translationX: finalX, y: finalY)
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self.alertBGView.alpha = 0
                self.alertDialog.transform = translateTransform
            }){ (_) in
                self.abAlert.removeFromSuperview()
            }
        }
    }
    
}
