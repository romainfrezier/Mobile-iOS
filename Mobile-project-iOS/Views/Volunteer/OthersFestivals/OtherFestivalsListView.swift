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
    
    @State private var searchText: String = ""
    @State private var selectedSortOption: SortOptions = .nameAscending
    @State private var alertPresented: Bool = false
    @State private var selectedID : String = ""

    @State var toastMessage : String = ""
    @State var showSuccessToast : Bool = false
    @State var showErrorToast : Bool = false
    
    @EnvironmentObject var currentUser: VolunteerViewModel
    
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
                case .updating :
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
                            .swipeActions(edge: .trailing) {
                                Button{
                                    self.selectedID = vm.festival.id
                                    self.alertPresented.toggle()
                                } label: {
                                    Label("Changer", systemImage: "bookmark.slash")
                                }.tint(.blue)
                            }
                        }
                    }.alert(isPresented: $alertPresented) {
                        Alert(
                            title: Text("Changer de festival"),
                            message: Text("Êtes vous sûr de vouloir changer de festival? Vous ne pourrez plus revenir en arrière, vous perdrez toutes vos affectations et disponibilités."),
                            primaryButton: .destructive(Text("Changer")) {
                                if self.selectedID != "" {
                                    self.currentUser.volunteer.festivalId = self.selectedID
                                    intent.changeFestival(volunteer: self.currentUser.volunteer.id, festival: selectedID)
                                    self.toastMessage = "Changement de festival effectué !"
                                    self.showSuccessToast.toggle()
                                    self.selectedID = ""
                                }
                                
                            },
                            secondaryButton: .cancel(Text("Annuler")) {
                                self.selectedID = ""
                                self.toastMessage = "Changement de festival annulé !"
                                self.showErrorToast.toggle()
                            }
                        )
                    }
                    .refreshable {
                        intent.loadOther(firebaseId: currentUser.volunteer.firebaseId)
                    }
                    .navigationDestination(for: FestivalViewModel.self){
                        vm in
                        OtherFestivalsDetailView(vm: vm)
                    }
                    Spacer()
                    .toast(isPresenting: $showSuccessToast) {
                        AlertToast(displayMode: .banner(.slide), type: .complete(.green), title: toastMessage, subTitle: nil, style: nil)
                    }
                    .toast(isPresenting: $showErrorToast) {
                        AlertToast(displayMode: .banner(.slide), type: .error(.red), title: toastMessage, subTitle: nil, style: nil)
                    }
                    
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



