//
//  RKCollectionViewCell.swift
//  
//
//  Created by Chris Scalcucci on 11/4/22.
//

import UIKit
import RxSwift
import RxCocoa

open class RKCollectionViewCell<VM: RKCellViewModel> : UICollectionViewCell {
    class var CellIdentifier : String {
        return String(describing: self)
    }

    //
    // MARK: Life Cycle Properties
    //

    open var viewModel : VM?

    private var completedInitialSetup : Bool = false

    public var disposeBag = DisposeBag()

    //
    // MARK: Creation
    //

    open class func create<T: RKCollectionViewCell>(vm: VM) -> T {
        let vc = T()
        vc.setModel(vm)
        return vc
    }

    open class func `init`(vm: VM) -> Self {
        let cell = self.init()
        cell.setModel(vm)
        return cell
    }

    @discardableResult
    open func setModel(_ vm: VM?) -> Self {
        _ = self

        // We have no view model
        if self.viewModel == nil {
            // And are now setting one
            if vm != nil {
                self.viewModel = vm

                // Have we setup our views yet?
                if !self.completedInitialSetup {
                    self.completedInitialSetup = true
                    setupViews()
                }

                setupViewBindings()
            }
        } else if vm == nil {
            // Remove all bindings
            self.disposeBag = DisposeBag()
            self.viewModel = nil
        } else if vm != self.viewModel {
            // Someone forgot to prepare for reuse, we are setting over with a new VM
            self.viewModel = vm
            setupViewBindings()
        }

        return self
    }

    //
    // MARK: LifeCycle
    //

    @objc open func setupViewBindings() {

    }

    @objc open func setupViews() {

    }

    open override func prepareForReuse() {
        super.prepareForReuse()

        self.setModel(nil)
    }
}
