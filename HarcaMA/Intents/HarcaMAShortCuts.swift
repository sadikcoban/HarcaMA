//
//  HarcaMAShortCuts.swift
//  HarcaMA
//
//  Created by Sadık Çoban on 15.09.2022.
//

import AppIntents

struct HarcaMAShortCuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: ShowTotalExpense(),
            phrases: [
                "What is my total expense in \(.applicationName)?",
                "Show my total expense in \(.applicationName)",
                "How much did I spend in \(.applicationName)?"
            ]
        )
        
        AppShortcut(
            intent: AddExpense(),
            phrases: [
                "Add a new expense to \(.applicationName)",
                "Create an expense in \(.applicationName)"
            ]
        )
    }
}
