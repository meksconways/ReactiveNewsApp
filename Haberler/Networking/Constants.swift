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
    static let API_KEY = "e41c62d01ebf4cfba1f52448d53042bb"
    
    
    //The parameters (Queries) that we're gonna use
    struct Parameters {
        static let userId = "userId"
        static let newsId = "Id"
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
