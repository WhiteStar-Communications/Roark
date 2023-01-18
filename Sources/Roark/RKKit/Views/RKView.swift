//
//  RKView.swift
//  
//
//  Created by Chris Scalcucci on 3/21/22.
//

import UIKit
import RxSwift
import RxCocoa

open class RKView<VM: RKViewModel> : UIView {

    //
    // MARK: Life Cycle Properties
    //
    
    open private(set) var viewModel : VM? {
        didSet {
            if let _ = viewModel {
                setupViewBindings()
            } else {
                disposeBag = DisposeBag()
            }
        }
    }

    open private(set) var disposeBag = DisposeBag()

    open func resetDisposeBag() {
        self.disposeBag = DisposeBag()
    }

    //
    // MARK: Creation
    //

    open class func create<T: RKView>(vm: VM) -> T {
        let v = T()
        v.setModel(vm)
        return v
    }

    open func setModel(_ vm: VM) {
        _ = self
        self.viewModel = vm
    }

    open func detachModel() {
        _ = self
        self.viewModel = nil
    }

    //
    // MARK: LifeCycle
    //

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    open func commonInit() {

    }

    open func setupViewBindings() {

    }
}


