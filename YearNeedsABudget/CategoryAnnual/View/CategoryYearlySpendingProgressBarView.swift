//
//  CategoryAnnualProgressBarView.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/11/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import UIKit

class CategoryYearlySpendingProgressBarView: UIView {
    
    private let oneMonthMultipler: CGFloat = (100 / 12)
    private let percentSpent: CGFloat
    private let percentOfYear: CGFloat
    private var spendingBarWidthConstraint: NSLayoutConstraint?
    private var paceBarWidthConstraint: NSLayoutConstraint?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(percentSpent: Double, percentOfYear: Double) {
        self.percentSpent = CGFloat(percentSpent)
        self.percentOfYear = CGFloat(percentOfYear)
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundBar.backgroundColor = .lightGray
        paceBar.identifier = "paceBar"
        paceMarker.backgroundColor = .lightGray
        spendingBar.backgroundColor = percentOfYear > percentSpent ? .green : .red
        monthsStackView.backgroundColor = .clear
    }
    
    func updateProgress(percentSpent: Double, percentOfYear: Double, animated: Bool = false) {
        spendingBarWidthConstraint?.isActive = false
        spendingBarWidthConstraint = spendingBar.widthAnchor.constraint(equalTo: backgroundBar.widthAnchor, multiplier: min(CGFloat(percentSpent), 1.0))
        spendingBarWidthConstraint?.isActive = true
        spendingBar.backgroundColor = percentOfYear > percentSpent ? .green : .red
    }
    
    private lazy var backgroundBar: UIView = { [unowned self] in
        let view = UIView()
        view.layer.cornerRadius = 10
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.heightAnchor.constraint(equalToConstant: 20)
        ])
        return view
    }()
    
    private lazy var spendingBar: UIView = { [unowned self] in
        let view = UIView()
        view.layer.cornerRadius = 10
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        spendingBarWidthConstraint = view.widthAnchor.constraint(equalTo: backgroundBar.widthAnchor, multiplier: min(percentSpent, 1.0))
        spendingBarWidthConstraint?.isActive = true
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: backgroundBar.leftAnchor),
            view.topAnchor.constraint(equalTo: backgroundBar.topAnchor),
            view.heightAnchor.constraint(equalTo: backgroundBar.heightAnchor),
        ])
        return view
    }()
    
    private lazy var paceBar: UILayoutGuide = { [unowned self] in
        let guide = UILayoutGuide()
        addLayoutGuide(guide)
        paceBarWidthConstraint = guide.widthAnchor.constraint(equalTo: backgroundBar.widthAnchor, multiplier: percentOfYear)
        paceBarWidthConstraint?.isActive = true
        NSLayoutConstraint.activate([
            guide.leftAnchor.constraint(equalTo: backgroundBar.leftAnchor),
            guide.topAnchor.constraint(equalTo: backgroundBar.topAnchor),
            guide.heightAnchor.constraint(equalTo: backgroundBar.heightAnchor),
        ])
        return guide
    }()
    
    private lazy var paceMarker: UIView = { [unowned self] in
        let view = UIView()
        view.layer.cornerRadius = 1
        addSubview(view)
        sendSubviewToBack(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: paceBar.rightAnchor, constant: -1), //-1 to offset width of 2
            view.topAnchor.constraint(equalTo: backgroundBar.topAnchor, constant: -4),
            view.heightAnchor.constraint(equalTo: backgroundBar.heightAnchor, constant: 8),
            view.widthAnchor.constraint(equalToConstant: 2)
        ])
        return view
    }()
    
    private lazy var monthsStackView: UIStackView = { [unowned self] in
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
//        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
//        let months = ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"]
        let months = ["", "Feb", "", "", "May", "", "", "Aug", "", "", "Nov", ""]
//        let months = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
        for index in 0...months.count - 1 {
            let label = UILabel()
            if index != months.startIndex && index != months.endIndex - 1 {
                label.layer.borderColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 0.3).cgColor
                label.layer.borderWidth = 0.5
            }
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = .center
            label.textColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
            label.font = UIFont.systemFont(ofSize: 11)
            label.text = months[index]
            stackView.addArrangedSubview(label)
        }
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: backgroundBar.leftAnchor, constant: 5),
            stackView.rightAnchor.constraint(equalTo: backgroundBar.rightAnchor, constant: -5),
            stackView.topAnchor.constraint(equalTo: backgroundBar.topAnchor, constant: -1),
            stackView.heightAnchor.constraint(equalTo: backgroundBar.heightAnchor, constant: 2)
       ])
        return stackView
    }()
}
