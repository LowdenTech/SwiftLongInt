import XCTest
import Foundation
@testable import SwiftLongInt

final class SwiftLongIntTests: XCTestCase {
    
    private var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest
        
        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }
    
    func testAddition() throws {
        let iterations = 1000000
        for i in 0..<iterations {
            print(i)
            XCTAssertEqual((LongInt(i) + LongInt(iterations - i)).toString(), numberFormatter.string(from: NSNumber(value: i + (iterations - i))))
        }
    }
    
    func testSubtraction() throws {
        let iterations = 1000000
        for i in 0..<iterations {
            print(i)
            XCTAssertEqual((LongInt(iterations) - LongInt(i)).toString(), numberFormatter.string(from: NSNumber(value: (iterations) - i)))
        }
    }
    
    func testMultiplication() throws {
        let iterations = 1000
        for i in 0...iterations {
            for j in 0...iterations {
                print("\(i)  \(j)")
                XCTAssertEqual((LongInt(i) * LongInt(j)).toString(), numberFormatter.string(from: NSNumber(value: i * j)))
            }
        }
    }
    
    func testDivision() throws {
        let iterations = 1000
        for i in 1...iterations {
            for j in 1...iterations {
                print("\(i)  \(j)")
                XCTAssertEqual((LongInt(i) / LongInt(j)).toString(), numberFormatter.string(from: NSNumber(value: i / j)))
            }
        }
    }
    
    func testDivideByZero() throws {
        XCTAssertThrowsError(LongInt(1) / LongInt(0))
    }
    
    func testComparitors() throws {
        let iterations = 1000
        for i in 0...iterations {
            for j in 0...iterations {
                print("\(i)  \(j)")
                XCTAssertEqual(LongInt(i) > LongInt(j),  i > j)
                XCTAssertEqual(LongInt(i) >= LongInt(j),  i >= j)
                XCTAssertEqual(LongInt(i) < LongInt(j),  i < j)
                XCTAssertEqual(LongInt(i) <= LongInt(j),  i <= j)
                XCTAssertEqual(LongInt(i) == LongInt(j),  i == j)
            }
        }
    }
    
}
