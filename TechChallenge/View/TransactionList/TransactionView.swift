//
//  TransactionView.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 27/7/21.
//

import SwiftUI

struct TransactionView: View {
    @ObservedObject var config: PinnableTransaction
    
    var body: some View {
        VStack {
            HStack {
                Text(config.transaction.category.rawValue)
                    .font(.headline)
                    .foregroundColor(config.transaction.category.color)
                Spacer()
                Button(action: {
                    config.pinned.toggle()
                }, label: {
                    config.pinImage
                })
                .buttonStyle(PlainButtonStyle())
            }
            if config.pinned {
                HStack {
                    config.transaction.image
                        .resizable()
                        .frame(
                            width: 60.0,
                            height: 60.0,
                            alignment: .top
                        )
                    
                    VStack(alignment: .leading) {
                        Text(config.transaction.name)
                            .secondary()
                        Text(config.transaction.accountName)
                            .tertiary()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("$\(config.transaction.amount.formatted())")
                            .bold()
                            .secondary()
                        Text(config.transaction.date.formatted)
                            .tertiary()
                    }
                }
            }
        }
        .padding(8.0)
        .background(Color.accentColor.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8.0))
    }
}

#if DEBUG
struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        
        VStack {
            TransactionView(config: ModelData.sampleDataProvider.transactions[0])
            TransactionView(config: ModelData.sampleDataProvider.transactions[1])
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
