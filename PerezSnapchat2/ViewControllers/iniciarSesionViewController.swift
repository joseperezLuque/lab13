//
//  ViewController.swift
//  PerezSnapchat2
//
//  Created by Jose Adriano Perez Luque on 25/06/24.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class iniciarSesionViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
                view.addGestureRecognizer(tapGesture)
    }
    @objc func hideKeyboard() {
            view.endEditing(true)
        }
    
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text! , password: passwordTextField.text!){ (user, error) in
                            print ("Intentando Iniciar Sesion")
                            if error != nil {
                                print("Se presento el siguiente error: \(error)")
                                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: {(user, error) in print ("Intentando crear un usuario")
                                    if error != nil{
                                        print("Se presento el siguiente error al crear el usuario: \(error)")
                                        // Mostrar alerta para crear usuario si no existe
                                        self.mostrarAlertaCrearUsuario()
                                    }else{
                                        print("El usuario fue creado exitosamente")
                                        
                                        Database.database().reference().child("usuario").child(user!.user.uid).child("email").setValue(user!.user.email)
                                        
                                        let alerta = UIAlertController(title: "Creacion de Usuario", message: "Usuario: \(self.emailTextField.text!) se creo correctamente.", preferredStyle: .alert)
                                        let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler:{(UIAlertAction) in self.performSegue(withIdentifier: "iniciarsesionSegue", sender: nil)
                                        })
                                        alerta.addAction(btnOK)
                                        self.present(alerta, animated:true, completion: nil)
                                    }})
                            }else{
                                print("Inicio de sesion exitoso")
                                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                            }
                        }
        
    }
    
    @IBAction func registrarseTapped(_ sender: Any) {
        performSegue(withIdentifier: "registroSegue", sender: nil)

    }
    func mostrarAlertaCrearUsuario() {
            let alerta = UIAlertController(title: "Usuario no registrado", message: "El usuario no está registrado. ¿Desea crear uno nuevo?", preferredStyle: .alert)
            let btnCrear = UIAlertAction(title: "Crear", style: .default) { (_) in
                self.performSegue(withIdentifier: "registroSegue", sender: nil)
            }
            let btnCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            alerta.addAction(btnCrear)
            alerta.addAction(btnCancelar)
            present(alerta, animated: true, completion: nil)
        }
    
    
}
