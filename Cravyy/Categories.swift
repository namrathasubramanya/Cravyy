//
//  Categories.swift
//  Cravyy
//
//  Created by Namratha Subramanya on 12/4/18.
//  Copyright © 2018 Namratha Subramanya. All rights reserved.
//

import Foundation

struct CategoryArray: Decodable {
    let categories: [Categories]!
}

struct Categories: Decodable {
    let categories: Category!
}

struct Category: Decodable {
    let id: Int?
    let name: String?
}
