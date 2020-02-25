//
//  CategoryAnnualProgressBarView.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/11/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import UIKit
import SnapKit

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
        bar.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.left.right.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        return bar
    }()
    
    lazy var progressBar: UIView = {
        let progress = UIView()
        progress.backgroundColor = .green
        progress.layer.cornerRadius = 10
        addSubview(progress)
        progress.snp.makeConstraints {
            $0.left.top.height.equalTo(self.backgroundBar)
            $0.width.equalTo(200)
        }
        return progress
    }()
    
    lazy var targetMarker: UIView = {
        let marker = UIView()
        marker.backgroundColor = .black
        marker.layer.cornerRadius = 0.75
        addSubview(marker)
        marker.snp.makeConstraints {
            $0.width.equalTo(1.5)
            $0.height.equalTo(30)
            $0.left.equalTo(self.backgroundBar).offset(230)
            $0.centerY.equalTo(self.backgroundBar)
        }
        return marker
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
