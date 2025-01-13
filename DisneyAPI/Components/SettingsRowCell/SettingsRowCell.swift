//
//  SettingsRowCell.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 13/1/25.
//

import SwiftUI

struct SettingsRowCell<Destination: View>: View {
    
    var initials: String? = ""
    var fullName: String? = ""
    var email: String? = ""
    @ViewBuilder var destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Text(initials ?? "")
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(width: 73, height: 73)
                    .background(Color(.systemGray3))
                    .clipShape(.circle)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(fullName ?? "")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(email ?? "")
                        .font(.footnote)
                        .tint(.gray)
                }
            }
        }
    }
}

#Preview("W/ all value") {
    NavigationStack {
        List {
            SettingsRowCell(initials: "RL", fullName: "Rafael Loggiodice", email: "mail@gmail.com") {
                Text("hola")
            }
        }
    }
}

#Preview("W/ name & initials") {
    NavigationStack {
        List {
            SettingsRowCell(initials: "MJ", fullName: "Michael Jackson") {
                Text("hola")
            }
        }
    }
}

#Preview("W/out value") {
    NavigationStack {
        List {
            SettingsRowCell {
                Text("hola")
            }
        }
    }
}
