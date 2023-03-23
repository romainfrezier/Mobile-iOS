//
//  UpdateZoneView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 23/03/2023.
//

import SwiftUI
import AlertToast

struct UpdateZoneView: View {
    
    @State var intent : ZoneIntent
    @ObservedObject var vm : ZoneViewModel
    
    @Binding var isPresentedUpdateZone : Bool
    
    @Binding var toastMessage : String
    @State var showToast : Bool = false
    @Binding var showSuccessToast : Bool
    
    init(vm: ZoneViewModel, isPresentedUpdateZone: Binding<Bool>, toastMessage: Binding<String>, showSuccessToast: Binding<Bool>) {
        self.vm = vm
        self._intent = State(initialValue: ZoneIntent(zoneVM: self._vm.wrappedValue))
        self._isPresentedUpdateZone = isPresentedUpdateZone
        self._toastMessage = toastMessage
        self._showSuccessToast = showSuccessToast
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("Annuler"){
                    self.isPresentedUpdateZone.toggle()
                }
                Spacer()
                Button("Enregister") {
                    if (vm.zone.name != ""){
                        intent.update(id: vm.id, name: vm.zone.name, volunteerNumber: vm.zone.volunteersNumber)
                        self.showSuccessToast.toggle()
                        self.toastMessage = "La zone a été modifiée avec succès !"
                        self.isPresentedUpdateZone.toggle()
                    } else {
                        toastMessage = "Merci de donner un nom à la zone."
                        showToast.toggle()
                    }
                }
            }.padding()
            Spacer()
            ZStack(alignment: .bottom) {
                HStack {
                    TextField(vm.zone.name, text: $vm.zone.name)
                        .background(Color.clear)
                        .padding()
                    Image(systemName: vm.zone.name.count != 0 ? "checkmark" : "xmark")
                        .fontWeight(.bold)
                        .foregroundColor(vm.zone.name.count != 0 ? .green : .red)
                }

                Rectangle()
                    .fill(vm.zone.name == "" ? Color.red : Color.blue)
                    .frame(height: 1)
            }.padding()
            Stepper("Nombre de bénévoles : \(vm.zone.volunteersNumber)", value: $vm.zone.volunteersNumber, in: 1...Int.max).padding()
            Spacer()
            
            .toast(isPresenting: $showToast){
                AlertToast(displayMode: .banner(.slide), type: .error(.red), title: toastMessage, subTitle: nil, style: nil)
            }
        }
    }
}
