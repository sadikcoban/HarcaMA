//
//  AddExpense.swift
//  HarcaMA
//
//  Created by Sadık Çoban on 15.09.2022.
//

import AppIntents
import UIKit
struct AddExpense: AppIntent {
    
    static var title: LocalizedStringResource = "Add a new expense"
    
    @Parameter(title: "Title")
    var title: String
    
    @Parameter(title: "Price")
    var price: Double
    
    @Parameter(title: "Date")
    var date: Date
    
    
    func perform() async throws -> some IntentResult & ProvidesDialog  {
        await addExpense()
        let dialog = IntentDialog("Successfully added your \(title) expense!")
        return .result(dialog: dialog)
    }
    
    
    private func addExpense() async {
        let service = await ExpenseService(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        service.addExpenseItem(title: title, date: date, price: price, completion: {_ in})
    }
    
}
