import Combine

/**
 # TaskBasedOperation
 */
protocol TaskBasedOperation: Actor {
    associatedtype SuccessType
    var internalTask: OperationTask<SuccessType, any Error> { get }
    func main() async throws -> SuccessType
}

// MARK: - API

extension TaskBasedOperation {

    typealias TaskType = Task<SuccessType, any Error>

    var task: TaskType {
        start()
    }

    func execute() async throws -> SuccessType {
        try await start().value
    }

    @discardableResult
    func start() -> TaskType {
        if let task = internalTask.task {
            return task
        }

        let task = Task {
            try Task.checkCancellation()
            return try await main()
        }

        self.internalTask.task = task
        AnyCancellable(task.cancel)
            .store(in: &self.internalTask.subscriptions)
        return task
    }

    func cancel() {
        task.cancel()
    }
}

// MARK: - Definitions

class OperationTask<SuccessType, ErrorType: Error> {
    fileprivate var task: Task<SuccessType, ErrorType>?
    fileprivate var subscriptions: Set<AnyCancellable> = []
}
