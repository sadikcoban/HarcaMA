//
//  ExpenseService.swift
//  HarcaMA
//
//  Created by Sadık Çoban on 15.09.2022.
//

import Foundation
import CoreData

struct ExpenseService {
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func fetchExpenseItems(completion: @escaping (Result<[ExpenseItem], ExpenseServiceErrors>) -> (Void)){
        do {
            let items = try context.fetch(ExpenseItem.fetchRequest())
            completion(.success(items))
        } catch  {
            completion(.failure(.fetchError))
        }
    }
    
    public func addExpenseItem(title: String, date: Date, price: Double, completion: @escaping (Bool) -> (Void)){
        let newItem = ExpenseItem(context: context)
        newItem.title = title
        newItem.date = date
        newItem.price = price
        do {
            try context.save()
            completion(true)
        } catch  {
            completion(false)
        }
    }
    
    public func updateExpenseItem(with newExpense: Expense, completion: @escaping (Bool) -> (Void)){
        guard let prevExpense = context.object(with: newExpense.id) as? ExpenseItem else {
            completion(false)
            return
        }
        prevExpense.title = newExpense.title
        prevExpense.date = newExpense.date
        prevExpense.price = newExpense.price
        do {
            try context.save()
            completion(true)
        } catch  {
            completion(false)
        }
    }
    
    public func deleteExpenseItem(with id: NSManagedObjectID, completion: @escaping (Bool) -> (Void)){
        guard let expense = context.object(with: id) as? ExpenseItem else {
            completion(false)
            return
        }
        context.delete(expense)
        do {
            try context.save()
            completion(true)
        } catch  {
            completion(false)
        }
    }
    
    public func totalExpenseAmount() -> Double? {
        do {
            let items = try context.fetch(ExpenseItem.fetchRequest())
            let total = items.reduce(0) { $0 + $1.price }
            return total
        } catch  {
            return nil
        }
    }
}

public enum ExpenseServiceErrors: Error {
    case fetchError
}
