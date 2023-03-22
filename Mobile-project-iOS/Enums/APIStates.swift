//
//  APIStates.swift
//  Mobile-project-iOS
//
//  Created by Romain on 02/03/2023.
//

import Foundation

enum APIStates<T> : CustomStringConvertible {
    var description: String {
        switch self {
        case .loading :
            return "loading"
        case .idle :
            return "idle"
        case .loadOne:
            return "loadOne"
        case .load:
            return "load"
        case .failed :
            return "failed"
        default:
            return "default"
        }
    }
    
    case idle
    case creating
    case loading
    case load([T])
    case loadOne(T)
    case deleting
    case updating
    case failed(APIErrors)
}
