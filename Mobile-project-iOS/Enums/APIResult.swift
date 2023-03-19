//
//  APIResult.swift
//  Mobile-project-iOS
//
//  Created by Romain on 19/03/2023.
//

import Foundation

enum APIResult<T> {
    case success(T)
    case successList([T])
    case failure(Error)
}
