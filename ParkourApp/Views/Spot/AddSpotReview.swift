//
//  AddSpotReview.swift
//  ParkourApp
//
//  Created by joseph cauvy-foster on 11/12/2023.
//

import SwiftUI
import MapKit

struct AddSpotReview: View {
    @Binding var spotViewState: Int
    var spotName: String
    @Binding var mapSelection: String?
    @State private var title: String = ""
    @State private var reviewBody: String = ""
    @State private var responseTime: String = ""
    @State private var timeSpent: String = ""
    @State private var rating = Float(0)
    
    var body: some View {
        ScrollView{
            VStack(alignment: .center) {
                Text("Add review for \(spotName)")
                    .fontWeight(Font.Weight.bold)
                    .font(.system(size: 26))
                    .foregroundColor(Color.textDark)
                VStack{
                    Text("Title")
                        .padding(.top)
                        .foregroundColor(Color.textLight)
                    TextField("", text: $title)
                        .padding([.bottom,.leading,.trailing])
                        .textFieldStyle(.roundedBorder)
                    
                    Text("Rating")
                        .padding(.bottom, 3)
                        .foregroundColor(Color.textLight)
                    
                    HStack{
                        RatingView(rating: $rating, isClickable: true).scaledToFit()
                            .padding(.trailing)
                        Text(String(rating))
                            .foregroundColor(Color.textLight)
                    }
                    .padding(.bottom)
                    
                    Text("Body")
                        .foregroundColor(Color.textLight)
                    TextEditor(text: $reviewBody)
                        .cornerRadius(10)
                        .frame(height: 100)
                        .padding([.leading,.trailing])
                    
                    VStack{
                        Text("Security response time if applicable")
                            .foregroundColor(Color.textLight)
                        TextField("", text: $responseTime)
                            .cornerRadius(10)
                            .padding([.leading,.trailing])
                            .textFieldStyle(.roundedBorder)
                    }.padding(.top, 4)
                    VStack{
                        Text("Time spent at spot")
                            .foregroundColor(Color.textLight)
                        TextField("", text: $timeSpent)
                            .cornerRadius(10)
                            .padding([.leading,.trailing,.bottom])
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(.top, 4)
                }
                .background(Color.primary)
                .cornerRadius(10)
                .padding([.leading,.trailing,.bottom])
                
                Spacer()
                HStack {
                    Spacer()
                    Button("Cancel", action: {spotViewState=3})
                        .buttonStyle(.bordered)
                    Spacer()
                    Button("Add", action: {
                        Task {
                            await createReview()
                        }
                    })
                        .buttonStyle(.bordered)
                    Spacer()
                }
                .padding(.bottom)
            }
            //.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    func createReview() async {
        
        var dictEntry = "\(spotName)-joemama"
        
        reviews[dictEntry] = Review(
            title: title,
            username: "joemama",
            spotName: spotName,
            rating: rating,
            body: reviewBody,
            responseTime: responseTime,
            timeSpent: timeSpent
        )

        let review = ReviewSupabase(
            title: title,
            username: "joemama",
            spotName: spotName,
            rating: rating,
            body: reviewBody,
            responseTime: responseTime,
            timeSpent: timeSpent
        )

        await insertReview(review: review)
        
        
        spotViewState = 3
        
    }
}

func insertReview(review: ReviewSupabase) async {
    do {
        // Try the asynchronous operation and wait for it to complete
        let result = try await supabase.database
            .from("Reviews")
            .insert(review)
            .execute()
        
        // Process the result if successful
        print("Review inserted successfully: \(result)")
    } catch {
        // Handle any errors
        print("An error occurred: \(error)")
    }
}


