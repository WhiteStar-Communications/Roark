//
//  RKNavigationController.swift
//  
//
//  Created by Chris Scalcucci on 3/21/22.
//

import UIKit

public protocol RKNavigationControllerDelegate : AnyObject {
    func shouldPopController() -> Bool
}

open class RKNavigationController : UINavigationController, UINavigationBarDelegate {
    weak var roarkNavigationDelegate : RKNavigationControllerDelegate?

    open func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        return roarkNavigationDelegate?.shouldPopController() ?? true
    }
}
