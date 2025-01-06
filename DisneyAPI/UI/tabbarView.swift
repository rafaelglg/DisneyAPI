//
//  tabbarView.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 6/1/25.
//

import SwiftUI

struct tabbarView: View {
    var body: some View {
        
        TabView {
            
            Tab("Home", systemImage: "house") {
                Text("home")
            }
            
            Tab("Profile", systemImage: "person") {
                Text("Profile")
            }
        }
    }
}

#Preview {
    tabbarView()
}
