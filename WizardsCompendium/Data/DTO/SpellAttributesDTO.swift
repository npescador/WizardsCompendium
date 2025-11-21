import Foundation

public struct SpellAttributesDTO: Decodable {
    public let name: String
    public let incantation: String?
    public let effect: String?
    public let category: String?
    public let light: String?
    public let image: String?
    public let wiki: String?
}
