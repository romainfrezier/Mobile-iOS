//
//  AvailableSlotsListView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 22/03/2023.
//

import SwiftUI
import AlertToast

struct AvailableSlotsListView: View {
    
    @ObservedObject private var availableSlotsVM : SlotsDetailedListViewModel
    @State private var availableSlotsIntent : SlotsDetailedListIntent
    
    @State var currentUserID : String
    @State var userFestival : String
    
    @State private var isListDisplayed: Bool = false
    @State private var selectedSlot: String = ""
    
    @State private var toastMessage : String = ""
    @State private var isToastDisplayed : Bool = false
    
    init(id: String, festival: String?) {
        self.availableSlotsVM = SlotsDetailedListViewModel()
        self._availableSlotsIntent = State(initialValue: SlotsDetailedListIntent(slotsVM: self._availableSlotsVM.wrappedValue))
        self.currentUserID = id
        self.userFestival = festival ?? ""
    }
    var body: some View {
        VStack {
            switch availableSlotsVM.state {
            case .loading, .updating :
                LoadingView()
            case .idle :
                if (availableSlotsVM.slots == []) {
                    EmptyArrayPlaceholder(text: "Aucune disponibilité.")
                } else {
                    List{
                        ForEach(availableSlotsVM.slots, id: \.self) {
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
                                        self.toastMessage = "Bénévole libérer avec succès !"
                                        self.isToastDisplayed = true
                                    } label: {
                                        Label("Libérer", systemImage: "bookmark.slash")
                                    }.tint(.blue)
                                } else {
                                    Button{
                                        self.selectedSlot = vm.availableSlot.slot.id
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
            SelectZoneView(availableSlotsIntent: availableSlotsIntent, isListDisplayed: $isListDisplayed, toastMessage: $toastMessage, isToastDisplayed: $isToastDisplayed, selectedSlot: self.selectedSlot, currentUserID: self.currentUserID, userFestival: self.userFestival)
        })
        .onAppear {
            availableSlotsIntent.loadAvailable(id: self.currentUserID)

        }.refreshable {
            availableSlotsIntent.loadAvailable(id: self.currentUserID)
        }
    }
}
