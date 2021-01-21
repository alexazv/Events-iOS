//
//  EventCheckinViewController.swift
//  Events-iOS
//
//  Created by Alexandre Azevedo on 21/01/21.
//

import UIKit
import SwiftValidator

class EventCheckinViewController: UIViewController, ValidationDelegate {
    
    @IBOutlet weak var nameField: UITextField?
    @IBOutlet weak var emailField: UITextField?
    @IBOutlet weak var emailErrorLabel: UILabel?
    @IBOutlet weak var nameErrorLabel: UILabel?
    @IBOutlet weak var sendButton: UIButton?
    private var viewModel: EventCheckinViewModel?
    private let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupValidator()
    }

    func setup(id: String) {
        viewModel = EventCheckinViewModel(eventId: id, bindToViewController: onRequest, bindLoadingChange: onLoadingChange)
    }
    
    func setupValidator() {
        if let nameField = self.nameField {
            validator.registerField(nameField, errorLabel: nameErrorLabel, rules: [RequiredRule(message: "Campo obrigatório")])
        }
        
        if let emailField = self.emailField {
            validator.registerField(emailField, errorLabel: emailErrorLabel, rules: [RequiredRule(message: "Campo obrigatório"), EmailRule(message: "Email inválido")])
        }
        resetErrors()
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
    
    func validationSuccessful() {
        viewModel?.send(name: nameField?.text ?? "", email: emailField?.text ?? "")
    }
    
    func resetErrors() {
        for field in [nameField, emailField] {
            field?.layer.borderColor = UIColor.systemGray2.cgColor
            field?.layer.borderWidth = 0
        }
        
        for label in [nameErrorLabel, emailErrorLabel] {
            label?.text = nil;
            label?.isHidden = true
        }
    }

    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
      for (field, error) in errors {
        if let field = field as? UITextField {
            field.layer.borderColor = UIColor.systemRed.cgColor
          field.layer.borderWidth = 1.0
        }
        error.errorLabel?.text = error.errorMessage
        error.errorLabel?.isHidden = false
      }
    }
    
    @IBAction func didTapSendBtn(_ sender: Any) {
        resetErrors()
        validator.validate(self)
    }
}
