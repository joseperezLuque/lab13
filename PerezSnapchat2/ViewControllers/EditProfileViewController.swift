//
//  ditProfileViewController.swift
//  PerezSnapchat2
//
//  Created by Jose Adriano Perez Luque on 29/06/24.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.text = Auth.auth().currentUser?.email
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
                view.addGestureRecognizer(tapGesture)

    }
    @objc func hideKeyboard() {
            view.endEditing(true)
        }
    @IBAction func updateProfileTapped(_ sender: Any) {
        guard let newEmail = emailTextField.text else {
                    return // Manejar caso de email vacío
                }

                // Actualizar el correo electrónico del usuario
                Auth.auth().currentUser?.updateEmail(to: newEmail) { error in
                    if let error = error {
                        print("Error al actualizar el correo electrónico: \(error.localizedDescription)")
                        // Mostrar alerta de error
                        self.showAlert(title: "Error", message: "No se pudo actualizar el correo electrónico. \(error.localizedDescription)")
                    } else {
                        print("Correo electrónico actualizado correctamente")
                        // Mostrar alerta de éxito
                        self.showAlert(title: "Éxito", message: "Correo electrónico actualizado correctamente.")
                    }
                }

                // Actualizar la contraseña si se ingresaron nuevas contraseñas
                if let newPassword = newPasswordTextField.text, !newPassword.isEmpty {
                    guard let confirmPassword = confirmPasswordTextField.text, newPassword == confirmPassword else {
                        // Mostrar alerta si las contraseñas no coinciden
                        showAlert(title: "Error", message: "Las contraseñas no coinciden.")
                        return
                    }

                    // Actualizar la contraseña del usuario
                    Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
                        if let error = error {
                            print("Error al actualizar la contraseña: \(error.localizedDescription)")
                            // Mostrar alerta de error
                            self.showAlert(title: "Error", message: "No se pudo actualizar la contraseña. \(error.localizedDescription)")
                        } else {
                            print("Contraseña actualizada correctamente")
                            // Mostrar alerta de éxito
                            self.showAlert(title: "Éxito", message: "Contraseña actualizada correctamente.")
                        }
                    }
                }
            }

            func showAlert(title: String, message: String) {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
