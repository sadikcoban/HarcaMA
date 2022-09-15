//
//  Expense.swift
//  HarcaMA
//
//  Created by Sadık Çoban on 15.09.2022.
//

import Foundation
import CoreData

struct Expense {
    let id: NSManagedObjectID
    let title: String
    let date: Date
    let price: Double
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
        return formatter.string(from: date)
    }
}


