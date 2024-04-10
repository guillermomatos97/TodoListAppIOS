//
//  ItemTableViewCell.swift
//  TodolistApp
//
//  Created by Gullermo Antonio Matos Uc on 09/04/24.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    static let identifier: String = "ItemTableViewCell"

    @IBOutlet weak var itemCheckState: UIImageView!
    @IBOutlet weak var itemLbl: UILabel!
    @IBOutlet weak var generalView: UIView!
    
    var checkState:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupUI(){
        generalView.layer.cornerRadius = 12.0
        self.selectionStyle = .none
    }
    
    func setCheckState(){
        let img = checkState ? "checkConfirmed" : "unCheckMovement"
        itemCheckState.image = UIImage(named: img)
    }
    
    func configure(item: Item){
        itemLbl.text = item.text
        checkState = item.checkState ?? false
        setCheckState()
    }
    
}
