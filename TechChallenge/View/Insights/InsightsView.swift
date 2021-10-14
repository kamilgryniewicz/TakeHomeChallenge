//
//  InsightsView.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 29/7/21.
//

import SwiftUI

struct InsightsView: View {
    @ObservedObject var dataProvider: DataProvider
    
    var body: some View {
        List {
            RingView(dataProvider: dataProvider)
                .scaledToFit()
            
            ForEach(TransactionModel.Category.allCases) { category in
                HStack {
                    Text(category.rawValue)
                        .font(.headline)
                        .foregroundColor(category.color)
                    Spacer()
                    Text("$\(dataProvider.sum(for: category).formatted())")
                        .bold()
                        .secondary()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Insights")
    }
}

#if DEBUG
struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView(dataProvider: ModelData.sampleDataProvider)
            .previewLayout(.sizeThatFits)
    }
}
#endif
