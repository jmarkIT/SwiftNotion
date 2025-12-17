//
//  NotionPage.swift
//  wo-details-getter
//
//  Created by James Mark on 8/21/25.
//

public struct NotionPage: Codable, Sendable {
    public let object: String
    public let id: String
    public let createdTime: String
    public let lastEditedTime: String
    public let createdBy: NotionPageUser
    public let lastEditedBy: NotionPageUser
    public let properties: [String: NotionProperty]
    public let url: String

    enum CodingKeys: String, CodingKey {
        case object, id, url, properties
        case createdTime = "created_time"
        case lastEditedTime = "last_edited_time"
        case createdBy = "created_by"
        case lastEditedBy = "last_edited_by"
    }
}

public struct NotionPageUser: Codable, Sendable {
    public let object: String
    public let id: String
}
