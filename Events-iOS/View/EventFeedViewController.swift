//
//  EventFeedViewController.swift
//  Events-iOS
//
//  Created by Alexandre Azevedo on 21/01/21.
//

import UIKit

class EventFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView?
    private var viewModel: EventFeedViewModel?
    private let reuseIdentifier = "EventTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupViewModel() {
        viewModel = EventFeedViewModel(bindToViewController: onViewModelUpdate)
    }
    
    private func onViewModelUpdate() {
        updateErrorView()
        updateList()
    }
    
    private func updateList() {
      tableView?.reloadData()
    }
    
    private func updateErrorView() {
        guard viewModel?.error != nil else {
            return
        }
        
        let alert = UIAlertController(title: "Error", message: viewModel?.errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler:  { _ in
            self.viewModel?.onErrorConfirm()
        }))
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.events.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EventTableViewCell
        cell.setup(viewModel?.events[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let eventId = viewModel?.events[indexPath.item].eventId else { return }
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: EventDetailViewController = storyboard.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
        vc.setup(eventId)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

