//
//  CustomCell.swift
//  BankApp
//
//  Created by Zam on 10.09.2022.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var transactionLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
