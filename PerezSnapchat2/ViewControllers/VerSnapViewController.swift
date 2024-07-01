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
        // Añade un inicializador conveniente para Snap
    var snap: Snap? // Cambia a opcional
            
        // Añade un inicializador conveniente para Snap
        init(snap: Snap) {
            self.snap = snap
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            // Puedes dejar la inicialización de snap en nil y configurarla después
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            guard let snap = snap else { return }
            lblMensaje.text = "Mensaje: " + snap.descrip
            imageView.sd_setImage(with: URL(string: snap.imagenURL), completed: nil)
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            guard let snap = snap else { return }
            
            Database.database().reference().child("usuario").child((Auth.auth().currentUser?.uid)!).child("snaps").child(snap.id).removeValue()
            
            Storage.storage().reference().child("imagenes").child("\(snap.imagenID).jpg").delete { error in
                if let error = error {
                    print("Error al eliminar la imagen: \(error.localizedDescription)")
                } else {
                    print("Se eliminó la imagen correctamente")
                }
            }
        }
    }
