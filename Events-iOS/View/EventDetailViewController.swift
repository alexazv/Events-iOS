//
//  EventDetailViewController.swift
//  Events-iOS
//
//  Created by Alexandre Azevedo on 21/01/21.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    private var viewModel: EventDetailViewModel?
    @IBOutlet weak var eventImage: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var date: UILabel?
    
    func setup(_ eventId: String) {
        viewModel = EventDetailViewModel(bindToViewController: updateView)
        viewModel?.eventId = eventId;
    }
    
    private func updateView() {
        guard let event = viewModel?.event else {
            return
        }
        titleLabel?.text = event.title
        date?.text = event.dateString
        descriptionLabel?.text = event.description
        if let url = event.imageUrl {
            eventImage?.af.setImage(withURL: url)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
