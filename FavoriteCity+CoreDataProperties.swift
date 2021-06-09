//
//  FavoriteCity+CoreDataProperties.swift
//  TicketLand
//
//  Created by Дима Давыдов on 08.06.2021.
//
//

import Foundation
import CoreData


extension FavoriteCity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteCity> {
        return NSFetchRequest<FavoriteCity>(entityName: "FavoriteCity")
    }

    @NSManaged public var lat: String?
    @NSManaged public var lon: String?

}

extension FavoriteCity : Identifiable {

}
