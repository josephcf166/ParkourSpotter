//
//  SpotMediaView.swift
//  ParkourApp
//
//  Created by joseph cauvy-foster on 23/01/2024.
//

import Foundation
import SwiftUI
import MapKit
    
struct SpotMediaView: View {
    @Binding var mapSelection: String?
    @Binding var show: Bool
    @Binding var spotViewState: Int
    var item: Spot?
    
    var body: some View {
        ScrollView{
            VStack{
                
                if (media.isEmpty) {
                    Text("No Media :(")
                        .font(.headline)
                        .fontWeight(.bold)
                        .font(Font.system(size: 32))
                        .padding()
                }
                else {
                    
                }
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
