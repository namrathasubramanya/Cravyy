//
//  RestaurantEstablishment.swift
//  Cravyy
//
//  Created by Namratha Subramanya on 12/16/18.
//  Copyright © 2018 Namratha Subramanya. All rights reserved.
//

import Foundation

struct RestaurantSearchEstablishment: Decodable {
    let results_found: Int!
    let results_start: Int!
    let results_shown: Int!
    let restaurants: [RestaurantsEstablishment]!
}

struct RestaurantsEstablishment: Decodable {
    let restaurant : RestaurantEstablishment!
}

struct RestaurantEstablishment: Decodable {
    let R: Res_id_Establishment!
    let apikey: String!
    let id: String!
    let name: String!
    let url: String!
    let location: Location_Establishment!
    let switch_to_order_menu: Int!
    let cuisines: String!
    let average_cost_for_two: Int!
    let price_range: Int!
    let currency: String!
    let offers: [Int]
    let opentable_support: Int!
    let is_zomato_book_res: Int!
    let mezzo_provider: String!
    let is_book_form_web_view: Int!
    let book_form_web_view_url: String!
    let book_again_url: String!
    let thumb: String!
    let user_rating: User_rating_Establishment!
    let photos_url: String!
    let menu_url: String!
    let featured_image: String!
    let has_online_delivery: Int!
    let is_delivering_now: Int!
    let include_bogo_offers: Bool!
    let deeplink: String!
    let is_table_reservation_supported: Int!
    let has_table_booking: Int!
    let events_url: String!
    let establishment_types: Establishment_Type!
}

struct Establishment_Type: Decodable {
    let establishment_type: Establishment_Id_and_Name!
}

struct Establishment_Id_and_Name: Decodable {
    let id: String!
    let name: String!
}

struct Res_id_Establishment: Decodable {
    let res_id: Int
}

struct Location_Establishment: Decodable {
    let address: String!
    let locality: String!
    let city: String!
    let city_id: Int!
    let latitude: String!
    let longitude: String!
    let zipcode: String!
    let country_id: Int!
    let locality_verbose: String!
}

struct User_rating_Establishment: Decodable {
    let aggregate_rating: String!
    let rating_text: String!
    let rating_color: String!
    let votes: String!
    
    enum CodingKeys: String, CodingKey {
        case aggregate_rating, rating_text, rating_color, votes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rating_text = try container.decode(String.self, forKey: .rating_text)
        self.rating_color = try container.decode(String.self, forKey: .rating_color)
        
        if let aggregate_rating = try? container.decode(String.self, forKey: .aggregate_rating) {
            self.aggregate_rating = aggregate_rating
        } else {
            let numericRating = try container.decode(Int.self, forKey: .aggregate_rating)
            self.aggregate_rating = String(numericRating)
        }
        
        if let votes = try? container.decode(String.self, forKey: .votes) {
            self.votes = votes
        } else {
            let numericVotes = try container.decode(Int.self, forKey: .votes)
            self.votes = String(numericVotes)
        }
    }
}
