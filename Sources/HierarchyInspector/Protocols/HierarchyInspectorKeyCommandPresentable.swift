//
//  HierarchyInspectorKeyCommandPresentable.swift
//  HierarchyInspector
//
//  Created by Pedro Almeida on 03.10.20.
//

import UIKit

public protocol HierarchyInspectorKeyCommandPresentable: UIViewController {
    
    var hirearchyInspectorKeyCommandsSelector: Selector { get }
    
    var hierarchyInspectorKeyCommands: [UIKeyCommand] { get }
    
    var hierarchyInspectorLayerToggleModifierFlags: UIKeyModifierFlags { get }
    
    var hierarchyInspectorPresentationKeyCommandOptions: UIKeyCommand.Options { get }
}

public extension HierarchyInspector.Manager {
    
    private var keyCommandSettings: HierarchyInspector.Configuration.KeyCommandSettings {
        HierarchyInspector.configuration.keyCommands
    }
    
    /// Interprets key commands into HierarchyInspector actions.
    /// - Parameter sender: (Any) If sender is not of `UIKeyCommand` type methods does nothing.
    func hierarchyInspectorKeyCommandHandler(_ sender: Any) {
        guard let keyCommand = sender as? UIKeyCommand else {
            return
        }
        
        let flattenedActions = availableActionsForKeyCommand.flatMap { $0.actions }
        
        for action in flattenedActions where action.title == keyCommand.discoverabilityTitle {
            action.closure?()
            return
        }
    }
    
    func hierarchyInspectorKeyCommands(selector aSelector: Selector) -> [UIKeyCommand] {
        var keyCommands = [UIKeyCommand]()
        
        var index = keyCommandSettings.layerToggleInputRange.lowerBound
        
        for actionGroup in availableActionsForKeyCommand {
            
            for action in actionGroup.actions {
                
                switch action {
                case .emptyLayer:
                    continue
                    
                case .openHierarchyInspector:
                    keyCommands.append(
                        UIKeyCommand(
                            keyCommandSettings.presentationOptions,
                            action: aSelector
                        )
                    )
                    
                case .showAllLayers,
                     .hideVisibleLayers:
                    keyCommands.append(
                        UIKeyCommand(
                            input: keyCommandSettings.allLayersToggleInput,
                            modifierFlags: keyCommandSettings.layerToggleModifierFlags,
                            action: aSelector,
                            discoverabilityTitle: action.title
                        )
                    )
                    
                case .hideLayer,
                     .showLayer:
                    
                    guard keyCommandSettings.layerToggleInputRange.contains(index) else {
                        break
                    }
                    
                    keyCommands.append(
                        UIKeyCommand(
                            input: String(index),
                            modifierFlags: keyCommandSettings.layerToggleModifierFlags,
                            action: aSelector,
                            discoverabilityTitle: action.title
                        )
                    )
                    
                    index += 1
                }
                
            }
            
        }
        
        return keyCommands.sortedByInputKey()
    }
    
}
// MARK: - KeyCommands

extension HierarchyInspectorKeyCommandPresentable {
    
    private var keyCommandSettings: HierarchyInspector.Configuration.KeyCommandSettings {
        HierarchyInspector.configuration.keyCommands
    }
    
    public var hierarchyInspectorLayerToggleModifierFlags: UIKeyModifierFlags {
        keyCommandSettings.layerToggleModifierFlags
    }
    
    public var hierarchyInspectorPresentationKeyCommandOptions: UIKeyCommand.Options {
        keyCommandSettings.presentationOptions
    }
    
    public var hierarchyInspectorKeyCommands: [UIKeyCommand] {
        guard let hierarchyInspectorManager = hierarchyInspectorManager else {
            return []
        }
        
        let aSelector = hirearchyInspectorKeyCommandsSelector
        
        return hierarchyInspectorManager.hierarchyInspectorKeyCommands(selector: aSelector)
    }
    
    /// Interprets key commands into HierarchyInspector actions.
    /// - Parameter sender: (Any) If sender is not of `UIKeyCommand` type methods does nothing.
    public func hierarchyInspectorKeyCommandHandler(_ sender: Any) {
        guard
            let keyCommand = sender as? UIKeyCommand,
            let hierarchyInspectorManager = hierarchyInspectorManager
        else {
            return
        }
        
        let flattenedActions = hierarchyInspectorManager.availableActionsForKeyCommand.flatMap { $0.actions }
        
        for action in flattenedActions where action.title == keyCommand.discoverabilityTitle {
            action.closure?()
            return
        }
    
    }
    
}

extension HierarchyInspector.Manager {
    
    var availableActionsForKeyCommand: ActionGroups {
        var array = availableActionGroups
        
        let openInspectorGroup = ActionGroup(
            title: nil,
            actions: [
                .openHierarchyInspector(from: host)
            ]
        )
        
        array.insert(openInspectorGroup, at: 0)
        
        return array
    }
    
}

private extension Array where Element == UIKeyCommand {
    func sortedByInputKey() -> Self {
        var copy = self
        copy.sort { lhs, rhs -> Bool in
            guard
                let lhsInput = lhs.input,
                let rhsInput = rhs.input
            else {
                return true
            }
            
            return lhsInput < rhsInput
        }
        
        return copy
    }
}
