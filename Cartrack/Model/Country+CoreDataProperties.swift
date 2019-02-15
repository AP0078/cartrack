//
//  Country+CoreDataProperties.swift
//  Cartrack
//
//  Created by Aung Phyoe on 15/2/19.
//  Copyright © 2019 Aung Phyoe. All rights reserved.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var name: String?
    @NSManaged public var flag: String?

}
