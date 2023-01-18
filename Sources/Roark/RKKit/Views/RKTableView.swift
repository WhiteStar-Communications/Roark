//
//  RKTableView.swift
//  
//
//  Created by Chris Scalcucci on 11/4/22.
//

import UIKit

open class RKTableView : UITableView {

    public func dequeue<T: RKCellViewModel, U: RKTableViewCell<T>>(_ type: U.Type, index: IndexPath, viewModel: T) -> U {
        if let dequeued = dequeueReusableCell(withIdentifier: type.CellIdentifier, for: index) as? U {
            return dequeued.setModel(viewModel)
        }

        return U.create(vm: viewModel)
    }

    public func register<T: RKCellViewModel, U: RKTableViewCell<T>>(_ cell: U.Type) {
        register(cell, forCellReuseIdentifier: cell.CellIdentifier)
    }
}
