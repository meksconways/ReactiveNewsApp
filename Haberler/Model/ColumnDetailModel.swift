//
//  ColumnDetailModel.swift
//  Haberler
//
//  Created by macbook  on 18.03.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

import Foundation

struct ColumnDetailModel: Codable {
    let id, fullname, contentType, createdDate: String
    let description: String
    let files: [FileColumn]
    let path, startDate, text, title: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case fullname = "Fullname"
        case contentType = "ContentType"
        case createdDate = "CreatedDate"
        case description = "Description"
        case files = "Files"
        case path = "Path"
        case startDate = "StartDate"
        case text = "Text"
        case title = "Title"
        case url = "Url"
    }
}

struct FileColumn: Codable {
    let fileURL: String
    let metadata: MetadataColumn
    
    enum CodingKeys: String, CodingKey {
        case fileURL = "FileUrl"
        case metadata = "Metadata"
    }
}

struct MetadataColumn: Codable {
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        
    }
}


