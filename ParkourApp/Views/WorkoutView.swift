//
//  WorkoutView.swift
//  ParkourApp
//
//  Created by joseph cauvy-foster on 09/12/2023.
//

import SwiftUI

struct WorkoutView: View {
    var body: some View {
        ZStack {
            Color.red
            Image(systemName: "figure.run.circle")
                .foregroundColor(.white)
                .font(.system(size: 150))
        }
    }
}

#Preview {
    WorkoutView()
}
