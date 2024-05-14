import Foundation

public struct CSP <V: Hashable, D> {
    let variables: [V]
    let domains: [V: [D]]
    var contraints = Dictionary<V, [Constraint<V, D>]>()
    
    public init (variable)
}
