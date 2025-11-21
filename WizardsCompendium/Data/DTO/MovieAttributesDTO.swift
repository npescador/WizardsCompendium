import Foundation

public struct MovieAttributesDTO: Decodable {
    public let title: String
    public let summary: String?
    public let releaseDate: Date?
    public let poster: String?
    public let wiki: String?

    enum CodingKeys: String, CodingKey {
        case title
        case summary
        case releaseDate = "release_date"
        case poster
        case wiki
    }
}
