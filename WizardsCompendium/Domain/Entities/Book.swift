import Foundation

public struct Book: Identifiable, Equatable, Sendable {
    public let id: String
    public let title: String
    public let releaseDate: Date?
    public let summary: String?
    public let coverURL: URL?
    public let wikiURL: URL?

    public init(
        id: String,
        title: String,
        releaseDate: Date?,
        summary: String?,
        coverURL: URL?,
        wikiURL: URL?
    ) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.summary = summary
        self.coverURL = coverURL
        self.wikiURL = wikiURL
    }
}
