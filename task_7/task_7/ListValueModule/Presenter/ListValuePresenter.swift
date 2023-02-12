//
//  ListValuePresenter.swift
//  task_7
//
//  Created by Natalia Drozd on 25.01.23.
//

import UIKit

protocol ListValueBusinessLogic {
    func fetchDataValues()
    func getValuesArray() -> [[String]]?
    func configuredListValueCell(cell: ListValueCell, row: Int)
    func closeViewController()
    
}

final class ListValuePresenter {
    private weak var view: ListValueDisplayLogic?
    private var model: Values?
    private var router: RouterProtocol?
    private var image: UIImage?
    
    required init (view: ListValueDisplayLogic, model: Values, router: RouterProtocol, image: UIImage) {
        self.view = view
        self.model = model
        self.router = router
        self.image = image
    }
    
}

extension ListValuePresenter: ListValueBusinessLogic {
    
    // MARK: Получкние массива для заполнения ячеек
    func getValuesArray() -> [[String]]? {
        do {
            let result = try self.model?.allProperties()
            return result
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    // MARK: Загрузка данных для котроллера
    func fetchDataValues() {
        guard let model = model, let image = self.image else { return }
        self.view?.displayData(model: model, image: image)
    }
    
    // MARK: Настройка ячеек
    func configuredListValueCell(cell: ListValueCell, row: Int) {
        guard let arrays = self.getValuesArray() else { return }
        let arrayValue = arrays[1]
        cell.configured(nameValue: arrayValue[row])
    }
    
    // MARK: Закрытие контроллера
    func closeViewController() {
        self.router?.popToRoot()
    }
}
