//
//  SelectZoneView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 28/03/2023.
//

import SwiftUI

struct SelectZoneView: View {
    
    @State private var availableSlotsIntent : SlotsDetailedListIntent
    
    @ObservedObject private var zonesVM : ZonesListViewModel = ZonesListViewModel()
    @State private var zonesIntent : ZonesListIntent
    
    @Binding private var isListDisplayed: Bool
    @Binding private var toastMessage : String
    @Binding private var isToastDisplayed : Bool
    
    @State private var selectedSlot: String
    @State var currentUserID : String
    @State var userFestival : String
    
    init(availableSlotsIntent: SlotsDetailedListIntent, isListDisplayed: Binding<Bool>, toastMessage: Binding<String>, isToastDisplayed: Binding<Bool>, selectedSlot: String, currentUserID: String, userFestival: String) {
        self.availableSlotsIntent = availableSlotsIntent
        self._zonesIntent = State(initialValue: ZonesListIntent(zoneListVM: self._zonesVM.wrappedValue))
        self._isListDisplayed = isListDisplayed
        self._toastMessage = toastMessage
        self._isToastDisplayed = isToastDisplayed
        self.selectedSlot = selectedSlot
        self.currentUserID = currentUserID
        self.userFestival = userFestival
    }
    
    var body: some View {
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
                            availableSlotsIntent.assign(volunteer: self.currentUserID, slot: self.selectedSlot, zone: zone.zone.id)
                            self.toastMessage = "Bénévole affecté avec succès !"
                            self.isToastDisplayed = true
                        } label: {
                            Text(zone.zone.name)
                        }.buttonStyle(PlainButtonStyle())
                    }
                }.padding()
            }
            Spacer()
        }.padding()
        .onAppear {
            if (self.userFestival != "") {
                zonesIntent.loadByFestival(festival: self.userFestival)
            }
        }.refreshable {
            if (self.userFestival != "") {
                zonesIntent.loadByFestival(festival: self.userFestival)
            }
        }
    }
}
