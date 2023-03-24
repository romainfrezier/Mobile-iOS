//
//  FestivalUpdateNameView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 23/03/2023.
//

import SwiftUI
import AlertToast

struct FestivalUpdateNameView: View {
   
    @State var toastMessage : String = ""
    @State var showToast : Bool = false
    
    @State var festivalVM : FestivalViewModel
    @State var intent : FestivalIntent
    @Binding var isPresentedUpate : Bool
    
    @State var festivalName : String
    
    init(festivalVM: FestivalViewModel, intent: FestivalIntent, isPresentedUpate: Binding<Bool>) {
        self.festivalVM = festivalVM
        self.intent = intent
        self._isPresentedUpate = isPresentedUpate
        self.festivalName = self._festivalVM.wrappedValue.festival.name
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("Annuler"){
                    self.isPresentedUpate.toggle()
                }
                Spacer()
                Button("Enregister") {
                    if (festivalName != ""){
                        intent.updateName(festivalID: festivalVM.festival.id, newName: festivalName)
                        self.isPresentedUpate.toggle()
                    } else {
                        toastMessage = "Merci de donner un nom au festival."
                        showToast.toggle()
                    }
                }
            }
            
            HStack {
                Text("Modifier un festival").font(.title).bold()
                Spacer()
            }.padding()
            
            Spacer()
            
            ZStack(alignment: .bottom) {
                HStack {
                    TextField(festivalName, text: $festivalName)
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

