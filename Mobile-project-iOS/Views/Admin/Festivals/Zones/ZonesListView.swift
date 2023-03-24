//
//  ZonesListView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 23/03/2023.
//

import SwiftUI
import AlertToast

struct ZonesListView: View {
    
    @ObservedObject var zonesListVM : ZonesListViewModel
    @State var intent : ZonesListIntent
    
    @State var festivalID : String
    
    @State private var isPresentedNewZone : Bool = false
    @State private var isPresentedUpdate : Bool = false
    
    @State private var showConfirmationDialogZone = false
    @State private var selectedId : String = ""
    @State private var selectedZone : ZoneViewModel? = nil
    
    @State var successMessage : String = ""
    @State var showSuccessToast : Bool = false
    
    init(festivalID: String) {
        self.zonesListVM = ZonesListViewModel()
        self._intent = State(initialValue: ZonesListIntent(zoneListVM: self._zonesListVM.wrappedValue))
        self.festivalID = festivalID
    }
    
    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                Button{
                    self.isPresentedNewZone.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }.padding(.trailing)
            switch zonesListVM.state {
            case .loading :
                LoadingView()
            case .idle :
                if (zonesListVM.zones.count == 0){
                    EmptyArrayPlaceholder(text: "Il n'y a pas encore de zone")
                } else {
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
                            .swipeActions(edge: .trailing) {
                                Button{
                                    self.selectedId = vm.zone.id
                                    self.showConfirmationDialogZone = true
                                } label: {
                                    Label("Supprimer", systemImage: "trash")
                                }.tint(.red)
                                Button{
                                    self.selectedZone = vm
                                    self.isPresentedUpdate.toggle()
                                } label: {
                                    Label("Modifier", systemImage: "pencil")
                                }.tint(.blue)
                            }
                        }
                        .alert(isPresented: $showConfirmationDialogZone) {
                            Alert(
                                title: Text("Supprimer une zone"),
                                message: Text("Êtes vous sûr de vouloir supprimer la zone ? Vous ne pourrez plus revenir en arrière."),
                                primaryButton: .destructive(Text("Supprimer")) {
                                    if self.selectedId != "" {
                                        intent.deleteZone(id: selectedId)
                                        successMessage = "La zone a bien été supprimé."
                                        showSuccessToast.toggle()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            intent.loadByFestival(festival: self.festivalID)
                                        }
                                    }
                                    self.selectedId = ""
                                },
                                secondaryButton: .cancel(Text("Annuler")) {
                                    self.selectedId = ""
                                }
                            )
                        }
                    }.sheet(isPresented: $isPresentedNewZone) {
                        AddZoneView(festivalID: self.festivalID, isPresentedNewZone: $isPresentedNewZone, toastMessage: $successMessage, showSuccessToast: $showSuccessToast)
                    }.sheet(isPresented: $isPresentedUpdate) {
                        if self.selectedZone != nil {
                            UpdateZoneView(vm: self.selectedZone!, isPresentedUpdateZone: $isPresentedUpdate, toastMessage: $successMessage, showSuccessToast: $showSuccessToast)
                        } else {
                            HStack {
                                Text("Veuillez rafraichir la liste des zones")
                                Image(systemName: "xmark").fontWeight(.bold).foregroundColor(.red)
                            }
                        }
                    }.toast(isPresenting: $showSuccessToast) {
                        AlertToast(displayMode: .banner(.slide), type: .complete(.green), title: successMessage, subTitle: nil, style: nil)
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
