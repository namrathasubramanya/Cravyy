//
//  Collections.swift
//  Cravyy
//
//  Created by Namratha Subramanya on 12/15/18.
//  Copyright © 2018 Namratha Subramanya. All rights reserved.
//

import Foundation

struct Collections: Decodable {
    let collections: [Collection]!
}

struct Collection: Decodable {
    let collection: CollectionData!
}

struct CollectionData: Decodable {
    let collection_id: Int!
    let res_count: Int!
    let image_url: String!
    let url: String!
    let title: String!
    let description: String!
    let share_url: String!
}
