//
//  Establishments.swift
//  Cravyy
//
//  Created by Namratha Subramanya on 12/16/18.
//  Copyright © 2018 Namratha Subramanya. All rights reserved.
//

import Foundation

struct Establishments: Decodable {
    let establishments: [Establishment]!
}

struct Establishment: Decodable {
    let establishment: EstablishmentData!
}

struct EstablishmentData: Decodable {
    let id: Int!
    let name: String!
}
