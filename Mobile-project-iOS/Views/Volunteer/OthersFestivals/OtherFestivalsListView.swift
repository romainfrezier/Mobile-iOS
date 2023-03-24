//
//  OtherFestivalsListView.swift
//  Mobile-project-iOS
//
//  Created by etud on 21/03/2023.
//

import SwiftUI
import AlertToast

struct OtherFestivalsListView: View {
    
    @ObservedObject private var listVM : FestivalsListViewModel
    
    @State private var intent : FestivalsListIntent
    
    @State private var searchText = ""
    @State private var selectedSortOption: SortOptions = .nameAscending

    @EnvironmentObject var currentUser: AuthViewModel
    
    init() {
        self.listVM = FestivalsListViewModel()
        self._intent = State(initialValue: FestivalsListIntent(festivalsListVM: self._listVM.wrappedValue))
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
                    switch listVM.state {
                    case .loading :
                        LoadingView()
                    case .idle :
                        List{
                            ForEach(searchResults, id: \.self) {
                                vm in NavigationLink(value: vm) {
                                    VStack(alignment: .leading){
                                        HStack {
                                            Text(vm.festival.name)
                                        }
                                    }
                                }
                            }
                            
                            
                        }
                        .refreshable {
                            intent.loadOther(firebaseId: currentUser.volunteer.firebaseId)
                        }
                        .scrollContentBackground(.hidden)
                        //.navigationDestination(for: FestivalViewModel.self){
                          //  vm in
                            //FestivalDetailView(vm: vm, successMessage: $successMessage, showSuccessToast: $showSuccessToast)
                        //}
                        
                    default:
                        CustomEmptyView()
                    }
                }
                .searchable(text: $searchText)
                .onAppear{
                    self.intent.loadOther(firebaseId: currentUser.volunteer.firebaseId)
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



