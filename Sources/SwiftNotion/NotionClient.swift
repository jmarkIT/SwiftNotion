//
//  notionClient.swift
//  wo-details-getter
//
//  Created by James Mark on 8/20/25.
//

import Foundation

public class NotionClient {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    private func makeRequest(
        pathComponents: [String],
        method: String = "GET",
        body: Data? = nil
    ) -> URLRequest {
        var url = NotionConfig.apiBaseURL
        for component in pathComponents {
            url.append(path: component)
        }
        var request = URLRequest(
            url: url
        )
        request.httpMethod = method
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(
            "Bearer \(NotionConfig.authToken)",
            forHTTPHeaderField: "Authorization"
        )
        request.setValue(
            NotionConfig.apiVersion,
            forHTTPHeaderField: "Notion-Version"
        )
        return request
    }

    func perform<T: Decodable>(
        _ pathComponents: [String],
        method: String = "GET",
        body: Data? = nil
    ) async throws -> T {
        let request = makeRequest(
            pathComponents: pathComponents,
            method: method,
            body: body
        )
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if !(200..<300).contains(httpResponse.statusCode) {
            if let notionError = try? JSONDecoder().decode(
                NotionError.self,
                from: data
            ) {
                throw notionError
            } else {
                throw URLError(.badServerResponse)
            }
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}

extension NotionClient {
    func fetchPage(pageId: String) async throws -> NotionPage {
        return try await perform(["pages", pageId])
    }
}

extension NotionClient {
    public func getPageProperty(pageId: String, propertyId: String) async throws
        -> NotionPropertiesResults
    {
        let normalizedPropertyId =
            propertyId.removingPercentEncoding ?? propertyId
        let pageProperty: NotionPropertiesResults = try await perform([
            "pages", pageId, "properties", normalizedPropertyId,
        ])
        //        if pageProperty.results[0].type == NotionPropertyType.rollup {
        //            let rollupPropertyId = pageProperty.results[0].id.removingPercentEncoding ?? ""
        //            pageProperty = try await perform([
        //                "pages", pageId, "properties", rollupPropertyId
        //            ])

        //        }
        return pageProperty
    }
}

extension NotionClient {
    public func getDatabaseRows(dataSourceId: String) async throws -> [NotionPage] {
        var databaseRows: [NotionPage] = []
        var queryResults: NotionDatabaseQueryResponse = try await perform(
            ["data_sources", dataSourceId, "query"],
            method: "POST",
        )
        databaseRows.append(contentsOf: queryResults.results)
        while queryResults.hasMore {
            let body = NotionDatabaseQueryBody(
                startCursor: queryResults.nextCursor
            )
            let bodyData = try JSONEncoder().encode(body)

            queryResults = try await perform(
                ["data_sources", dataSourceId, "query"],
                method: "POST",
                body: bodyData
            )

            databaseRows.append(contentsOf: queryResults.results)
        }
        return databaseRows
    }
}

extension NotionClient {
    func updatePageProperties(pageId: String, properties: NotionProperties)
        async throws
    {
        let bodyData = try JSONEncoder().encode(properties)
        _ =
            try await perform(
                ["pages", pageId],
                method: "PATCH",
                body: bodyData
            ) as NotionPage
    }
}
