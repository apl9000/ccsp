func calculatePi(nTerms: UInt) -> Double {
    let numerator: Double = 4
    var denominator: Double = 1
    var operation: Double = -1
    var pi: Double = 0
    
    for _ in 0..<nTerms {
        pi += operation * (numerator / denominator)
        denominator += 2
        operation *= -1
    }
    return abs(pi)
}
print(calculatePi(nTerms: 5))
print(calculatePi(nTerms: 10))
print(calculatePi(nTerms: 20))
print(calculatePi(nTerms: 40))
print(calculatePi(nTerms: 100))
