import Foundation

public extension Decodable {
    init(from jsonObject: Any) throws {
        let data = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        try self.init(from: data)
    }

    init(from jsonData: Data) throws {
        do {
            let decoder = JSONDecoder()
            self = try decoder.decode(Self.self, from: jsonData)
        } catch {
            // Even we can use try directly because this function have throws
            // But we use do catch for debug purpose
            print("init(from jsonObject:) error: \(error)")
            throw error
        }
    }
}

public extension Encodable {
    func asDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }

        guard let dictionary = try? JSONSerialization.jsonObject(with: data,
                                                                 options: .allowFragments) as? [String: Any] else {
            return [:]
        }

        return dictionary.filter({ !($0.value is NSNull) })
    }
}
