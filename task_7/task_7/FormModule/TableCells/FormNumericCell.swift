//
//  FormNumericCell.swift
//  task_7
//
//  Created by Natalia Drozd on 24.01.23.
//

import UIKit

protocol FormNumericCellProtocol {
    func configured(title: String?, presenter: FormViewBusinessLogic)
    func getTextFromTextField() -> String?
}

final class FormNumericCell: UITableViewCell {
    static let key = "FormNumericCell"
    
    private lazy var title: BaseLabel = {
        let lbl = BaseLabel()
        return lbl
    }()
    
    private lazy var textField: BaseTextField = {
        let area = BaseTextField()
        area.delegate = self
        return area
    }()
    
    private var presenter: FormViewBusinessLogic?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemTeal.withAlphaComponent(0.6)
        self.addSubviews()
        self.setConstraint()
    }
    
    private func addSubviews() {
        self.contentView.addSubview(self.title)
        self.contentView.addSubview(self.textField)
        // MARK: Проверка введеного числа
        self.textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingDidEnd)
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            self.title.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10),
            self.title.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.title.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            self.textField.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10),
            self.textField.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.textField.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            self.textField.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Проверка введеного числа
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text, let number = Double(text) else { return }
        if number < 1 || number > 1024 {
            textField.text = ""
            self.presenter?.showAlert(message: "Число должно быть в дипазоне:\n 1 < && < 1024" )
            
        }
    }
}

extension FormNumericCell: FormNumericCellProtocol {
    // MARK: Настройка ячейки
    func configured(title: String?, presenter: FormViewBusinessLogic) {
        self.presenter = presenter
        guard let title = title else { return }
        self.title.text = title
    }
    
    // MARK: Получение введенной информации
    func getTextFromTextField() -> String? {
        guard let text = self.textField.text else { return nil }
        return text
    }
}

// MARK: UITEXTFIELDDEGATE
extension FormNumericCell: UITextFieldDelegate {
    
    // MARK: Добавление ограничений на ввод
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = "1234567890."
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        let numbers = allowedCharacterSet.isSuperset(of: typedCharacterSet)
        return numbers
        
    }
}
