//
//  SampleModel.swift
//  doFavor
//
//  Created by Phakkharachate on 16/3/2565 BE.
//

import Foundation

struct SampleData: Codable {
    let keys: [SampleModel]
}

struct SampleModel: Codable {
    let name: String
    let description: String
}
