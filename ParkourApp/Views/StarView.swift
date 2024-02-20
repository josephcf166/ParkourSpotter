//
//  StarView.swift
//  ParkourApp
//
//  Created by joseph cauvy-foster on 22/01/2024.
//

import SwiftUI

var pattern = [0,1,0.5]
// to hold value to stop it resetting when the star is clicked and rating is changed
var holder = [0,0]

struct StarView: View {
    var isFilled: Bool
    var isHalfFilled: Bool
    var id: Int
    var isClickable: Bool
    @Binding var rating: Float

    var body: some View {
        
        if (isClickable) {
            Button(action: {
                if (holder[0] != id) {
                    holder[1] = 0
                }
                holder[0] = id
                holder[1] += 1
                rating = Float(id) + Float(pattern[holder[1] % 3])
            }) {
                Image(systemName: isFilled ? "star.fill" : isHalfFilled ? "star.leadinghalf.filled" : "star")
                    .foregroundColor(isFilled || isHalfFilled ? .gold : .textLight)
            }
        }
        else {
            Image(systemName: isFilled ? "star.fill" : isHalfFilled ? "star.leadinghalf.filled" : "star")
                .foregroundColor(isFilled || isHalfFilled ? .gold : .textLight)
        }
    }
}

struct RatingView: View {
    @Binding var rating: Float
    var isClickable: Bool = false

    var fullStarCount: Int {
        Int(rating)
    }

    var hasHalfStar: Bool {
        rating - Float(fullStarCount) >= 0.5
    }

    var body: some View {
        HStack {
            ForEach(0..<5, id: \.self) { index in
                StarView(isFilled: index < fullStarCount, isHalfFilled: index == fullStarCount && hasHalfStar, id: index, isClickable: isClickable, rating: $rating)
            }
        }
    }
}

