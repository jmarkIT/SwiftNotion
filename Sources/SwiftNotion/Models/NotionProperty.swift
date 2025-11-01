//
//  NotionProperty.swift
//  wo-details-getter
//
//  Created by James Mark on 8/21/25.
//

public struct NotionPropertiesResults: Codable {
    public let object: String
    public let results: [NotionProperty]
}

public struct NotionProperties: Codable {
    public let properties: [String: NotionProperty]
}

public struct NotionProperty: Codable {
    public let id: String
    let type: NotionPropertyType

    public let title: [RichText]?
    public let richText: [RichText]?
    public let number: Double?
    public let checkbox: Bool?
    public let select: SelectProperty?
    public let multiSelect: [SelectProperty]?
    public let people: Person?

    init(
        id: String,
        type: NotionPropertyType,
        title: [RichText]? = nil,
        richText: [RichText]? = nil,
        number: Double? = nil,
        checkbox: Bool? = nil,
        select: SelectProperty? = nil,
        multiSelect: [SelectProperty]? = nil,
        people: Person? = nil
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.richText = richText
        self.number = number
        self.checkbox = checkbox
        self.select = select
        self.multiSelect = multiSelect
        self.people = people
    }

    enum CodingKeys: String, CodingKey {
        case id, type, title, number, checkbox, select, people
        case richText = "rich_text"
        case multiSelect = "multi_select"
    }
}

//TODO: Consider implementing a failable initializer here for any types I missed, or are added.
enum NotionPropertyType: String, Codable {
    case title
    case richText = "rich_text"
    case number
    case checkbox
    case select
    case multiSelect = "multi_select"
    case url  // TODO: Implement in NotionProperty
    case formula  // TODO: Implement in NotionProperty
    case rollup  // TODO: Implement in NotionProperty
    case relation  // TODO: Implement in NotionProperty
    case people  // TODO: Implement in NotionProperty
}

public struct RichText: Codable {
    public let type: String?
    public let plainText: String?
    public let href: String?
    public let text: TextContent?

    enum CodingKeys: String, CodingKey {
        case type
        case plainText = "plain_text"
        case href
        case text
    }
}

public struct TextContent: Codable {
    public let content: String
    public let link: [String: String]?
}

public struct SelectProperty: Codable {
    public let id: String?
    public let name: String
    public let color: String
}

public struct Person: Codable {
    public let object: String
    public let id: String
    public let name: String
    let type: PeopleType
    public let person: [String: String]

}

enum PeopleType: String, Codable {
    case person
}

extension NotionProperty {
    public var plainText: String? {
        switch type {
        case .title:
            return title?.compactMap { $0.plainText }.joined() ?? ""
        case .richText:
            return richText?.compactMap { $0.plainText }.joined() ?? ""
        default:
            return nil
        }
    }
}
