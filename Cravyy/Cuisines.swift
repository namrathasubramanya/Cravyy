//
//  Cuisines.swift
//  Cravyy
//
//  Created by Namratha Subramanya on 12/15/18.
//  Copyright © 2018 Namratha Subramanya. All rights reserved.
//

import Foundation

struct Cuisines: Decodable {
    let cuisines: [Cuisine]!
}

struct Cuisine: Decodable {
    let cuisine: CuisineData!
}

struct CuisineData: Decodable {
    let cuisine_id: Int!
    let cuisine_name: String!
}
