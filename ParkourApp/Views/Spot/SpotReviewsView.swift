//
//  SpotReviewsView.swift
//  ParkourApp
//
//  Created by joseph cauvy-foster on 23/01/2024.
//

import Foundation
import SwiftUI
import MapKit
    
struct SpotReviewsView: View {
    @Binding var mapSelection: String?
    @Binding var show: Bool
    @Binding var spotViewState: Int
    var item: Spot?
    @State private var reviews1: [ReviewSupabase] = [] // Assuming `Review` is your model type
    
    var body: some View {
        ScrollView{
            VStack{
                
                if (reviews1.isEmpty) {
                    Text("No Reviews :(")
                }
                else{
                    ForEach(reviews1) { review in
                        if review.spotName == item?.name {
                            // This ReviewCard will only be added to the VStack if the condition is true.
                            ReviewCard(review: review)
                        }
                    }
                }
                
                //if (reviews.isEmpty) {
                  //  Text("No Reviews :(")
                    //    .font(.headline)
                      //  .fontWeight(.bold)
                        //.font(Font.system(size: 32))
                        //.padding()
                //}
                //else {

                  //  }
                    
                    
                    //ForEach(Array(reviews.values)) { review in
                      //  if review.spotName == item?.name{
                           // ReviewCard(review: review)
                        //}
                   // }
                }
            }
            .frame(maxWidth: .infinity)
            .task{
                let result = await fetchReviewsForSpotName(spotName: item!.name)
                
                switch result {
                case .success(let reviews):
                    reviews1 = reviews
                    print("Fetched Reviews: \(reviews)")
                    
                case .failure(let error):
                    print("spot reviews")
                    print("An error occurred: \(error.localizedDescription)")
                    
                }
            }
            
        }
    }


struct ReviewCard : View {
    var review: ReviewSupabase
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack{
                Spacer()
                Text(review.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .task {
                        print(review.title)
                    }
                Spacer()
            }
            .padding(.top)
            
            HStack {
                Image(systemName: "person.crop.circle")
                    .font(.subheadline)
                    .font(Font.system(size: 16))
                        
                Text(review.username)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .font(Font.system(size: 16))
                    
                Spacer()
                        
                Image(systemName: "star.fill")
                    .foregroundColor(.gold)
                    .font(Font.system(size: 16))
                        
                Text(String(review.rating))
                    .font(Font.system(size: 16))
                
                Spacer()
                
                Image(systemName: "clock")
                    .font(Font.system(size: 16))
                    
                VStack{
                    Text(review.responseTime)
                        .font(Font.system(size: 16))
                    
                    Text("Response time")
                        .font(Font.system(size: 10))
                }
                
                VStack{
                    Text(review.timeSpent)
                        .font(Font.system(size: 16))
                    
                    Text("Time spent")
                        .font(Font.system(size: 10))
                }
            }
            .padding([.leading,.trailing])
            
            Divider()
                .background(Color.textLight)
                .padding([.leading,.trailing])

            Text(review.body)
                .padding([.trailing,.leading,.bottom])
                .frame(maxHeight: 470)
        }
        .frame(maxHeight: 220)
        .background(Color.primary)
        .cornerRadius(10)
        .padding([.top,.leading,.trailing])
        .foregroundColor(Color.textLight)
    }
    
}


func fetchReviewsForSpotName(spotName: String) async -> Result<[ReviewSupabase], Error> {
    do {
        // Execute the query
        let response = try await supabase.database
            .from("Reviews")
            .select()
            .eq("spotName", value: spotName)
            .execute()
        
        // Assuming the response data is in `response.data`
        // You will need to decode the JSON from the response data manually
        if let data: Data? = response.data {
            do {
                // Decode the data into an array of Review models
                let reviews = try JSONDecoder().decode([ReviewSupabase].self, from: data!)
                return .success(reviews)
            } catch {
                // Handle JSON decoding errors
                return .failure(error)
            }
        } else {
            // Handle the case where there's no data
            return .failure(NSError(domain: "NoData", code: 0, userInfo: nil))
        }
    } catch {
        // Handle other errors (e.g., network errors)
        return .failure(error)
    }
}
