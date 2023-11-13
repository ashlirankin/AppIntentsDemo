//
//  CompleteTaskIntent.swift
//  AppIntentsDemo
//
//  Created by Ashli Rankin on 11/13/23.
//

import Foundation
import AppIntents

struct CompleteTaskIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Complete Task"
    
    @Parameter(title: "title")
    var date: Date
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
