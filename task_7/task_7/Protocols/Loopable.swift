//
//  Loopable.swift
//  task_7
//
//  Created by Natalia Drozd on 26.01.23.
//

import UIKit

protocol Loopable {
    func allProperties() throws -> [[String]]
}

extension Loopable {
    func allProperties() throws -> [[String]] {
        var result: [[String]] = [[]]
        let mirror = Mirror(reflecting: self)
        guard let style = mirror.displayStyle, style == .struct || style == .class else {
            throw NSError()
        }
        var arrayKey: [String] = []
        var arrayValue: [String] = []
        for (property, value) in mirror.children {
            if let property = property {
                if let val = value as? String {
                    arrayKey.append(property)
                    arrayValue.append(val)
                }
            }
        }
        result = [arrayKey, arrayValue]
        return result
    }
}
