//
//  Superbase.swift
//  ParkourApp
//
//  Created by joseph cauvy-foster on 18/02/2024.
//

import Foundation
import Supabase

let supabase = SupabaseClient(
  supabaseURL: URL(string: "https://shqrcoblvmgnuacfmkss.supabase.co")!,
  supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNocXJjb2Jsdm1nbnVhY2Zta3NzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDgyODUwMzQsImV4cCI6MjAyMzg2MTAzNH0.3H_tdhyaXqImiUWAniKz7CMifjTuacfhA28Mcudq0Uw"
)
