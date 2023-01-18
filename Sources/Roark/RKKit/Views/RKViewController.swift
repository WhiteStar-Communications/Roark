//
//  RKViewController.swift
//  
//
//  Created by Chris Scalcucci on 3/21/22.
//

import UIKit
import RxSwift
import RxCocoa

open class RKViewController<VM: RKViewModel> : UIViewController,
                                               RKNavigationControllerDelegate {

    //
    // MARK: Life Cycle Properties
    //

    open var viewModel : VM!

    open private(set) var disposeBag = DisposeBag()

    open func resetDisposeBag() {
        self.disposeBag = DisposeBag()
    }

    //
    // MARK: Creation
    //

    open class func storyboardID() -> String {
        preconditionFailure("SocietyViewController.storyboardID() must be overriden.")
    }

    open class func storyboardName() -> String {
        preconditionFailure("SocietyViewController.storyboardID() must be overriden.")
    }

    open class func create<T: RKViewController>(vm: VM) -> T {
        let vc = T()
        vc.setModel(vm)
        return vc
    }

    open class func `init`(vm: VM) -> Self {
        let vc = self.instantiateFromStoryboard(
            storyboardName : self.storyboardName(),
            storyboardId   : self.storyboardID())

        vc.setModel(vm)
        return vc
    }

    open func setModel(_ vm: VM) {
        _ = self
        self.viewModel = vm
        setupViews()
        setupViewBindings()
    }

    //
    // MARK: LifeCycle
    //

    open func shouldPopController() -> Bool {
        return true
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        (self.navigationController as? RKNavigationController)?.roarkNavigationDelegate = self
    }

    @objc open func setupViewBindings() {

    }

    @objc open func setupViews() {

    }

    //
    // MARK: Key Bindings
    //

    open var keyCommand = PublishSubject<UIKeyCommand>()

    private var keySelectors = [UIKeyCommand:Selector]()

    open override var canBecomeFirstResponder: Bool {
        return true
    }

    public final func addKeyCommands(_ keyCommands: [UIKeyCommand]) {
        keyCommands.forEach({
            self.addKeyCommand($0)
        })
    }

    public final override func addKeyCommand(_ keyCommand: UIKeyCommand) {
        guard let input = keyCommand.input else { return }
        let interceptedCommand = UIKeyCommand(input: input,
                                              modifierFlags: keyCommand.modifierFlags,
                                              action: #selector(processKey))
        self.keySelectors[interceptedCommand] = keyCommand.action
        super.addKeyCommand(interceptedCommand)
    }

    public final override func removeKeyCommand(_ keyCommand: UIKeyCommand) {
        guard let input = keyCommand.input else { return }
        let interceptedCommand = UIKeyCommand(input: input,
                                              modifierFlags: keyCommand.modifierFlags,
                                              action: #selector(processKey))
        self.keySelectors.removeValue(forKey: interceptedCommand)
        super.removeKeyCommand(interceptedCommand)
    }

    @objc open func emptySelector() {
    }

    @objc open func processKey(_ command: UIKeyCommand) {
        self.keyCommand.onNext(command)

        if let selector = keySelectors[command] {
            perform(selector)
        }
    }

}

extension RKViewController {
    open class func instantiateFromStoryboard(storyboardName: String, storyboardId: String) -> Self {
        return instantiateFromStoryboardHelper(storyboardName: storyboardName, storyboardId: storyboardId)
    }

    private class func instantiateFromStoryboardHelper<T>(storyboardName: String, storyboardId: String) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        return controller
    }
}
