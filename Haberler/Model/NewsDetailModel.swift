//
//  NewsDetailModel.swift
//  Haberler
//
//  Created by macbook  on 15.03.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let newsDetailModel = try? newJSONDecoder().decode(NewsDetailModel.self, from: jsonData)

import Foundation

struct NewsDetailModel: Codable {
    let id, contentType, createdDate, description: String
    let editor: String
    let files: [File]
    let modifiedDate, path: String
    let startDate: String
    let tags: [String]
    let text, title: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case contentType = "ContentType"
        case createdDate = "CreatedDate"
        case description = "Description"
        case editor = "Editor"
        case files = "Files"
        case modifiedDate = "ModifiedDate"
        case path = "Path"
        case startDate = "StartDate"
        case tags = "Tags"
        case text = "Text"
        case title = "Title"
        case url = "Url"
       
    }
}



