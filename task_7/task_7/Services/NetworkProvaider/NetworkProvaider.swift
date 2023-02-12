//
//  File.swift
//  task_7
//
//  Created by Natalia Drozd on 23.01.23.
//

import Foundation

protocol NetworkProvaiderProtocol {
    func getDataFromURL (completion: @escaping (Info?) -> Void)
    func sendDataToServer(body: [String: String], completion: @escaping ([String: Any]?) -> Void)
}

final class NetworkProvaider: NetworkProvaiderProtocol {
    
    // MARK: Получение данных формы с запроса
    func getDataFromURL (completion: @escaping (Info?) -> Void) {
        if let url = URL(string: Constants.getMetaData) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
                guard self != nil else { return }
                if error != nil {
                    completion(nil)
                }
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(Info.self, from: data)
                        completion(result)
                    } catch {
                        completion(nil)
                    }
                }
            }
            task.resume()
        }
    }
    
    // MARK: Отправка данных и получение ответа с сервера
    func sendDataToServer(body: [String: String], completion: @escaping ([String: Any]?) -> Void) {
        let url = String(format: Constants.sendData)
        guard let serviceUrl = URL(string: url) else { return }
        let parameters: [String: Any] = [
            "form": body
        ]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { [weak self] (data, _, _) in
            guard self != nil else { return }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = json as? [String: Any] {
                        completion(responseJSON)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}
