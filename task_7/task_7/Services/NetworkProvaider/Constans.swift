//
//  Constans.swift
//  task_7
//
//  Created by Natalia Drozd on 23.01.23.
//

import Foundation

struct Constants {
    static var baseUrl = "http://test.clevertec.ru/tt/"
    
    static var getMetaData: String {
        return baseUrl.appending("meta/")
    }
    static var sendData: String {
        return baseUrl.appending("data/")
    }
}
