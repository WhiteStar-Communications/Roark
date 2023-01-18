//
//  RKCollectionView.swift
//  
//
//  Created by Chris Scalcucci on 11/4/22.
//

import UIKit

open class RKCollectionView : UICollectionView {

    public func dequeue<T: RKCellViewModel, U: RKCollectionViewCell<T>>(_ type: U.Type, index: IndexPath, viewModel: T) -> U {
        if let dequeued = dequeueReusableCell(withReuseIdentifier: type.CellIdentifier, for: index) as? U {
            return dequeued.setModel(viewModel)
        }

        return U.create(vm: viewModel)
    }

    public func register<T: RKCellViewModel, U: RKCollectionViewCell<T>>(_ cell: U.Type) {
        register(cell, forCellWithReuseIdentifier: cell.CellIdentifier)
    }
}
