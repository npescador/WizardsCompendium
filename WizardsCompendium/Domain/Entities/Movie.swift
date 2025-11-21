import Foundation

public struct Movie: Identifiable, Equatable, Sendable {
    public let id: String
    public let title: String
    public let releaseDate: Date?
    public let summary: String?
    public let posterURL: URL?
    public let wikiURL: URL?

    public init(
        id: String,
        title: String,
        releaseDate: Date?,
        summary: String?,
        posterURL: URL?,
        wikiURL: URL?
    ) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.summary = summary
        self.posterURL = posterURL
        self.wikiURL = wikiURL
    }
}
