//
//  MyFestivalDaysListView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 25/03/2023.
//

import SwiftUI

struct MyFestivalDaysListView: View {
    @State var intent : DaysListIntent
    @ObservedObject var daysListVM : DaysListViewModel = DaysListViewModel()
    
    @State var festivalID : String
    
    private var listSize : Int {
        self.daysListVM.days.count
    }
    
    init(festivalID: String) {
        self._festivalID = State(initialValue: festivalID)
        self._intent = State(initialValue: DaysListIntent(daysListVM: self._daysListVM.wrappedValue))
    }
    
    var body: some View {
        VStack {
            
            switch daysListVM.state {
            case .loading :
                LoadingView()
            case .idle :
                VStack {
                    switch listSize {
                    case 0:
                        EmptyArrayPlaceholder(text: "Il n'y a pas encore de jour")
                    default:
                    
                        List {
                            ForEach(daysListVM.days, id: \.self){
                                vm in NavigationLink(value: vm) {
                                    VStack(alignment: .leading) {
                                        
                                        Text(vm.day.name).bold()
                                        
                                        Text(DateFormatters.justDate().string(from: vm.day.hours.opening).capitalized).padding([.vertical])
                                        
                                        HStack {
                                            Text("Ouvre à :")
                                            Text(DateFormatters.justTime().string(from: vm.day.hours.opening))
                                        }
                                        
                                        HStack {
                                            Text("Ferme à :")
                                            Text(DateFormatters.justTime().string(from: vm.day.hours.closing))
                                        }
                                    }
                                }
                            }
                        }.navigationDestination(for: DayViewModel.self){
                            vm in DayDetailView(vm: vm)
                        }
                    }
                }
            default:
                CustomEmptyView()
            }
            
        }
        .onAppear{
            intent.load(festivalID: self.festivalID)
        }
        .refreshable {
            intent.load(festivalID: self.festivalID)
        }
    }
}
