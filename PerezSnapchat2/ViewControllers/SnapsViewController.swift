//
//  SnapsViewController.swift
//  PerezSnapchat2
//
//  Created by Jose Adriano Perez Luque on 25/06/24.
//
import UIKit
import Firebase

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tablaSnaps: UITableView!
    var snaps: [Snap] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tablaSnaps.delegate = self
        tablaSnaps.dataSource = self

        Database.database().reference().child("usuario").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childAdded, with: { (snapshot) in
            let snap = Snap()
            snap.imagenURL = (snapshot.value as! NSDictionary)["imagenURL"] as? String ?? ""
            snap.audioURL = (snapshot.value as! NSDictionary)["audioURL"] as? String ?? ""
            snap.locationURL = (snapshot.value as! NSDictionary)["locationURL"] as? String ?? ""
            snap.from = (snapshot.value as! NSDictionary)["from"] as! String
            snap.descrip = (snapshot.value as! NSDictionary)["descripcion"] as! String
            snap.id = snapshot.key
            snap.imagenID = (snapshot.value as! NSDictionary)["imagenID"] as? String ?? ""
            self.snaps.append(snap)
            self.tablaSnaps.reloadData()
        })

        Database.database().reference().child("usuario").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childRemoved, with: { (snapshot) in
            self.snaps.removeAll { $0.id == snapshot.key }
            self.tablaSnaps.reloadData()
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snaps.isEmpty ? 1 : snaps.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if snaps.isEmpty {
            cell.textLabel?.text = "No tienes Snaps"
        } else {
            let snap = snaps[indexPath.row]
            if !snap.imagenURL.isEmpty {
                cell.detailTextLabel?.text = "Tipo de mensaje: Imagen"
            } else if !snap.audioURL.isEmpty {
                cell.detailTextLabel?.text = "Tipo de mensaje: Audio"
            } else if !snap.locationURL.isEmpty {
                cell.detailTextLabel?.text = "Tipo de mensaje: Ubicacion"
            }
            
            
            cell.textLabel?.text = snap.from
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if snaps.isEmpty { return }
        let snap = snaps[indexPath.row]
        
        if !snap.imagenURL.isEmpty {
            performSegue(withIdentifier: "versnapsegue", sender: snap)
        } else if !snap.audioURL.isEmpty {
            performSegue(withIdentifier: "segueEscucharAudio", sender: snap)
        } else if !snap.locationURL.isEmpty {
            performSegue(withIdentifier: "segueVerMapa", sender: snap)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let snap = sender as? Snap {
            if segue.identifier == "versnapsegue", let siguienteVC = segue.destination as? VerSnapViewController {
                siguienteVC.snap = snap
            } else if segue.identifier == "segueEscucharAudio", let siguienteVC = segue.destination as? EscucharAudioViewController {
                siguienteVC.snap = snap
            } else if segue.identifier == "segueVerMapa", let siguienteVC = segue.destination as? VerMapaViewController {
                siguienteVC.snap = snap
            }
        }
    }
    
    @IBAction func cerrarSesionTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
