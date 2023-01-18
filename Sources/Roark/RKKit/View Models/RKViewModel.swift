//
//  RKViewModel.swift
//  
//
//  Created by Chris Scalcucci on 1/14/21.
//

import Foundation
import Combine

open class RKViewModel : ViewModel,
                         IdentifiableType {
    public typealias Identity = Int

    //
    // MARK: Properties
    //

    open var identity : Int = UUID().hashValue

    open var cancellables = Set<AnyCancellable>()

    //
    // MARK: Synchronization
    //

    private lazy var operationQueue : OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    open func setQueueName(_ queueName: String) {
        let operation = AsyncOperation { (asyncOperation: @escaping (AsyncOperation.State) -> Void) in
            Thread.current.name = queueName
            asyncOperation(.finished)
        }
        operation.name = "Set Thread Name"
        operationQueue.addOperation(operation)
    }

    //
    // MARK: Updates
    //

    open func cancelAllOperations() {
        operationQueue.cancelAllOperations()
    }

    open func executeInSerialContext(_ asyncCompletion: AsyncCompletion? = nil,
                                     _ name: String? = nil,
                                     _ execute: @escaping (@escaping AsyncCompletion) -> ()) {
        if let asyncCompletion = asyncCompletion {
            execute(asyncCompletion)
        } else {
            let operation = AsyncOperation { (asyncOperation: @escaping (AsyncOperation.State) -> Void) in
                execute(asyncOperation)
            }
            operation.name = name ?? "Unknown"
            operationQueue.addOperation(operation)
        }
    }

    open func executeInGlobalContext(qos: DispatchQoS.QoSClass = .default,
                                     _ fn: @escaping () -> Void) {
        DispatchQueue.global(qos: qos).async {
            fn()
        }
    }

    //
    // MARK: Hashable & Equatable
    //

    @inlinable
    public static func ==(lhs: RKViewModel, rhs: RKViewModel) -> Bool {
        return lhs.identity == rhs.identity
    }

    open override var hash: Int {
        return identity
    }

    open override func isEqual(_ object: Any?) -> Bool {
        if let other = object as? RKViewModel {
            return self.identity == other.identity
        } else {
            return false
        }
    }
}
