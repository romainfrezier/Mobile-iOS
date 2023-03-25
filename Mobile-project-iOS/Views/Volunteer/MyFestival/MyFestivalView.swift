//
//  MyFestivalView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 24/03/2023.
//

import SwiftUI
import AlertToast

struct MyFestivalView: View {
    
    @ObservedObject var myFestivalVM : FestivalDetailedViewModel
    @State var intent : FestivalIntent
    
    @EnvironmentObject var currentUser : VolunteerViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var isShowingChooseFestivalView : Bool = false
    @State var selectedFestival : String = ""
    
    var filters : [String] = ["Zones", "Jours"]
    @State private var selectedDisplay : String = "Zones"
    
    init(){
        self.myFestivalVM = FestivalDetailedViewModel()
        self._intent = State(initialValue: FestivalIntent(festivalVM: self._myFestivalVM.wrappedValue))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                switch myFestivalVM.state {
                case .loading:
                    LoadingView()
                case .idle :
                    VStack {
                        HStack {
                            Text(myFestivalVM.festival.name).font(.title).bold()
                            Spacer()
                        }.padding([.leading, .bottom, .trailing])
                        HStack {
                            Image(systemName: "info.circle.fill")
                            Text("Informations")
                            Spacer()
                        }.padding([.leading, .trailing, .top])
                        VStack {
                            HStack {
                                Text("Nom :").bold()
                                Text(myFestivalVM.festival.name)
                                Spacer()
                            }.padding([.leading, .top])
                            HStack {
                                Text("Nombre de zones :").bold()
                                Text("\(myFestivalVM.festival.zones.count)")
                                Spacer()
                            }.padding([.leading, .top])
                            HStack {
                                Text("Nombre de jours :").bold()
                                Text("\(myFestivalVM.festival.days.count)")
                                Spacer()
                            }.padding([.leading, .top, .bottom])
                        }.background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        ).padding([.leading, .trailing, .bottom])
                        Picker(selection: $selectedDisplay, label: Text("Choisir un filtre")) {
                            ForEach(filters, id: \.self) {
                                Text($0)
                            }
                        }.pickerStyle(SegmentedPickerStyle()).padding(.all)
                        switch selectedDisplay {
                        case filters[0]:
                            MyFestivalZonesListView(festivalID: self.currentUser.volunteer.festivalId!)
                        case filters[1]:
                            MyFestivalDaysListView(festivalID: self.currentUser.volunteer.festivalId!)
                        default:
                            CustomEmptyView()
                        }
                        Spacer()
                    }
                default:
                    CustomEmptyView()
                }
            }.onAppear {
                if let festivalID = self.currentUser.volunteer.festivalId {
                    intent.loadOne(id: festivalID)
                }
            }.onChange(of: selectedFestival){ id in
                intent.loadOne(id: id)
            }
        }
    }
}
