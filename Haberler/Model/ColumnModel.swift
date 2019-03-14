//
//  ColumnModel.swift
//  Haberler
//
//  Created by macbook  on 13.03.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let columnModel = try? newJSONDecoder().decode(ColumnModel.self, from: jsonData)

import Foundation

typealias ColumnModel = [ColumnModelElement]

struct ColumnModelElement: Codable {
    let id, fullname, contentType, createdDate: String
    let description: String
    let files: [FileX]
    let path, startDate, title: String
    let url: String
    let writerID: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case fullname = "Fullname"
        case contentType = "ContentType"
        case createdDate = "CreatedDate"
        case description = "Description"
        case files = "Files"
        case path = "Path"
        case startDate = "StartDate"
        case title = "Title"
        case url = "Url"
        case writerID = "WriterId"
    }
}

struct FileX: Codable {
    let fileURL: String
    let metadata: MetadataX
    
    enum CodingKeys: String, CodingKey {
        case fileURL = "FileUrl"
        case metadata = "Metadata"
    }
}

struct MetadataX: Codable {
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
    }
}
