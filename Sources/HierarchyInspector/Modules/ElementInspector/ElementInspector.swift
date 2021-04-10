//
//  ElementInspector.swift
//  HierarchyInspector
//
//  Created by Pedro Almeida on 09.10.20.
//

import UIKit

enum ElementInspector {
    static var configuration = Configuration()
    
    static var appearance = Appearance()
}

extension ElementInspector {
    struct Configuration {
        let animationDuration: TimeInterval = CATransaction.animationDuration()
    }
}

extension ElementInspector {
    struct Appearance {
        var thumbnailBackgroundStyle: ThumbnailBackgroundStyle = .medium
        
        let horizontalMargins: CGFloat = 24
        
        let verticalMargins: CGFloat = 12
        
        var tintColor: UIColor = UIColor(hex: 0xBF5AF2)
        
        var accessoryControlBackgroundColor = UIColor(hex: 0x3D3D42)
        
        var textColor: UIColor = {
            return .white
        }()
        
        var secondaryTextColor: UIColor {
            textColor.withAlphaComponent(disabledAlpha * 2)
        }
        
        var tertiaryTextColor: UIColor {
            textColor.withAlphaComponent(disabledAlpha)
        }
        
        var quaternaryTextColor: UIColor {
            textColor.withAlphaComponent(disabledAlpha / 2)
        }
        
        var disabledAlpha: CGFloat = 0.3
        
        var margins: NSDirectionalEdgeInsets {
            .margins(
                horizontal: horizontalMargins,
                vertical: verticalMargins
            )
        }
        
        var panelPreferredCompressedSize: CGSize {
            CGSize(
                width: min(UIScreen.main.bounds.width, 414),
                height: .zero
            )
        }
        
        var panelBackgroundColor: UIColor = {
            return UIColor(hex: 0x2C2C2E)
        }()
        
        var panelHighlightBackgroundColor: UIColor = {
            return UIColor(hex: 0x3A3A3C)
        }()
        
        func titleFont(forRelativeDepth relativeDepth: Int) -> UIFont {
            switch relativeDepth {
            case 0:
                return UIFont.preferredFont(forTextStyle: .title3).bold()

            case 1:
                return UIFont.preferredFont(forTextStyle: .headline).bold()

            case 2:
                return UIFont.preferredFont(forTextStyle: .body).bold()

            case 3:
                return UIFont.preferredFont(forTextStyle: .callout).bold()

            default:
                return UIFont.preferredFont(forTextStyle: .footnote)
            }
        }
    }
}
