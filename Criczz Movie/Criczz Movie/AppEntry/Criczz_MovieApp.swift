//
//  Criczz_MovieApp.swift
//  Criczz Movie
//
//  Created by Santhosh G Patkar on 04/10/25.
//

import SwiftUI

@main
struct Criczz_MovieApp: App {
    let dependencies = AppDependencies.live()
    var body: some Scene {
        WindowGroup {
            ContentView(dependencies: dependencies)
        }
    }
}
