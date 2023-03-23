//
//  FestivalDetailView.swift
//  AWI-IOS
//
//  Created by Romain on 02/03/2023.
//

import SwiftUI
import AlertToast

struct FestivalDetailView: View {
    
    @ObservedObject var vm : FestivalDetailedViewModel;
    @State var intent : FestivalIntent
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var errorMessage : String = ""
    @State private var showErrorToast : Bool = false
    
    @State private var isPresentedNewZone : Bool = false
    
    @Binding var successMessage : String
    @Binding var showSuccessToast : Bool
    
    @State private var showConfirmationDialogZone = false
    @State private var selectedId : String = ""
    
    var filters : [String] = ["Zones", "Jours"]
    @State private var selectedDisplay : String = "Zones"
    
    init(vm: FestivalViewModel, successMessage : Binding<String>, showSuccessToast: Binding<Bool>){
        self.vm = FestivalDetailedViewModel(festivalVM: vm)
        self._intent = State(initialValue: FestivalIntent(festivalVM: self._vm.wrappedValue))
        self._successMessage = successMessage
        self._showSuccessToast = showSuccessToast
    }
    
    var body: some View {
        VStack {
            switch vm.state {
            case .loading:
                LoadingView()
            case .idle :
                
                HStack {
                    Text(vm.festival.name).font(.title).bold()
                    Spacer()
                }.padding()
                
                HStack {
                    Image(systemName: "info.circle.fill")
                    Text("Informations")
                    Spacer()
                }.padding([.leading, .trailing, .top])
                VStack {
                    HStack {
                        Text("Nom :").bold()
                        Text(vm.festival.name)
                        Spacer()
                    }.padding([.leading, .top])
                    HStack {
                        Text("Nombre de zones :").bold()
                        Text("\(vm.festival.zones.count)")
                        Spacer()
                    }.padding([.leading, .top, .bottom])
                }.background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                ).padding([.leading, .trailing, .bottom])
                
                Divider()
                
                Picker(selection: $selectedDisplay, label: Text("Choisir un filtre")) {
                    ForEach(filters, id: \.self) {
                        Text($0)
                    }
                }.pickerStyle(SegmentedPickerStyle()).padding(.all)
                    
                switch selectedDisplay {
                case filters[0]:
                    ZonesListView(festivalID: vm.festival.id, successMessage: $successMessage, showSuccessToast: $showSuccessToast)
                case filters[1]:
                    HStack {
                        Spacer()
                        Button{} label: {
                            Image(systemName: "plus")
                        }
                    }.padding(.trailing)
                    List {
                        ForEach(vm.festival.days, id: \.self){
                            day in NavigationLink(value: day) {
                                VStack(alignment: .leading) {
                                    
                                    Text(DateFormatters.justDate().string(from: day.hours.opening).capitalized)
                                    
                                    HStack {
                                        Text("Ouvre à :")
                                        Text(DateFormatters.justTime().string(from: day.hours.opening))
                                    }
                                    
                                    HStack {
                                        Text("Ferme à :")
                                        Text(DateFormatters.justTime().string(from: day.hours.closing))
                                    }
                                }
                            }
                        }
                    }.navigationDestination(for: DayDetailedDTO.self){
                        day in
                        VStack(alignment: .leading) {
                            Text("Liste des créneaux").font(.title).bold().padding(.leading)
                            Text(DateFormatters.justDate().string(from: day.hours.opening).capitalized).font(.body).padding(.leading)
                            
                            List {
                                ForEach(day.slots, id: \.self){ slot in
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("Début à :")
                                            Spacer()
                                            Text(DateFormatters.justTime().string(from: slot.start))
                                        }
                                        
                                        HStack {
                                            Text("Fin à :")
                                            Spacer()
                                            Text(DateFormatters.justTime().string(from: slot.end))
                                        }
                                    }
                                }
                            }
                        }
                    }
                default:
                    CustomEmptyView()
                }
                Spacer()
            default:
                CustomEmptyView()
            }
        }
        .onAppear{
            intent.loadOne(id: vm.festival.id)
        }
//        .refreshable {
//            intent.loadOne(id: vm.festival.id)
//        }
    }
}
