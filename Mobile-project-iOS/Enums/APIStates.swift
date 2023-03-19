//
//  APIStates.swift
//  Mobile-project-iOS
//
//  Created by Romain on 02/03/2023.
//

import Foundation

enum APIStates<T> {
    case idle
    case creating
    case loading
    case load([T])
    case loadOne(T)
    case deleting
    case updating
    case failed(APIErrors)
}
