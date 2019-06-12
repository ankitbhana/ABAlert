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

    private weak var abAlertAppearanceManager = ABAlert.appearanceManager
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
        /*if let alertEnableToastMode = abAlertAppearanceManager?.alertEnableToastMode, alertEnableToastMode {
            showAlertAsToast()
            return
        }*/
        
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
            UIView.animate(withDuration: 0.3) {
                self.abAlert.alpha = 1
            }
            
        case .out:
            UIView.animate(withDuration: 0.2, animations: {
                self.abAlert.alpha = 0
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
    
    /**
     Present ABAlert as a toast.
     */
    /*private func showAlertAsToast() {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        
        let frameY = alertDialog.frame.origin.y
        let maxY = keyWindow.frame.maxY
        
        let initialX: CGFloat = 0
        let initialY: CGFloat = maxY - frameY
        
        let translateTransform = CGAffineTransform(translationX: initialX, y: initialY)
        alertDialog.transform = translateTransform
        
        let bottomSafeArea = keyWindow.safeAreaInsets.bottom
        let totalHeightWithoutSafeArea = keyWindow.bounds.height - bottomSafeArea
        
        let finalX: CGFloat = 0
        let finalY: CGFloat = totalHeightWithoutSafeArea - frameY - 100
        let finalTranslateTransform = CGAffineTransform(translationX: finalX, y: finalY)
        
        self.alertBGView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.alertDialog.transform = finalTranslateTransform
        }, completion: {(_) in
            
            UIView.animate(withDuration: 0.5, delay: 3.0, options: .curveEaseIn, animations: {
                self.alertDialog.alpha = 0
            }, completion: { (_) in
                self.abAlert.removeFromSuperview()
            })
        })

    }*/
}
