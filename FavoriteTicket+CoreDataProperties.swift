//
//  FavoriteTicket+CoreDataProperties.swift
//  TicketLand
//
//  Created by Дима Давыдов on 03.06.2021.
//
//

import Foundation
import CoreData


extension FavoriteTicket {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteTicket> {
        return NSFetchRequest<FavoriteTicket>(entityName: "FavoriteTicket")
    }

    @NSManaged public var airline: String?
    @NSManaged public var flightNumber: Int16
    @NSManaged public var from: String?
    @NSManaged public var to: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var departureAt: Date?
    @NSManaged public var expiresAt: Date?
    @NSManaged public var returnAt: Date?
    @NSManaged public var price: Int64

}

extension FavoriteTicket : Identifiable {

}
