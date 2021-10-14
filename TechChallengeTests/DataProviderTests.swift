//
//  DataProviderTests.swift
//  TechChallengeTests
//
//  Created by Kamil Gryniewicz on 14/10/2021.
//

import XCTest
@testable import TechChallenge

final class DataProviderTests: XCTestCase {
    
    var sut: DataProvider!
    
    override func setUpWithError() throws {
        sut = makeSUT()
    }

    // MARK: - Initialisation
    func test_init_filterCategoryShouldBeAll() {
        XCTAssertEqual(sut.category, .all)
    }
    
    func test_init_filterSumShouldBeCorrect() {
        XCTAssertEqual(sut.sum.rounded(to: 2), 472.08)
    }
    
    func test_init_transactionsCountShouldBeCorrect() {
        XCTAssertEqual(sut.transactions.count, 13)
    }
    
    func test_init_filterCategoriesCountShouldBeCorrect() {
        // given
        let expectation = TransactionModel.Category.allCases.count + 1
        // then
        XCTAssertEqual(sut.categories.count, expectation)
    }
    
    func test_init_transactionsHasDelegate() {
        for t in sut.transactions {
            XCTAssertNotNil(t.delegate)
        }
    }
    
    func test_init_calculatesAllSumsAsExpected() {
        // given
        let expectations: [TransactionModel.Category: Double] = [ .food : 74.28,
                                                                  .health: 21.53,
                                                                  .entertainment: 82.99,
                                                                  .shopping: 78.00,
                                                                  .travel: 215.28]
        // then
        for (key, value) in expectations {
            XCTAssertEqual(sut.sum(for: key), value)
        }
    }
    
    func test_init_calculatesAllRatiosAsExpected() {
        // given
        let expectations = [0.1573, 0.0456, 0.1758, 0.1652, 0.4560]
        // then
        for (i, value) in expectations.enumerated() {
            XCTAssertEqual(sut.ratio(for: i).rounded(to: 4), value)
        }
    }
    
    // MARK: - Filter
    // Filtering of transactions according to category
    // Sum of transaction amounts for filtered category
    func test_filter_categoryTransactionsCalculatesSumAsExpected() {
        // given
        let expectations: [TransactionModel.Category: Double] = [.food : 74.28,
                                                                 .health: 21.53,
                                                                 .entertainment: 82.99,
                                                                 .shopping: 78.00,
                                                                 .travel: 215.28]
        for (key, value) in expectations {
            let filterCategory: DataProvider.FilterCategory = .filter(key)
            // when
            sut.applyFilter(for: filterCategory)
            // then
            XCTAssertEqual(sut.sum, value)
            XCTAssertEqual(sut.category, filterCategory)
            sut.transactions.forEach {
                XCTAssertEqual($0.transaction.category, key)
            }
        }
    }
    
    // MARK: - Pinning integration
    func test_unpinTransaction_sumAndRatioShouldBeUpdated() {
        // given
        let t = sut.transactions.first!
        let expectedSum = (sut.sum - t.transaction.amount).rounded(to: 2)
        let ratioIndex = 2
        let expectedRatio = 0.0
        // when
        t.pinned.toggle()
        // then
        XCTAssertFalse(t.pinned)
        let updatedSum = sut.sum.rounded(to: 2)
        XCTAssertEqual(updatedSum, expectedSum)
        let updatedRatio = sut.ratio(for: ratioIndex).rounded(to: 4)
        XCTAssertEqual(updatedRatio, expectedRatio)
        //
    }
    
    func test_unpinAndPinTransaction_sumAndRatioShouldBeUnchanged() {
        // given
        let t = sut.transactions.last!
        let expectedSum = sut.sum.rounded(to: 2)
        let ratioIndex = 4
        let expectedRatio = sut.ratio(for: ratioIndex).rounded(to: 4)
        // when
        t.pinned.toggle()
        t.pinned.toggle()
        // then
        XCTAssertTrue(t.pinned)
        let updatedSum = sut.sum.rounded(to: 2)
        XCTAssertEqual(updatedSum, expectedSum)
        let updatedRatio = sut.ratio(for: ratioIndex).rounded(to: 4)
        XCTAssertEqual(expectedRatio, updatedRatio)
    }
    
    private func makeSUT() -> DataProvider {
        DataProvider(transactions: TestModelData.sampleTransactions)
    }
}

extension Double {
    func rounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
