//
//  IdentifiableType.swift
//  
//
//  Created by Chris Scalcucci on 12/15/22.
//

import Foundation

public protocol IdentifiableType {
    associatedtype Identity: Hashable

    var identity : Identity { get }
}
