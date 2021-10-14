//
//  PinnableTransaction.swift
//  TechChallenge
//
//  Created by Kamil Gryniewicz on 13/10/2021.
//

import Foundation

protocol PinnableTransactionDelegate: class {
    func pinDidChange(with category: TransactionModel.Category)
}

class PinnableTransaction: ObservableObject {
    let transaction: TransactionModel
    weak var delegate: PinnableTransactionDelegate?
    @Published
    var pinned: Bool {
        didSet {
            delegate?.pinDidChange(with: transaction.category)
        }
    }
    
    init(transaction: TransactionModel) {
        self.transaction = transaction
        self.pinned = true
    }
}

extension PinnableTransaction: Identifiable {
    var id: Int {
        transaction.id
    }
}
