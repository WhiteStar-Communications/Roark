//
//  AnyEquatable.swift
//
//  Created by Chris Scalcucci on 1/20/21.
//

import Foundation

public struct AnyEquatable: Equatable {
    public let value: Any
    public let equals: (Any) -> Bool

    public init<E: Equatable>(_ value: E) {
        self.value = value
        self.equals = { $0 as? E == value }
    }
}

@inlinable public func ==(lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
    return lhs.equals(rhs.value)
}

