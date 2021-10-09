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

import UIKit

struct ViewHierarchySnapshot: ExpirableProtocol {
    let expirationDate = Date().addingTimeInterval(Inspector.configuration.snapshotExpirationTimeInterval)

    let availableLayers: [ViewHierarchyLayer]

    let populatedLayers: [ViewHierarchyLayer]

    let rootElement: ViewHierarchyElement

    let rootViewController: ViewHierarchyController

    let inspectableElements: [ViewHierarchyElement]

    init(layers: [ViewHierarchyLayer], rootElement: ViewHierarchyElement, rootViewController: ViewHierarchyController) {
        self.rootElement = rootElement
        self.rootViewController = rootViewController
        inspectableElements = rootElement.inspectableChildren
        availableLayers = layers.uniqueValues()
        populatedLayers = availableLayers.filter {
            $0.filter(flattenedViewHierarchy: rootElement.inspectableChildren).isEmpty == false
        }
    }
}
