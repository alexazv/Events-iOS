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
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var date: UILabel?
    @IBOutlet weak var containerView: UIView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(_ event: Event?) {
        guard let event  = event else {
            return
        }
        titleLabel?.text = event.title
        date?.text = event.dateString
        if let url = event.imageUrl {
            eventImage?.af.setImage(withURL: url)
        }
       setupContainerView()
       selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func setupContainerView() {
        containerView?.layer.shadowOpacity = 0.5
        containerView?.layer.shadowOffset = CGSize(width: 3, height: 3)
        containerView?.layer.shadowRadius = 8.0
        containerView?.layer.shadowColor = UIColor.systemGray.cgColor
    }

}
