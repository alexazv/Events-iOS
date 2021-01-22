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
    private (set) var dataSource: EventDataSource = DataSource.eventDataSource()
    private (set) var error: Error?
    private (set) var event: Event?
    var errorMessage: String = "There was an error retrieving info"
    private (set) var loading = false {
        didSet {
            self.bindLoadingChange()
        }
    }
    private (set) var eventId: String

    init(eventId: String, bindToViewController: @escaping () -> Void, bindLoadingChange: @escaping () -> Void = {}) {
        self.eventId = eventId
        self.bindToViewController = bindToViewController
        self.bindLoadingChange = bindLoadingChange
        fetch()
    }

    func onErrorConfirm() {
        error = nil
        fetch()
    }

    private func fetch() {
        guard !loading else { return }
        loading = true
        error = nil
        dataSource.getEvent(eventId: eventId).subscribe(
            onSuccess: { event in
                self.event = event
                self.bindToViewController()
                self.loading = false
            }, onFailure: { error in
                self.error = error
                self.loading = false
                self.bindToViewController()
            }).disposed(by: disposeBag)
    }
}
