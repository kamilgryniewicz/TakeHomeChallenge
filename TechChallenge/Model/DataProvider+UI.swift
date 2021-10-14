//
//  DataProvider+UI.swift
//  TechChallenge
//
//  Created by Kamil Gryniewicz on 12/10/2021.
//

import SwiftUI

extension DataProvider.FilterCategory {
    var text: String {
        switch self {
        case .all:
            return "all"
        case .filter(let category):
            return category.rawValue
        }
    }
    
    var color: Color {
        switch self {
        case .all:
            return .black
        case .filter(let category):
            return category.color
        }
    }
}
