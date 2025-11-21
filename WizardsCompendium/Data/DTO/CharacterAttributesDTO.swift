import Foundation

public struct CharacterAttributesDTO: Decodable {
    public let name: String
    public let house: String?
    public let species: String?
    public let patronus: String?
    public let image: String?
    public let titles: [String]?
    public let jobs: [String]?
    public let romances: [String]?
    public let wiki: String?
}
