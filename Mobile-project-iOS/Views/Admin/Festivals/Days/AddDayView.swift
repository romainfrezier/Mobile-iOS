//
//  AddDayView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 24/03/2023.
//

import SwiftUI

struct AddDayView: View {
    @State private var dayName : String = ""
    @State private var selectedDate : Date = Date()
    @State private var selectedStartTime : String = "09:00"
    @State private var selectedEndTime : String = "18:00"
    @State private var opening : Date = Date()
    @State private var closing : Date = Date()
    
    @Binding var isPresentedNewDay : Bool
    @State var intent : DayIntent = DayIntent(dayVM: DayViewModel())
    @State var festivalID : String
    
    @Binding var toastMessage : String
    @State var showToast : Bool = false
    @Binding var showSuccessToast : Bool
    
    let hours = Array(stride(from: 0, to: 24, by: 1)).flatMap {
        [String(format: "%02d:00", $0), String(format: "%02d:30", $0)]
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("Annuler"){
                    self.isPresentedNewDay.toggle()
                }
                Spacer()
                Button("Enregister") {
                    if (dayName != "" && opening < closing){
                        intent.create(festivalID: self.festivalID, name: dayName, opening: opening, closing: closing)
                        self.showSuccessToast.toggle()
                        self.toastMessage = "La journée a été ajoutée avec succès !"
                        self.isPresentedNewDay.toggle()
                    } else if (dayName == ""){
                        toastMessage = "Merci de donner un nom à la journée."
                        showToast.toggle()
                    } else if (opening > closing) {
                        toastMessage = "L'ouverture doit être avant la fermeture."
                        showToast.toggle()
                    } else {
                        toastMessage = "Les champs ne sont pas correctement rempli."
                        showToast.toggle()
                    }
                }
            }.padding()
            HStack {
                Text("Ajouter un jour").font(.title).bold()
                Spacer()
            }.padding()
            Spacer().frame(height: 50)
            ZStack(alignment: .bottom) {
                HStack {
                    TextField("Nom du jour", text: $dayName)
                        .background(Color.clear)
                        .padding()
                    Image(systemName: dayName.count != 0 ? "checkmark" : "xmark")
                        .fontWeight(.bold)
                        .foregroundColor(dayName.count != 0 ? .green : .red)
                }

                Rectangle()
                    .fill(dayName == "" ? Color.red : Color.blue)
                    .frame(height: 1)
            }.padding()
            DatePicker("Sélectionnez une date", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            
            HStack {
                Text("Heure d'ouverture :")
                Picker("Ouverture", selection: $selectedStartTime) {
                    ForEach(hours, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            HStack {
                Text("Heure de fermeture :")
                Picker("Fermeture", selection: $selectedEndTime) {
                    ForEach(hours, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            Spacer()
        }.onChange(of: selectedStartTime) { _ in
            updateSelectedEndTime()
        }
        .onAppear {
            updateSelectedEndTime()
        }
    }
    
    func updateSelectedEndTime() {
        let calendar = Calendar.current
        
        let selectedStartDate = calendar.startOfDay(for: selectedDate)
        let startTimeComponents = selectedStartTime.split(separator: ":").map { Int($0)! }
        opening = calendar.date(bySettingHour: startTimeComponents[0], minute: startTimeComponents[1], second: 0, of: selectedStartDate)!
        
        let selectedEndDate = calendar.startOfDay(for: selectedDate)
        let endTimeComponents = selectedEndTime.split(separator: ":").map { Int($0)! }
        closing = calendar.date(bySettingHour: endTimeComponents[0], minute: endTimeComponents[1], second: 0, of: selectedEndDate)!
    }
}

