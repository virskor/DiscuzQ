//
//  AlertData.swift
//  flutter_native_dialog
//
//  Created by Wouter Hardeman on 19/01/2019.
//

import Foundation

struct AlertData {
    static let DEFAULT_POSITIVE_BUTTON_TEXT: String = "OK"
    static let DEFAULT_NEGATIVE_BUTTON_TEXT: String = "Cancel"
    
    let title: String?
    let message: String?
    let positiveButtonText: String
    let negativeButtonText: String
    let destructive: Bool
    init(withDictionary dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String
        self.message = dictionary["message"] as? String
        self.positiveButtonText = dictionary["positiveButtonText"] as? String ?? AlertData.DEFAULT_POSITIVE_BUTTON_TEXT
        self.negativeButtonText = dictionary["negativeButtonText"] as? String ?? AlertData.DEFAULT_NEGATIVE_BUTTON_TEXT
        self.destructive = dictionary["destructive"] as? Bool ?? false
    }
    
}
