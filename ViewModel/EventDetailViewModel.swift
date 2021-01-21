//
//  EventDetailViewModel.swift
//  Events-iOS
//
//  Created by Alexandre Azevedo on 21/01/21.
//

import Foundation
import RxSwift

class EventDetailViewModel {
    private let disposeBag = DisposeBag()
    var bindToViewController: (() -> Void) = {}
    var bindLoadingChange: (() -> Void) = {}
    private var dataSource: EventDataSource = DataSource.eventDataSource()
    private (set) var error: Error?
    private (set) var event: Event?
    private (set) var loading = false {
        didSet {
            self.bindLoadingChange()
        }
    }
    var eventId: String? {
        didSet {
            fetch()
        }
    }
    
    var errorMessage: String = "There was an error retrieving info"
    
    init(bindToViewController: @escaping () -> Void, bindLoadingChange: @escaping () -> Void = {}) {
        self.bindToViewController = bindToViewController
        self.bindLoadingChange = bindLoadingChange
    }
    
    func onErrorConfirm() {
        error = nil
        fetch()
    }
    
    private func fetch() {
        guard !loading, let eventId = self.eventId else { return }
        loading = true
        error = nil
        dataSource.getEvent(id: eventId).subscribe(
            onSuccess: { event in
                self.event = event;
                self.bindToViewController();
                self.loading = false;
            }, onFailure: { error in
                self.error = error
                self.loading = false
                self.bindToViewController()
            }).disposed(by: disposeBag)
    }
}
