//
//  GalleryModel.swift
//  Haberler
//
//  Created by macbook  on 14.03.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let galleryModel = try? newJSONDecoder().decode(GalleryModel.self, from: jsonData)

import Foundation

typealias GalleryModel = [GalleryModelElement]

struct GalleryModelElement: Codable {
    let id, contentType, createdDate, description: String
    let files: [FileY]
    let modifiedDate, path, startDate: String
    let tags: [String]
    let title: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case contentType = "ContentType"
        case createdDate = "CreatedDate"
        case description = "Description"
        case files = "Files"
        case modifiedDate = "ModifiedDate"
        case path = "Path"
        case startDate = "StartDate"
        case tags = "Tags"
        case title = "Title"
        case url = "Url"
    }
}

struct FileY: Codable {
    let fileURL: String
    let metadata: MetadataY
    
    enum CodingKeys: String, CodingKey {
        case fileURL = "FileUrl"
        case metadata = "Metadata"
    }
}

struct MetadataY: Codable {
    let title, description: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case description = "Description"
    }
}
