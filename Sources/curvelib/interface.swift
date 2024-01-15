//
//  interface.swift
//  
//
//  Created by CW Lee on 13/01/2024.
//

import Foundation

public struct ECIES: Codable {
    public let iv: String
    public let ephemPublicKey: String
    public let ciphertext: String
    public let mac: String
    public let mode: String?
}
