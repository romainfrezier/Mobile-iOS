//
//  VolunteerDetailView.swift
//  Mobile-project-iOS
//
//  Created by Romain on 21/03/2023.
//

import SwiftUI

struct VolunteerDetailView: View {
    
    @ObservedObject var vm : VolunteerViewModel;
    @Binding var intent : VolunteerIntent
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var errorMessage : String = ""
    @State private var showErrorToast : Bool = false
    
    @Binding var successMessage : String
    @Binding var showSuccessToast : Bool
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
