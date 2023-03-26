//
//  AddAvailabilityView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 25/03/2023.
//

import SwiftUI

struct AddAvailabilityView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var currentUser : VolunteerViewModel
    
    @State var intent : SlotListIntent
    @ObservedObject var slotsListVM : SlotsListViewModel = SlotsListViewModel()
    @State var listIntent : SlotsDetailedListIntent
    
    @Binding var isPresentedNew : Bool
    
    @State var vIntent : VolunteerIntent
    
    private var listSize : Int {
        self.slotsListVM.slots.count
    }
    
    init(isPresentedNew: Binding<Bool>, intent: VolunteerIntent, listIntent: SlotsDetailedListIntent) {
        self._listIntent = State(initialValue: listIntent)
        self._vIntent = State(initialValue: intent)
        self._isPresentedNew = isPresentedNew
        self._intent = State(initialValue: SlotListIntent(slotsVM: self._slotsListVM.wrappedValue))
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("Fermer"){
                    self.isPresentedNew.toggle()
                }
                Spacer()
            }.padding()
            switch slotsListVM.state {
            case .loading :
                LoadingView()
            case .idle :
                VStack {
                    switch listSize {
                    case 0:
                        EmptyArrayPlaceholder(text: "Votre festival n'a pas encore de jour")
                    default:
                    
                        List {
                            ForEach(slotsListVM.slots, id: \.self){
                                vm in VStack(alignment: .leading) {
                                    Button{
                                        vIntent.addSlot(id: currentUser.volunteer.id, slotID: vm.slot.id)
                                        presentationMode.wrappedValue.dismiss()
                                    } label: {
                                        VStack {
                                            HStack {
                                                Text("Début à :")
                                                Spacer()
                                                Text(DateFormatters.justTime().string(from: vm.slot.start))
                                            }
                                            
                                            HStack {
                                                Text("Fin à :")
                                                Spacer()
                                                Text(DateFormatters.justTime().string(from: vm.slot.end))
                                            }
                                        }
                                    }
                                }
                            }
                            .scrollContentBackground(.hidden)
                        }
                    }
                }
            default:
                CustomEmptyView()
            }
            
        }.onDisappear{
            listIntent.loadAvailable(id: self.currentUser.volunteer.id)
        }
        .onAppear{
            intent.loadNotAvailable(volunteer: self.currentUser.volunteer.id)
        }
        .refreshable {
            intent.loadNotAvailable(volunteer: self.currentUser.volunteer.id)
        }
    }
}

