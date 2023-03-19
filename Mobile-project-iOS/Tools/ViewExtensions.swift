//
//  ViewExtensions.swift
//  Mobile-project-iOS
//
//  Created by Romain on 07/03/2023.
//

import Foundation
import SwiftUI

extension View {
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }

        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }

        return root
    }
}
