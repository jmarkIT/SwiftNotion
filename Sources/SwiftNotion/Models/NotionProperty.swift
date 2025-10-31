//
//  NotionProperty.swift
//  wo-details-getter
//
//  Created by James Mark on 8/21/25.
//

public struct NotionPropertiesResults: Codable {
    let object: String
    let results: [NotionProperty]
}

public struct NotionProperties: Codable {
    let properties: [String: NotionProperty]
}

public struct NotionProperty: Codable {
    let id: String
    let type: NotionPropertyType

    let title: [RichText]?
    let richText: [RichText]?
    let number: Double?
    let checkbox: Bool?
    let select: SelectProperty?
    let multiSelect: [SelectProperty]?
    let people: Person?

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
    let type: String?
    let plainText: String?
    let href: String?
    let text: TextContent?

    enum CodingKeys: String, CodingKey {
        case type
        case plainText = "plain_text"
        case href
        case text
    }
}

public struct TextContent: Codable {
    let content: String
    let link: [String: String]?
}

public struct SelectProperty: Codable {
    let id: String?
    let name: String
    let color: String
}

public struct Person: Codable {
    let object: String
    let id: String
    let name: String
    let type: PeopleType
    let person: [String: String]
    
}

enum PeopleType: String, Codable {
    case person
}

extension NotionProperty {
    var plainText: String? {
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
