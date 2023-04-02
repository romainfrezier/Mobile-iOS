//
//  SelectZoneView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 28/03/2023.
//

import SwiftUI

struct SelectZoneView: View {
    
    @State private var availableSlotsIntent : SlotsDetailedListIntent
    
    @ObservedObject var zonesListVM : ZonesListViewModel
    @State var intent : ZonesListIntent
    
    @Binding private var isListDisplayed: Bool
    @Binding private var toastMessage : String
    @Binding private var isToastDisplayed : Bool
    
    @State private var selectedSlot: String
    @State var currentUserID : String
    @State var userFestival : String
    
    init(availableSlotsIntent: SlotsDetailedListIntent, isListDisplayed: Binding<Bool>, toastMessage: Binding<String>, isToastDisplayed: Binding<Bool>, selectedSlot: String, currentUserID: String, userFestival: String) {
        self.availableSlotsIntent = availableSlotsIntent
        self.zonesListVM = ZonesListViewModel()
        self._intent = State(initialValue: ZonesListIntent(zoneListVM: self._zonesListVM.wrappedValue))
        self._isListDisplayed = isListDisplayed
        self._toastMessage = toastMessage
        self._isToastDisplayed = isToastDisplayed
        self.selectedSlot = selectedSlot
        self.currentUserID = currentUserID
        self.userFestival = userFestival
        print(selectedSlot)
        print(currentUserID)
        print(userFestival)
    }
    
    private var listSize : Int {
        return self.zonesListVM.zones.count
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
            switch zonesListVM.state {
            case .loading :
                LoadingView()
            case .idle :
                switch listSize {
                case 0:
                    EmptyArrayPlaceholder(text: "Ce festival n'a pas encore de zone...")
                default :
                    List {
                        ForEach(zonesListVM.zones, id: \.self) { zone in
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
                    .refreshable {
                        if (self.userFestival != "") {
                            intent.loadByFestival(festival: self.userFestival)
                        }
                    }
                }
            default:
                CustomEmptyView()
            }
            Spacer()
        }.onAppear {
            intent.loadByFestival(festival: self.userFestival)
        }.padding()
    }
}
