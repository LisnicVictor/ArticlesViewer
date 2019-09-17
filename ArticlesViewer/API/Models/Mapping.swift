import Foundation

struct Mapping: Decodable {
    enum CodingKeys: String, CodingKey {
        case uuid, sortingOrder, sourceTags, destinationValue
    }

    let uuid: String
    let sortingOrder: Double
    let sourceTags: [String]
    let destinationValue: String
}

extension Mapping {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try values.decode(String.self, forKey: .uuid)
        sortingOrder = try values.decode(Double.self, forKey: .sortingOrder)
        sourceTags = try values.decode(String.self, forKey: .sourceTags).components(separatedBy: "||")
        destinationValue = try values.decode(String.self, forKey: .destinationValue)
    }
}
