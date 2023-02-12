//
//  ListValueCell.swift
//  task_7
//
//  Created by Natalia Drozd on 25.01.23.
//

import UIKit

protocol ListValueCellProtocol {
    func configured(nameValue: String?)
}

final class ListValueCell: UITableViewCell {
    static let key = "ListValueCell"
    
    private lazy var title: BaseLabel = {
        let lbl = BaseLabel()
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemIndigo.withAlphaComponent(0.6)
        self.addSubviews()
        self.setConstraint()
    }
    
    private func addSubviews() {
        self.contentView.addSubview(self.title)
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            self.title.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10),
            self.title.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.title.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ListValueCell: ListValueCellProtocol {
    
    // MARK: Настройка ячейки
    func configured(nameValue: String?) {
        guard let value = nameValue else { return }
        self.title.text = value
    }
}
