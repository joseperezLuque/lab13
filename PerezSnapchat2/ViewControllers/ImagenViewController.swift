//
//  ImagenViewController.swift
//  PerezSnapchat2
//
//  Created by Jose Adriano Perez Luque on 25/06/24.
//

import UIKit
import FirebaseStorage

class ImagenViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        elegirContactoBoton.isEnabled = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
                view.addGestureRecognizer(tapGesture)

    }
    @objc func hideKeyboard() {
            view.endEditing(true)
        }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var elegirContactoBoton: UIButton!
    
    
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func elegirContactoTapped(_ sender: Any) {
        self.elegirContactoBoton.isEnabled = false
        let imagenesFolder = Storage.storage().reference().child("imagenes")
        let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
        let cargarImagen = imagenesFolder.child("\(imagenID).jpg")
        cargarImagen.putData(imagenData!, metadata: nil) {(metadata, error) in
            if error != nil{
                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen. Verifique su conexion a internet y vuelva a intentarlo.", accion: "Aceptar")
                self.elegirContactoBoton.isEnabled = true
                print("Ocurrio un error al subir imagen: \(error)")
                return
            }else{
                cargarImagen.downloadURL(completion: {(url, error) in
                    guard let enlaceURL = url else{
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener informacion de imagen.", accion: "Cancelar")
                        self.elegirContactoBoton.isEnabled = true
                        print("Ocurrio un error al obtener informacion de imagen \(error)")
                        return
                    }
                    
                    self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: url?.absoluteString)
                })
            }
        }
    }
         func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
         imageView.image = image
         imageView.backgroundColor = UIColor.clear
         elegirContactoBoton.isEnabled = true
         imagePicker.dismiss(animated: true, completion: nil)
         }
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             let siguienteVC = segue.destination as! ElegirUsuarioViewController
             siguienteVC.imagenURL = sender as! String
             siguienteVC.descrip = descripcionTextField.text!
             siguienteVC.imagenID = imagenID
         
         }
         func mostrarAlerta(titulo: String, mensaje: String, accion:String){
         let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
         let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
         alerta.addAction(btnCANCELOK)
         present (alerta, animated: true, completion: nil)
         }
         
    }


