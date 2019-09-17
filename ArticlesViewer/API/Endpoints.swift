import Foundation

enum Endpoints {
    static let source: URL = URL(string: "http://challenge.fashionexchange.nl:80/api")!
    static let articles: URL = source.appendingPathComponent("articles")
    static let mappingSets: URL = source.appendingPathComponent("mappingsets")

    static func mapping(with uuid: String) -> URL {
        return mappingSets.appendingPathComponent(uuid).appendingPathComponent("mappings")
    }
}
