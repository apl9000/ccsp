public class Stack<T>: CustomStringConvertible {
    private var container: [T] = [T]()
    public func push(_ thing: T) {  container.append(thing) }
    public func pop() -> T { return container.removeLast() }
    public var description: String { return container.description }
}

var numDiscs = 3
var towerA = Stack<Int>()
var towerB = Stack<Int>()
var towerC = Stack<Int>()

for i in 1...numDiscs {
    towerA.push(i)
}

func hanoi(from: Stack<Int>, to: Stack<Int>, temp: Stack<Int>, n: Int) {
    if n == 1{
        // base case
        to.push(from.pop())
    } else {
        hanoi(from: from, to: temp, temp: to, n: n - 1)
        hanoi(from: from, to: to, temp: temp, n: 1)
        hanoi(from: temp, to: to, temp: from, n: n - 1)
    }
}

hanoi(from: towerA, to: towerC, temp: towerB, n: numDiscs);
print(towerA)
print(towerB)
print(towerC)
hanoi(from: towerC, to: towerA, temp: towerB, n: numDiscs)
print(towerA)
print(towerB)
print(towerC)
