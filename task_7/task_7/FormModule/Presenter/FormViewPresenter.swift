//
//  FormViewPresenter.swift
//  task_7
//
//  Created by Natalia Drozd on 24.01.23.
//

import UIKit
protocol StoreProtocol: AnyObject {
    var data: String? {get set}
}
protocol FormViewBusinessLogic {
    func fetchMetaDataFromUrl()
    func configureTextCell(cell: FormTextCellProtocol, row: Int)
    func configureListCell(cell: FormListCellProtocol, row: Int)
    func configureNumericCell(cell: FormNumericCellProtocol, row: Int)
    func getFieldArray() -> [Field]
    func openListValueVc()
    func getTextFromCell(cell: FormTextCellProtocol, row: Int ) -> String?
    func getTextFromCell(cell: FormNumericCell, row: Int ) -> String?
    func saveParametres(type: String, text: String)
    func sendDataToServer(data: [String: String])
    func getListValue(value: String) -> String?
    func getImagebyURL(url: String)
    func showAlert(message: String)
}

final class FormPresenter: StoreProtocol {
    
    private weak var view: FormDisplayLogic?
    private var router: RouterProtocol?
    private var networkProvaider: NetworkProvaiderProtocol?
    private var formViewModel: Info?
    var data: String? {
        willSet {
            self.data = newValue
            self.view?.updateFormTable()
        }
    }
    private var parametrs: [String: String]?
    
    required init (view: FormDisplayLogic, router: RouterProtocol, provaider: NetworkProvaiderProtocol, model: Info, data: String?, params: [String: String]) {
        self.view = view
        self.router = router
        self.networkProvaider = provaider
        self.formViewModel = model
        self.data = data
        self.parametrs = params
    }
}

extension FormPresenter: FormViewBusinessLogic {
    
    // MARK: Загрузка данных
    func fetchMetaDataFromUrl() {
        self.networkProvaider?.getDataFromURL(completion: { [weak self] info in
            guard let self = self else { return }
            if let info = info {
                self.formViewModel = info
                self.view?.displayData(model: info)
            }
        })
    }
    
    // MARK: Получение массива для заполнения полей
    func getFieldArray() -> [Field] {
        guard let model = formViewModel, let fields = model.fields else { return [] }
        return fields
    }
    
    // MARK: Получение картинки по урл
    func getImagebyURL(url: String) {
        if let url = URL(string: url) {
            do {
                let data = try Data(contentsOf: url)
                guard let icon = UIImage(data: data) else {return}
                self.view?.setImageToImageView(image: icon)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: Настройка ячеек
    func configureTextCell(cell: FormTextCellProtocol, row: Int) {
        guard let fields = formViewModel?.fields, let title = fields[row].title else { return }
        cell.configured(title: title)
    }
    
    func configureListCell(cell: FormListCellProtocol, row: Int) {
        guard let fields = formViewModel?.fields, let title = fields[row].title else { return }
        cell.ubdateButtonTitl(title: self.data ?? "Выбрать значение")
        cell.configured(title: title)
    }
    
    func configureNumericCell(cell: FormNumericCellProtocol, row: Int) {
        guard let fields = formViewModel?.fields, let title = fields[row].title else { return }
        cell.configured(title: title, presenter: self)
    }
    
    // MARK: Получение информации с текстовых полей
    func getTextFromCell(cell: FormTextCellProtocol, row: Int ) -> String? {
        guard let text = cell.getTextFromTextField() else { return nil }
        return text
    }
    func getTextFromCell(cell: FormNumericCell, row: Int ) -> String? {
        guard let text = cell.getTextFromTextField() else { return nil }
        return text
    }
    
    // MARK: Получение списка значений
    func getListValue(value: String) -> String? {
        guard let fields = formViewModel?.fields, let list = fields.first(where: {$0.values != nil}), let values = list.values else { return nil }
        do {
            let arrays = try values.allProperties()
            let dictionary = Dictionary(uniqueKeysWithValues: zip(arrays[0], arrays[1]))
            let res = dictionary.first(where: {$1 == value})?.key
            return res
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    // MARK: Сохранение параметров для запроса
    func saveParametres(type: String, text: String) {
        self.parametrs?[type] = text
        if UserDefaults.standard.bool(forKey: "sendData") {
            if self.parametrs?.count == self.view?.getCountCell() {
                self.sendDataToServer(data: self.parametrs ?? [:])
            }
        }
    }
    
    // MARK: Отправка данных на сервер и получение ответа
    func sendDataToServer(data: [String: String]) {
        self.networkProvaider?.sendDataToServer(body: data, completion: { [weak self] result in
            guard let self = self else { return }
            if let result = result {
                var message = ""
                result.values.forEach({message = $0 as? String ?? ""})
                self.showAlert(message: message)
            }
        })
        self.parametrs?.removeAll()
        UserDefaults.standard.set(false, forKey: "sendData")
    }
    
    // MARK: Открытик контроллера для выбора значений
    func openListValueVc() {
        guard let fields = formViewModel?.fields, let list = fields.first(where: {$0.values != nil}), let values = list.values, let url = formViewModel?.image else { return }
        DispatchQueue.global().async {
            if let url = URL(string: url) {
                do {
                    let data = try Data(contentsOf: url)
                    guard let icon = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        self.router?.openListValueController(values: values, image: icon)
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: Открытик alert с ответом
    func showAlert(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let closeButton = UIAlertAction(title: "Закрыть", style: .cancel)
        alert.addAction(closeButton)
        self.view?.showAlert(alert: alert)
    }
}
