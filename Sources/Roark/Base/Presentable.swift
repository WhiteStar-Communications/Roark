//
//  Presentable.swift
//
//  Created by Chris Scalcucci on 1/20/21.
//

// Inspired by Coordinator pattern from Ian MacCallum
// https://hackernoon.com/coordinators-routers-and-back-buttons-c58b021b32a

import UIKit

public protocol Presentable {
    func presentable() -> UIViewController
}

extension UIViewController: Presentable {
    public func presentable() -> UIViewController {
        return self
    }
}
