//
//  TechChallengeApp.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 27/7/21.
//

import SwiftUI

@main
struct TechChallengeApp: App {
    @StateObject 
    private var dataProvider = DataProvider(transactions: ModelData.sampleTransactions)
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    TransactionListView(dataProvider: dataProvider)
                }
                .tabItem {
                    Label("Transactions", systemImage: "list.bullet")
                }
                .navigationViewStyle(StackNavigationViewStyle())
                
                NavigationView {
                    InsightsView(dataProvider: dataProvider)
                }
                .tabItem {
                    Label("Insights", systemImage: "chart.pie.fill")
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
    }
}
