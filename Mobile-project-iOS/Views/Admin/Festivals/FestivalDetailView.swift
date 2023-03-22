//
//  FestivalDetailView.swift
//  AWI-IOS
//
//  Created by Romain on 02/03/2023.
//

import SwiftUI
import AlertToast

struct FestivalDetailView: View {
    
    @ObservedObject var vm : FestivalDetailedViewModel;
    @State var intent : FestivalIntent
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var errorMessage : String = ""
    @State private var showErrorToast : Bool = false
    
    @Binding var successMessage : String
    @Binding var showSuccessToast : Bool
    
    var filters : [String] = ["Zones", "Creneaux"]
    @State private var selectedDisplay : String = "Zones"
    
    init(vm: FestivalViewModel, successMessage : Binding<String>, showSuccessToast: Binding<Bool>){
        self.vm = FestivalDetailedViewModel(festivalVM: vm)
        self._intent = State(initialValue: FestivalIntent(festivalVM: self._vm.wrappedValue))
        self._successMessage = successMessage
        self._showSuccessToast = showSuccessToast
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(vm.festival.name).font(.title).bold()
                Spacer()
            }.padding()
            
            HStack {
                Image(systemName: "info.circle.fill")
                Text("Informations")
                Spacer()
            }.padding([.leading, .trailing, .top])
            VStack {
                HStack {
                    Text("Nom :").bold()
                    Text(vm.festival.name)
                    Spacer()
                }.padding([.leading, .top])
                HStack {
                    Text("Nombre de zones :").bold()
                    Text("\(vm.festival.zones.count)")
                    Spacer()
                }.padding([.leading, .top, .bottom])
            }.background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            ).padding([.leading, .trailing, .bottom])
            
            Divider()
            
            Picker(selection: $selectedDisplay, label: Text("Choisir un filtre")) {
                ForEach(filters, id: \.self) {
                    Text($0)
                }
            }.pickerStyle(SegmentedPickerStyle()).padding(.all)
            
//            switch selectedDisplay {
//            case filters[0]:
//                ZonesListView()
//            case filters[1]:
//                DaysListView()
//            default:
//                CustomEmptyView()
//            }

            .toast(isPresenting: $showErrorToast){
                AlertToast(displayMode: .banner(.slide), type: .error(.red), title: errorMessage, subTitle: nil, style: nil)
            }
            Spacer()
        }
        .onAppear{
            intent.loadOne(id: vm.festival.id)
        }
    }
    
//    var updateButton : some View {
//        VStack{
//            Button("Enregister") {
//                if (vm.volunteer.firstName != "" && vm.volunteer.lastName != "" && vm.volunteer.emailAddress != ""){
//                    intent.update(volunteer: vm.volunteer)
//                    successMessage = "Le bénévole a bien été modifié."
//                    showSuccessToast.toggle()
//                    presentationMode.wrappedValue.dismiss()
//                } else {
//                    errorMessage = "Tous les champs doivent être remplis."
//                    showErrorToast.toggle()
//                }
//            }
//        }
//    }
}
