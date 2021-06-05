//
//  FavoriteCity+CoreDataProperties.swift
//  TicketLand
//
//  Created by Дима Давыдов on 05.06.2021.
//
//

import Foundation
import CoreData


extension FavoriteCity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteCity> {
        return NSFetchRequest<FavoriteCity>(entityName: "FavoriteCity")
    }

    @NSManaged public var lat: Double
    @NSManaged public var lon: Double

}

extension FavoriteCity : Identifiable {

}
