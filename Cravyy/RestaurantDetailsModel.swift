//
//  RestaurantDetailsModel.swift
//  Cravyy
//
//  Created by Namratha Subramanya on 12/16/18.
//  Copyright © 2018 Namratha Subramanya. All rights reserved.
//

import Foundation

struct RestaurantDetailsModel: Decodable {
    let id: String!
    let name: String!
    let url: String!
    let location: Location!
    let average_cost_for_two: Int!
    let price_range: Int!
    let currency: String!
    let thumb: String!
    let featured_image: String!
    let photos_url: String!
    let menu_url: String!
    let events_url: String!
    let user_rating: User_rating!
    let has_online_delivery: Int!
    let is_delivering_now: Int!
    let has_table_booking: Int!
    let deeplink: String!
    let cuisines: String!
    let all_reviews_count: String!
    let photo_count: String!
    let phone_numbers: String!
    let photos: [Photo]?
    let all_reviews: [All_Reviews]?
}

struct All_Reviews: Decodable {
    let rating: String!
    let review_text: String!
    let id: String!
    let rating_color: String!
    let review_time_friendly: String!
    let rating_text: String!
    let timestamp: String!
    let likes: String!
    let user: User!
    let comments_count: String!
}

struct Photo: Decodable {
    let id: String!
    let url: String!
    let thumb_url: String!
    let user: User
    let res_id: String!
    let caption: String!
    let timestamp: String!
    let friendly_time: String!
    let width: String!
    let height: String!
    let comments_count: String!
    let likes_count: String!
}

struct User: Decodable {
    let name: String!
    let zomato_handle: String!
    let foodie_level: String!
    let foodie_level_num: String!
    let foodie_color: String!
    let profile_url: String!
    let profile_deeplink: String!
    let profile_image: String!
}
