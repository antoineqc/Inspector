//  Copyright (c) 2021 Pedro Almeida
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import MapKit
import UIKit
import WebKit

enum ElementInspectorAttributesLibrary: Swift.CaseIterable, InspectorElementLibraryProtocol {
    case activityIndicator
    case button
    case control
    case datePicker
    case imageView
    case label
    case mapView
    case navigationBar
    case scrollView
    case segmentedControl
    case slider
    case stackView
    case `switch`
    case tabBar
    case textField
    case textView
    case view
    case webView
    case window

    case coreAnimationLayer

    // MARK: - InspectorElementLibraryProtocol

    var targetClass: AnyClass {
        switch self {
        case .coreAnimationLayer:
            return UIView.self

        case .navigationBar:
            return UINavigationBar.self

        case .window:
            return UIWindow.self

        case .activityIndicator:
            return UIActivityIndicatorView.self

        case .button:
            return UIButton.self

        case .control:
            return UIControl.self

        case .datePicker:
            return UIDatePicker.self

        case .imageView:
            return UIImageView.self

        case .label:
            return UILabel.self

        case .mapView:
            return MKMapView.self

        case .scrollView:
            return UIScrollView.self

        case .segmentedControl:
            return UISegmentedControl.self

        case .slider:
            return UISlider.self

        case .switch:
            return UISwitch.self

        case .stackView:
            return UIStackView.self

        case .textField:
            return UITextField.self

        case .textView:
            return UITextView.self

        case .view:
            return UIView.self

        case .webView:
            return WKWebView.self

        case .tabBar:
            return UITabBar.self
        }
    }

    func sections(for referenceView: UIView) -> InspectorElementSections {
        switch self {
        case .coreAnimationLayer:
            return .init(with: CALayerAttributesViewModel(view: referenceView))

        case .window:
            return .init(with: UIWindowAttributesViewModel(view: referenceView))

        case .navigationBar:
            var section = InspectorElementSection()

            if #available(iOS 13.0, *) {
                section.rows.append(UINavigationBarAppearanceAttributesViewModel(type: .standard, view: referenceView))
                section.rows.append(UINavigationBarAppearanceAttributesViewModel(type: .compact, view: referenceView))
                section.rows.append(UINavigationBarAppearanceAttributesViewModel(type: .scrollEdge, view: referenceView))
            }

            if #available(iOS 15.0, *) {
                section.rows.append(UINavigationBarAppearanceAttributesViewModel(type: .compactScrollEdge, view: referenceView))
            }

            section.rows.append(UINavigationBarAttributesViewModel(view: referenceView))

            return [section]

        case .activityIndicator:
            return .init(with: UIActivityIndicatorViewAttributesViewModel(view: referenceView))

        case .button:
            return .init(with: UIButtonAttributesViewModel(view: referenceView))

        case .control:
            return .init(with: UIControlAttributesViewModel(view: referenceView))

        case .datePicker:
            return .init(with: UIDatePickerAttributesViewModel(view: referenceView))

        case .imageView:
            return .init(with: UIImageViewAttributesViewModel(view: referenceView))

        case .label:
            return .init(with: UILabelAttributesViewModel(view: referenceView))

        case .mapView:
            return .init(with: MKMapViewAttributesViewModel(view: referenceView))

        case .scrollView:
            return .init(with: UIScrollViewAttributesViewModel(view: referenceView))

        case .segmentedControl:
            return .init(with: UISegmentedControlAttributesViewModel(view: referenceView))

        case .slider:
            return .init(with: UISliderAttributesViewModel(view: referenceView))

        case .switch:
            return .init(with: UISwitchAttributesViewModel(view: referenceView))

        case .stackView:
            return .init(with: UIStackViewAttributesViewModel(view: referenceView))

        case .textField:
            return .init(with: UITextFieldAttributesViewModel(view: referenceView))

        case .textView:
            return .init(with: UITextViewAttributesViewModel(view: referenceView))

        case .view:
            return .init(with: UIViewAttributesViewModel(view: referenceView))

        case .tabBar:
            return .init(with: UITabBarAttributesViewModel(view: referenceView))

        case .webView:
            return []
        }
    }
}
