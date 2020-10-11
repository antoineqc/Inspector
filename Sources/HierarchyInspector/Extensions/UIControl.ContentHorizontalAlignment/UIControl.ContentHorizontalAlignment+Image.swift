//
//  UIControl.ContentHorizontalAlignment+Image.swift
//  HierarchyInspector
//
//  Created by Pedro Almeida on 10.10.20.
//

import UIKit

extension UIControl.ContentHorizontalAlignment {
    var image: UIImage? {
        switch self {
            case .leading:
                return IconKit.imageOfHorizontalAlignmentLeading()
                
            case .left:
                return IconKit.imageOfHorizontalAlignmentLeft()
                
            case .center:
                return IconKit.imageOfHorizontalAlignmentCenter()
                
            case .right:
                return IconKit.imageOfHorizontalAlignmentRight()
                
            case .trailing:
                return IconKit.imageOfHorizontalAlignmentTrailing()
                
            case .fill:
                return IconKit.imageOfHorizontalAlignmentFill()
                
            @unknown default:
                return nil
        }
    }
}
