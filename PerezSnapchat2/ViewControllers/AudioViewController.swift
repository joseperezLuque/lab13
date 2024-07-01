    //
    //  AudioViewController.swift
    //  PerezSnapchat2
    //
    //  Created by Jose Adriano Perez Luque on 29/06/24.
    //

import UIKit
import AVFoundation
import Firebase
import FirebaseStorage

class AudioViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    var audioRecorder: AVAudioRecorder?
    var audioURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        sendButton.isEnabled = false
        styleButtons()
    }

    func setupRecorder() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try session.setActive(true)
            session.requestRecordPermission { granted in
                if !granted {
                    self.mostrarAlerta(titulo: "Permiso Denegado", mensaje: "Necesitamos acceso al micrófono para grabar audio.", accion: "Aceptar")
                }
            }
        } catch {
            print("Error al configurar la sesión de audio: \(error)")
        }

        let basePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let audioFilePath = (basePath as NSString).appendingPathComponent("audio.m4a")
        audioURL = URL(fileURLWithPath: audioFilePath)

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder?.delegate = self
        } catch {
            print("Error al crear el grabador de audio: \(error)")
        }
    }

    func styleButtons() {
        recordButton.backgroundColor = UIColor.systemBlue
        recordButton.setTitleColor(.white, for: .normal)
        recordButton.layer.cornerRadius = 10
        recordButton.layer.shadowColor = UIColor.black.cgColor
        recordButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        recordButton.layer.shadowOpacity = 0.5
        recordButton.layer.shadowRadius = 2

        sendButton.backgroundColor = UIColor.systemGreen
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.layer.cornerRadius = 10
        sendButton.layer.shadowColor = UIColor.black.cgColor
        sendButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        sendButton.layer.shadowOpacity = 0.5
        sendButton.layer.shadowRadius = 2
    }

    @IBAction func recordTapped(_ sender: UIButton) {
        if audioRecorder?.isRecording == false {
            audioRecorder?.record()
            recordButton.setTitle("Detener", for: .normal)
            sendButton.isEnabled = false
        } else {
            audioRecorder?.stop()
            recordButton.setTitle("Grabar", for: .normal)
            sendButton.isEnabled = true
        }
    }

    @IBAction func sendTapped(_ sender: UIButton) {
        guard let audioURL = audioURL else {
            print("Error: No se encontró la URL del audio.")
            return
        }

        sendButton.isEnabled = false
        let audiosFolder = Storage.storage().reference().child("audios")
        let audioData = try? Data(contentsOf: audioURL)
        let audioRef = audiosFolder.child("\(NSUUID().uuidString).m4a")

        audioRef.putData(audioData!, metadata: nil) { (metadata, error) in
            if let error = error {
                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir el audio. Verifique su conexión a internet y vuelva a intentarlo.", accion: "Aceptar")
                self.sendButton.isEnabled = true
                print("Ocurrió un error al subir el audio: \(error.localizedDescription)")
                return
            } else {
                audioRef.downloadURL(completion: {(url, error) in
                    guard let enlaceURL = url else{
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener informacion de imagen.", accion: "Cancelar")
                        self.sendButton.isEnabled = true
                        print("Ocurrio un error al obtener informacion de imagen \(error)")
                        return
                    }
                    
                    self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: url?.absoluteString)
                })
            }

            
        }
    }

    func mostrarAlerta(titulo: String, mensaje: String, accion: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnAceptar = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnAceptar)
        present(alerta, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seleccionarContactoSegue" {
            if let destinationVC = segue.destination as? ElegirUsuarioViewController {
                destinationVC.audioURL = sender as? String
                destinationVC.audioTitle = titleTextField.text
            }
        }
    }
}
