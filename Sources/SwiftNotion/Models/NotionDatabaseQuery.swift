//
//  NotionDatabaseQuery.swift
//  wo-details-getter
//
//  Created by James Mark on 8/21/25.
//

public struct NotionDatabaseQueryResponse: Codable, Sendable {
    let object: String
    let results: [NotionPage]
    let nextCursor: String?
    let hasMore: Bool
    let type: String?
    let page: [String: String]?

    enum CodingKeys: String, CodingKey {
        case object
        case results
        case nextCursor = "next_cursor"
        case hasMore = "has_more"
        case type
        case page
    }
}

public struct NotionDatabaseQueryBody: Encodable, Sendable {
    let startCursor: String?

    enum CodingKeys: String, CodingKey {
        case startCursor = "start_cursor"
    }
}
