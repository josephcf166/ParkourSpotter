//
//  Media.swift
//  ParkourApp
//
//  Created by joseph cauvy-foster on 27/01/2024.
//

import Foundation
import MapKit

struct Media: Encodable {
    var title: String
    var username: String = "Unknown"
    var spotName: String
    let id = UUID()
}

var media: [String: Media] = [:]
