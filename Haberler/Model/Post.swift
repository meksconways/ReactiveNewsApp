//
//  Post.swift
//  Haberler
//
//  Created by macbook  on 27.02.2019.
//  Copyright © 2019 meksconway. All rights reserved.
//

import Foundation

struct Post: Codable {
    let id: Int
    let title: String
    let body: String
    let userId: Int
}


