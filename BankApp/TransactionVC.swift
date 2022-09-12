//
//  TransactionVC.swift
//  BankApp
//
//  Created by Zam on 10.09.2022.
//

import UIKit
import RealmSwift

protocol TransactionVCDelegate: AnyObject {
    func reloadList()
}

class TransactionVC: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var newTransactionLabel: UILabel!
    @IBOutlet weak var newTransactionAmount: UITextField!
    @IBOutlet weak var newTransactionBtn: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    var delegate: TransactionVCDelegate?
    
    let realm = try! Realm()
    
    var transactionType = ""
    var balanceSum: Double = 0
    var buttonConfirmState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newTransactionAmount.delegate = self
        newTransactionAmount.becomeFirstResponder()
        backView.layer.cornerRadius = 40
        
        newTransactionLabel.text = "Enter the amount to \(transactionType)"
        newTransactionBtn.setTitle(transactionType.capitalized, for: .normal)
        
    }
    
    @IBAction func newTransactionBtnAction(_ sender: UIButton) {
        
        guard var amount = Double(newTransactionAmount.text ?? ""), amount >= 0.01 else {
            infoLabel.text = "Oops... Enter correct number"
            infoLabel.isHidden = false
            return
        }
        
        amount = round(amount * 100) / 100
        
        var type = ""
        var operation = ""
        var target = ""
        
        switch transactionType {
        case "deposit":
            if amount > 1000000 {
                infoLabel.text = "Deposits above 1 mln are alowed in the bank office only"
                infoLabel.isHidden = false
                return
            }
            type = "Income"
            operation = "Cash deposit"
            target = "Bank ATM № 088"
        case "withdraw":
            if amount > balanceSum {
                infoLabel.text = "Oops... You don't have enough balance"
                infoLabel.isHidden = false
                return
            }
            type = "Expense"
            operation = "Cash withdrawal"
            target = "Bank ATM № 015"
            amount = -amount
        case "top up":
            if amount > balanceSum {
                infoLabel.text = "Oops... You don't have enough balance"
                infoLabel.isHidden = false
                return
            }
            type = "Expense"
            operation = "Mobile top-up"
            target = "+7 888 123 45 67"
            amount = -amount
        default:
            return
        }
        
        newTransactionAmount.text = String(format: "%.2f", abs(amount))
        
        switch buttonConfirmState {
        case false:
            newTransactionLabel.text = "Please, confirm"
            infoLabel.text = "\(transactionType.capitalized) \(newTransactionAmount.text ?? "")"
            infoLabel.isHidden = false
            newTransactionAmount.isEnabled = false
            newTransactionAmount.textColor = .systemGray2
            newTransactionBtn.setTitle("Confirm", for: .normal)
            buttonConfirmState = true
            return
        case true:
            addTransaction(type: type, operation: operation, target: target, sum: amount, time: Date())
            dismiss(animated: true, completion: delegate?.reloadList)
        }
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        dismiss(animated: true)
    }

    func addTransaction(type: String, operation: String, target: String, sum: Double, time: Date) {
        let model = Model()

        model.type = type
        model.operation = operation
        model.target = target
        model.sum = sum
        model.timeAndDate = time
        
        try! realm.write {
            realm.add(model)
        }
    }
    
}

// MARK: - UITextFieldDelegate for limiting characters in UITextField

extension TransactionVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        let allowedChars = CharacterSet(charactersIn: "0123456789.")

        return newString.count <= 9 && newString.rangeOfCharacter(from: allowedChars.inverted) == nil
    }
}
