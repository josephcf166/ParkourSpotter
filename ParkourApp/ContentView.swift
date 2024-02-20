//
//  ContentView.swift
//  ParkourApp
//
//  Created by joseph cauvy-foster on 09/12/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MapView()
                .tabItem() {
                    Image(systemName:"map.circle")
                    Text("Map")
                }
            WorkoutView()
                .tabItem() {
                    Image(systemName: "figure.run.circle")
                    Text("Workout")
                }
            ProfileView()
                .tabItem() {
                    Image(systemName:"person.circle")
                    Text("Profile")
                }
        }.accentColor(Color.primary)
    }
}

#Preview {
    ContentView()
}
