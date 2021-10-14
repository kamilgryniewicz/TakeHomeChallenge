//
//  DataProvider.swift
//  TechChallenge
//
//  Created by Kamil Gryniewicz on 12/10/2021.
//

import Foundation
final class DataProvider: ObservableObject {
    enum FilterCategory {
        case all
        case filter(TransactionModel.Category)
    }
    
    private let allTransaction: [PinnableTransaction]
    private var sums = [FilterCategory: Double]()
    private var ratios = [Double](repeating: 0.0, count: TransactionModel.Category.allCases.count)
    
    let categories: [FilterCategory]
    
    @Published
    var transactions: [PinnableTransaction]
    
    @Published
    var category: FilterCategory = .all

    @Published
    var sum: Double = 0.0
    
    init(transactions: [TransactionModel]) {
        allTransaction = transactions.map {
            PinnableTransaction(transaction: $0)
        }
        self.transactions = allTransaction
        categories = [.all] + TransactionModel.Category.allCases.map { .filter($0) }
        observeTransactions()
        calculateAllSums()
        calculateAllRatios()
        updateFilterSum()
    }
    
    func applyFilter(for category: DataProvider.FilterCategory) {
        guard category != self.category else { return }
        self.category = category
        transactions = transactions(for: category)
        updateFilterSum()
    }
    
    func sum(for category: TransactionModel.Category) -> Double {
        sum(for: .filter(category))
    }
    
    func ratio(for index: Int) -> Double {
        guard (0..<ratios.count).contains(index) else {
            return 0.0
        }
        return ratios[index]
    }
    
    private func observeTransactions() {
        transactions.forEach { transaction in
            transaction.delegate = self
        }
    }
    
    private func transactions(for category: DataProvider.FilterCategory) -> [PinnableTransaction] {
        switch category {
        case .all:
            return allTransaction
        case .filter(let category):
            return allTransaction.filter { $0.transaction.category == category }
        }
    }
    
    private func calculateAllRatios() {
        let total = sums[.all, default: 0]
        
        for (n, c) in TransactionModel.Category.allCases.enumerated() {
            ratios[n] = total > 0 ? sums[.filter(c), default: 0] / total : 0
        }
    }
    
    private func calculateAllSums() {
        TransactionModel.Category.allCases.forEach {
            calculateSum(for: $0)
        }
    }
    
    private func calculateSum(for category: TransactionModel.Category) {
        let filterCategory: FilterCategory = .filter(category)
        // Do not filter again if already filtered
        let sumTransactions = filterCategory == self.category ? transactions : transactions(for: filterCategory)
        let sum = sumTransactions.filter {
            $0.pinned
        }
        .reduce(into: 0.0) { $0 += $1.transaction.amount }
        sums[filterCategory] = sum
        updateAllSum()
    }
    
    private func updateFilterSum() {
        sum = sum(for: category)
    }
    
    private func updateAllSum() {
        sums[.all] = nil
        sums[.all] = sums.values.reduce(into: 0.0) { $0 += $1 }
    }
    
    private func sum(for category: FilterCategory) -> Double {
        sums[category, default: 0.0]
    }
}

extension DataProvider: PinnableTransactionDelegate {
    func pinDidChange(with category: TransactionModel.Category) {
        calculateSum(for: category)
        calculateAllRatios()
        updateFilterSum()
    }
}

extension DataProvider.FilterCategory: Hashable {}
