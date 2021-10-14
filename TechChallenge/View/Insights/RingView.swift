//
//  RingView.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 29/7/21.
//

import SwiftUI

fileprivate typealias Category = TransactionModel.Category

struct RingView: View {
    @ObservedObject var dataProvider: DataProvider
    
    private func ratio(for categoryIndex: Int) -> Double {
        dataProvider.ratio(for: categoryIndex)
    }
    
    private func offset(for categoryIndex: Int) -> Double {
        let offset = (0..<categoryIndex).reduce(into: 0.0) { (sum, i) in
            sum += ratio(for: i)
        }
        return offset
    }

    private func gradient(for categoryIndex: Int) -> AngularGradient {
        let color = Category[categoryIndex]?.color ?? .black
        return AngularGradient(
            gradient: Gradient(colors: [color.unsaturated, color]),
            center: .center,
            startAngle: .init(
                offset: offset(for: categoryIndex),
                ratio: 0
            ),
            endAngle: .init(
                offset: offset(for: categoryIndex),
                ratio: ratio(for: categoryIndex)
            )
        )
    }
    
    private func percentageText(for categoryIndex: Int) -> String {
        let r = ratio(for: categoryIndex)
        return r > 0 ? "\((r * 100).formatted(hasDecimals: false))%" : ""
    }
    
    var body: some View {
        ZStack {
            ForEach(Category.allCases.indices) { categoryIndex in
                let currentRatio = ratio(for: categoryIndex)
                if currentRatio > 0.0 {
                    let currentOffset = offset(for: categoryIndex)
                    PartialCircleShape(
                        offset: currentOffset,
                        ratio: currentRatio
                    )
                    .stroke(
                        gradient(for: categoryIndex),
                        style: StrokeStyle(lineWidth: 28.0, lineCap: .butt)
                    )
                    .overlay(
                        PercentageText(
                            offset: currentOffset,
                            ratio: currentRatio,
                            text: percentageText(for: categoryIndex)
                        )
                    )
                    .scaleEffect(0.85)
                }
            }
        }
    }
}

extension RingView {
    struct PartialCircleShape: Shape {
        let offset: Double
        let ratio: Double
        
        func path(in rect: CGRect) -> Path {
            return Path(offset: offset, ratio: ratio, in: rect)
        }
    }
    
    struct PercentageText: View {
        let offset: Double
        let ratio: Double
        let text: String
        
        private func position(for geometry: GeometryProxy) -> CGPoint {
            let rect = geometry.frame(in: .local)
            let path = Path(offset: offset, ratio: ratio / 2.0, in: rect)
            return path.currentPoint ?? .zero
        }
        
        var body: some View {
            GeometryReader { geometry in
                Text(text)
                    .percentage()
                    .position(position(for: geometry))
            }
        }
    }
}

#if DEBUG
struct RingView_Previews: PreviewProvider {
    static var sampleRing: some View {
        ZStack {
            RingView.PartialCircleShape(offset: 0.0, ratio: 0.15)
                .stroke(
                    Color.red,
                    style: StrokeStyle(lineWidth: 28.0, lineCap: .butt)
                )
            
            RingView.PartialCircleShape(offset: 0.15, ratio: 0.5)
                .stroke(
                    Color.green,
                    style: StrokeStyle(lineWidth: 28.0, lineCap: .butt)
                )
                
            RingView.PartialCircleShape(offset: 0.65, ratio: 0.35)
                .stroke(
                    Color.blue,
                    style: StrokeStyle(lineWidth: 28.0, lineCap: .butt)
                )
        }
        .scaleEffect(0.85)
    }
    
    static var previews: some View {
        VStack {
            sampleRing
                .scaledToFit()
            
            RingView(dataProvider: ModelData.sampleDataProvider)
                .scaledToFit()
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
