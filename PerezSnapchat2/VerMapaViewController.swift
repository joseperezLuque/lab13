import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseStorage

class VerMapaViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapaView: MKMapView!
    var snap: Snap?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarMapa()
    }
    
    func configurarMapa() {
        guard let snap = snap, let url = URL(string: snap.locationURL) else {
            mostrarAlerta(titulo: "Error", mensaje: "No se pudo cargar la ubicación.", accion: "Aceptar")
            return
        }
        
        // Parsear la URL para obtener las coordenadas
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let queryItems = components.queryItems {
            var latitude: CLLocationDegrees?
            var longitude: CLLocationDegrees?
            
            for item in queryItems {
                if item.name == "ll" {
                    let coordinates = item.value?.split(separator: ",")
                    if let latString = coordinates?.first, let lonString = coordinates?.last,
                       let lat = CLLocationDegrees(latString), let lon = CLLocationDegrees(lonString) {
                        latitude = lat
                        longitude = lon
                    }
                }
            }
            
            if let latitude = latitude, let longitude = longitude {
                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
                mapaView.setRegion(region, animated: true)
                
                // Añadir una anotación en el mapa
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = "Ubicación compartida"
                mapaView.addAnnotation(annotation)
            } else {
                mostrarAlerta(titulo: "Error", mensaje: "No se pudieron extraer las coordenadas de la URL.", accion: "Aceptar")
            }
        }
    }

    func mostrarAlerta(titulo: String, mensaje: String, accion: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnAceptar = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnAceptar)
        present(alerta, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let snap = snap else { return }
        
        Database.database().reference().child("usuario").child((Auth.auth().currentUser?.uid)!).child("snaps").child(snap.id).removeValue()
        
        
    }
    
}
