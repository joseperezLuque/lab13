//
//  VerSnapViewController.swift
//  PerezSnapchat2
//
//  Created by Jose Adriano Perez Luque on 27/06/24.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseStorage

class VerSnapViewController: UIViewController {

    @IBOutlet weak var lblMensaje: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var snap = Snap()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMensaje.text = "Mensaje: " + snap.descrip
        imageView.sd_setImage(with: URL(string: snap.imagenURL), completed: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        Database.database().reference().child("usuario").child((Auth.auth().currentUser?.uid)!).child("snaps").child(snap.id).removeValue()
        
        Storage.storage().reference().child("imagenes").child("\(snap.imagenID).jpg").delete{ (error) in
            print("Se elimino la imagen correctamente")
        }
    }

   

}
