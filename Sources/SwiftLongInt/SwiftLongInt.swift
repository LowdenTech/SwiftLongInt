// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public class LongInt: Equatable {
    
    public var value: [Int] = [0]
    
    private var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 3
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    public init() {}
    
    @available(iOS 16.0, *)
    public init(_ value: String = "") {
        if value.wholeMatch(of: try! Regex("(^[0-9]{0,3})(,[0-9]{3})*")) != nil {
            self.value = value.split(separator: ",").reversed().map { Int($0) ?? 0 }
        }
    }
    
    public init(_ number: Int = 0) {
        guard let value = numberFormatter.string(from: NSNumber(value: number)) else { return }
        self.value = value.split(separator: ",").reversed().map { Int($0) ?? 0 }
    }
    
    public init(_ longInt: LongInt = LongInt()) {
        self.value = longInt.value
    }
    
    public func toString() -> String {
        var components = value.reversed().map { numberFormatter.string(from: NSNumber(value: $0)) ?? "000" }
        components[0] = String(Int(components[0]) ?? 0)
        return components.joined(separator: ",")
    }
    
    public subscript(index: Int) -> Int {
        get {
            value[index]
        }
        set {
            value[index] = newValue
        }
    }
    
    // MARK: - Addition
    
    public static func +(lhs: LongInt, rhs: LongInt) -> LongInt {
        let result = LongInt(lhs)
        while result.value.count < rhs.value.count {
            result.value.append(0)
        }
        for i in 0..<rhs.value.count {
            result[i] += rhs[i]
            var j = i
            while (result[j] > 999) {
                result[j] = result[j] - 1000
                if j == result.value.count - 1 {
                    result.value.append(0)
                }
                result[j+1] += 1
                j += 1
            }
        }
        return result
    }
    
    public static func +(lhs: LongInt, rhs: Int) -> LongInt {
        return lhs + LongInt(rhs)
    }
    
    public static func +(lhs: Int, rhs: LongInt) -> LongInt {
        return LongInt(lhs) + rhs
    }
    
    // MARK: - Subtraction
    
    public static func -(lhs: LongInt, rhs: LongInt) -> LongInt {
        if lhs < rhs {
            return LongInt()
        }
        let difference = LongInt(lhs)
        for i in 0..<rhs.value.count {
            if difference[i] < rhs[i] {
                var j = i
                while difference[j+1] == 0 {
                    j += 1
                }
                difference[j+1] -= 1
                if j+1 == difference.value.count - 1 && difference[j+1] == 0 {
                    difference.value.remove(at: j+1)
                }
                for _ in stride(from: j, to: i, by: -1) {
                    difference[j] = 999
                    j -= 1
                }
                difference[i] += 1000
            }
            difference[i] -= rhs[i]
            if i == difference.value.count - 1 && difference[i] == 0 {
                difference.value.remove(at: i)
            }
        }
        return difference
    }
    
    public static func -(lhs: LongInt, rhs: Int) -> LongInt {
        return lhs - LongInt(rhs)
    }
    
    public static func -(lhs: Int, rhs: LongInt) -> LongInt {
        return LongInt(lhs) - rhs
    }
    
    // MARK: - Multiplication
    
    public static func *(lhs: LongInt, rhs: LongInt) -> LongInt {
        var product = LongInt()
        let multiplicand = lhs >= rhs ? lhs : rhs
        let multiplier = lhs <= rhs ? lhs : rhs
        for i in 0..<multiplier.value.count {
            for j in 0..<multiplicand.value.count {
                let subproduct = LongInt(multiplier[i] * multiplicand[j])
                for _ in 0..<i+j {
                    subproduct.value.insert(0, at: 0)
                }
                product = product + subproduct
            }
        }
        return product
    }
    
    public static func *(lhs: LongInt, rhs: Int) -> LongInt {
        return lhs * LongInt(rhs)
    }
    
    public static func *(lhs: Int, rhs: LongInt) -> LongInt {
        return LongInt(lhs) * rhs
    }
    
    // MARK: - Division
    
    public static func /(lhs: LongInt, rhs: LongInt) -> LongInt {
        if rhs.toString() == "0" {
            fatalError("Can not divide by zero")
        }
        var quotient = LongInt()
        var dividend = lhs
        while dividend >= rhs {
            var divisor = rhs
            var multiplier = 0
            var result = 1
            while divisor * 10 <= dividend {
                divisor = divisor * 10
                multiplier += 1
            }
            var runningTotal = divisor
            while runningTotal + divisor <= dividend {
                runningTotal = runningTotal + divisor
                result += 1
            }
            quotient = quotient + (result * NSDecimalNumber(decimal: pow(10, multiplier)).intValue)
            dividend = dividend - runningTotal
        }
        return quotient
    }
    
    public static func /(lhs: LongInt, rhs: Int) -> LongInt {
        return lhs / LongInt(rhs)
    }
    
    public static func /(lhs: Int, rhs: LongInt) -> LongInt {
        return LongInt(lhs) / rhs
    }
    
    public static func ^(lhs: LongInt, rhs: Int) -> LongInt {
        var result = LongInt(lhs)
        for _ in 1..<rhs {
            result = result * lhs
        }
        return result
    }
    
    // MARK: - Equal To
    
    public static func ==(lhs: LongInt, rhs: LongInt) -> Bool {
        if lhs.value.count != rhs.value.count {
            return false
        }
        for i in 0..<lhs.value.count {
            if lhs[i] != rhs[i] {
                return false
            }
        }
        return true
    }
    
    public static func ==(lhs: LongInt, rhs: Int) -> Bool {
        return lhs == LongInt(rhs)
    }
    
    public static func ==(lhs: Int, rhs: LongInt) -> Bool {
        return LongInt(lhs) == rhs
    }
    
    // MARK: - Less Than
    
    public static func <(lhs: LongInt, rhs: LongInt) -> Bool {
        if lhs.value.count > rhs.value.count {
            return false
        }
        if lhs.value.count < rhs.value.count {
            return true
        }
        for i in stride(from: lhs.value.count - 1, through: 0, by: -1) {
            if lhs[i] > rhs[i] {
                return false
            }
            if lhs[i] < rhs[i] {
                return true
            }
        }
        return false
    }
    
    public static func <(lhs: LongInt, rhs: Int) -> Bool {
        return lhs < LongInt(rhs)
    }
    
    public static func <(lhs: Int, rhs: LongInt) -> Bool {
        return LongInt(lhs) < rhs
    }
    
    public static func <=(lhs: LongInt, rhs: LongInt) -> Bool {
        return lhs < rhs || lhs == rhs
    }
    
    public static func <=(lhs: LongInt, rhs: Int) -> Bool {
        return lhs < LongInt(rhs) || lhs == LongInt(rhs)
    }
    
    public static func <=(lhs: Int, rhs: LongInt) -> Bool {
        return LongInt(lhs) < rhs || LongInt(lhs) == rhs
    }
    
    // MARK: - Greater Than
    
    public static func >(lhs: LongInt, rhs: LongInt) -> Bool {
        if lhs.value.count < rhs.value.count {
            return false
        }
        if lhs.value.count > rhs.value.count {
            return true
        }
        for i in stride(from: lhs.value.count - 1, through: 0, by: -1) {
            if lhs[i] < rhs[i] {
                return false
            }
            if lhs[i] > rhs[i] {
                return true
            }
        }
        return false
    }
    
    public static func >(lhs: LongInt, rhs: Int) -> Bool {
        return lhs > LongInt(rhs)
    }
    
    public static func >(lhs: Int, rhs: LongInt) -> Bool {
        return LongInt(lhs) > rhs
    }
    
    public static func >=(lhs: LongInt, rhs: LongInt) -> Bool {
        return lhs > rhs || lhs == rhs
    }
    
    public static func >=(lhs: LongInt, rhs: Int) -> Bool {
        return lhs > LongInt(rhs) || lhs == LongInt(rhs)
    }
    
    public static func >=(lhs: Int, rhs: LongInt) -> Bool {
        return LongInt(lhs) > rhs || LongInt(lhs) == rhs
    }
    
}
