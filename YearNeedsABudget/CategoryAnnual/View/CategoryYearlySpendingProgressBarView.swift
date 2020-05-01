//
//  CategoryAnnualProgressBarView.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/11/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import UIKit

class CategoryYearlySpendingProgressBarView: UIView {
    
    let percentSpent: Double
    let percentOfYear: Double
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(percentSpent: Double, percentOfYear: Double) {
        self.percentSpent = percentSpent
        self.percentOfYear = percentOfYear
        super.init(frame: .zero)
        commonInit()
    }
    
    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundBar.tag = 1
        spendingBar.tag = 2
//        paceBar.tag = 3
    }
    
    lazy var backgroundBar: UIView = { [unowned self] in
        let bar = UIView()
        bar.backgroundColor = .lightGray
        bar.layer.cornerRadius = 10
        
        addSubview(bar)
        bar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bar.heightAnchor.constraint(equalToConstant: 20)
        ])
        return bar
    }()
    
    lazy var spendingBar: UIView = { [unowned self] in
        let progress = UIView()
        progress.backgroundColor = .green
        progress.layer.cornerRadius = 10
        
        addSubview(progress)
        progress.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progress.leftAnchor.constraint(equalTo: backgroundBar.leftAnchor),
            progress.topAnchor.constraint(equalTo: backgroundBar.topAnchor),
            progress.heightAnchor.constraint(equalTo: backgroundBar.heightAnchor),
            progress.widthAnchor.constraint(equalToConstant: 100)
        ])
        return progress
    }()
    
    lazy var paceBar: UIView = { [unowned self] in
        let progress = UIView()
        progress.backgroundColor = .green
        progress.layer.cornerRadius = 10
        
        addSubview(progress)
        progress.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progress.leftAnchor.constraint(equalTo: backgroundBar.leftAnchor, constant: 230),
            progress.topAnchor.constraint(equalTo: backgroundBar.topAnchor, constant: 230),
            progress.heightAnchor.constraint(equalTo: backgroundBar.heightAnchor, constant: 230),
            progress.widthAnchor.constraint(equalToConstant: 200)
        ])
        return progress
    }()
    
}
