//
//  DateFormatters.swift
//  Mobile-project-iOS
//
//  Created by Romain on 09/03/2023.
//

import Foundation

struct DateFormatters {
    
    static func shortDate() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy '-' HH:mm"
        return formatter
    }
    
    static func longDate() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .long
        return formatter
    }
    
    static func dbDate() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter
    }
    
    static func justDate() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd MMMM"
        return formatter
    }
    
    static func justTime() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
}

extension Date {
    func toJSONString() -> String {
        return DateFormatters.dbDate().string(from: self)
    }
}
