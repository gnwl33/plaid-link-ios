//
//  AccountBalanceModel.swift
//  LinkDemo-Swift
//
//  Created by Gene Lee on 3/30/22.
//  Copyright © 2022 Plaid Inc. All rights reserved.
//

import Foundation

struct AccountsList: Codable {
    let accounts: [Account]
}

struct Account: Codable {
    let account_id: String
    let name: String
    let balances: Balances
    let official_name: String?
    let type: String
    let subtype: String?
    let mask: String?
}

struct Balances: Codable {
    let available: Double?
    let current: Double?
    let limit: Double?
    let iso_currency_code: String?
    let unofficial_currency_code: String?
}

struct AccessToken: Codable {
    let access_token: String
    let item_id: String
    let error: String?
}
