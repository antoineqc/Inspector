//
//  ViewHierarchyLayersCoordinator.swift
//  HierarchyInspector
//
//  Created by Pedro Almeida on 03.10.20.
//

import Foundation

extension ViewHierarchyLayersCoordinator: LayerReferenceManagerProtocol {
    
    var isShowingLayers: Bool {
        visibleReferences.keys.isEmpty == false
    }
    
    var activeLayers: [ViewHierarchyLayer] {
        visibleReferences.compactMap { dict -> ViewHierarchyLayer? in
            guard dict.value.isEmpty == false else {
                return nil
            }
            
            return dict.key
        }
    }
    
    var availableLayers: [ViewHierarchyLayer] {
        dataSource?.viewHierarchySnapshot?.availableLayers ?? []
    }
    
    var populatedLayers: [ViewHierarchyLayer] {
        dataSource?.viewHierarchySnapshot?.populatedLayers ?? []
    }
    
    func updateLayerViews(to newValue: [ViewHierarchyReference: LayerView],
                          from oldValue: [ViewHierarchyReference: LayerView]) {
        
        let viewReferences = Set<ViewHierarchyReference>(newValue.keys)
        
        let oldViewReferences = Set<ViewHierarchyReference>(oldValue.keys)
        
        let removedReferences = oldViewReferences.subtracting(viewReferences)
        
        let newReferences = viewReferences.subtracting(oldViewReferences)
        
        removedReferences.forEach {
            guard let layerView = oldValue[$0] else {
                return
            }
            
            layerView.removeFromSuperview()
        }
        
        newReferences.forEach {
            guard
                let referenceView = $0.rootView,
                let inspectorView = newValue[$0]
            else {
                return
            }
            
            referenceView.installView(inspectorView, .autoResizingMask)
        }
    }
    
    func removeReferences(for removedLayers: Set<ViewHierarchyLayer>,
                          in oldValue: [ViewHierarchyLayer: [ViewHierarchyReference]]) {
        
        var removedReferences = [ViewHierarchyReference]()
        
        removedLayers.forEach { layer in
            Console.log("\(layer) was removed")
            
            oldValue[layer]?.forEach {
                Console.log("[Hierarchy Inspector] \(layer): removing reference to \($0.displayName)")
                removedReferences.append($0)
            }
        }
        
        for (layer, references) in visibleReferences where layer != .wireframes {
            references.forEach { reference in
                
                if let index = removedReferences.firstIndex(of: reference) {
                    Console.log("[Hierarchy Inspector] reference to \(reference.displayName) reclaimed by \(layer)")
                    
                    removedReferences.remove(at: index)
                }
            }
        }
        
        removedReferences.forEach { removedReference in
            highlightViews.removeValue(forKey: removedReference)
        }
        
        if removedLayers.contains(.wireframes) {
            wireframeViews.removeAll()
        }
    }
    
    func addReferences(for newLayers: Set<ViewHierarchyLayer>, with colorScheme: ViewHierarchyColorScheme) {
        
        for newLayer in newLayers {
            guard let references = visibleReferences[newLayer] else {
                continue
            }
            
            switch newLayer.showLabels {
            case true:
                references.forEach { viewReference in
                    guard
                        highlightViews[viewReference] == nil,
                        let element = viewReference.rootView
                    else {
                        return
                    }
                    
                    let inspectorView = HighlightView(frame: element.bounds, name: element.className, colorScheme: colorScheme, reference: viewReference)
                    inspectorView.delegate = self
                    
                    highlightViews[viewReference] = inspectorView
                }
                
            case false:
                references.forEach { viewReference in
                    guard
                        highlightViews[viewReference] == nil,
                        let element = viewReference.rootView
                    else {
                        return
                    }
                    
                    let wireframeView = WireframeView(frame: element.bounds, reference: viewReference)
                    
                    wireframeViews[viewReference] = wireframeView
                }
            }
        }
    }
    
}
