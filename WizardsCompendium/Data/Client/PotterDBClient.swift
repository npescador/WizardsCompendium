import Foundation

public struct PotterDBClient {
    public enum ClientError: Error {
        case invalidURL
    }

    private let base = URL(string: "https://api.potterdb.com/v1")!
    private let session: URLSession
    private let decoder: JSONDecoder

    public init(
        session: URLSession = .shared,
        decoder: JSONDecoder = PotterDBClient.defaultDecoder
    ) {
        self.session = session
        self.decoder = decoder
    }

    public func get<T: Decodable>(
        _ path: String,
        query: [URLQueryItem] = []
    ) async throws -> T {
        guard var components = URLComponents(
            url: base.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        ) else {
            throw ClientError.invalidURL
        }
        components.queryItems = query.isEmpty ? nil : query
        guard let url = components.url else { throw ClientError.invalidURL }

        let (data, _) = try await session.data(from: url)
        return try decoder.decode(T.self, from: data)
    }
}

public extension PotterDBClient {
    static var defaultDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601WithFallback
        return decoder
    }
}
