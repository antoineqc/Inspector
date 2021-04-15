//
//  KeyboardAnimatable.swift
//  HierarchyInspector
//
//  Created by Pedro Almeida on 04.04.21.
//

import UIKit

protocol KeyboardAnimatable: UIViewController {}

enum KeyboardEvent {
    case willShow
    case didShow
    case willHide
    case didHide
    case willChangeFrame
    case didChangeFrame
    
    fileprivate var notificationName: Notification.Name {
        switch self {
        
        case .willShow:
            return UIResponder.keyboardWillShowNotification
        
        case .didShow:
            return UIResponder.keyboardDidShowNotification
        
        case .willHide:
            return UIResponder.keyboardWillHideNotification
        
        case .didHide:
            return UIResponder.keyboardDidHideNotification
            
        case .willChangeFrame:
            return UIResponder.keyboardWillChangeFrameNotification
        
        case .didChangeFrame:
            return UIResponder.keyboardDidChangeFrameNotification
        }
    }
}

struct KeyboardAnimationProperties {
    let duration: TimeInterval
    let keyboardFrame: CGRect
    let curveValue: Int
    let curve: UIView.AnimationCurve
}

extension KeyboardAnimatable {
    
    func addKeyboardNotificationObserver(with selector: Selector, to keyboardEvent: KeyboardEvent) {
        NotificationCenter.default.addObserver(self, selector: selector, name: keyboardEvent.notificationName, object: nil)
    }
    
    func removeKeyboardNotificationObserver(with selector: Selector, to keyboardEvent: KeyboardEvent) {
        NotificationCenter.default.removeObserver(self, name: keyboardEvent.notificationName, object: nil)
    }
    
    func animateWithKeyboard(notification: Notification, animations: @escaping ((_ properties: KeyboardAnimationProperties) -> Void)) {
        guard
            let userInfo = notification.userInfo,
            userInfo[.keyboardIsLocalKey] as? Bool == true,
            let duration = userInfo[.durationKey] as? Double,
            let keyboardFrame = userInfo[.frameKey] as? CGRect,
            let curveValue = userInfo[.curveKey] as? Int,
            let curve = UIView.AnimationCurve(rawValue: curveValue)
        else {
            return
        }
        
        let properties = KeyboardAnimationProperties(
            duration: duration,
            keyboardFrame: keyboardFrame,
            curveValue: curveValue,
            curve: curve
        )
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: curve) {
            animations(properties)
            
            self.view.layoutIfNeeded()
        }
        
        animator.startAnimation()
    }
}

private extension AnyHashable {
    
    static var durationKey: AnyHashable { UIResponder.keyboardAnimationDurationUserInfoKey }
    
    static var frameKey: AnyHashable { UIResponder.keyboardFrameEndUserInfoKey }
    
    static var curveKey: AnyHashable { UIResponder.keyboardAnimationCurveUserInfoKey }
    
    static var keyboardIsLocalKey: AnyHashable { UIResponder.keyboardIsLocalUserInfoKey }
    
}
