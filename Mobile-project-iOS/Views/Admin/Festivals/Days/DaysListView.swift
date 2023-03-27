//
//  DaysListView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 23/03/2023.
//

import SwiftUI
import AlertToast

struct DaysListView: View {
    
    @State var intent : DaysListIntent
    @ObservedObject var daysListVM : DaysListViewModel = DaysListViewModel()
    
    @State var festivalID : String
    
    @State var selectedID : String = ""
    @State var selectedDay : DayViewModel? = nil
    @State var showConfirmationDialogDay : Bool = false
    @State var isPresentedUpdate : Bool = false
    @State var isPresentedNewDay : Bool = false
    
    @State var successMessage : String = ""
    @State var showSuccessToast : Bool = false
    
    private var listSize : Int {
        self.daysListVM.days.count
    }
    
    init(festivalID: String) {
        self._festivalID = State(initialValue: festivalID)
        self._intent = State(initialValue: DaysListIntent(daysListVM: self._daysListVM.wrappedValue))
    }
    
    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                Button{
                    self.isPresentedNewDay.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }.padding([.bottom, .trailing])
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
                                vm in NavigationLink(destination: DayDetailView(vm: vm)) {
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
                                    }.swipeActions(edge: .trailing) {
                                        Button{
                                            self.selectedID = vm.day.id
                                            self.showConfirmationDialogDay = true
                                        } label: {
                                            Label("Supprimer", systemImage: "trash")
                                        }.tint(.red)
                                        Button{
                                            self.selectedDay = vm
                                            self.isPresentedUpdate.toggle()
                                        } label: {
                                            Label("Modifier", systemImage: "pencil")
                                        }.tint(.blue)
                                    }
                                }.alert(isPresented: $showConfirmationDialogDay) {
                                    Alert(
                                        title: Text("Supprimer une zone"),
                                        message: Text("Êtes vous sûr de vouloir supprimer le jour ? Vous ne pourrez plus revenir en arrière."),
                                        primaryButton: .destructive(Text("Supprimer")) {
                                            if self.selectedID != "" {
                                                intent.delete(id: selectedID)
                                                successMessage = "Le jour a bien été supprimé."
                                                showSuccessToast.toggle()
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                    intent.load(festivalID: self.festivalID)
                                                }
                                            }
                                            self.selectedID = ""
                                        },
                                        secondaryButton: .cancel(Text("Annuler")) {
                                            self.selectedID = ""
                                        }
                                    )
                                }
                            }
                            .toast(isPresenting: $showSuccessToast) {
                                AlertToast(displayMode: .banner(.slide), type: .complete(.green), title: successMessage, subTitle: nil, style: nil)
                            } 
                        }.navigationDestination(for: DayViewModel.self){
                            vm in DayDetailView(vm: vm)
                        }
                    }
                }
                .sheet(isPresented: $isPresentedNewDay) {
                    AddDayView(isPresentedNewDay: $isPresentedNewDay, festivalID: self.festivalID, toastMessage: $successMessage, showSuccessToast: $showSuccessToast)
                }
                .sheet(isPresented: $isPresentedUpdate) {
                    if self.selectedDay != nil {
                        UpdateDayView(vm: self.selectedDay!, isPresentedUpdateDay: $isPresentedUpdate, toastMessage: $successMessage, showSuccessToast: $showSuccessToast)
                    } else {
                        HStack {
                            Text("Veuillez rafraichir la liste des jours")
                            Image(systemName: "xmark").fontWeight(.bold).foregroundColor(.red)
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
