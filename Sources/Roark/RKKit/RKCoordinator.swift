//
//  RKCoordinator.swift
//  
//
//  Created by Chris Scalcucci on 3/21/22.
//

import UIKit
import RxSwift
import RxCocoa

open class RKCoordinator<DeepLinkType: DeepLink> : Coordinator<DeepLinkType> {

    open var activeLink : DeepLinkType?

    open private(set) var disposeBag = DisposeBag()

    open func resetDisposeBag() {
        self.disposeBag = DisposeBag()
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
