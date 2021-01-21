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
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var mapView: MKMapView?
    @IBOutlet weak var priceLabel: UILabel?
    @IBOutlet weak var date: UILabel?
    
    func setup(_ eventId: String) {
        viewModel = EventDetailViewModel(eventId: eventId, bindToViewController: updateView)
    }
    
    private func updateView() {
        guard let event = viewModel?.event else {
            return
        }
        updateMapView()
        titleLabel?.text = event.title
        date?.text = event.dateString
        priceLabel?.text = String(format: "R$%.2f", event.price ?? 0)
        descriptionLabel?.text = event.description
        if let url = event.imageUrl {
            eventImage?.af.setImage(withURL: url)
        }
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
        mapView?.setCenter(coordinate, animated: true);
        mapView?.setRegion(viewRegion, animated: true)
    }
    
    @IBAction func didTapCheckin() {
        guard let eventId = viewModel?.event?.eventId else { return }
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: EventCheckinViewController = storyboard.instantiateViewController(withIdentifier: "EventCheckinViewController") as! EventCheckinViewController
        vc.setup(id: eventId)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
