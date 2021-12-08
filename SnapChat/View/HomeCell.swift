//
//  HomeCell.swift
//  SnapChat
//
//  Created by Tolga on 25.09.2021.
//

import UIKit

class HomeCell: UITableViewCell {
    
    
    
    @IBOutlet weak var homeUserNameLabel: UILabel!
    @IBOutlet weak var homeImageView: UIImageView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
