//
//  ModuleBuilder.swift
//  task_7
//
//  Created by Natalia Drozd on 24.01.23.
//

import Foundation
import UIKit
protocol DataPassing {
    var dataStore: StoreProtocol? {get }
}

protocol AsselderBuildProtocol {
    func createFormModule(router: RouterProtocol) -> UIViewController
    func createListValueModule(router: RouterProtocol, values: Values, image: UIImage) -> UIViewController
}

class BuilderClass: AsselderBuildProtocol, DataPassing {
    // MARK: Хранит информацию переданную с контроллера с выбором значений
    var dataStore: StoreProtocol?
    
    // MARK: Настройка основного контроллера с формой
    func createFormModule(router: RouterProtocol) -> UIViewController {
        let formViewController = FormViewController()
        let networkProvaider = NetworkProvaider()
        let formModel = Info(title: "", image: "", fields: [])
        let presenter = FormPresenter(view: formViewController, router: router, provaider: networkProvaider, model: formModel, data: nil, params: [:])
        formViewController.presenter = presenter
        self.dataStore = presenter
        return formViewController
    }
    
    // MARK: Настройка контроллера с выбором значений
    func createListValueModule(router: RouterProtocol, values: Values, image: UIImage) -> UIViewController {
        let listValueVC = ListValueViewController()
        listValueVC.dataPassing = { [weak self] str in
            guard let self = self else { return }
            self.dataStore?.data = str
        }
        let model = values
        let presenter = ListValuePresenter(view: listValueVC, model: model, router: router, image: image)
        listValueVC.presenter = presenter
        return listValueVC
    }
}
