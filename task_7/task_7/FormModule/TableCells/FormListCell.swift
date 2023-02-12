//
//  FormListCell.swift
//  task_7
//
//  Created by Natalia Drozd on 24.01.23.
//

import UIKit

protocol FormListCellProtocol {
    func configured(title: String?)
    func ubdateButtonTitl(title: String)
}

final class FormListCell: UITableViewCell {
    static let key = "FormListCell"
    
    private lazy var title: BaseLabel = {
        let lbl = BaseLabel()
        return lbl
    }()
    
    private lazy var chooseValueButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .systemTeal
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 2
        btn.addTarget(self, action: #selector(chooseValueButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    var actionBlock: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemTeal.withAlphaComponent(0.6)
        self.addSubviews()
        self.setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addSubviews() {
        self.contentView.addSubview(self.title)
        self.contentView.addSubview(self.chooseValueButton)
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            self.title.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10),
            self.title.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.title.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            self.title.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.4),
            self.chooseValueButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10),
            self.chooseValueButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.chooseValueButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            self.chooseValueButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5)
        ])
    }
    
    @objc func chooseValueButtonTapped() {
        self.actionBlock?()
    }
    
}

extension FormListCell: FormListCellProtocol {
    
    // MARK: Настройка ячейки
    func configured(title: String?) {
        guard let title = title else { return }
        self.title.text = title
    }
    
    // MARK: Обновление кнопки после выбранного значения
    func ubdateButtonTitl(title: String) {
        self.chooseValueButton.setTitle(title, for: .normal)
    }
}
