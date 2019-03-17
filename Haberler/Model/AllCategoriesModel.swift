// To parse the JSON, add this file to your project and do:
//
//   let allCategoriesModel = try? newJSONDecoder().decode(AllCategoriesModel.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseAllCategoriesModel { response in
//     if let allCategoriesModel = response.result.value {
//       ...
//     }
//   }

import Foundation

struct AllCategoriesModel: Codable {
    let count : Int?
    let list : [List]?
    
    enum CodingKeys: String, CodingKey {
        case count = "Count"
        case list = "List"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        count = try values.decodeIfPresent(Int.self, forKey: .count)
        list = try values.decodeIfPresent([List].self, forKey: .list)
    }
}

struct List : Codable {
    
    let id : String?
    let contentType : String?
    let descriptionField : String?
    let files : [FileD]?
    let modifiedDate : String?
    let startDate : String?
    let text : String?
    let title : String?
    let url : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case contentType = "ContentType"
        case descriptionField = "Description"
        case files = "Files"
        case modifiedDate = "ModifiedDate"
        case startDate = "StartDate"
        case text = "Text"
        case title = "Title"
        case url = "Url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        contentType = try values.decodeIfPresent(String.self, forKey: .contentType)
        descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
        files = try values.decodeIfPresent([FileD].self, forKey: .files)
        modifiedDate = try values.decodeIfPresent(String.self, forKey: .modifiedDate)
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }
    
}
struct FileD : Codable {
    
    let fileUrl : String?
    let metadata : MetadataD?
    
    enum CodingKeys: String, CodingKey {
        case fileUrl = "FileUrl"
        case metadata = "Metadata"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fileUrl = try values.decodeIfPresent(String.self, forKey: .fileUrl)
        metadata = try MetadataD(from: decoder)
    }
    
}
struct MetadataD : Codable {
    
    let title : String?
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
    }
    
}




