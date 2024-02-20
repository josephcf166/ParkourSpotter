//
//  Markers.swift
//  ParkourApp
//
//  Created by joseph cauvy-foster on 09/12/2023.
//

import Foundation
import MapKit

struct MyAnnotationItem: Identifiable {
    var name: String = "Unnamed"
    var coordinate: CLLocationCoordinate2D
    var difficulty: String = "Unknown"
    var rating: Float = 0
    var noOfRatings: Int = 0
    var description: String = "No Description"
    var creatorUsername: String = "Unknown"
    //var imageLink: String = "https://shqrcoblvmgnuacfmkss.supabase.co/storage/v1/object/sign/Media/default.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJNZWRpYS9kZWZhdWx0LnBuZyIsImlhdCI6MTcwODI5NjU1MiwiZXhwIjozMTU1Mjc2NzYwNTUyfQ.uf4IbIg76gi7-eqmyAL3eEWZfa5MWq-aaY1ztsoWTow&t=2024-02-18T22%3A49%3A12.881Z"
    let id = UUID()
}

struct Spot: Codable & Identifiable {
    var name: String = "Unnamed"
    var latitude: Float
    var longitude: Float
    var difficulty: String = "Unknown"
    var description: String = "No Description"
    var creatorUsername: String = "Unknown"
    var imageLink: String = "https://shqrcoblvmgnuacfmkss.supabase.co/storage/v1/object/sign/Media/default.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJNZWRpYS9kZWZhdWx0LnBuZyIsImlhdCI6MTcwODI5NjU1MiwiZXhwIjozMTU1Mjc2NzYwNTUyfQ.uf4IbIg76gi7-eqmyAL3eEWZfa5MWq-aaY1ztsoWTow&t=2024-02-18T22%3A49%3A12.881Z"
    let id = UUID()
}

var annotationItems: [String: Spot] = [:]
