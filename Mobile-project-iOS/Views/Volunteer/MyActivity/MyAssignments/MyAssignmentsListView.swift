//
//  MyAssignmentsListView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 25/03/2023.
//

import SwiftUI

struct MyAssignmentsListView: View {
    @State var intent : SlotsDetailedListIntent
    @ObservedObject var slotsListVM : SlotsDetailedListViewModel = SlotsDetailedListViewModel()
    
    @State var volunteerID : String
    
    private var listSize : Int {
        self.slotsListVM.slots.count
    }
    
    init(volunteerID: String) {
        self._volunteerID = State(initialValue: volunteerID)
        self._intent = State(initialValue: SlotsDetailedListIntent(slotsVM: self._slotsListVM.wrappedValue))
    }
    
    var body: some View {
        NavigationStack {
            
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
                                vm in NavigationLink(value: vm) {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("Du :")
                                            Text(DateFormatters.shortDate().string(from: vm.availableSlot.slot.start))
                                        }
                                        HStack {
                                            Text("Au :")
                                            Text(DateFormatters.shortDate().string(from: vm.availableSlot.slot.end))
                                        }
                                        HStack {
                                            Text("Sur la zone :")
                                            Text(vm.availableSlot.zone!.name)
                                        }
                                    }
                                }
                            }
                            .scrollContentBackground(.hidden)
                        }
                        .navigationDestination(for: SlotDetailedViewModel.self){
                            vm in AssignmentDetailView(zoneName: vm.availableSlot.zone!.name, slotID: vm.availableSlot.slot.id, volunteerID: volunteerID)
                        }
                    }
                }
            default:
                CustomEmptyView()
            }
            
        }
        .onAppear{
            intent.loadAssigned(volunteerID: self.volunteerID)
        }
        .refreshable {
            intent.loadAssigned(volunteerID: self.volunteerID)
        }
    }
}
