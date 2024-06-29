//
//  RegistroViewController.swift
//  PerezSnapchat2
//
//  Created by Jose Adriano Perez Luque on 25/06/24.
//

import UIKit
import Firebase


class RegistroViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func registrarTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
                    mostrarAlerta(titulo: "Error", mensaje: "Por favor ingrese un email y contraseña válidos", accion: "Aceptar")
                    return
    }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if let error = error {
                        print("Se presentó el siguiente error al crear el usuario: \(error)")
                        self.mostrarAlerta(titulo: "Error", mensaje: "No se pudo crear el usuario. Verifique los datos ingresados.", accion: "Aceptar")
                    } else {
                        print("El usuario fue creado exitosamente")
                        
                        // Guardar el email del usuario en la base de datos
                        if let user = user {
                            Database.database().reference().child("usuario").child(user.user.uid).child("email").setValue(user.user.email)
                            
                            // Mostrar alerta de éxito
                            let alerta = UIAlertController(title: "Registro Exitoso", message: "Usuario registrado correctamente.", preferredStyle: .alert)
                            let btnOK = UIAlertAction(title: "Aceptar", style: .default) { (UIAlertAction) in
                                self.dismiss(animated: true, completion: nil)
                            }
                            alerta.addAction(btnOK)
                            self.present(alerta, animated: true, completion: nil)
                        }
                    }
                }
            }
            
            func mostrarAlerta(titulo: String, mensaje: String, accion: String) {
                let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
                let btnOK = UIAlertAction(title: accion, style: .default, handler: nil)
                alerta.addAction(btnOK)
                present(alerta, animated: true, completion: nil)
            }

}
