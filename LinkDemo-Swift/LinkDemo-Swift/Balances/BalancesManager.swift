//
//  AccountBalanceManager.swift
//  LinkDemo-Swift
//
//  Created by Gene Lee on 3/30/22.
//  Copyright © 2022 Plaid Inc. All rights reserved.
//

import Foundation

protocol BalancesManagerDelegate {
    func didUpdateAccounts(_ accountsList: AccountsList)
    func didFailWithError(error: Error)
}

struct BalancesManager {
    var delegate: BalancesManagerDelegate?
    var baseUrl = "http://localhost:8000/"
    
    func setAccessToken(publicToken: String, completion: @escaping (Result<AccessToken, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)api/set_access_token") else {
            fatalError("URL guard stmt failed")
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = "public_token=\(publicToken)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }

            if let data = data {
                do {
                    let accessToken = try JSONDecoder().decode(AccessToken.self, from: data)
                    completion(.success(accessToken))
                } catch let decoderError {
                    completion(.failure(decoderError))
                }
            }
        }.resume()
    }
    
    func fetchAccounts(completion: @escaping (Result<AccountsList, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)api/balance") else {
            fatalError("URL guard stmt failed")
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }

            if let data = data {
                do {
                    let accountsList = try JSONDecoder().decode(AccountsList.self, from: data)
                    completion(.success(accountsList))
                } catch let decoderError {
                    completion(.failure(decoderError))
                }
            }
        }.resume()
    }
}

