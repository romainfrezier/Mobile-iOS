//
//  MyAvailabilitiesListView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 25/03/2023.
//

import SwiftUI
import AlertToast

struct MyAvailabilitiesListView: View {
    
    @EnvironmentObject var currentUser : VolunteerViewModel
    
    @State var intent : SlotsDetailedListIntent
    @ObservedObject var slotsListVM : SlotsDetailedListViewModel = SlotsDetailedListViewModel()
    
    @State var isPresentedNew : Bool = false
    
    @State private var toastMessage : String = ""
    @State private var showToast : Bool = false
    
    @State var volunteerIntent : VolunteerIntent
    
    private var listSize : Int {
        self.slotsListVM.slots.count
    }
    
    init(vIntent : VolunteerIntent) {
        self._volunteerIntent = State(initialValue: vIntent)
        self._intent = State(initialValue: SlotsDetailedListIntent(slotsVM: self._slotsListVM.wrappedValue))
    }
    
    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                Button{
                    self.isPresentedNew.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }.padding()
            
            switch slotsListVM.state {
            case .loading :
                LoadingView()
            case .idle :
                VStack {
                    switch listSize {
                    case 0:
                        EmptyArrayPlaceholder(text: "Vous n'avez pas encore été affecté.")
                    default:
                        List {
                            ForEach(slotsListVM.slots, id: \.self){
                                vm in VStack(alignment: .leading) {
                                    HStack {
                                        Text("Du :")
                                        Text(DateFormatters.shortDate().string(from: vm.availableSlot.slot.start))
                                    }
                                    HStack {
                                        Text("Au :")
                                        Text(DateFormatters.shortDate().string(from: vm.availableSlot.slot.end))
                                    }
                                }
                            }
                            .onDelete{ indexSet in
                                if let index = indexSet.first {
                                    let slot = slotsListVM.slots[index]
                                    volunteerIntent.removeSlot(id: currentUser.volunteer.id, slotID: slot.availableSlot.slot.id)
                                }
                            }
                            .scrollContentBackground(.hidden)
                        }
                    }
                }.fullScreenCover(isPresented: $isPresentedNew){
                    AddAvailabilityView(isPresentedNew: $isPresentedNew, intent: volunteerIntent, listIntent: intent).environmentObject(currentUser)
                }
            default:
                CustomEmptyView()
            }
            
        }
        .onAppear{
            intent.loadAvailable(id: self.currentUser.volunteer.id)
        }
        .refreshable {
            intent.loadAvailable(id: self.currentUser.volunteer.id)
        }
    }
}
