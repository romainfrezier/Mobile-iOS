//
//  FestivalDetailView.swift
//  AWI-IOS
//
//  Created by Romain on 02/03/2023.
//

import SwiftUI
import AlertToast

struct FestivalDetailView: View {
    
    @ObservedObject var vm : FestivalViewModel;
    @State var intent : FestivalIntent
    
    @State private var errorMessage : String = ""
    @State private var showErrorToast : Bool = false
    
    @State private var isPresentedNewZone : Bool = false
    
    @Binding var successMessage : String
    @Binding var showSuccessToast : Bool
    
    @State private var showConfirmationDialogZone = false
    @State private var selectedId : String = ""
    
    var filters : [String] = ["Zones", "Jours"]
    @State private var selectedDisplay : String = "Zones"
    
    init(vm: FestivalViewModel, successMessage : Binding<String>, showSuccessToast: Binding<Bool>){
        self.vm = vm
        self._intent = State(initialValue: FestivalIntent(festivalVM: self._vm.wrappedValue))
        self._successMessage = successMessage
        self._showSuccessToast = showSuccessToast
    }
    
    var body: some View {
        VStack {
            switch vm.state {
            case .loading:
                LoadingView()
            case .idle :
                
                HStack {
                    Text(vm.festival.name).font(.title).bold()
                    Spacer()
                }.padding([.leading, .bottom, .trailing])
                
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
                    }.padding([.leading, .top])
                    HStack {
                        Text("Nombre de jours :").bold()
                        Text("\(vm.festival.days.count)")
                        Spacer()
                    }.padding([.leading, .top, .bottom])
                }.background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                ).padding([.leading, .trailing, .bottom])
                
                Picker(selection: $selectedDisplay, label: Text("Choisir un filtre")) {
                    ForEach(filters, id: \.self) {
                        Text($0)
                    }
                }.pickerStyle(SegmentedPickerStyle()).padding(.all)
                
                Text("Swipez pour modifier ou supprimer").font(.caption).italic()
                    
                switch selectedDisplay {
                case filters[0]:
                    ZonesListView(festivalID: vm.festival.id)
                case filters[1]:
                    DaysListView(festivalID: vm.festival.id)
                default:
                    CustomEmptyView()
                }
                Spacer()
            default:
                CustomEmptyView()
            }
        }
        .onAppear{
            intent.loadOne(id: vm.festival.id)
        }
    }
}
