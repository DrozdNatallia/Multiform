//
//  FormTableCell.swift
//  task_7
//
//  Created by Natalia Drozd on 24.01.23.
//

import UIKit

protocol FormTextCellProtocol {
    func configured(title: String?)
    func getTextFromTextField() -> String?
}

final class FormTextCell: UITableViewCell {
    static let key = "FormTextCell"
    
    private lazy var title: BaseLabel = {
        let lbl = BaseLabel()
        return lbl
    }()
    
    private lazy var textField: BaseTextField = {
        let area = BaseTextField()
        area.delegate = self
        return area
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemTeal.withAlphaComponent(0.6)
        self.addSubviews()
        self.setConstraint()
    }
    
    private func addSubviews() {
        self.contentView.addSubview(self.title)
        self.contentView.addSubview(self.textField)
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
    
}

extension FormTextCell: FormTextCellProtocol {
    // MARK: Настройка ячейки
    func configured(title: String?) {
        guard let title = title else { return }
        self.title.text = title
    }
    
    // MARK: Получение введенного ответа
    func getTextFromTextField() -> String? {
        guard let text = self.textField.text else { return nil }
        return text
    }  
}

// MARK: UITEXTFIELDDELEGATE
extension FormTextCell: UITextFieldDelegate {
    
    // MARK: Установка ограничений на ввод
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var allowedCharacters = "abcdefghijklmnopqrstuvwxyzйцукенгшщзхъфывапролджэёячсмитьбю"
        allowedCharacters = allowedCharacters + allowedCharacters.uppercased()
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
        return alphabet
    }
}
