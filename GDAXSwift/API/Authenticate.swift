//
//  Authenticate.swift
//  GDAXSwift
//
//  Created by Alexandre Barbier on 07/12/2017.
//  Copyright © 2017 Alexandre Barbier. All rights reserved.
//

import UIKit
import CryptoSwift

open class Authenticate: NSObject {
    static let client = Authenticate()
    private let queue = OperationQueue()
    private let session:URLSession

    public var CB_ACCESS_KEY = UserDefaults.standard.string(forKey: "CB_ACCESS_KEY") ?? ""
    public var CB_ACCESS_SIGN = UserDefaults.standard.string(forKey: "CB_ACCESS_SIGN") ?? ""
    public var CB_ACCESS_PASSPHRASE = UserDefaults.standard.string(forKey: "CB_ACCESS_PASSPHRASE") ?? ""

    private override init() {
        let config = URLSessionConfiguration.default
        guard CB_ACCESS_SIGN != "" else {
            fatalError("Init your credentials")
        }
        config.httpAdditionalHeaders = ["CB-ACCESS-KEY": CB_ACCESS_KEY,
                                        "CB-ACCESS-PASSPHRASE":CB_ACCESS_PASSPHRASE]

        queue.name = "authenticate_queue"
        session = URLSession(configuration: config, delegate: nil, delegateQueue: queue)
        super.init()
    }

    private func createRequest(path: String, method:String, body: String? = nil) -> URLRequest {
        var request = URLRequest(url: URL(string:"\(BASE_URL)\(path)")!)
        let timestamp = Int64(Date().timeIntervalSince1970)
        request.addValue("\(timestamp)", forHTTPHeaderField: "CB-ACCESS-TIMESTAMP")
        // create the prehash string by concatenating required parts
        let what = "\(timestamp)\(method.uppercased())\(path)\(body ?? "")".data(using: .utf8)
        let key = Data(base64Encoded:CB_ACCESS_SIGN)
        do {
            let sign = try HMAC(key: key!.bytes, variant: .sha256).authenticate(what!.bytes).toBase64()
            request.addValue(sign!, forHTTPHeaderField: "CB-ACCESS-SIGN")
        } catch {

        }

        return request
    }

    public func getAccounts(completion:@escaping (_ accounts: [Account]?,_ error:Error?) -> Void) {
        session.dataTask(with: createRequest(path: "/accounts", method: "GET")) { (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let k  = try decoder.decode([Account].self, from: data!)
                completion(k, nil)
            } catch {
                completion(nil, nil)
            }
        }.resume()
    }

    public func getAccount(accountId: String, completion:@escaping (_ account: Account?,_ error:Error?) -> Void)  {
        session.dataTask(with: createRequest(path: "/accounts/\(accountId)", method: "GET")) { (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let k  = try decoder.decode(Account.self, from: data!)
                completion(k, nil)
            } catch {
                completion(nil, nil)
            }
            }.resume()
    }

    ///accounts/<account-id>/ledger
    public func getAccountHistory(accountId: String, completion:@escaping (_ activities: [Activity]?,_ error:Error?) -> Void)  {
        session.dataTask(with: createRequest(path: "/accounts/\(accountId)/ledger", method: "GET")) { (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let k  = try decoder.decode([Activity].self, from: data!)
                completion(k, nil)
            } catch {
                completion(nil, nil)
            }
            }.resume()
    }

    public func getAccountHolds(accountId: String, completion:@escaping (_ holds: [Hold]?,_ error:Error?) -> Void)  {
        session.dataTask(with: createRequest(path: "/accounts/\(accountId)/holds", method: "GET")) { (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let k  = try decoder.decode([Hold].self, from: data!)
                completion(k, nil)
            } catch {
                completion(nil, nil)
            }
            }.resume()
    }

}
