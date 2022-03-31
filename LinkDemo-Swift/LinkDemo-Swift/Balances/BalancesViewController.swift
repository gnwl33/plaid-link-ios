//
//  AccountBalanceViewController.swift
//  LinkDemo-Swift
//
//  Created by Gene Lee on 3/30/22.
//  Copyright © 2022 Plaid Inc. All rights reserved.
//

import UIKit

class BalancesViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var balancesManager = BalancesManager()
    var accounts: [Account] = []
    var loading = true
    var publicToken: String = "public-sandbox-8a43ce2a-e65c-4f3e-ab98-12bda53d9825"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        balancesManager.delegate = self
        balancesManager.setAccessToken(publicToken: publicToken) { result in
            switch result {
            case .success(_):
                self.balancesManager.fetchAccounts() { result in
                    switch result {
                    case .success(let accountsList):
                        self.didUpdateAccounts(accountsList)
                    case .failure(let error):
                        self.didFailWithError(error: error)
                    }
                }
            case .failure(let error):
                self.didFailWithError(error: error)
            }
        }
    }
}

extension BalancesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
    }
}

extension BalancesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loading {
            return 1
        } else {
            return accounts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if loading {
            cell.textLabel?.text = "Loading..."
            cell.detailTextLabel?.text = ""
        } else {
            let account = accounts[indexPath.row]
            cell.textLabel?.text = account.name
            let currentBalance = account.balances.current
            let currentBalanceFormatted = currentBalance != nil ? String(format: "%.2f", currentBalance!) : ""
            cell.detailTextLabel?.text = "$" + currentBalanceFormatted
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension BalancesViewController: BalancesManagerDelegate {
    func didUpdateAccounts(_ accountsList: AccountsList) {
        self.accounts += accountsList.accounts
        self.loading = false
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func didFailWithError(error: Error) {
        print(error)
    }
}
