//
//  VolunteerDetailView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 21/03/2023.
//

import SwiftUI

struct VolunteerDetailView: View {
    
    @ObservedObject var vm : VolunteerViewModel;
    @State var intent : VolunteerIntent;
    @ObservedObject var availableSlotVM : AvailableSlotListViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var errorMessage : String = ""
    @State private var showErrorToast : Bool = false
    
    @Binding var successMessage : String
    @Binding var showSuccessToast : Bool
    
    var body: some View {
        ScrollView {
            switch vm.state {
            case .loading :
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            case .idle:
                VStack {
                    HStack {
                        Text(vm.volunteer.firstName).font(.title).bold()
                        Text(vm.volunteer.lastName).font(.title).bold()
                        Spacer()
                    }.padding()
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "info.circle.fill")
                        Text("Informations")
                        Spacer()
                    }.padding([.leading, .trailing])
                    VStack {
                        HStack {
                            Text("Email :").bold()
                            Text(vm.volunteer.emailAddress)
                            Spacer()
                        }.padding([.leading, .top])
                        HStack {
                            Text("Festival :").bold()
                            Text(vm.volunteer.festivalId ?? "Pas de festival")
                            Spacer()
                        }.padding([.leading, .top])
                        HStack {
                            Text(vm.volunteer.isAdmin ? "Ce bénévole est un admin." : "")
                            Spacer()
                        }.padding([.leading, .top, .bottom])
                    }.background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    ).padding([.leading, .trailing, .bottom])
                    
                    HStack {
                        Image(systemName: "calendar.badge.clock")
                        Text("Disponibilités")
                        Spacer()
                    }.padding([.leading, .trailing])
                    
                    HStack {
                        switch availableSlotVM.state {
                        case .loading :
                            Spacer()
                            ProgressView()
                            Spacer()
                        case .idle :
                            if (availableSlotVM.availableSlots == []) {
                                Text("Aucune disponibilité").padding()
                            } else {
                                List{
                                    ForEach(availableSlotVM.availableSlots, id: \.self) {
                                        slot in VStack(alignment: .leading) {
                                            HStack {
                                                Text(DateFormatters.shortDate().string(from: slot.slot.start))
                                                Text(" - ")
                                                Text(DateFormatters.shortDate().string(from: slot.slot.end))
                                            }
                                        }
                                    }
                                }.padding()
                            }
                        default:
                            CustomEmptyView()
                        }
                        Spacer()
                    }.background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    ).padding([.leading, .trailing, .bottom])
                    
                    Spacer()
                    
                    if (!vm.volunteer.isAdmin){
                        CustomButton(text: "Passer admin", action: makeAdmin)
                    }
                }
            default:
                CustomEmptyView()
            }
        }.onAppear{
            intent.setAvailableSlots(availableSlotsVM: self.availableSlotVM)
            intent.loadOne(id: vm.volunteer.id)
            intent.loadAvailableSlots(id: vm.volunteer.id)
        }.refreshable {
            intent.loadOne(id: vm.volunteer.id)
            intent.loadAvailableSlots(id: vm.volunteer.id)
        }
    }
    
    private func makeAdmin() -> Void {
        intent.makeAdmin(id: vm.volunteer.id)
    }
}
