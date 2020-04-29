//
//  CategoryAnnualProgressBarView.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/11/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import UIKit

class ProgressBarView: UIView {
    
    let percentComplete: Double = 0.0
    let targetComplete: Double = 0.0
    
    init(frame: CGRect, percentComplete: Double, targetComplete: Double) {
        super.init(frame: frame)
    }
    
    lazy var backgroundBar: UIView = {
        let bar = UIView()
        bar.backgroundColor = .lightGray
        bar.layer.cornerRadius = 10
        
        addSubview(bar)
        bar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bar.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            bar.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 20),
            bar.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            bar.heightAnchor.constraint(equalToConstant: 20)
        ])
        return bar
    }()
    
    lazy var progressBar: UIView = {
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
    
    lazy var targetMarker: UIView = {
        let marker = UIView()
        marker.backgroundColor = .black
        marker.layer.cornerRadius = 0.75
        
        addSubview(marker)
        marker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            marker.widthAnchor.constraint(equalToConstant: 1.5),
            marker.heightAnchor.constraint(equalToConstant: 30),
            marker.leftAnchor.constraint(equalTo: backgroundBar.leftAnchor, constant: 230),
            marker.centerYAnchor.constraint(equalTo: backgroundBar.centerYAnchor)
        ])
        return marker
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
