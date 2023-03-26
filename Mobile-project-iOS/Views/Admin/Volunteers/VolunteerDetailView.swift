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
    
    @State private var errorMessage : String = ""
    @State private var showErrorToast : Bool = false
    
    @Binding var successMessage : String
    @Binding var showSuccessToast : Bool
    
    @State var festivalID : String?

    init(vm:VolunteerViewModel, successMessage: Binding<String>, showSuccessToast: Binding<Bool>, festivalID: String?) {
        self.vm = vm
        self._intent = State(initialValue: VolunteerIntent(volunteerVM: vm))
        self._successMessage = successMessage
        self._showSuccessToast = showSuccessToast
        self._festivalID = State(initialValue: festivalID)
    }
    
    var body: some View {
        VStack {
            switch vm.state {
            case .loading :
                LoadingView()
            case .idle:
                VStack {
                    HStack {
                        Text(vm.volunteer.firstName).font(.title).bold()
                        Text(vm.volunteer.lastName).font(.title).bold()
                        Spacer()
                    }.padding()
                    
                    HStack {
                        Image(systemName: "info.circle.fill")
                        Text("Informations")
                        Spacer()
                    }.padding([.leading, .trailing, .top])
                    VStack {
                        VStack{
                            HStack {
                                Text("Email :").bold()
                                Text(vm.volunteer.emailAddress)
                                Spacer()
                            }.padding(.top)
                            HStack {
                                Text("Festival :").bold()
                                Text(vm.volunteer.festivalId ?? "Pas de festival")
                                Spacer()
                            }.padding(.top)
                            if (vm.volunteer.isAdmin) {
                                HStack {
                                    Text("Ce bénévole est un admin.")
                                    Spacer()
                                }.padding(.top)
                            }
                        }.padding([.bottom, .leading, .trailing])
                    }.background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    ).padding([.leading, .trailing, .bottom])
                    
                    HStack {
                        Image(systemName: "calendar.badge.clock")
                        Text("Disponibilités")
                        Spacer()
                    }.padding([.leading, .trailing])
                    
                    if (vm.volunteer.availableSlots.count > 0) {
                        HStack {
                            Spacer().frame(width: 30)
                            Text("Swipez pour affecter ou libérer le bénévole").font(.caption).italic()
                            Spacer()
                        }.padding([.leading, .trailing])
                    }
                    
                    AvailableSlotsListView(id: vm.volunteer.id, festival: festivalID)
                    
                    Spacer()
                    
                    if (!vm.volunteer.isAdmin){
                        CustomButton(text: "Passer admin", action: makeAdmin)
                    }
                    
                    Spacer()
                }
            default:
                CustomEmptyView()
            }
            Spacer()
        }.onAppear{
            intent.loadOne(id: vm.volunteer.id)
        }
    }
    
    private func makeAdmin() -> Void {
        intent.makeAdmin(id: vm.volunteer.id)
    }
}
