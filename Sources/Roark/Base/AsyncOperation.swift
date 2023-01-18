//
//  AsyncOperation.swift
//  
//
//  Created by Chris Scalcucci on 3/21/22.
//

import Foundation

fileprivate extension NSLock {
    func withCriticalScope<T>(_ block: () -> T) -> T {
        lock()
        let value = block()
        unlock()
        return value
    }
}

public typealias AsyncCompletion = ((AsyncOperation.State) -> Void)

open class AsyncOperation: Operation {
    public typealias StateOperationBlock = (@escaping (AsyncOperation.State) -> Void) -> Void

    public enum State: String {
        case ready = "isReady"
        case executing = "isExecuting"
        case finished = "isFinished"
    }

    /// Private storage for the `state` property that will be KVO observed.
    private var _state : State = .ready

    /// A lock to guard reads and writes to the `_state` property
    private let stateLock = NSLock()

    private var state : State {
        get {
            return stateLock.withCriticalScope({ _state })
        } set {
            let oldValue : State = self.stateLock.withCriticalScope({ _state })
            guard newValue != oldValue else { return }

            /*
             It's important to note that the KVO notifications are NOT called from inside
             the lock. If they were, the app would deadlock, because in the middle of
             calling the `didChangeValueForKey()` method, the observers try to access
             properties like "isReady" or "isFinished". Since those methods also
             acquire the lock, then we'd be stuck waiting on our own lock. It's the
             classic definition of deadlock.
             */
            willChangeValue(forKey: oldValue.rawValue)
            willChangeValue(forKey: newValue.rawValue)

            stateLock.withCriticalScope({
                guard _state != .finished else { return }

                _state = newValue
            })

            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: newValue.rawValue)
        }
    }

    public override var isReady: Bool {
        return state == .ready
    }

    public override var isExecuting: Bool {
        return state == .executing
    }

    public override var isFinished: Bool {
        let currentState = state
        if isCancelled && currentState != .executing { return true }
        return currentState == .finished
    }

    public override var isAsynchronous: Bool {
        true
    }

    public override func start() {
        guard !isCancelled else { state = .finished; return }
        main()
    }

    public override func cancel() {
        state = .finished
    }

    open var block: StateOperationBlock = { (asyncBlock: @escaping (AsyncOperation.State) -> Void) in }

    public init(block: @escaping StateOperationBlock) {
        self.block = block
        super.init()
    }

    public override init() {
        super.init()
    }

    public override func main() {
        state = .executing

        self.block({ [weak self] state in
            guard let self = self else { return }
            self.state = state
        })
    }
}
