//
//  BaseLabel.swift
//  task_7
//
//  Created by Natalia Drozd on 28.01.23.
//

import UIKit

class BaseLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textColor = .white
        self.numberOfLines = 0
        self.font = self.font.withSize(20)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}
