//
//  Coordinator.swift
//
//  Created by Chris Scalcucci on 1/20/21.
//

// Inspired by Coordinator pattern from Ian MacCallum
// https://hackernoon.com/coordinators-routers-and-back-buttons-c58b021b32a

import UIKit

public protocol Coordinatable: AnyObject {
    associatedtype DeepLinkType

    func start()
    func start(with link: DeepLinkType?)
    func popToRoot(_ animated: Bool)
}

public protocol PresentableCoordinatable: Coordinatable, Presentable {}

open class PresentableCoordinator<DeepLinkType>: NSObject, PresentableCoordinatable {

    public override init() {
        super.init()
    }

    open func start() { start(with: nil) }
    open func start(with link: DeepLinkType?) {}

    open func process(_ link: DeepLinkType?, _ parameters: [String:Any]? = nil) {}

    open func presentable() -> UIViewController {
        preconditionFailure("Must override toPresentable()")
    }

    open func popToRoot(_ animated: Bool) {}
}

open class Coordinator<DeepLinkType>: PresentableCoordinator<DeepLinkType> {

    public var childCoordinators: [Coordinator<DeepLinkType>] = []
    open var router: Router

    public init(router: Router = Router(UINavigationController())) {
        self.router = router
        super.init()
    }

    public func addChild(_ coordinator: Coordinator<DeepLinkType>) {
        if let _ = childCoordinators.firstIndex(of: coordinator) {
            return
        }
        childCoordinators.append(coordinator)
    }

    public func removeChild(_ coordinator: Coordinator<DeepLinkType>) {
        guard let index = childCoordinators.firstIndex(of: coordinator) else {
            return
        }
        childCoordinators.remove(at: index)
    }

    // Make this function open to override it in a different module
    open override func presentable() -> UIViewController {
        return router.presentable()
    }

    open override func popToRoot(_ animated: Bool) {
        // Pop all view controllers off the stack
        self.router.popToRoot(animated: animated)

        // Remove all children
        Array(self.childCoordinators).forEach({
            $0.popToRoot(animated)
            self.removeChild($0)
        })
    }
}

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Child coordinators can represent either vertical or horizontal flows.

 Coordinators that are PRESENTED are vertical flows. Upon completion
 it is dismissed and deallocated.

 Example of a vertical flow would be login that is presented modally
 and completes when the process is cancelled or user is logged in.

 Coordinators that are PUSHED to are horizontal flows. Upon completion
 (due to action or back button) will be popped from the navigation
 controller stack and deallocated.

 Horizontal flows have a shared navigation controller between the parent
 and child.

 Example would be an account page where there are many other sub flows so
 a new account view controller can't just be instantiated over and over.
 This allows it to be a reusable coordinator that can be pushed to.

 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Coordinator implements Presentable so Router can present it.
 Default implementation will return the Router's presentable
 which is just the underlying navigation controller. Perfect
 for PRESENTING a coordinator for a new vertical flow.

 This does not allow the coordinator to be PUSHED for a horizontal
 flow. To do so, one must override presentable() to give a new
 view controller instance that will work when calling router.push(coordinator)

 This is why in Router's push() function, it's guarded to ensure
 the view controller being pushed isn't a UINavigationController.

 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

/*              Example of a Horizontal Push Flow & Coordinator                      */
/*
 fileprivate class AccountCoordinator: Coordinator<DeepLink> {

 lazy var viewController: UIViewController = {
 return UIViewController()
 }()

 open override func start() {}

 open override func presentable() -> UIViewController {
 return viewController
 }
 }
 */

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
/*        Allows for child coordinator to be pushed from parent coordinator
 and deallocated easily                                      */
/*
 fileprivate extension Coordinator {
 func examplePush() {
 let coordinator : Coordinator<DeepLinkType> = AccountCoordinator(router: self.router) as! Coordinator<DeepLinkType>

 addChild(coordinator)

 //        router.push(coordinator)
 //            .then({ [weak self, weak coordinator] in
 //                // Executes when the back button is pressed
 //                if let parent = self, let child = coordinator {
 //                    parent.removeChild(child)
 //                }
 //            })
 coordinator.start()
 }
 }
 */

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */


//open class ProfileCoordinator: Coordinator {
//    fileprivate let store: StoreType
//    fileprivate let profile: Profile
//
//    lazy var viewController: ProfileViewController = {
//        return ProfileViewController()
//    }()
//
//    public init(router: RouterType, store: StoreType, profile: Profile) {
//        self.store = store
//        self.profile = profile
//        super.init(router: router)
//    }
//
//    open override func start {}
//
//    open override func presentable() -> UIViewController {
//        return viewController
//}

