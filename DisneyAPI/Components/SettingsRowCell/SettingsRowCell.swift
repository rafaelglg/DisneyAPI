//
//  SettingsRowCell.swift
//  DisneyAPI
//
//  Created by Rafael Loggiodice on 13/1/25.
//

import SwiftUI

struct SettingsRowCell<Destination: View>: View {
    
    var profilePicture: String? = ""
    var initials: String? = ""
    var fullName: String? = ""
    var email: String? = ""
    var destination: Destination?
    
    init(
        profilePicture: String? = "",
        initials: String? = "",
        fullName: String? = "",
        email: String? = "",
        destination: (() -> Destination)? = nil
    ) {
        self.profilePicture = profilePicture
        self.initials = initials
        self.fullName = fullName
        self.email = email
        self.destination = destination?()
    }
    
    var body: some View {
        
        if let destination {
            NavigationLink(destination: destination) {
                HStack {
                    profilePictureSection
                    
                    VStack(alignment: .leading, spacing: 5) {
                        fullNameSection
                        emailSection
                    }
                }
            }
        } else {
            HStack {
                profilePictureSection
                
                VStack(alignment: .leading, spacing: 5) {
                    fullNameSection
                    emailSection
                }
            }
        }
    }
    
    @ViewBuilder
    var profilePictureSection: some View {
        
        if let profilePicture = profilePicture, !profilePicture.isEmpty {
            AsyncImage(url: URL(string: profilePicture)) { image in
                image.resizable()
                    .frame(width: 73, height: 73)
                    .clipShape(.circle)
            } placeholder: {
                Circle()
                    .frame(width: 73, height: 73)
                    .redacted(reason: .placeholder)
            }
        } else {
            Text(initials ?? "")
                .font(.title)
                .fontWeight(.semibold)
                .frame(width: 73, height: 73)
                .background(Color(.systemGray3))
                .clipShape(.circle)
        }
    }
    
    var fullNameSection: some View {
        Text(fullName ?? "")
            .font(.subheadline)
            .fontWeight(.semibold)
    }
    
    var emailSection: some View {
        Text(email ?? "")
            .font(.footnote)
            .tint(.gray)
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

#Preview("W/ profilePicture") {
    @Previewable @State var url: String = ""
    
    return NavigationStack {
        List {
            SettingsRowCell(profilePicture: url, initials: "MJ", fullName: "Michael Jackson")
                .task {
                    try? await Task.sleep(for: .seconds(2))
                    url = "https://lh3.googleusercontent.com/a/ACg8ocLgqtxHCq5PLnzKWGPoBhTzhSyeBvHjwfBw80F4M_E9OVAJqw=s96-c"
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

#Preview("W/out navigation") {
    NavigationStack {
        List {
            SettingsRowCell(initials: "RL", fullName: "Rafael Loggiodice", email: "mail@gmail.com")
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

/// Add this extension to have the posibility when the destination is nil to not have it as parameter when initialize
extension SettingsRowCell where Destination == EmptyView {
    init(
        profilePicture: String? = "",
        initials: String? = "",
        fullName: String? = "",
        email: String? = ""
    ) {
        self.profilePicture = profilePicture
        self.initials = initials
        self.fullName = fullName
        self.email = email
    }
}
