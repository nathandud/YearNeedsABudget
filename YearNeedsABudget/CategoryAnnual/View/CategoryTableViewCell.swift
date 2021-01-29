//
//  CategoryAnnualTableViewCell.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 4/29/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    private var viewModel: CategoryTableViewModel?
    
    func configure(with viewModel: CategoryTableViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.nameLabelText
        spentLabel.text = viewModel.spentThisYearLabelText
        progressView.updateProgress(percentSpent: viewModel.percentSpent, percentOfYear: viewModel.percentOfYear)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel = nil
    }
    
    private lazy var titleLabel: UILabel = { [unowned self] in
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            label.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        return label
    }()
    
    private lazy var spentLabel: UILabel = { [unowned self] in
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            label.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        return label
    }()
    
    private lazy var progressView: CategoryYearlySpendingProgressBarView = { [unowned self] in
        let spent = self.viewModel?.percentSpent ?? 0.0
        let elapsed = self.viewModel?.percentOfYear ?? 0
        
        let progressBar = CategoryYearlySpendingProgressBarView(percentSpent: spent, percentOfYear: elapsed)
        addSubview(progressBar)
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            progressBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            progressBar.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 20),
            progressBar.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        return progressBar
    }()

    
}
