import Foundation

extension Decodable {
    static func result(jsonData: Data, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase) -> Result<Self, Error> {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = keyDecodingStrategy
        do {
            let model = try jsonDecoder.decode(Self.self, from: jsonData)
            return .success(model)
        } catch {
            return .failure(error)
        }
    }
}
