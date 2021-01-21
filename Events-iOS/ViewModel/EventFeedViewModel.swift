//
//  EventFeedViewModel.swift
//  Events-iOS
//
//  Created by Alexandre Azevedo on 21/01/21.
//

import Foundation
import RxSwift

class EventFeedViewModel {
    private let disposeBag = DisposeBag()
    var bindToViewController: (() -> Void) = {}
    var bindLoadingChange: (() -> Void) = {}
    private (set) var dataSource: EventDataSource = DataSource.eventDataSource()
    private (set) var error: Error?
    private (set) var events: [Event] = []
    private (set) var loading = false {
        didSet {
            self.bindLoadingChange()
        }
    }
    
    var errorMessage: String = "There was an error retrieving info"
    
    init(bindToViewController: @escaping () -> Void, bindLoadingChange: @escaping () -> Void = {}) {
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
        dataSource.getEvents().subscribe(
            onSuccess: { events in
                self.events = events;
                self.bindToViewController();
                self.loading = false;
            }, onFailure: { error in
                self.error = error
                self.loading = false
                self.bindToViewController()
            }).disposed(by: disposeBag)
    }
}
