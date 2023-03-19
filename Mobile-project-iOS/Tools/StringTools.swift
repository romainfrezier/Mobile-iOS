//
//  StringTools.swift
//  Mobile-project-iOS
//
//  Created by Romain on 07/03/2023.
//

import Foundation

struct StringTools {
    static func isValidPassword(password: String) -> Bool {
        let regex : String = "^(.{6,})$"
        return password.range(of: regex, options: .regularExpression) != nil
    }
    
    static func isValidEmail(email: String) -> Bool {
        let regex : String = ".+@.+\\.[A-Za-z]{2,}"
        return email.range(of: regex, options: .regularExpression) != nil
    }
}
