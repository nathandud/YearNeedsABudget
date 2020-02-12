//
//  ViewController.swift
//  YearNeedsABudget
//
//  Created by Nathan Dudley on 2/9/20.
//  Copyright © 2020 Nathan Dudley. All rights reserved.
//

import UIKit
import SnapKit

class CategoriesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let json = getJson() {
            storeJson(json)
            readJson()
        }
    }
    
    func getJson() -> Data? {
        return MockData.categoryJsonResponse
    }
    
    func storeJson(_ jsonData: Data) {
        let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("output.json")
        print(filename)
        
        do {
            try jsonData.write(to: filename, options: [.completeFileProtection, .atomic])
            print("Successfully stored JSON")
        } catch {
            print("Failed: \(error.localizedDescription)")
        }
    }
    
    func readJson()  {
        let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("output.json")
        do {
            let response = try Data(contentsOf: filename)
            let data = try JSONDecoder().decode(YnabResponse.self, from: response)
            debugPrint(data)
            print(data)
        } catch {
            print(error)
        }
    }
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

