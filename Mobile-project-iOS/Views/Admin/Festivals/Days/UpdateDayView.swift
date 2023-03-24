//
//  UpdateDayView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 23/03/2023.
//

import SwiftUI
import AlertToast

struct UpdateDayView: View {
    @State var intent : DayIntent
    @ObservedObject var vm : DayViewModel
    
    @Binding var isPresentedUpdateDay : Bool
    
    @Binding var toastMessage : String
    @State var showToast : Bool = false
    @Binding var showSuccessToast : Bool
    
    init(vm: DayViewModel, isPresentedUpdateDay: Binding<Bool>, toastMessage: Binding<String>, showSuccessToast: Binding<Bool>) {
        self.vm = vm
        self._intent = State(initialValue: DayIntent(dayVM: self._vm.wrappedValue))
        self._isPresentedUpdateDay = isPresentedUpdateDay
        self._toastMessage = toastMessage
        self._showSuccessToast = showSuccessToast
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("Annuler"){
                    self.isPresentedUpdateDay.toggle()
                }
                Spacer()
                Button("Enregister") {
                    if (vm.day.name != ""){
                        intent.update(id: vm.id, name: vm.day.name)
                        self.showSuccessToast.toggle()
                        self.toastMessage = "Le jour a été modifiée avec succès !"
                        self.isPresentedUpdateDay.toggle()
                    } else {
                        toastMessage = "Merci de donner un nom au jour."
                        showToast.toggle()
                    }
                }
            }.padding()
            HStack {
                Text("Modifier un jour").font(.title).bold()
                Spacer()
            }.padding()
            Spacer().frame(height: 100)
            ZStack(alignment: .bottom) {
                HStack {
                    TextField(vm.day.name, text: $vm.day.name)
                        .background(Color.clear)
                        .padding()
                    Image(systemName: vm.day.name.count != 0 ? "checkmark" : "xmark")
                        .fontWeight(.bold)
                        .foregroundColor(vm.day.name.count != 0 ? .green : .red)
                }

                Rectangle()
                    .fill(vm.day.name == "" ? Color.red : Color.blue)
                    .frame(height: 1)
            }.padding()
            
            Spacer()
            
            .toast(isPresenting: $showToast){
                AlertToast(displayMode: .banner(.slide), type: .error(.red), title: toastMessage, subTitle: nil, style: nil)
            }
        }
    }
}
