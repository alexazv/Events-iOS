//
//  EventCheckinViewModel.swift
//  Events-iOS
//
//  Created by Alexandre Azevedo on 21/01/21.
//

import Foundation
import RxSwift

class EventCheckinViewModel {
    private let disposeBag = DisposeBag()
    var bindToViewController: (() -> Void) = {}
    var bindLoadingChange: (() -> Void) = {}
    private (set) var errorMessage: String = "Erro ao fazer checkin"
    private (set) var successMessage: String = "Checkin feito com sucesso"
    private (set) var dataSource: EventDataSource = DataSource.eventDataSource()
    private (set) var error: Error?
    private (set) var loading = false {
        didSet {
            self.bindLoadingChange()
        }
    }
    
    private (set) var eventId: String
    
    init(eventId: String, bindToViewController: @escaping () -> Void, bindLoadingChange: @escaping () -> Void = {}) {
        self.eventId = eventId
        self.bindLoadingChange = bindLoadingChange
        self.bindToViewController = bindToViewController
    }
    
    func send(name: String, email: String) {
        guard !loading else { return }
        loading = true
        error = nil
        dataSource.confirmEvent(id: eventId, name: name, email: email)
            .subscribe(onCompleted: {
                self.bindToViewController();
                self.loading = false;
            }, onError: { error in
                self.error = error
                self.loading = false
                self.bindToViewController()
        }).disposed(by: disposeBag)
    }
}
