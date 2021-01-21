//
//  EventTableViewCell.swift
//  Events-iOS
//
//  Created by Alexandre Azevedo on 21/01/21.
//

import AlamofireImage

import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventImage: UIImageView?
    @IBOutlet weak var label: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(_ event: Event?) {
        guard let event  = event else {
            return
        }
        label?.text = event.title;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
