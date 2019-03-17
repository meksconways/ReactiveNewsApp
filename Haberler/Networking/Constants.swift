//
//  Constants.swift
//  Haberler
//
//  Created by macbook  on 27.02.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

import Foundation

struct Constants{
    //The API's base URL
    static let BASE_URL = "https://api.hurriyet.com.tr/v1/"
    // apikeyimiz <3
    static let API_KEY = "c7673c86072d4a01a953cdb1ae2e355a"
    
    
    //The parameters (Queries) that we're gonna use
    struct Parameters {
        static let userId = "userId"
        static let newsId = "Id"
        static let keyword = "keyword"
    }
    
    //The header fields
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
        case apikey = "apikey"
    }
    
    //The content type (JSON)
    enum ContentType: String {
        case json = "application/json"
    }
}
