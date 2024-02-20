//
//  SpotDetailsView.swift
//  ParkourApp
//
//  Created by joseph cauvy-foster on 10/12/2023.
//

import SwiftUI
import MapKit
    
struct SpotDetailsView: View {
    @Binding var mapSelection: String?
    @Binding var show: Bool
    @Binding var spotViewState: Int
    var item: Spot?
    
    var body: some View {
            VStack{
                VStack(alignment: .leading, spacing: 0) {
                    
                    VStack(alignment: .leading, spacing: 5) {
                            
                        ZStack(alignment: .bottomLeading){
                            
                            Image("DefaultImage")
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                                .padding([.leading,.trailing])
                            
                            HStack (spacing:1){
                                Image(systemName: "person.crop.circle")
                                    .foregroundColor(.primary)
                                    .font(.subheadline)
                                    .padding(.leading)
                                
                                Text(item?.creatorUsername ?? "")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                            }.padding(5)
                        }
                        
                        CardView(item: item)
                            .padding([.leading,.trailing])
                        
                    }.background(Color.background)
                }.background(Color.background)
                
            }
            //.frame(width: .infinity)//, maxHeight: .infinity)
    }
}

struct CardView: View {
    let item: Spot?
    @State var rating: Float = 0.0
    @State var noOfRatings: Int = 0
    
    var body: some View {

        VStack(alignment: .leading){
            VStack(alignment: .leading){
                HStack(){
                    VStack(alignment: .leading){
                        
                        HStack(){
                            
                            RatingView(rating: $rating)
                            
                            Text("\(String(rating)) (\(noOfRatings))")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Text("Ratings")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }.padding(.leading)
                    
                    Spacer()
                    
                    VStack(alignment: .leading){
                        
                        Text(item!.difficulty)
                            .fontWeight(.medium)
                            .font(.title2)
                        
                        Text("Difficulty")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }.padding(.trailing, 10)
                }
                
                VStack{
                    Text("Description")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding()
                    
                    Text(item!.description)
                        .font(.body)
                        .padding(.leading)
                }.padding(.top,30)
                Spacer()
            }.padding([.top,.bottom], 10)
            
        }
        .background(Color.primary)
        .cornerRadius(10)
        .foregroundColor(Color.textLight)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            let result = await getRatingFromSpot(spotName: item?.name)
            
            switch result {
            case .success(let ratingList):
                rating = ratingList[0]
                noOfRatings = Int(ratingList[1])
                print("Fetched Rating data for \(String(describing: item?.name)): \(ratingList)")
                
            case .failure(let error):
                print("spot details")
                print("An error occurred: \(error.localizedDescription)")
                
            }
        }
    }
}
