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

extension ElementChildrenPanelViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cellViewModel = viewModel.cellViewModel(at: indexPath) else { return }

        let backgroundColor = cell.backgroundColor

        cell.backgroundColor = .none
        cell.contentView.alpha = cellViewModel.appearance.alpha
        cell.transform = cellViewModel.appearance.transform
        cell.alpha = cellViewModel.appearance.alpha

        tableView.animate(withDuration: .veryLong, delay: .short) {
            cellViewModel.animatedDisplay = false

            cell.backgroundColor = backgroundColor
            cell.contentView.alpha = cellViewModel.appearance.alpha
            cell.transform = cellViewModel.appearance.transform
            cell.alpha = cellViewModel.appearance.alpha
        }
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        viewModel.shouldHighlightItem(at: indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCellViewModel = viewModel.cellViewModel(at: indexPath) else { return }

        delegate?.elementChildrenPanelViewController(
            self,
            didSelect: selectedCellViewModel.reference,
            with: .children,
            from: viewModel.rootReference
        )
    }

    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let reference = viewModel.cellViewModel(at: indexPath)?.reference else { return nil }

        return .contextMenuConfiguration(for: reference) { [weak self] reference, action in
            guard let self = self else { return }

            self.delegate?.elementChildrenPanelViewController(
                self,
                didSelect: reference,
                with: action,
                from: self.viewModel.rootReference
            )
        }
    }
}

// MARK: - Helpers

extension ElementChildrenPanelViewController {
    func updateTableView(_ indexPath: IndexPath, with actions: [ElementInspector.ElementChildrenPanelAction]) {
        guard actions.isEmpty == false else { return }

        let tableView = viewCode.tableView

        if let cell = tableView.cellForRow(at: indexPath) as? ElementChildrenPanelTableViewCodeCell {
            cell.toggleCollapse(animated: true)
        }

        tableView.performBatchUpdates {
            actions.forEach {
                switch $0 {
                case let .inserted(indexPaths):
                    indexPaths.forEach {
                        self.viewModel.cellViewModel(at: $0)?.animatedDisplay = true
                    }
                    tableView.insertRows(at: indexPaths, with: .top)

                case let .deleted(indexPaths):
                    let cells = indexPaths.compactMap { tableView.cellForRow(at: $0) }

                    tableView.animate {
                        cells.forEach{
                            $0.contentView.alpha = 0
                            $0.transform = ElementInspector.appearance.panelInitialTransform
                            $0.backgroundColor = .none
                        }
                    }

                    tableView.deleteRows(at: indexPaths, with: .top)
                }
            }
        } completion: { [weak self] _ in
            self?.updateVisibleRowsBackgroundColor()
        }
    }

    func updateVisibleRowsBackgroundColor(_ completion: ((Bool) -> Void)? = nil) {
        UIView.animate(
            withDuration: .average,
            animations: { [weak self] in

                self?.viewCode.tableView.indexPathsForVisibleRows?.forEach { indexPath in
                    guard let cell = self?.viewCode.tableView.cellForRow(at: indexPath) as? ElementChildrenPanelTableViewCodeCell else {
                        return
                    }

                    cell.isEvenRow = indexPath.row % 2 == 0
                }

            },
            completion: completion
        )
    }
}
