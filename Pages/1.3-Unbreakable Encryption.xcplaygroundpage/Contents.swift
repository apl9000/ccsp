import Foundation

// One Time Pad (OTP) Encryption
typealias OTPKey = [UInt8]
typealias OTPKeyPair = (key1: OTPKey, key2: OTPKey)

func randomOTPKey(length: Int) -> OTPKey {
    var randomKey: OTPKey = OTPKey()
    for _ in 0..<length {
        let randomKeyPoint = UInt8(arc4random_uniform(UInt32(UInt8.max)))
        randomKey.append(randomKeyPoint)
    }
    return randomKey
}

func encryptOTP(original: String) -> OTPKeyPair {
    let dummyKey = randomOTPKey(length: original.utf8.count)
    let encryptedKey: OTPKey = dummyKey.enumerated().map { idx, val in // Lambda func
        return val ^ original.utf8[original.utf8.index(original.utf8.startIndex, offsetBy: idx)] // "^" XOR
    }
    return (dummyKey, encryptedKey)
}

func decryptOTP(keyPair: OTPKeyPair) -> String? {
    let decrypted: OTPKey = keyPair.key1.enumerated().map { idx, val in
        val ^ keyPair.key2[idx]
    }
    return String(bytes: decrypted, encoding:String.Encoding.utf8)
}

let keyPair = encryptOTP(original: "Vamos Swift!")
print(keyPair)
let decrypted = decryptOTP(keyPair: keyPair)
print(decrypted)
