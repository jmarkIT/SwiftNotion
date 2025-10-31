//
//  NotionError.swift
//  wo-details-getter
//
//  Created by James Mark on 8/21/25.
//

public struct NotionError: Codable, Error {
    let object: String
    let status: Int
    let code: String
    let message: String
}
