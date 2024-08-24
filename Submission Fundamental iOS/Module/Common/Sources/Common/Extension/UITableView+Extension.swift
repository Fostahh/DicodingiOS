//
//  UITableView+Extension.swift
//
//
//  Created by Mohammaad Azri Khairuddin on 25/08/24.
//

import UIKit

public extension UITableView {
    
    func registerCellNib<Cell: UITableViewCell>(_ cellClass: Cell.Type, module: String) {
        let identifier = String(describing: cellClass)
        let nib = UINib(nibName: identifier, bundle: .resourceBundle(for: `cellClass`.self, moduleName: module))
        register(nib, forCellReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<Cell: UITableViewCell>(forIndexPath indexPath: IndexPath) -> Cell {
        let identifier = String(describing: Cell.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("Error for cell if: \(identifier) at \(indexPath)")
        }
        return cell
    }
    
}
