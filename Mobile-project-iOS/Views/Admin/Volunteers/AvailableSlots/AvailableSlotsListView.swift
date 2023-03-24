//
//  AvailableSlotsListView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 22/03/2023.
//

import SwiftUI
import AlertToast

struct AvailableSlotsListView: View {
    
    @ObservedObject private var availableSlotsVM : AvailableSlotsListViewModel
    @State private var availableSlotsIntent : AvailableSlotsListIntent
    
    @ObservedObject private var zonesVM : ZonesListViewModel
    @State private var zonesIntent : ZonesListIntent
    
    @State var currentUserID : String
    @State var userFestival : String
    
    @State private var isListDisplayed: Bool = false
    @State private var selectedSlot: AvailableSlotViewModel? = nil
    
    @State private var toastMessage : String = ""
    @State private var isToastDisplayed : Bool = false
    
    init(id: String, festival: String?) {
        self.availableSlotsVM = AvailableSlotsListViewModel()
        self._availableSlotsIntent = State(initialValue: AvailableSlotsListIntent(availableSlotsVM: self._availableSlotsVM.wrappedValue))
        
        self.zonesVM = ZonesListViewModel()
        self._zonesIntent = State(initialValue: ZonesListIntent(zoneListVM: self._zonesVM.wrappedValue))
        
        self.currentUserID = id
        self.userFestival = festival ?? ""
    }
    var body: some View {
        VStack {
            switch availableSlotsVM.state {
            case .loading :
                LoadingView()
            case .idle :
                if (availableSlotsVM.availableSlots == []) {
                    EmptyArrayPlaceholder(text: "Aucune disponibilité.")
                } else {
                    List{
                        ForEach(availableSlotsVM.availableSlots, id: \.self) {
                            vm in VStack(alignment: .leading) {
                                HStack {
                                    Text("Du :")
                                    Text(DateFormatters.shortDate().string(from: vm.availableSlot.slot.start))
                                }
                                HStack {
                                    Text("Au :")
                                    Text(DateFormatters.shortDate().string(from: vm.availableSlot.slot.end))
                                }
                                if let zone = vm.availableSlot.zone {
                                    HStack {
                                        Text("Affecté sur la zone : ")
                                        Text(zone.name)
                                    }
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                if vm.availableSlot.zone != nil {
                                    Button{
                                        availableSlotsIntent.free(volunteer: self.currentUserID, slot: vm.availableSlot.slot.id)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            availableSlotsIntent.load(id: self.currentUserID)
                                        }
                                        self.toastMessage = "Bénévole libérer avec succès !"
                                        self.isToastDisplayed = true
                                    } label: {
                                        Label("Libérer", systemImage: "bookmark.slash")
                                    }.tint(.blue)
                                } else {
                                    Button{
                                        self.selectedSlot = vm
                                        isListDisplayed = true
                                    } label: {
                                        Label("Assigner", systemImage: "bookmark")
                                    }.tint(.blue)
                                }
                            }
                        }
                    }
                    Spacer()
                        
                    .toast(isPresenting: $isToastDisplayed){
                        AlertToast(displayMode: .banner(.slide), type: .complete(.green), title: self.toastMessage, subTitle: nil, style: nil)
                    }
                }
            default:
                CustomEmptyView()
            }
        }
        .sheet(isPresented: $isListDisplayed, content: {
            
            VStack(alignment: .leading) {
                HStack {
                    Button("Annuler") {
                        self.toastMessage = "Bénévole n'a pas été affecté !"
                        self.isToastDisplayed = true
                        self.isListDisplayed.toggle()
                    }
                    Spacer()
                }.padding()
                
                Text("Les zones du festival").font(.title).bold().padding()
                if (zonesVM.zones == []){
                    Text("Ce festival n'a pas encore de zone...").padding()
                } else {
                    List {
                        ForEach(zonesVM.zones, id: \.self) { zone in
                            Button {
                                isListDisplayed = false
                                availableSlotsIntent.assign(volunteer: self.currentUserID, slot: self.selectedSlot!.availableSlot.slot.id, zone: zone.zone.id)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    availableSlotsIntent.load(id: self.currentUserID)
                                }
                                self.toastMessage = "Bénévole affecté avec succès !"
                                self.isToastDisplayed = true
                            } label: {
                                Text(zone.zone.name)
                            }
                        }
                    }.padding()
                }
                Spacer()
            }.padding()
            
        })
        .onAppear{
            availableSlotsIntent.load(id: self.currentUserID)
            if (self.userFestival != "") {
                zonesIntent.loadByFestival(festival: self.userFestival)
            }
        }
    }
}
