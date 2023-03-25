//
//  MyFestivalZonesListView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 25/03/2023.
//

import SwiftUI

struct MyFestivalZonesListView: View {
    @ObservedObject var zonesListVM : ZonesListViewModel = ZonesListViewModel()
    @State var intent : ZonesListIntent
    
    @State var festivalID : String
    
    private var listSize : Int {
        self.zonesListVM.zones.count
    }
    
    init(festivalID: String) {
        self._intent = State(initialValue: ZonesListIntent(zoneListVM: self._zonesListVM.wrappedValue))
        self.festivalID = festivalID
    }
    
    var body: some View {
        VStack {
            switch zonesListVM.state {
            case .loading :
                LoadingView()
            case .idle :
                VStack {
                    switch listSize {
                    case 0:
                        EmptyArrayPlaceholder(text: "Il n'y a pas encore de zone")
                    default:
                        List {
                            ForEach(zonesListVM.zones, id: \.self){
                                vm in
                                VStack(alignment: .leading) {
                                    Text(vm.zone.name)
                                    HStack {
                                        Text("Nombre de bénévole requis :")
                                        Text("\(vm.zone.volunteersNumber)")
                                    }
                                }
                            }
                        }.scrollContentBackground(.hidden)
                    }
                }
            default:
                CustomEmptyView()
            }
        }
        .onAppear{
            intent.loadByFestival(festival: self.festivalID)
        }
        .refreshable {
            intent.loadByFestival(festival: self.festivalID)
        }
    }
}
