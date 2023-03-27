//
//  ChooseFestivalView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 24/03/2023.
//

import SwiftUI

struct ChooseFestivalView: View {
    
    @EnvironmentObject var currentUser : VolunteerViewModel
    
    @ObservedObject private var listVM : FestivalsListViewModel = FestivalsListViewModel()
    @State private var intent : FestivalsListIntent
    @State private var volunteerIntent : VolunteerIntent
    
    @State private var searchText = ""
    @State private var selectedSortOption: SortOptions = .nameAscending
    
    init() {
        self._intent = State(initialValue: FestivalsListIntent(festivalsListVM: self._listVM.wrappedValue))
        self._volunteerIntent = State(initialValue: VolunteerIntent(volunteerVM: VolunteerViewModel()))
    }
    
    var body: some View {
        NavigationStack {
                VStack {
                    HStack {
                        Spacer().frame(width: 30)
                        Text("Festivals").font(.title).fontWeight(.bold)
                        Spacer()
                        
                        Menu {
                            Button("Nom A-Z\(self.selectedSortOption == .nameAscending ? " ✓" : "")"){self.selectedSortOption = .nameAscending}.buttonStyle(PlainButtonStyle())
                            Button("Nom Z-A\(self.selectedSortOption == .nameDescending ? " ✓" : "")"){self.selectedSortOption = .nameDescending}.buttonStyle(PlainButtonStyle())
                        } label: {
                            HStack {
                                Text("Trier")
                                Image(systemName: "arrow.up.arrow.down")
                            }
                        }
                        Spacer().frame(width: 30)
                    }.padding(.top)
                    
                    Text("Veuillez commencer par choisir un festival").padding()
                    
                    switch listVM.state {
                    case .loading :
                        LoadingView()
                    case .idle :
                        if (listVM.festivals.count == 0){
                            EmptyArrayPlaceholder(text: "Aucun festival.")
                            Spacer()
                        } else {
                            List{
                                ForEach(searchResults, id: \.self) {
                                    vm in
                                    VStack(alignment: .leading){
                                        HStack {
                                            Text(vm.festival.name)
                                        }
                                    }.onTapGesture{
                                        self.volunteerIntent = VolunteerIntent(volunteerVM: self.currentUser)
                                        self.volunteerIntent.setFestival(id: self.currentUser.volunteer.id, festivalID: vm.festival.id)
                                        self.currentUser.volunteer.festivalId = vm.festival.id
                                    }
                                }
                            }.refreshable {
                                intent.load()
                            }
                        }
                    default:
                        CustomEmptyView()
                    }
                }
                .searchable(text: $searchText)
                .onAppear{
                    self.intent.load()
                }
        }
    }
    
    var searchResults: [FestivalViewModel] {
        if searchText.isEmpty {
            return sortedFestivals(festivals: listVM.festivals)
        } else {
            return sortedFestivals(festivals: listVM.festivals.filter {
                $0.festival.name.contains(searchText)
            })
        }
    }
    
    func sortedFestivals(festivals: [FestivalViewModel]) -> [FestivalViewModel] {
        festivals.sorted{
            switch selectedSortOption {
            case .nameAscending :
                return $0.festival.name < $1.festival.name
            case .nameDescending :
                return $0.festival.name > $1.festival.name
            default:
                return $0.festival.name < $1.festival.name
            }
        }
    }
}
