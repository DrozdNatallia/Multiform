//
//  InfoModel.swift
//  task_7
//
//  Created by Natalia Drozd on 23.01.23.
//

import UIKit
struct Info: Codable {
    let title: String?
    let image: String?
    let fields: [Field]?
}

// MARK: - Field
struct Field: Codable {
    let title, name, type: String?
    let values: Values?
}

// MARK: - Values
struct Values: Codable, Loopable {
    let none, v1, v2, v3: String?
}
