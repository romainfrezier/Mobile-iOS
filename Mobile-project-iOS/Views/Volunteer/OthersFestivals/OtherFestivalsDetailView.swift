//
//  OtherFestivalsDetailView.swift
//  Mobile-project-iOS
//
//  Created by etud on 27/03/2023.
//

import SwiftUI
import AlertToast

struct OtherFestivalsDetailView: View {
    
    @ObservedObject var otherFestivalVM : FestivalViewModel
    @State var intent : FestivalIntent
    
    var filters : [String] = ["Zones", "Jours"]
    @State private var selectedDisplay : String = "Zones"
    
    init(vm: FestivalViewModel){
        self.otherFestivalVM = vm
        self._intent = State(initialValue: FestivalIntent(festivalVM: vm))
    }
    
    var body: some View {
        VStack {
            VStack {
                switch otherFestivalVM.state {
                case .loading:
                    LoadingView()
                case .idle :
                    VStack {
                        HStack {
                            Text(otherFestivalVM.festival.name).font(.title).bold()
                            Spacer()
                        }.padding()
                        HStack {
                            Image(systemName: "info.circle.fill")
                            Text("Informations")
                            Spacer()
                        }.padding([.leading, .trailing, .top])
                        VStack {
                            HStack {
                                Text("Nom :").bold()
                                Text(otherFestivalVM.festival.name)
                                Spacer()
                            }.padding([.leading, .top])
                            HStack {
                                Text("Nombre de zones :").bold()
                                Text("\(otherFestivalVM.festival.zones.count)")
                                Spacer()
                            }.padding([.leading, .top])
                            HStack {
                                Text("Nombre de jours :").bold()
                                Text("\(otherFestivalVM.festival.days.count)")
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
                            MyFestivalZonesListView(festivalID: self.otherFestivalVM.festival.id)
                        case filters[1]:
                            MyFestivalDaysListView(festivalID: self.otherFestivalVM.festival.id)
                        default:
                            CustomEmptyView()
                        }
                        Spacer()
                    }
                default:
                    CustomEmptyView()
                }
            }.onAppear {
                intent.loadOne(id: self.otherFestivalVM.festival.id)
            }
        }
    }
}
