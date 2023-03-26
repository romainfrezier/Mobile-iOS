//
//  AssignmentDetailView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 26/03/2023.
//

import SwiftUI

struct AssignmentDetailView: View {
    
    @State var zoneName : String
    @State var slotID : String
    @State var volunteerID : String
    
    @State var intent : SlotIntent
    @ObservedObject var slotVM : AssignedSlotViewModel = AssignedSlotViewModel()
    
    init(zoneName: String, slotID: String, volunteerID : String){
        self.volunteerID = volunteerID
        self.zoneName = zoneName
        self.slotID = slotID
        self._intent = State(initialValue: SlotIntent(slotVM: self._slotVM.wrappedValue))
    }
    
    var body: some View {

        VStack {
            switch slotVM.state {
            case .loading:
                LoadingView()
            case .idle:
                HStack {
                    Text("Mon affectation").font(.title).bold()
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
                            Text("Jour :").bold()
                            Text(DateFormatters.justDate().string(from: slotVM.slot.start))
                            Spacer()
                        }.padding(.top)
                        HStack {
                            Text("Début :").bold()
                            Text(DateFormatters.justTime().string(from: slotVM.slot.start))
                            Spacer()
                        }.padding(.top)
                        HStack {
                            Text("Fin :").bold()
                            Text(DateFormatters.justTime().string(from: slotVM.slot.end))
                            Spacer()
                        }.padding(.top)
                        HStack {
                            Text("Zone :").bold()
                            Text(zoneName)
                            Spacer()
                        }.padding(.top)
                    }.padding([.bottom, .leading, .trailing])
                }.background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                ).padding([.leading, .trailing, .bottom])
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Les bénévoles affectés")
                    Spacer()
                }.padding([.leading, .trailing, .top])
                if (slotVM.slot.volunteers.count == 0){
                    EmptyArrayPlaceholder(text: "Aucun autre bénévole sur ce créneau")
                } else {
                    List {
                        ForEach(slotVM.slot.volunteers, id: \.self){
                            volunteer in HStack{
                                Text(volunteer.firstName)
                                Text(volunteer.lastName)
                                if (volunteer.id == volunteerID) {
                                    Text("(moi)").italic()
                                }
                            }
                        }
                    }.refreshable {
                        intent.load(id: self.slotID)
                    }
                }
            default:
                CustomEmptyView()
            }
            
        }.onAppear{
            intent.load(id: self.slotID)
        }
    }
}
