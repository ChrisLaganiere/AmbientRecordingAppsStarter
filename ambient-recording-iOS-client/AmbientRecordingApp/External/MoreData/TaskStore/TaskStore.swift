import Foundation

/**
 # TaskStore
 Container for ongoing tasks, with configurable behavior. Use this to store tasks indexed by key.

 It can be easy to make mistakes storing tasks, so this helper implements common patterns for you!
 */
actor TaskStore<TaskKey: Hashable, ResultType> {

    /// Configurable options
    enum Behavior {
        /// Run only the first task provided for a task key, and keep its result forever.
        /// Subsequent `perform()` calls will always get the same result.
        case awaitFirstResult
        /// If another task is already ongoing for the same task key, just await the already-
        /// running task, and ignore repeated calls while it is still running.
        /// If there has been no previous task, or previous task already finished, then spawn
        /// a new task.
        case awaitNextResult
        /// Immediately cancel and replace any ongoing tasks, failing them with cancellation error,
        /// and replace with a new task.
        case cancelAndReplace
    }

    /// Configuration
    let behavior: Behavior

    /// Ongoing tasks
    private var tasks: [TaskKey: Task<ResultType, Error>] = [:]

    init(behavior: Behavior) {
        self.behavior = behavior
    }

    /// Cancel ongoing operation
    func cancel(for key: TaskKey) {
        tasks[key]?.cancel()

        if behavior != .awaitFirstResult {
            tasks[key] = nil
        }
    }

    /// Enqueue a task with an identifier key
    @discardableResult
    func enqueue(
        for key: TaskKey,
        block: @escaping () async throws -> ResultType
    ) -> Task<ResultType, Error> {
        if let existing = tasks[key] {
            switch behavior {
            case .awaitNextResult,
                 .awaitFirstResult:
                return existing
            case .cancelAndReplace:
                existing.cancel()
            }
        }

        let task = Task {
            defer {
                if behavior == .awaitNextResult {
                    tasks[key] = nil
                }
            }

            try Task.checkCancellation()
            return try await block()
        }

        tasks[key] = task
        return task
    }

    /// Get ongoing task, if any
    func task(for key: TaskKey) -> Task<ResultType, Error>? {
        tasks[key]
    }
}
