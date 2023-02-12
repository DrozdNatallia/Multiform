//
//  Router.swift
//  task_7
//
//  Created by Natalia Drozd on 24.01.23.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: (AsselderBuildProtocol & DataPassing)? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func popToRoot()
    func openListValueController(values: Values, image: UIImage)
    
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: (AsselderBuildProtocol & DataPassing)?
    
    init(navigationController: UINavigationController, assemblyBuilder: (AsselderBuildProtocol & DataPassing)) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    // MARK: Инициализация рутового контроллера
    func initialViewController() {
        if let navigationController = self.navigationController {
            guard let homeViewController = assemblyBuilder?.createFormModule(router: self) else { return }
            navigationController.viewControllers = [homeViewController]
        }
    }
    
    // MARK: Открытие контроллера с выбором значения
    func openListValueController(values: Values, image: UIImage) {
        if let navigationController = self.navigationController {
            guard let listValueViewController = assemblyBuilder?.createListValueModule(router: self, values: values, image: image) else { return }
            navigationController.pushViewController(listValueViewController, animated: true)
        }
    }
    
    // MARK: Возвращение на рутовый контроллер
    func popToRoot() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }
}
