//
//  CategoryData.swift
//  DemoAssignment
//
//  Created by Pooja Raghuwanshi on 01/04/23.
//

import Foundation

struct Category : Codable {
    let id : Int?
    let name : String?
    let image : String?
    let creationAt : String?
    let updatedAt : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case image = "image"
        case creationAt = "creationAt"
        case updatedAt = "updatedAt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        creationAt = try values.decodeIfPresent(String.self, forKey: .creationAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }

}
