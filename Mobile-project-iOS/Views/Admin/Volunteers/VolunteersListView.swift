//
//  VolunteersListView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 21/03/2023.
//

import SwiftUI
import AlertToast

struct VolunteersListView: View {
    @ObservedObject private var listVM : VolunteerListViewModel
    @EnvironmentObject var currentUser : AuthViewModel
    @State private var intent : VolunteerListIntent
    
    @State private var searchText = ""
    @State private var selectedSortOption: SortOptions = .nameAscending
    
    @State private var selectedIndexes : IndexSet = IndexSet()
    
    @State private var errorMessage : String = ""
    @State private var showErrorToast : Bool = false
    
    @State private var successMessage : String = ""
    @State private var showSuccessToast : Bool = false
    
    init() {
        self.listVM = VolunteerListViewModel()
        self._intent = State(initialValue: VolunteerListIntent(volunteerListVM: self._listVM.wrappedValue))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer().frame(width: 30)
                    Text("Bénévoles").font(.title).fontWeight(.bold)
                    Spacer()
                    Menu {
                        Button("Prénom A-Z\(self.selectedSortOption == .firstNameAscending ? " ✓" : "")"){self.selectedSortOption = .firstNameAscending}.buttonStyle(PlainButtonStyle())
                        Button("Prénom Z-A \(self.selectedSortOption == .firstNameDescending ? " ✓" : "")"){self.selectedSortOption = .firstNameDescending}.buttonStyle(PlainButtonStyle())
                        Button("Nom A-Z\(self.selectedSortOption == .lastNameAscending ? " ✓" : "")"){self.selectedSortOption = .lastNameAscending}.buttonStyle(PlainButtonStyle())
                        Button("Nom Z-A\(self.selectedSortOption == .lastNameDescending ? " ✓" : "")"){self.selectedSortOption = .lastNameDescending}.buttonStyle(PlainButtonStyle())
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
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(vm.volunteer.firstName)
                                        Text(vm.volunteer.lastName)
                                        if (currentUser.volunteer.firebaseId == vm.volunteer.firebaseId) {
                                            Text("(moi)").font(.caption).italic()
                                        }
                                        if (vm.volunteer.isAdmin) {
                                            Text("- admin").font(.caption).italic()
                                        }
                                    }
                                }
                            }
                        }
                    }.refreshable {
                        intent.load()
                    }.scrollContentBackground(.hidden)
                        .navigationDestination(for: VolunteerViewModel.self){
                            vm in
                            VolunteerDetailView(vm: vm, successMessage: $successMessage, showSuccessToast: $showSuccessToast, festivalID: vm.volunteer.festivalId)
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
        .toast(isPresenting: $showErrorToast){
            AlertToast(displayMode: .banner(.slide), type: .error(.red), title: errorMessage, subTitle: nil, style: nil)
        }
        .toast(isPresenting: $showSuccessToast){
            AlertToast(displayMode: .banner(.slide), type: .complete(.green), title: successMessage, subTitle: nil, style: nil)
        }
    }
    
    var searchResults: [VolunteerViewModel] {
        if searchText.isEmpty {
            return sortedVolunteers(volunteers: listVM.volunteers)
        } else {
            return sortedVolunteers(volunteers: listVM.volunteers.filter {
                $0.volunteer.firstName.contains(searchText) ||
                $0.volunteer.lastName.contains(searchText) ||
                $0.volunteer.emailAddress.contains(searchText)
            })
        }
    }
    
    func sortedVolunteers(volunteers: [VolunteerViewModel]) -> [VolunteerViewModel] {
        volunteers.sorted{
            switch selectedSortOption {
            case .firstNameAscending :
                return $0.volunteer.firstName < $1.volunteer.firstName
            case .firstNameDescending :
                return $0.volunteer.firstName > $1.volunteer.firstName
            case .lastNameAscending :
                return $0.volunteer.lastName < $1.volunteer.lastName
            case .lastNameDescending :
                return $0.volunteer.lastName > $1.volunteer.lastName
            default:
                return $0.volunteer.firstName < $1.volunteer.firstName
            }
        }
    }
}

struct VolunteersListView_Previews: PreviewProvider {
    static var previews: some View {
        VolunteersListView()
    }
}
