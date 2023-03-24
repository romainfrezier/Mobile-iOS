//
//  DayDetailView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 23/03/2023.
//

import SwiftUI

struct DayDetailView: View {
    
    @ObservedObject var vm : DayViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Liste des créneaux").font(.title).bold().padding(.leading)
            Text(DateFormatters.justDate().string(from: vm.day.hours.opening).capitalized).font(.body).padding(.leading)
            
            List {
                ForEach(vm.day.slots, id: \.self){ slot in
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
}
