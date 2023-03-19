//
//  PasswordToggle.swift
//  Mobile-project-iOS
//
//  Created by Romain on 15/03/2023.
//

import SwiftUI

struct PasswordToggle: View {
    @Binding var isPasswordVisible : Bool
    var body: some View {
        HStack {
            Spacer()
            HStack {
                if !isPasswordVisible {
                    Text("Afficher le mot de passe")
                    Image(systemName: "eye.slash")
                } else {
                    Text("Cacher le mot de passe")
                    Image(systemName: "eye")
                }
                Spacer()
            }.frame(width: 300)
            Toggle("", isOn: $isPasswordVisible).toggleStyle(SwitchToggleStyle(tint: .blue))
        }.padding([.top, .bottom, .trailing])
    }
}
