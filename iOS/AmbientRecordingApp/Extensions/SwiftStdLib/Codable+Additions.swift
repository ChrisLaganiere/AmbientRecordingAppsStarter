import Foundation

extension Encodable {
    /// Converts any type that conforms to Encodable (Codable) as JSON `Data`.
    /// Note: for consistent results, we use a sorted JSON encoder.
    var asSortedJSONData: Data? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .sortedKeys
            return try encoder.encode(self)
        }
        catch {
            print("Failed to encode JSON: \(error)")
            return nil
        }
    }
}

extension Decodable {
    /// Decodes any type that conforms to Decodable (Codable) from JSON `Data`
    static func fromJSONData(_ data: Data?) -> Self? {
        guard let data else {
            return nil
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Self.self, from: data)
        }
        catch {
            print("Failed to decode JSON: \(error)")
            return nil
        }
    }
}
