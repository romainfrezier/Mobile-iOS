//
//  FestivalListView.swift
//  Mobile-project-iOS
//
//  Created by etud on 21/03/2023.
//

import SwiftUI

struct GameListView: View {
    @ObservedObject private var listVM : FestivalsListViewModel
    
    @State private var intent : FestivalIntent
    
    @State var isPresentedNew : Bool = false
    
    @State var name : String = ""
    @State var zone : String = ""
    @State var day : String = ""
    
    @State private var searchText = ""
    @State private var selectedSortOption: SortOptions = .nameAscending
    
    @State private var showConfirmationDialog = false
    @State private var selectedIndexes : IndexSet = IndexSet()
    
    init() {
        self.listVM = FestivalsListViewModel()
        self._intent = State(initialValue: FestivalIntent(festivalsListVM: self._listVM.wrappedValue))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer().frame(width: 30)
                    Text("Jeux").font(.title).fontWeight(.bold)
                    Spacer()
                    Menu {
                        Button("Nom A-Z\(self.selectedSortOption == .nameAscending ? " ✓" : "")"){self.selectedSortOption = .nameAscending}.buttonStyle(PlainButtonStyle())
                        Button("Nom Z-A \(self.selectedSortOption == .nameDescending ? " ✓" : "")"){self.selectedSortOption = .nameDescending}.buttonStyle(PlainButtonStyle())
                        Button("Type A-Z\(self.selectedSortOption == .typeAscending ? " ✓" : "")"){self.selectedSortOption = .typeAscending}.buttonStyle(PlainButtonStyle())
                        Button("Type Z-A\(self.selectedSortOption == .typeDescending ? " ✓" : "")"){self.selectedSortOption = .typeDescending}.buttonStyle(PlainButtonStyle())
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }

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
                case .failed(_) :
                    VStack {
                        Spacer()
                        Text("Erreur de chargement").foregroundColor(.red)
                        Spacer()
                    }
                case .idle :
                    List{
                        ForEach(searchResults, id: \.self) {
                            vm in NavigationLink(value: vm) {
                                HStack {
                                    Text(vm.game.name)
                                }
                            }
                        }
                        .onDelete{indexSet in
                            self.selectedIndexes = indexSet
                            self.showConfirmationDialog = true
                        }
                        
                        Spacer()

                    }.refreshable {
                        intent.load()
                    }.scrollContentBackground(.hidden)
                        .navigationDestination(for: GameViewModel.self){
                            vm in
                            GameDetailView(vm: vm, intent: $intent)
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
                    title: Text("Supprimer un bénévole"),
                    message: Text("Êtes vous sûr de vouloir supprimer le bénévole ?"),
                    primaryButton: .destructive(Text("Supprimer")) {
                        if let indexToDelete = self.selectedIndexes.first {
                            let game = searchResults[indexToDelete]
                            intent.delete(id: game.id)
                            intent.load()
                        }
                        self.selectedIndexes.removeAll()
                    },
                    secondaryButton: .cancel(Text("Annuler")) {
                        self.selectedIndexes.removeAll()
                    }
                )
            }
        }.sheet(isPresented: $isPresentedNew, content: {
            GameAddView(isPresented: $isPresentedNew, name: $name, type: $type, intent: $intent)
        })
    }
    
    var searchResults: [GameViewModel] {
        if searchText.isEmpty {
            return sortedGames(games:listVM.games)
        } else {
            return sortedGames(games:listVM.games.filter {
                $0.game.name.contains(searchText) ||
                $0.game.type!.contains(searchText)
            })
        }
    }
    
    func sortedGames(games: [GameViewModel]) -> [GameViewModel] {
        games.sorted{
            guard let type0 = $0.game.type, let type1 = $1.game.type else  {
                return $0.game.name < $1.game.name
            }
            switch selectedSortOption {
            case .nameAscending :
                return $0.game.name < $1.game.name
            case .nameDescending :
                return $0.game.name > $1.game.name
            case .typeAscending :
                return type0 < type1
            case .typeDescending :
                return type0 > type1
            default:
                return $0.game.name < $1.game.name
            }
        }
    }
}

struct GameListView_Previews: PreviewProvider {
    static var previews: some View {
        GameListView()
    }
}
