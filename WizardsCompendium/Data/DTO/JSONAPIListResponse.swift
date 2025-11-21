import Foundation

public struct JSONAPIListResponse<Attributes: Decodable>: Decodable {
    public struct Item: Decodable {
        public let id: String
        public let attributes: Attributes
    }

    public let data: [Item]
}
