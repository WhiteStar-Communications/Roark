//
//  RKCoordinator.swift
//  
//
//  Created by Chris Scalcucci on 3/21/22.
//

import UIKit
import Combine

open class RKCoordinator<DeepLinkType: DeepLink> : Coordinator<DeepLinkType> {

    open var activeLink : DeepLinkType?

    open var cancellables = Set<AnyCancellable>()

    open func resetCancellables() {
        self.cancellables.removeAll()
    }

    public override init(router: Router = Router(RKNavigationController())) {
        super.init(router: router)
    }

    open class func newRouter() -> Router {
        return Router(RKNavigationController())
    }

    open func newRouter() -> Router {
        return Router(RKNavigationController())
    }
}
