//
//  CustomEmptyView.swift
//  AWI-IOS
//
//  Created by Romain on 09/03/2023.
//

import SwiftUI

struct CustomEmptyView: View {
    var body: some View {
        VStack {
            Spacer()
            Image("Logo")
            Spacer()
        }
    }
}

struct CustomEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        CustomEmptyView()
    }
}
