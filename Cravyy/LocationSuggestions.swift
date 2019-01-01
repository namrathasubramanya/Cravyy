//
//  LocationSuggestions.swift
//  Cravyy
//
//  Created by Namratha Subramanya on 12/8/18.
//  Copyright © 2018 Namratha Subramanya. All rights reserved.
//

import Foundation

struct LocationSuggestions: Decodable {
    let location_suggestions: [LocationSuggestion]
}

struct LocationSuggestion: Decodable {
    let id: Int
    let name: String
    let country_id: Int
    let country_name: String
    let country_flag_url: String
    let should_experiment_with: Int
    let discovery_enabled: Int
    let has_new_ad_format: Int
    let is_state: Int
    let state_id: Int
    let state_name: String
    let state_code: String
}
