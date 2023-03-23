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
    @State var isPresentedUpdate : Bool = false
    @State var selectedFestival : FestivalViewModel? = nil
    
    @State private var searchText = ""
    @State private var selectedSortOption: SortOptions = .nameAscending
    
    @State private var showConfirmationDialog = false
    @State private var selectedIndex : Int = -1
    
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
                                .swipeActions(edge: .trailing) {
                                    Button{
                                        if let index = searchResults.firstIndex(where: { $0 == vm }) {
                                            self.selectedIndex = index
                                            self.showConfirmationDialog = true
                                        }
                                    } label: {
                                    Label("Supprimer", systemImage: "trash")
                                    }.tint(.red)
                                    Button{
                                        self.selectedFestival = vm
                                        self.isPresentedUpdate.toggle()
                                    } label: {
                                        Label("Modifier", systemImage: "pencil")
                                    }.tint(.blue)
                                }
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
                            if self.selectedIndex != -1 {
                                let festival = searchResults[self.selectedIndex]
                                intent.delete(id: festival.festival.id)
                                successMessage = "Le festival a bien été supprimé."
                                showSuccessToast.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    intent.load()
                                }
                            }
                            self.selectedIndex = -1
                        },
                        secondaryButton: .cancel(Text("Annuler")) {
                            self.selectedIndex = -1
                        }
                    )
                }
        }.sheet(isPresented: $isPresentedNew, content: {
//            FestivalAddView(vm: FestivalViewModel(), isPresented: $isPresentedNew, toastMessage: $errorMessage, showErrorToast: $showErrorToast, showSuccessToast: $showSuccessToast)
            FestivalAddView()
        }).sheet(isPresented: $isPresentedUpdate, content: {
            if self.selectedFestival != nil {
                FestivalUpdateNameView(festivalVM: self.selectedFestival!, intent: FestivalIntent(festivalVM: FestivalDetailedViewModel(festivalVM: self.selectedFestival!)), isPresentedUpate: $isPresentedUpdate)
            } else {
                HStack {
                    Text("Veuillez rafraichir la liste des festivals")
                    Image(systemName: "xmark").fontWeight(.bold).foregroundColor(.red)
                }
                
            }
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
