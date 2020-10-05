//
//  HierarchyInspectableProtocol+ActionSheetPresentation.swift
//  HierarchyInspector
//
//  Created by Pedro Almeida on 03.10.20.
//

import UIKit

public protocol HierarchyInspectorPresentable: HierarchyInspectableProtocol {
    
    var hierarchyInspectorManager: HierarchyInspector.Manager { get }
    
    var canPresentHierarchyInspector: Bool { get }
    
    func presentHierarchyInspector(animated: Bool)
    
}

public extension HierarchyInspectorPresentable {
    
    func presentHierarchyInspector(animated: Bool) {
        presentHierarchyInspector(animated: animated, inspecting: false)
    }
    
}

// MARK: - ActionSheet Presentation

extension HierarchyInspectorPresentable {
    public var canPresentHierarchyInspector: Bool {
        presentingViewController is UIAlertController == false
    }
    
    func presentHierarchyInspector(animated: Bool, inspecting: Bool) {
        guard canPresentHierarchyInspector else {
            return
        }
        
        let start = Date()
        
        hierarchyInspectorManager.asyncOperation(name: "Calculating hierarchy") { [weak self] in
            guard let self = self else {
                return
            }
            
            guard
                let alertController = self.makeAlertController(
                    with: self.hierarchyInspectorManager.availableActions,
                    in: self.hierarchyInspectorManager.viewHierarchySnapshot,
                    inspecting: inspecting
                )
            else {
                return
            }
            
            self.present(alertController, animated: true) {
                let elaspedTime = Date().timeIntervalSince(start)
                
                print("Presented Hierarchy Inspector in \(elaspedTime) seconds")
            }
        }
    }
    
    private func makeAlertController(
        with actionGroups: [HierarchyInspector.Manager.ActionGroup],
        in snapshot: ViewHierarchySnapshot?,
        inspecting: Bool
    ) -> UIAlertController? {
        guard let snapshot = snapshot else {
            return nil
        }
        
        let alertController = UIAlertController(
            title: Texts.hierarchyInspector,
            message: "\(snapshot.inspectableViewHierarchy.count) inspectable views in \(snapshot.rootReference.className)",
            preferredStyle: .alert
        ).then {
            if #available(iOS 13.0, *) {
                $0.view.tintColor = .label
            } else {
                $0.view.tintColor = .darkText
            }
        }
        
        // Close button
        alertController.addAction(
            UIAlertAction(title: Texts.closeInspector, style: .cancel, handler: nil)
        )
        
        // Manager actions
        actionGroups.forEach { group in
            group.alertActions.forEach { alertController.addAction($0) }
        }
        
        // Alert controller inspection
        if inspecting {
            alertController.hierarchyInspectorManager.installAllLayers()
        }
        
        return alertController
    }
    
}
