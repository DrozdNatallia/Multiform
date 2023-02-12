//
//  ListValueViewController.swift
//  task_7
//
//  Created by Natalia Drozd on 24.01.23.
//

import UIKit
protocol ListValueDisplayLogic: AnyObject {
    func displayData(model: Values, image: UIImage)
    
}

final class ListValueViewController: UIViewController {
    var presenter: ListValueBusinessLogic?
    private lazy var listValueTableView: UITableView = {
        let table = UITableView()
        table.register(ListValueCell.self, forCellReuseIdentifier: ListValueCell.key)
        table.rowHeight = 60
        table.backgroundColor = .clear
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var dataPassing: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(self.listValueTableView)
        self.view.addSubview(self.imageView)
        self.setConstraints()
        self.presenter?.fetchDataValues()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.listValueTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.listValueTableView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.listValueTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.listValueTableView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50),
            self.imageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05)
        ])
    }
}

extension ListValueViewController: ListValueDisplayLogic {
    
    // MARK: Отображение данных на котроллере
    func displayData(model: Values, image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
            self.listValueTableView.reloadData()
        }
    }
}

// MARK: UITABLEVIEWDATASOURCE
extension ListValueViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arrays = self.presenter?.getValuesArray() else { return 0}
        return arrays[1].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.listValueTableView.dequeueReusableCell(withIdentifier: ListValueCell.key) as? ListValueCell {
            self.presenter?.configuredListValueCell(cell: cell, row: indexPath.row)
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: UITABLEVIEWDELEGATE
extension ListValueViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let values = self.presenter?.getValuesArray() else { return }
        guard let dataPassing = dataPassing else { return }
        dataPassing(values[1][indexPath.row])
        self.presenter?.closeViewController()
    }
}
