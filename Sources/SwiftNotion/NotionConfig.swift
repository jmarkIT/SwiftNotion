//
//  NotionConfig.swift
//  wo-details-getter
//
//  Created by James Mark on 8/21/25.
//

import Foundation

public struct NotionConfig {
    static let apiBaseURL = URL(string: "https://api.notion.com/v1/")!
    static let apiVersion = "2025-09-03"
    public var authToken: String
    
    public init(authToken: String) {
        self.authToken = authToken
    }
}
