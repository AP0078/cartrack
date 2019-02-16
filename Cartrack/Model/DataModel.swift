//
//  DataModel.swift
//  Cartrack
//
//  Created by Aung Phyoe on 16/2/19.
//  Copyright © 2019 Aung Phyoe. All rights reserved.
//

import Foundation
import MapKit
typealias DataModel = [Person]

struct Person: Codable {
    let id: Int
    let name, username, email: String
    let address: Address
    let phone, website: String
    let company: Company
}

struct Address: Codable {
    let street, suite, city, zipcode: String
    let geo: Geo
    func getFullAddress() -> String {
        return String(format: "%@ %@ %@ %@", street, suite, city, zipcode)
    }
}

struct Geo: Codable {
    let lat, lng: String
    func coordinate() -> CLLocationCoordinate2D {
        if let latitude = Double(lat),
            let longitude = Double(lng) {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return CLLocationCoordinate2D()
    }
}

struct Company: Codable {
    let name, catchPhrase, bs: String
}
