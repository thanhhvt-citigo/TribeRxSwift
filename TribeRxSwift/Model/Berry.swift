//
//  Berry.swift
//  TribeRxSwift
//
//  Created by thanh on 28/04/2022.
//

import Foundation

struct Berry: Codable {
    let name: String
    let url: String
}

struct BerryWrapper: Codable {
    let berry: Berry
}

struct BerryResponse: Codable {
    let berries: [BerryWrapper]
    let id: Int
}
