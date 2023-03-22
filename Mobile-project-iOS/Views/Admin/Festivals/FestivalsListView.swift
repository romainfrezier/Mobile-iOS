//
//  FestivalsListView.swift
//  AWI-IOS
//
//  Created by Romain on 02/03/2023.
//

import SwiftUI
import AlertToast

struct FestivalsListView: View {
    
    @ObservedObject private var listVM : FestivalsListViewModel
    
    @State private var intent : FestivalsListIntent
    
    @State var isPresentedNew : Bool = false
    
    @State private var searchText = ""
    @State private var selectedSortOption: SortOptions = .nameAscending
    
    @State private var showConfirmationDialog = false
    @State private var selectedIndexes : IndexSet = IndexSet()
    
    @State private var errorMessage : String = ""
    @State private var showErrorToast : Bool = false
    
    @State private var successMessage : String = ""
    @State private var showSuccessToast : Bool = false
    
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
                        Button {
                            isPresentedNew.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                        Spacer().frame(width: 30)
                        
                    }.padding(.top)
                    switch listVM.state {
                    case .loading :
                        VStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
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
                            .onDelete{ indexSet in
                                self.selectedIndexes = indexSet
                                self.showConfirmationDialog = true
                            }
                        }
                        .refreshable {
                            intent.load()
                        }
                        .scrollContentBackground(.hidden)
                        .navigationDestination(for: FestivalViewModel.self){
                            vm in
                            FestivalDetailView(vm: vm, successMessage: $successMessage, showSuccessToast: $showSuccessToast)
                        }
                        
                    default:
                        CustomEmptyView()
                    }
                }
                .searchable(text: $searchText)
                .onAppear{
                    self.intent.load()
                }
                .alert(isPresented: $showConfirmationDialog) {
                    Alert(
                        title: Text("Supprimer un festival"),
                        message: Text("Êtes vous sûr de vouloir supprimer le festival ? Vous ne pourrez plus revenir en arrière."),
                        primaryButton: .destructive(Text("Supprimer")) {
                            if let indexToDelete = self.selectedIndexes.first {
                                let festival = searchResults[indexToDelete]
                                intent.delete(id: festival.festival.id)
                                successMessage = "Le festival a bien été supprimé."
                                showSuccessToast.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    intent.load()
                                }
                            }
                            self.selectedIndexes.removeAll()
                        },
                        secondaryButton: .cancel(Text("Annuler")) {
                            self.selectedIndexes.removeAll()
                        }
                    )
                }
        }.sheet(isPresented: $isPresentedNew, content: {
            FestivalAddView(vm: FestivalViewModel(), isPresented: $isPresentedNew, toastMessage: $errorMessage, showErrorToast: $showErrorToast, showSuccessToast: $showSuccessToast)
        })
        .toast(isPresenting: $showErrorToast){
            AlertToast(displayMode: .banner(.slide), type: .error(.red), title: errorMessage, subTitle: nil, style: nil)
        }
        .toast(isPresenting: $showSuccessToast){
            AlertToast(displayMode: .banner(.slide), type: .complete(.green), title: successMessage, subTitle: nil, style: nil)
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

struct VolunteerListView_Previews: PreviewProvider {
    static var previews: some View {
        FestivalsListView()
    }
}
