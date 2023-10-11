// Recursive fib spawns many repetive branches for every call to fibRecursive
func fibRecursive(n: UInt) -> UInt {
    // Recursive functions require a base case
    if (n < 2) {
        return n
    }
    return fibRecursive(n: n - 1) + fibRecursive(n: n - 2)
}
print("Fibonacci recursive: \(fibRecursive(n: 10))")


// With memorization
var memory: [UInt: UInt] = [0: 0, 1: 1]; // Base cases
func fibMemorization(n: UInt) -> UInt {
    if let result = memory[n] { // check if base case or if already stored in memory
        return result
    } else {
        memory[n] = fibMemorization(n: n - 1) + fibMemorization(n: n - 2)
    }
    return memory[n]! // "!" force unwrap optionals is a hack
}
print("Fibonacci recursive with memorization: \(fibMemorization(n: 50))")


// Iterative
func fibIter(n: UInt) -> UInt {
    if (n == 0) { // special case
        return n
    }
    
    var last: UInt = 0, next: UInt = 1 // initiall set to fib(0) and fib(1)
    for _ in 1..<n {
        (last, next) = (next, last + next)
    }
    return next
}
print("Fibonacci iterative approach: \(fibIter(n: 10))")
