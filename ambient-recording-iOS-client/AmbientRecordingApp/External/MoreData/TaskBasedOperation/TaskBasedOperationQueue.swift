import Combine

/**
 # TaskBasedOperationQueue

 Queue for task-based operations, with configurable options.
 */
actor TaskBasedOperationQueue<OperationType: TaskBasedOperation> where OperationType: Hashable {

    /// The maximum number of queued operations that can run at the same time.
    /// Value of `0` means unbounded.
    let maxConcurrentOperationCount: Int

    /// Ongoing task-based operations
    private(set) var operations: [OperationType] = []

    // MARK: Private Properties

    /// Operations which are ready to start, but must wait for some existing operations to finish first.
    private var enqueuedOperations: [OperationType] = []

    /// Operations which are ready to start, but must wait for some existing operations to finish first.
    private var runningOperations: [OperationType] = []

    // MARK: Methods

    /// - Parameters:
    ///   - maxConcurrentOperationCount: maximum number of queued operations that can run at the same time
    init(maxConcurrentOperationCount: Int = 0) {
        self.maxConcurrentOperationCount = maxConcurrentOperationCount
    }

    /// Add an operation to the queue
    func add(_ operation: OperationType) {
        if runningOperations.count >= maxConcurrentOperationCount {
            enqueue(operation)
        }
        else {
            start(operation)
        }
        operations.append(operation)
    }

    /// Add a pending operation to the queue
    private func enqueue(_ operation: OperationType) {
        enqueuedOperations.append(operation)
    }

    /// Start a pending operation
    private func start(_ operation: OperationType) {
        runningOperations.append(operation)
        Task { [weak self] in
            _ = try await operation.execute()
            guard let self else {
                return
            }
            await self.handleFinish(of: operation)
        }
    }

    private func handleFinish(of operation: OperationType) {
        runningOperations.removeFirst(operation)
        operations.removeFirst(operation)
        // could add prioritization here
        if let next = enqueuedOperations.first {
            enqueuedOperations.removeFirst(next)
            start(next)
        }
    }
}

extension Array where Element: Equatable {
    /// Remove first instance of an element
    mutating func removeFirst(_ element: Element) {
        guard let index = firstIndex(where: { item in
            item == element
        }) else {
            return
        }
        remove(at: index)
    }
}
