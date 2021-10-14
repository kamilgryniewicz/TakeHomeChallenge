//
//  SumView.swift
//  TechChallenge
//
//  Created by Kamil Gryniewicz on 12/10/2021.
//

import SwiftUI

struct SumView: View {
    @ObservedObject
    var dataProvider: DataProvider
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(dataProvider.category.text)
                    .sumCategory(color: dataProvider.category.color)
            }
            HStack {
                Text("Total spent:")
                    .secondary()
                Spacer()
                Text("$\(dataProvider.sum.formatted())")
                    .bold()
                    .secondary()
            }
        }
        .padding()
        .overlay(
           RoundedRectangle(cornerRadius: 8)
            .stroke(Color.accentColor, lineWidth: 2.0)
            
        )
    }
}

struct SumView_Previews: PreviewProvider {
    static var previews: some View {
        SumView(dataProvider: ModelData.sampleDataProvider)
    }
}
