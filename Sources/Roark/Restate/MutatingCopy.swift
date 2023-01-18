//
//  MutatingCopy.swift
//
//  Created by Chris Scalcucci on 1/20/21.
//

import Foundation

protocol MutatingCopy {}

extension MutatingCopy {
    func mutate(fn: (inout Self) -> Void) -> Self {
        var a = self
        fn(&a)
        return a
    }
}
