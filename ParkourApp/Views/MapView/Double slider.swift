//
//  Double slider.swift
//  ParkourApp
//
//  Created by joseph cauvy-foster on 26/01/2024.
//

import Foundation
import SwiftUI


struct RangeSlider: View {
    @Binding var lowerValue: Double
    @Binding var upperValue: Double
    let range: ClosedRange<Double>

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.3))
                Rectangle()
                    .frame(width: CGFloat(upperValue - lowerValue) / CGFloat(range.upperBound - range.lowerBound) * geometry.size.width)
                    .offset(x: CGFloat(lowerValue - range.lowerBound) / CGFloat(range.upperBound - range.lowerBound) * geometry.size.width)
                    .foregroundColor(Color.blue)
                HStack(spacing: 0) {
                    Slider(value: $lowerValue, in: range.lowerBound...upperValue)
                        .frame(width: geometry.size.width / 2)
                    Slider(value: $upperValue, in: lowerValue...range.upperBound)
                        .frame(width: geometry.size.width / 2)
                }
            }
        }
        .frame(height: 30)
    }
}
