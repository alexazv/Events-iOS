//
//  EventDetailViewController.swift
//  Events-iOS
//
//  Created by Alexandre Azevedo on 21/01/21.
//

import UIKit
import MapKit

class EventDetailViewController: UIViewController {

    private var viewModel: EventDetailViewModel?
    @IBOutlet weak var eventImage: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descriptionTextField: UITextView?
    @IBOutlet weak var mapView: MKMapView?
    @IBOutlet weak var priceLabel: UILabel?
    @IBOutlet weak var date: UILabel?
    @IBOutlet weak var loadingView: LoadingView?

    func setup(_ eventId: String) {
        viewModel = EventDetailViewModel(eventId: eventId,
                                         bindToViewController: updateView,
                                         bindLoadingChange: updateLoadingView)
    }

    private func updateView() {
        guard let event = viewModel?.event else {
            return
        }
        updateMapView()
        titleLabel?.text = event.title
        date?.text = event.dateString
        priceLabel?.text = String(format: "R$%.2f", event.price ?? 0)
        descriptionTextField?.text = event.description
        if let url = event.imageUrl {
            eventImage?.af.setImage(withURL: url,
                                    imageTransition: UIImageView.ImageTransition.crossDissolve(0.25),
                                    runImageTransitionIfCached: true)
        }
    }

    private func updateLoadingView() {
        loadingView?.loading = viewModel?.loading ?? true
    }

    private func updateMapView() {
        guard let event = viewModel?.event,
              let latitude = event.latitude,
              let longitude = event.longitude else {
            return
        }
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView?.addAnnotation(annotation)

        let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView?.setCenter(coordinate, animated: true)
        mapView?.setRegion(viewRegion, animated: true)
    }

    @IBAction func didTapCheckin() {
        guard let eventId = viewModel?.event?.eventId else { return }

        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController: EventCheckinViewController =
                storyboard.instantiateViewController(withIdentifier: "EventCheckinViewController")
                as? EventCheckinViewController else { return }
        viewController.setup(eventId: eventId)

        navigationController?.pushViewController(viewController, animated: true)
    }
}
