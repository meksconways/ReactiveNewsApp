//
//  ApiRouter.swift
//  Haberler
//
//  Created by macbook  on 27.02.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

import Foundation
import Alamofire

enum ApiRouter : URLRequestConvertible{
    
    case getPosts(userId: Int)
    case getAllArticleNews()
    case getColumnNews()
    case getGalleryNews()
    case getNewsDetail(newsId: String)
    
    //MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.BASE_URL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        //Http method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.contentType.rawValue)
        urlRequest.setValue(Constants.API_KEY, forHTTPHeaderField: Constants.HttpHeaderField.apikey.rawValue)
        
        //Encoding
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    //MARK: - HttpMethod
    //This returns the HttpMethod type. It's used to determine the type if several endpoints are peresent
    private var method: HTTPMethod {
        switch self {
        case .getPosts:
            return .get
        case .getAllArticleNews:
            return .get
        case .getColumnNews():
            return .get
        case .getGalleryNews:
            return .get
        case .getNewsDetail:
            return .get
        }
    }
    
    //MARK: - Path
    //The path is the part following the base url
    private var path: String {
        switch self {
        case .getPosts:
            return "posts"
        case .getAllArticleNews():
            return "articles"
        case .getColumnNews():
            return "columns"
        case .getGalleryNews:
            return "newsphotogalleries"
        case .getNewsDetail:
            return "articles"
        }
    }
    
    //MARK: - Parameters
    //This is the queries part, it's optional because an endpoint can be without parameters
    private var parameters: Parameters? {
        switch self {
        case .getPosts(let userId):
            //A dictionary of the key (From the constants file) and its value is returned
            return [Constants.Parameters.userId : userId]
        case .getAllArticleNews:
            return [:]
        case .getColumnNews():
            return [:]
        case .getGalleryNews:
            return [:]
        case .getNewsDetail(let newsId):
            return [Constants.Parameters.newsId: newsId]
        }
    }
    
}


enum ApiError: Error {
    case forbidden              //Status code 403
    case notFound               //Status code 404
    case conflict               //Status code 409
    case internalServerError    //Status code 500
}
