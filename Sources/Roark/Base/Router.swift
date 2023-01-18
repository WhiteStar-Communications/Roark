//
//  Router.swift
//
//  Created by Chris Scalcucci on 1/20/21.
//

// Inspired by Coordinator pattern from Ian MacCallum
// https://hackernoon.com/coordinators-routers-and-back-buttons-c58b021b32a

import UIKit

public enum RoutingErrors: Error {
    case pushToNonNavigator
}

public protocol Routable: AnyObject, Presentable {
    var navigationController: UINavigationController { get }

    func present    (_ module: Presentable, animated: Bool)
    func push       (_ module: Presentable, animated: Bool)
    func pop        (animated: Bool)
    func dismiss    (animated: Bool)
    func setRoot    (_ module: Presentable, hideBar: Bool)
    func popToRoot  (animated: Bool)
}

final public class Router: NSObject, Routable {

    public let navigationController: UINavigationController

    public var hideBar : Bool {
        get {
            return navigationController.isNavigationBarHidden
        } set {
            navigationController.isNavigationBarHidden = newValue
        }
    }

    public init(_ navigationController: UINavigationController, _ style: UIModalPresentationStyle = .fullScreen) {
        self.navigationController = navigationController
        self.navigationController.modalPresentationStyle = style
        super.init()
        self.navigationController.delegate = self
    }

    public func presentable() -> UIViewController {
        return navigationController
    }

    public func present(_ module: Presentable, animated: Bool) {
        self.navigationController.present(module.presentable(), animated: animated)
    }

    public func push(_ module: Presentable, animated: Bool = true) {
        guard module.presentable() is UINavigationController == false else {
            return
        }

        guard module.presentable() != self.navigationController.topViewController else {
            return
        }

        self.navigationController.pushViewController(module.presentable(), animated: animated)
    }

    public func pop(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }

    public func popToRoot(animated: Bool) {
        navigationController.popToRootViewController(animated: true)
    }

    public func dismiss(animated: Bool) {
        self.navigationController.dismiss(animated: animated)
    }

    public func setRoot(_ module: Presentable, hideBar: Bool) {
        navigationController.setViewControllers([module.presentable()], animated: false)
        navigationController.isNavigationBarHidden = hideBar
    }
}

// MARK: UINavigationControllerDelegate
extension Router : UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Make sure view controller is popping
        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
              !navigationController.viewControllers.contains(poppedViewController) else {
                  return
              }
    }
}
