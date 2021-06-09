//
//  MapPrice+CoreDataProperties.swift
//  TicketLand
//
//  Created by Дима Давыдов on 05.06.2021.
//

import Foundation
import CoreData

extension MapPrice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MapPrice> {
        return NSFetchRequest<MapPrice>(entityName: "MapPrice")
    }

    @NSManaged public var departure: String?
    @NSManaged public var arrival: String?
}

extension MapPrice : Identifiable {

}
