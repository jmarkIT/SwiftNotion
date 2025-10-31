//
//  NotionPage.swift
//  wo-details-getter
//
//  Created by James Mark on 8/21/25.
//

public struct NotionPage: Codable {
    let object: String
    let id: String
    let createdTime: String
    let lastEditedTime: String
    let createdBy: NotionPageUser
    let lastEditedBy: NotionPageUser
    let properties: [String: NotionProperty]
    let url: String

    enum CodingKeys: String, CodingKey {
        case object, id, url, properties
        case createdTime = "created_time"
        case lastEditedTime = "last_edited_time"
        case createdBy = "created_by"
        case lastEditedBy = "last_edited_by"
    }
}

struct NotionPageUser: Codable {
    let object: String
    let id: String
}
