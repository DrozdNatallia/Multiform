//
//  BaseTextField.swift
//  task_7
//
//  Created by Natalia Drozd on 28.01.23.
//

import UIKit

class BaseTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.borderStyle = .line
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.textColor = .white
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}
