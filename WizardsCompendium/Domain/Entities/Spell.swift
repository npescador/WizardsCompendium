import Foundation

public struct Spell: Identifiable, Equatable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let incantation: String?
    public let effect: String?
    public let category: String?
    public let light: String?
    public let imageURL: URL?
    public let wikiURL: URL?

    public init(
        id: String,
        name: String,
        incantation: String?,
        effect: String?,
        category: String?,
        light: String?,
        imageURL: URL?,
        wikiURL: URL?
    ) {
        self.id = id
        self.name = name
        self.incantation = incantation
        self.effect = effect
        self.category = category
        self.light = light
        self.imageURL = imageURL
        self.wikiURL = wikiURL
    }
}
