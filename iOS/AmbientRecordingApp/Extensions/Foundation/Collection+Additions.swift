import Foundation

extension Collection {
    /// Returns an array containing the results of mapping to the given keypath over the sequence’s elements.
    func compactMap<ValueType>(_ keyPath: KeyPath<Element, ValueType?>) -> [ValueType] {
        self.compactMap {
            $0[keyPath: keyPath]
        }
    }
    /// Returns an array containing the results of mapping to the given keypath over the sequence’s elements.
    func compactMapToSet<ValueType>(_ keyPath: KeyPath<Element, ValueType?>) -> Set<ValueType> {
        Set(self.compactMap(keyPath))
    }
    /// Returns an array containing the results of mapping to the given keypath over the sequence’s elements.
    func map<ValueType>(_ keyPath: KeyPath<Element, ValueType>) -> [ValueType] {
        self.map {
            $0[keyPath: keyPath]
        }
    }
    /// Returns an array containing the results of mapping to the given keypath over the sequence’s elements.
    func mapToSet<ValueType>(_ keyPath: KeyPath<Element, ValueType>) -> Set<ValueType> {
        Set(self.map(keyPath))
    }
}
