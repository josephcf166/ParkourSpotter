//
//  Reviews.swift
//  ParkourApp
//
//  Created by joseph cauvy-foster on 27/01/2024.
//

import Foundation
import MapKit

struct ReviewSupabase: Codable & Identifiable{
    var title: String
    var username: String = "Unknown"
    var spotName: String
    var rating: Float = 0
    var body: String = "No Body"
    var responseTime: String = "N/A"
    var timeSpent: String = "Unknown"
    let id = UUID()
}

struct ReviewSupabaseFetch: Decodable {
    let id: Float
    let title: String
    let username: String
    let spotName: String
    let rating: Float
    let body: String
    let responseTime: String
    let timeSpent: String
    let imageLink: String
}

struct Review: Identifiable {
    var title: String
    var username: String = "Unknown"
    var spotName: String
    var rating: Float = 0
    var body: String = "No Body"
    var responseTime: String = "N/A"
    var timeSpent: String = "Unknown"
    let id = UUID()
}

var reviews = [
    "bear pit-joey1" : Review(title:"Good place", username: "joey", spotName: "bear pit", rating: 4, body: "its alrigth like \nbfiebfhiewbb \nfbewibfiw bfiew fewbiuf ewh fhjew fjwe jf \newhjfewjhfjhew fhjew\n fnsajncsaj", responseTime: "2 hours", timeSpent: "30 mins"),
    "bear pit-joey2" : Review(title:"Good place", username: "joey", spotName: "bear pit", rating: 4, body: "its alrigth like \nbfiebfhiewbb \nfbewibfiw bfiew fewbiuf ewh fhjew fjwe jf \newhjfewjhfjhew fhjew\n fnsajncsaj", responseTime: "2 hours", timeSpent: "30 mins"),
    "bear pit-joey3" : Review(title:"Good place", username: "joey", spotName: "bear pit", rating: 4, body: "its alrigth like \nbfiebfhiewbb \nfbewibfiw bfiew fewbiuf ewh fhjew fjwe jf \newhjfewjhfjhew fhjew\n fnsajncsaj", responseTime: "2 hours", timeSpent: "30 mins")
    ]
