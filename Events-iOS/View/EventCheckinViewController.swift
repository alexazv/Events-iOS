//
//  EventCheckinViewController.swift
//  Events-iOS
//
//  Created by Alexandre Azevedo on 21/01/21.
//

import UIKit

class EventCheckinViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField?
    @IBOutlet weak var emailField: UITextField?
    @IBOutlet weak var sendButton: UIButton?
    private var viewModel: EventCheckinViewModel?

    func setup(id: String) {
        viewModel = EventCheckinViewModel(eventId: id, bindToViewController: onRequest, bindLoadingChange: onLoadingChange)
    }
    
    // MARK: - Update
    
    private func onRequest() {
        if viewModel?.error != nil {
            updateErrorView()
        } else {
           updateSuccessView()
        }
    }

    private func onLoadingChange() {
        sendButton?.isEnabled = !(viewModel?.loading ?? true)
    }
    
    private func updateErrorView() {
        let alert = UIAlertController(title: "Erro", message: viewModel?.errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
    
    private func updateSuccessView() {
        
        let alert = UIAlertController(title: "Sucesso", message: viewModel?.successMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func didTapSendBtn(_ sender: Any) {
        guard let name = nameField?.text, let email = emailField?.text else { return }
        viewModel?.send(name: name, email: email)
    }
}
