//
//  ProfileView.swift
//  ParkourApp
//
//  Created by joseph cauvy-foster on 09/12/2023.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack {
            Color.green
            Image(systemName: "person.circle")
                .foregroundColor(.white)
                .font(.system(size: 150))
        }
    }
}

#Preview {
    ProfileView()
}
