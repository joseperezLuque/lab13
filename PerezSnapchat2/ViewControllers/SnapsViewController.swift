//
//  SnapsViewController.swift
//  PerezSnapchat2
//
//  Created by Jose Adriano Perez Luque on 25/06/24.
//

import UIKit
import Firebase

class SnapsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tablaSnaps: UITableView!
    var snaps:[Snap] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if snaps.count == 0{
            return 1
        }else{
            return snaps.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if snaps.count == 0 {
            cell.textLabel?.text = "No tienes Snaps"
        } else {
            let snap = snaps[indexPath.row]
            if snap.contentType == .audio {
                cell.textLabel?.text = "\(snap.from) (Audio)"
            } else {
                cell.textLabel?.text = "\(snap.from) (Imagen)"
            }
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaSnaps.delegate = self
        tablaSnaps.dataSource = self
        
        Database.database().reference().child("usuario").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childAdded, with: {(snapshot) in
            if let snapDict = snapshot.value as? [String: Any] {
                let snap = Snap()
                snap.from = snapDict["from"] as! String
                snap.descrip = snapDict["descripcion"] as! String
                snap.id = snapshot.key
                snap.imagenID = snapDict["imagenID"] as! String
                
                // Determinar si es un audio o imagen
                if let imagenURL = snapDict["imagenURL"] as? String {
                    snap.imagenURL = imagenURL
                    snap.contentType = .image
                } else if let audioURL = snapDict["audioURL"] as? String {
                    snap.audioURL = audioURL
                    snap.contentType = .audio
                }
                
                self.snaps.append(snap)
                self.tablaSnaps.reloadData()
            }
        })
        
        Database.database().reference().child("usuario").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childRemoved, with: { (snapshot) in
            self.snaps = self.snaps.filter { $0.id != snapshot.key }
            self.tablaSnaps.reloadData()
        })
    }

    @IBAction func cerrarSesionTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "versnapsegue", sender: snap)
    }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "versnapsegue"{
            let siguienteVC = segue.destination as! VerSnapViewController;
            siguienteVC.snap = sender as! Snap
        }
    }
}
