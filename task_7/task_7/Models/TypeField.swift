//
//  TypeField.swift
//  task_7
//
//  Created by Natalia Drozd on 24.01.23.
//

import Foundation

enum TypeField {
    case text
    case list
    case numeric
    
    var description: String {
        switch self {
        case .text:
            return "TEXT"
        case .list:
            return "LIST"
        case.numeric:
            return "NUMERIC"
        }
    }
}
