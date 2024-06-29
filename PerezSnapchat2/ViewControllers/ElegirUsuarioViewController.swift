//
//  ElegirUsuarioViewController.swift
//  PerezSnapchat2
//
//  Created by Jose Adriano Perez Luque on 25/06/24.
//

import UIKit
import Firebase

class ElegirUsuarioViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var listaUsuarios: UITableView!
    var usuarios:[Usuario] = []
    var imagenURL = ""
    var descrip = ""
    var imagenID = ""
    var audioURL: String?
    var audioTitle: String?


    
    override func viewDidLoad() {
        super.viewDidLoad()
        listaUsuarios.delegate=self
        listaUsuarios.dataSource=self
        Database.database().reference().child("usuario").observe(DataEventType.childAdded, with: { (snapshot) in
                    print(snapshot)
                    let usuario = Usuario()
                    usuario.email = (snapshot.value as! NSDictionary)["email"] as! String
                    usuario.uid = snapshot.key
                    self.usuarios.append(usuario)
                    self.listaUsuarios.reloadData()
                })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        let usuario = usuarios[indexPath.row]
        cell.textLabel?.text = usuario.email
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usuario = usuarios[indexPath.row]
        let snap = ["from" : Auth.auth().currentUser?.email, "descripcion" : descrip, "imagenURL" : imagenURL, "imagenID": imagenID,"audioURL": audioURL ?? "",
                    "audioTitle": audioTitle ?? "" ]
        
        Database.database().reference().child("usuario").child(usuario.uid).child("snaps").childByAutoId().setValue(snap)
        navigationController?.popViewController(animated: true)
    }
}
