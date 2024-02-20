//
//  getRating.swift
//  ParkourApp
//
//  Created by joseph cauvy-foster on 19/02/2024.
//

import Foundation

func getRatingFromSpot(spotName: String?) async -> Result<[Float], Error>{
    
    var output: [Float] = [0.0,0.0]
    var rating: Float = 0
    
    do {
        
        struct Rating: Decodable {
          let rating: Float
        }

        // Execute the query
        let response = try await supabase.database
            .from("Reviews")
            .select("rating")
            .eq("spotName", value: spotName ?? "bear pit")
            .execute()
        
        
        // Assuming the response data is in `response.data`
        // You will need to decode the JSON from the response data manually
        if let data: Data? = response.data {
            do {
                // Decode the data into an array of Review models
                let reviews = try JSONDecoder().decode([Rating].self, from: data!)
                for review in reviews {
                    output[1] += 1
                    rating += review.rating
                }
                if rating != 0.0 {
                    output[0] = rating / output[1]
                }

                return .success(output)
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

