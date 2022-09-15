//
//  ExpenseItem+CoreDataProperties.swift
//  HarcaMA
//
//  Created by Sadık Çoban on 15.09.2022.
//
//

import Foundation
import CoreData


extension ExpenseItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseItem> {
        return NSFetchRequest<ExpenseItem>(entityName: "ExpenseItem")
    }

    @NSManaged public var title: String
    @NSManaged public var date: Date
    @NSManaged public var price: Double

}

extension ExpenseItem : Identifiable {

}
