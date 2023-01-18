//
//  RKViewModelSection.swift
//  
//
//  Created by Chris Scalcucci on 11/4/22.
//

import Foundation

public struct RKViewModelSection :  Equatable, Hashable {
    public typealias Item = RKCellViewModel
    public typealias Identity = String

    public var identity : String

    public var items : [Item]

    public init(identity: String, items: [Item]) {
        self.identity = identity
        self.items = items
    }

    public init(original: RKViewModelSection, items: [Item]) {
        self = original
        self.items = items
    }

    @inlinable
    public static func ==(lhs: RKViewModelSection, rhs: RKViewModelSection) -> Bool {
        return lhs.identity == rhs.identity
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(identity)
    }
}
