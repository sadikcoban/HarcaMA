//
//  ExpenseListViewModel.swift
//  HarcaMA
//
//  Created by Sadık Çoban on 15.09.2022.
//

import Foundation
import CoreData

class ExpenseListViewModel {
    
    var expenseList = [Expense]()
    let service: ExpenseService
    
    init(context: NSManagedObjectContext) {
        self.service = ExpenseService(context: context)
        fetchExpenses(completion: nil)
    }
    
    public func fetchExpenses(completion: (() -> Void)?){
        service.fetchExpenseItems {[weak self] result in
            switch result {
            case .success(let expenses):
                self?.expenseList = expenses.map { Expense(id: $0.objectID, title: $0.title, date: $0.date, price: $0.price) }
                completion?()
            case .failure(_):
                print("error")
            }
        }
    }
    
    public func addExpense(title: String, date: Date, price: Double, completion: @escaping () -> Void){
        service.addExpenseItem(title: title, date: date, price: price) {[weak self] success in
            if success {
                self?.fetchExpenses(completion: completion)
            }
        }
    }
    
    public func deleteExpense(id: NSManagedObjectID, completion: @escaping () -> Void){
        service.deleteExpenseItem(with: id) {[weak self] success in
            if success {
                self?.fetchExpenses(completion: completion)
            }
        }
    }
    
    public func updateExpense(with newExpense: Expense, completion: @escaping () -> Void){
        service.updateExpenseItem(with: newExpense) {[weak self] success in
            if success {
                self?.fetchExpenses(completion: completion)
            }
        }
    }
    
}
