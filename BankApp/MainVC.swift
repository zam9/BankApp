//
//  MainVC.swift
//  BankApp
//
//  Created by Zam on 10.09.2022.
//

import UIKit
import RealmSwift

class MainVC: UIViewController {

    @IBOutlet weak var transactionList: UITableView!
    @IBOutlet weak var balance: UILabel!
    
    let realm = try! Realm()
    var balanceSum: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//       print(realm.configuration.fileURL as Any)
        
        transactionList.delegate = self
        transactionList.dataSource = self
        
        showBalance()
    }
    
    func showBalance() {
        balanceSum = realm.objects(Model.self).sum(ofProperty: "sum")
        balance.text = "$" + String(format: "%.2f", balanceSum)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC = segue.destination as? TransactionVC {
            nextVC.transactionType = segue.identifier ?? ""
            nextVC.balanceSum = balanceSum
            nextVC.delegate = self
        }
    }
}

// MARK: - TransactionVCDelegate

extension MainVC: TransactionVCDelegate {
    func reloadList() {
        transactionList.reloadData()
        showBalance()
    }
}

// MARK: - TableViewDelegate & TableViewDataSource

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realm.objects(Model.self).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        let transaction = realm.objects(Model.self).sorted(byKeyPath: "timeAndDate", ascending: false).sorted(byKeyPath: "type")
        
        let operation = transaction[indexPath.row].operation
        let target = transaction[indexPath.row].target
        let time = transaction[indexPath.row].timeAndDate
        let sum = transaction[indexPath.row].sum
        
        cell.transactionLabel.text = operation
        cell.targetLabel.text = target
        cell.timeLabel.text = time.formatted()
        cell.amountLabel.text = (sum < 0 ? "- $" : "+ $") + String(format: "%.2f", abs(sum))
        cell.amountLabel.textColor = sum < 0 ? .systemRed : .systemGreen
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Latest transactions"
    }

}
