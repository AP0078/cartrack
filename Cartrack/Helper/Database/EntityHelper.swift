//
//  EntityHelper.swift
//  Cartrack
//
//  Created by Aung Phyoe on 16/2/19.
//  Copyright © 2019 Aung Phyoe. All rights reserved.
//

import Foundation

enum EntityTypes: String {
    case country = "Country"
    case user = "User"
}
enum CountryAttributes: String {
    case
    name = "name",
    flag = "flag",
    users = "users"
    
    static let getAll = [
        users,
        name,
        flag
    ]
}
enum UserAttributes: String {
    case
    name = "name",
    password = "password",
    location = "location"
    
    static let getAll = [
        name,
        password,
        location
    ]
}
