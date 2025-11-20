import Foundation

public struct Character: Identifiable, Equatable, Sendable {
    public let id: String
    public let name: String
    public let house: String?
    public let species: String?
    public let patronus: String?
    public let imageURL: URL?
    public let titles: [String]
    public let jobs: [String]
    public let romances: [String]
    public let wikiURL: URL?

    public init(
        id: String,
        name: String,
        house: String?,
        species: String?,
        patronus: String?,
        imageURL: URL?,
        titles: [String],
        jobs: [String],
        romances: [String],
        wikiURL: URL?
    ) {
        self.id = id
        self.name = name
        self.house = house
        self.species = species
        self.patronus = patronus
        self.imageURL = imageURL
        self.titles = titles
        self.jobs = jobs
        self.romances = romances
        self.wikiURL = wikiURL
    }
}
