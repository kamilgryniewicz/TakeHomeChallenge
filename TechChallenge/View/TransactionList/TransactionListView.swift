//
//  TransactionListView.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 27/7/21.
//

import SwiftUI

struct TransactionListView: View {
    @ObservedObject var dataProvider: DataProvider
    
    var body: some View {
        VStack {
            FilterBarView(dataProvider: dataProvider)
            List {
                ForEach(dataProvider.transactions) { transaction in
                    TransactionView(config: transaction)
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Transactions")
            .animation(.easeIn)
            SumView(dataProvider: dataProvider)
                .padding(.horizontal, 10)
                .padding(.bottom, 5)
        }
    }
}

#if DEBUG
struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView(dataProvider: ModelData.sampleDataProvider)
    }
}
#endif
