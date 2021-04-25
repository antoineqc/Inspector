//
//  UIView+ViewHierarchyProtocol.swift
//  HierarchyInspector
//
//  Created by Pedro Almeida on 02.10.20.
//

import UIKit

// MARK: - ViewHierarchyProtocol

extension UIView: ViewHierarchyProtocol {
    
    var canPresentOnTop: Bool {
        switch self {
        case is UITextView:
            return true

        case is UIScrollView:
            return false

        default:
            return true
        }
    }
    
    var canHostInspectorView: Bool {
        guard
            // Adding subviews directly to a UIVisualEffectView throws runtime exception.
            self is UIVisualEffectView == false,
            
            // Avoid breaking UIButton layout.
            superview is UIButton == false,
            
            // Avoid breaking UITableView self sizing cells.
            className != "UITableViewCellContentView",
            
            // Avoid breaking UINavigationController large title.
            superview?.className != "UIViewControllerWrapperView",
            
            // Skip hierarchy inspector internal strcutures.
            self is LayerViewProtocol == false,
            superview is LayerViewProtocol == false
        else {
            return false
        }
        return true
    }
    
    var isSystemView: Bool {
        guard
            isSystemContainerView == false,
            className.first != "_"
        else {
            return true
        }
        
        return false
    }
    
    var isSystemContainerView: Bool {
        guard
            className != "UIWindow",
            className != "UITransitionView",
            className != "UIDropShadowView",
            className != "UILayoutContainerView",
            className != "UIViewControllerWrapperView",
            className != "UINavigationTransitionView"
        else {
            return true
        }
        
        return false
    }
    
    var className: String {
        String(describing: classForCoder)
    }
    
    var elementName: String {
        guard let description = accessibilityIdentifier?.split(separator: ".").last else {
            return className
        }
        
        return String(description)
    }
}
