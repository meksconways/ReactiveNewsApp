//
//  ArticleNewsModel.swift
//  Haberler
//
//  Created by macbook  on 27.02.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

import Foundation

typealias ArticleNewsModel = [ArticleNewsModelElement]

struct ArticleNewsModelElement: Codable {
    let id, contentType, createdDate, description: String
    let files: [File]
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

struct File: Codable {
    let fileURL: String
    let metadata: Metadata
    
    enum CodingKeys: String, CodingKey {
        case fileURL = "FileUrl"
        case metadata = "Metadata"
    }
}

struct Metadata: Codable {
    let title, description: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case description = "Description"
    }
}
