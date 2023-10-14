import Foundation

enum Nucleotide: Character, Comparable {
    case A = "A", C = "C", G = "G", T = "T"
}
// An entity that implements Comparable must overide the "<" operator which can be
// done with a freestanading func or a static method inside the comparable entity
func <(lhs: Nucleotide, rhs: Nucleotide) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

typealias Codon = (Nucleotide, Nucleotide, Nucleotide)
typealias Gene = [Codon]

let geneSequence = "ACGTGGCTCTCTAACGTACGTACGTACGGGGTTTATATATACCCTAGGACTCCCTTT"
// utility function to convert string to gene
func stringToGene(_ s: String) -> Gene {
    var gene = Gene()
    for i in stride(from: 0, to: s.count, by: 3) {
        guard (i + 2) < s.count else {
            return gene
        }
        if let n1 = Nucleotide(rawValue: s[s.index(s.startIndex, offsetBy: i)]),
           let n2 = Nucleotide(rawValue: s[s.index(s.startIndex, offsetBy: i + 1)]),
           let n3 = Nucleotide(rawValue: s[s.index(s.startIndex, offsetBy: i + 2)]) {
            print(n1, n2, n3)
            gene.append((n1, n2, n3))
        }
    }
    return gene
}
let geneInQuestion = stringToGene(geneSequence);
let codonToSearchFor: Codon = (.T, .A, .C)

// Linear Search - O(n)
func linearContains(gene: Gene, codon: Codon) -> (Bool, Int) {
    let mirror = Mirror(reflecting: gene)
    for (index, child) in mirror.children.enumerated() {
        if let value = child.value as? Codon {
            
            if value == codon {
                return (true, index)
            }
        }
      
    }
    return (false, -1)
}

print(linearContains(gene: geneInQuestion, codon: codonToSearchFor))

// Binary Search - O(lg n), sorting - O(n lg n)
func binaryContains(gene: Gene, codon: Codon) -> Bool {
    var low = 0
    var high = gene.count - 1
    while low <= high {
        let mid = (low + high) / 2
        print(gene[mid])
        if gene[mid] < codon {
            low = mid + 1
        } else if gene[mid] > codon {
            high = mid - 1
        } else {
            return true
        }
    }
    return false
}

let sortedGene = geneInQuestion.sorted(by: <)
print(binaryContains(gene: sortedGene, codon: codonToSearchFor))

// Generic Functions
func linearSearch<T: Equatable>(_ array: [T], item: T) -> Bool {
    for element in array where element == item {
        return true
    }
    return false
}
print(linearSearch([1, 5, 6, 77, 22, 4, 7], item: 22))

func binarySearch<T: Comparable>(_ array: [T], item: T) -> Bool {
    var low = 0
    var high = array.count - 1
    
    while low <= high {
        let mid = (low + high) / 2
        if array[mid] < item {
            low = mid + 1
        } else if array[mid] > item {
            high = mid - 1
        } else {
            return true
        }
    }
    return false
}
print(binarySearch(["b", "a", "n", "f"], item: "n"))

