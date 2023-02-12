//
//  ViewController.swift
//  task_7
//
//  Created by Natalia Drozd on 23.01.23.
//

import UIKit

protocol FormDisplayLogic: AnyObject {
    func displayData(model: Info)
    func updateFormTable()
    func getCountCell() -> Int
    func showAlert(alert: UIAlertController)
    func setImageToImageView(image: UIImage)
}

final class FormViewController: UIViewController {
    var presenter: (FormViewBusinessLogic & StoreProtocol)?
    private lazy var formTableView: UITableView = {
        let table = UITableView()
        table.register(FormNumericCell.self, forCellReuseIdentifier: FormNumericCell.key)
        table.register(FormTextCell.self, forCellReuseIdentifier: FormTextCell.key)
        table.register(FormListCell.self, forCellReuseIdentifier: FormListCell.key)
        table.allowsSelection = false
        table.backgroundColor = .clear
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    private lazy var sendDataButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Отправить форму", for: .normal)
        btn.backgroundColor = .systemIndigo.withAlphaComponent(0.8)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 2
        btn.addTarget(self, action: #selector(sendDataButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blur.frame = self.view.bounds
        return blur
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activity.color = .white
        activity.center = self.view.center
        activity.hidesWhenStopped = true
        activity.startAnimating()
        return activity
    }()
    
    private var changeableConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.addSubviews()
        self.setConstraints()
        // MARK: Устанавливаю констрейнт, котрый меняется при появлении клавиатуры
        self.changeableConstraint = imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50)
        self.changeableConstraint.isActive = true
        // MARK: Закрытие клавиатуры по тапу в любом месте
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard)))
        self.addListeners()
        self.addLoadBackground()
        self.presenter?.fetchMetaDataFromUrl()
        
    }
    
    // MARK: Добавление фона при загрузке данных
    private func addLoadBackground() {
        self.view.addSubview(self.blurView)
        self.view.addSubview(self.activityIndicator)
    }
    
    // MARK: Удаление фона загрузки
    private func removeLoadBackground() {
        self.blurView.removeFromSuperview()
        self.activityIndicator.removeFromSuperview()
    }
    
    // MARK: Скрытие клавиатуры
    @objc private func hideKeyBoard() {
        self.view.endEditing(true)
    }
    
    // MARK: Перемещение картинки при появлении еласиатуры
    @objc private func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo
        if let kbFrameSize = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let size = kbFrameSize.cgRectValue
            self.changeableConstraint.constant = -size.height - 10
        }
    }
    
    // MARK: Возвращение картинки после закрытия клавиатуры
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.changeableConstraint.constant = -50
    }
    
    // MARK: Удаление слушателей
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.imageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05),
            self.formTableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.formTableView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.formTableView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            self.formTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
    }
    
    private func addSubviews() {
        self.view.addSubview(self.formTableView)
        self.view.addSubview(self.imageView)
    }
    
    // MARK: Слушатели для обработки событий связанных с пояалением клавиатуры
    private func addListeners() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Отправка данных на сервер
    @objc func sendDataButtonTapped() {
        self.addLoadBackground()
        UserDefaults.standard.set(true, forKey: "sendData")
        self.formTableView.reloadData()
    }
}

// MARK: UITABLEVIEWDATASOURCE
extension FormViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arrayField = self.presenter?.getFieldArray() else { return 0}
        return arrayField.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let arrayField = self.presenter?.getFieldArray() else { return UITableViewCell() }
        let type = arrayField[indexPath.row].type
        if type == TypeField.text.description {
            if let cell = self.formTableView.dequeueReusableCell(withIdentifier: FormTextCell.key) as? FormTextCell {
                self.presenter?.configureTextCell(cell: cell, row: indexPath.row)
                let text = self.presenter?.getTextFromCell(cell: cell, row: indexPath.row)
                if let type = arrayField[indexPath.row].name {
                    self.presenter?.saveParametres(type: type, text: text ?? "")
                }
                return cell
            }
        } else if type == TypeField.numeric.description {
            if let cell = self.formTableView.dequeueReusableCell(withIdentifier: FormNumericCell.key) as? FormNumericCell {
                self.presenter?.configureNumericCell(cell: cell, row: indexPath.row)
                let text = self.presenter?.getTextFromCell(cell: cell, row: indexPath.row)
                if let type = arrayField[indexPath.row].name {
                    self.presenter?.saveParametres(type: type, text: text ?? "")
                }
                return cell
            }
        } else if type == TypeField.list.description {
            if let cell = self.formTableView.dequeueReusableCell(withIdentifier: FormListCell.key) as? FormListCell {
                self.presenter?.configureListCell(cell: cell, row: indexPath.row)
                let value = self.presenter?.getListValue(value: self.presenter?.data ?? "")
                if let type = arrayField[indexPath.row].name {
                    self.presenter?.saveParametres(type: type, text: value ?? "")
                }
                cell.actionBlock = {
                    self.presenter?.openListValueVc()
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension FormViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        60
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        footerView.addSubview(self.sendDataButton)
        NSLayoutConstraint.activate([
            self.sendDataButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            self.sendDataButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            self.sendDataButton.widthAnchor.constraint(equalTo: footerView.widthAnchor),
            self.sendDataButton.heightAnchor.constraint(equalTo: footerView.heightAnchor)
        ])
        return footerView
    }
}

extension FormViewController: FormDisplayLogic {
    
    // MARK: Отображение данных на котроллере
    func displayData(model: Info) {
        guard let title = model.title, let url = model.image else { return }
        self.presenter?.getImagebyURL(url: url)
        DispatchQueue.main.async {
            self.navigationItem.title = title
            self.navigationController?.navigationBar.tintColor = .systemIndigo
            self.formTableView.reloadData()
            self.removeLoadBackground()
        }
    }
    
    // MARK: Установка картинки
    func setImageToImageView(image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
    
    func updateFormTable() {
        self.formTableView.reloadData()
    }
    
    // MARK: Получение количества ячеек
    func getCountCell() -> Int {
        self.formTableView.numberOfRows(inSection: 0)
    }
    
    // MARK: Отображение alert
    func showAlert(alert: UIAlertController) {
        DispatchQueue.main.async {
            self.removeLoadBackground()
            self.present(alert, animated: true)
        }
    }
}
