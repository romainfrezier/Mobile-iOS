//
//  FestivalAddView.swift
//  AWI-IOS
//
//  Created by Romain on 06/03/2023.
//

import SwiftUI
import AlertToast

struct FestivalAddView: View {
    
    @State var intent : FestivalIntent = FestivalIntent(festivalVM: FestivalDetailedViewModel())
    @State var toastMessage : String = ""
    @State var showToast : Bool = false
    @Binding var isPresentedNew : Bool
    @State var festivalName : String = ""
    
    var body: some View {
        VStack {
            HStack {
                Button("Annuler"){
                    self.isPresentedNew.toggle()
                }
                Spacer()
                Button("Enregister") {
                    if (festivalName != ""){
                        intent.create(name: festivalName)
                        self.isPresentedNew.toggle()
                    } else {
                        toastMessage = "Merci de donner un nom au festival."
                        showToast.toggle()
                    }
                }
            }
            
            HStack {
                Text("Ajouter un festival").font(.title).bold()
                Spacer()
            }.padding()
            
            
            Spacer()
            
            ZStack(alignment: .bottom) {
                HStack {
                    TextField("Nom du festival", text: $festivalName)
                        .background(Color.clear)
                        .padding()
                    Image(systemName: festivalName.count != 0 ? "checkmark" : "xmark")
                        .fontWeight(.bold)
                        .foregroundColor(festivalName.count != 0 ? .green : .red)
                }

                Rectangle()
                    .fill(festivalName == "" ? Color.red : Color.blue)
                    .frame(height: 1)
            }.padding()
            
            
            
            Spacer()
            
            .toast(isPresenting: $showToast){
                AlertToast(displayMode: .banner(.slide), type: .error(.red), title: toastMessage, subTitle: nil, style: nil)
            }
            
        }.padding()
    }
}
