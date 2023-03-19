//
//  CustomButton.swift
//  Mobile-project-iOS
//
//  Created by Romain on 09/03/2023.
//

import SwiftUI

struct CustomButton: View {
    
    var text : String
    var action : () -> Void
    
    var body: some View {
        Button (action: {
            action()
        }, label: {
            Text(text).font(.title3).bold().padding().overlay(
                RoundedRectangle(cornerRadius: 10).stroke()
            )
        }).buttonStyle(PlainButtonStyle())
    }
}
