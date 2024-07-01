import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var sendButton: UIButton!
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Request location permission
        locationManager.requestWhenInUseAuthorization()
        
        // Start location updates
        locationManager.startUpdatingLocation()
        
        // Style the send button
        sendButton.layer.cornerRadius = 10
        sendButton.layer.shadowColor = UIColor.black.cgColor
        sendButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        sendButton.layer.shadowOpacity = 0.5
        sendButton.layer.shadowRadius = 2
        sendButton.isEnabled = false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        
        // Configure map region
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        // Add annotation for current location
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = "Ubicación Actual"
        mapView.addAnnotation(annotation)
        
        sendButton.isEnabled = true
    }
    
    @IBAction func sendTapped(_ sender: UIButton) {
        guard let location = currentLocation else { return }
        
        // Generate location URL
        let coordinate = location.coordinate
        let locationURL = "http://maps.apple.com/?ll=\(coordinate.latitude),\(coordinate.longitude)"
        print(locationURL)
        
        // Perform segue and pass the location URL
        performSegue(withIdentifier: "seleccionarContactoSegue", sender: locationURL)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seleccionarContactoSegue" {
            if let elegirUsuarioVC = segue.destination as? ElegirUsuarioViewController {
                elegirUsuarioVC.locationURL = sender as? String
            }
        }
    }
}
