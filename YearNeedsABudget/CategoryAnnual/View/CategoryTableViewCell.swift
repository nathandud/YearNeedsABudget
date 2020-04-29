//
//  CategoryAnnualTableViewCell.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 4/29/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    func configure(with viewModel: CategoryTableViewModel) {
        titleLabel.text = viewModel.name
        spentLabel.text = "\(viewModel.spentThisYear)"
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            label.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        return label
    }()
    
    private lazy var spentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            label.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        return label
    }()
    

    
}
