//
//  NotionError.swift
//  wo-details-getter
//
//  Created by James Mark on 8/21/25.
//

public struct NotionError: Codable, Error {
    public let object: String
    public let status: Int
    public let code: String
    public let message: String
}
