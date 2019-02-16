//
//  JsonModel.swift
//  Cartrack
//
//  Created by Aung Phyoe on 16/2/19.
//  Copyright © 2019 Aung Phyoe. All rights reserved.
//

import Foundation

typealias CountryJson = [CountryElement]
struct CountryElement: Codable {
    let name, flag: String
}

typealias UserJson = [UserElement]
struct UserElement: Codable {
    let name, password: String
}
