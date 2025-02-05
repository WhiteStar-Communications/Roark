
//
//  RKSwiftUIViewController.swift
//
//
//  Created by Logan Miller on 9/19/24.
//

import UIKit
import SwiftUI
import Combine

open class RKSwiftUIViewController<V: RKSwiftUIView> : UIViewController,
                                                       RKNavigationControllerDelegate {

    //
    // MARK: Life Cycle Properties
    //    
    open var hostingController: UIHostingController<V>!
    
    open var baseView: V!
    
    open var cancellables = Set<AnyCancellable>()
    
    open func resetCancellables() {
        self.cancellables.removeAll()
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

    open class func create<T: RKSwiftUIViewController>(view: V,
                                                       isModal: Bool = false) -> T {
        let vc = T()
        vc.setView(view, isModal)
        return vc
    }
    
    open func setView(_ view: V,
                      _ isModal: Bool) {
        _ = self
        let hostingController = UIHostingController(rootView: view)
        addChild(hostingController)
        isModalInPresentation = isModal
        self.view.addSubview(hostingController.view)
        hostingController.view.frame = self.view.bounds
        hostingController.didMove(toParent: self)
        self.hostingController = hostingController
        self.baseView = view
        
        // Register for orientation changes
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationDidChange),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
    }
    
    @objc open func orientationDidChange() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25,
                                      execute: { [weak self] in
            guard let self = self else { return }            
            // Adjust the hosting controller's view frame
            self.hostingController?.view.frame = self.view.bounds
        })
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

    open var keyCommand = PassthroughSubject<UIKeyCommand, Never>()

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
        self.keyCommand.send(command)

        if let selector = keySelectors[command] {
            perform(selector)
        }
    }

}

