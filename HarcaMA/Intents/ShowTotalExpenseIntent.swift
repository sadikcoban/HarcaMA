//
//  ShowTotalExpenseIntent.swift
//  HarcaMA
//
//  Created by Sadık Çoban on 15.09.2022.
//

import AppIntents
import UIKit

struct ShowTotalExpense: AppIntent {
    
    static var title: LocalizedStringResource = "Show my total expense"
    
    func perform() async throws -> some IntentResult & ProvidesDialog & ReturnsValue {
        let total = await getTotalExpanse()
        let dialog = IntentDialog(total)
        return .result(dialog: dialog)
    }
    
    private func getTotalExpanse() async -> LocalizedStringResource {
        let service = await ExpenseService(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        guard let total = service.totalExpenseAmount() else { return LocalizedStringResource(stringLiteral: "0") }
        return LocalizedStringResource(stringLiteral: String(format: "%2.f", total))
    }

}



