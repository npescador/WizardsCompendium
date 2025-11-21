import Foundation

public struct BookAttributesDTO: Decodable {
    public let title: String
    public let summary: String?
    public let releaseDate: Date?
    public let cover: String?
    public let wiki: String?

    enum CodingKeys: String, CodingKey {
        case title
        case summary
        case releaseDate = "release_date"
        case cover
        case wiki
    }
}
