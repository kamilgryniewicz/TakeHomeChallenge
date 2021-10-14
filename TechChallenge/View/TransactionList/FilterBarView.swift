//
//  FilterBarView.swift
//  TechChallenge
//
//  Created by Kamil Gryniewicz on 11/10/2021.
//

import SwiftUI



struct FilterBarView: View {
    let dataProvider: DataProvider
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(dataProvider.categories, id: \.self) {
                    filterButton($0)
                }                
            }
            .padding()
        }
        .background(Color.accentColor)
        .opacity(0.8)
    }
    
    @ViewBuilder
    private func filterButton(_ category: DataProvider.FilterCategory) -> some View {
        Button(action: {
            dataProvider.applyFilter(for: category)
        }, label: {
            Text(category.text)
                .filter()
        })
        .filter(color: category.color)
    }
}

struct FilterBarView_Previews: PreviewProvider {
    static var previews: some View {
        FilterBarView(dataProvider: ModelData.sampleDataProvider)
    }
}
