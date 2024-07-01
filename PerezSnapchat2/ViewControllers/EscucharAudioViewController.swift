import UIKit
import AVFoundation
import Firebase
import FirebaseStorage

class EscucharAudioViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var btnReproducir: UIButton!
    @IBOutlet weak var volumenSlider: UISlider!
    var snap: Snap?
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        volumenSlider.isHidden = true
        volumenSlider.addTarget(self, action: #selector(cambioDeVolumen(_:)), for: .valueChanged)
    }

    @IBAction func tappedReproducir(_ sender: Any) {
        if let audioPlayer = audioPlayer, audioPlayer.isPlaying {
            audioPlayer.stop()
            btnReproducir.setTitle("Reproducir", for: .normal)
            volumenSlider.isHidden = true
        } else {
            guard let snap = snap, let audioURL = URL(string: snap.audioURL) else {
                mostrarAlerta(titulo: "Error", mensaje: "No se pudo cargar el audio.", accion: "Aceptar")
                return
            }

            do {
                let audioData = try Data(contentsOf: audioURL)
                audioPlayer = try AVAudioPlayer(data: audioData)
                audioPlayer?.delegate = self
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
                btnReproducir.setTitle("Detener", for: .normal)
                volumenSlider.isHidden = false
                volumenSlider.value = audioPlayer?.volume ?? 0.5
            } catch {
                mostrarAlerta(titulo: "Error", mensaje: "No se pudo reproducir el audio.", accion: "Aceptar")
                print("Error al reproducir el audio: \(error.localizedDescription)")
            }
        }
    }

    @objc func cambioDeVolumen(_ sender: UISlider) {
        audioPlayer?.volume = sender.value
    }

    func mostrarAlerta(titulo: String, mensaje: String, accion: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnAceptar = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnAceptar)
        present(alerta, animated: true, completion: nil)
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        btnReproducir.setTitle("Reproducir", for: .normal)
        volumenSlider.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let snap = snap else { return }
        
        Database.database().reference().child("usuario").child((Auth.auth().currentUser?.uid)!).child("snaps").child(snap.id).removeValue()
        
        
    }
}
