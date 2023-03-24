//
//  EmptyArrayPlaceholder.swift
//  Mobile-project-iOS
//
//  Created by Romain on 24/03/2023.
//

import SwiftUI

struct EmptyArrayPlaceholder: View {
    
    @State var text : String
    
    var body: some View {
        HStack{
            Spacer()
            Text(text).padding()
            Spacer()
        }.background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        ).padding([.leading, .trailing, .bottom])
    }
}

struct EmptyArrayPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        EmptyArrayPlaceholder(text: "Random Text")
    }
}
