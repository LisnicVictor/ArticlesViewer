import Foundation

struct Article: Decodable {
    let uuid: String
    let sortingOrder: Double
    let name: String
    let tags: [String]
}
