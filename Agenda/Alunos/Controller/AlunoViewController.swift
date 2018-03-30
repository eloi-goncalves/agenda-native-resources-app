//
//  AlunoViewController.swift
//  Agenda
//
//  Created by Ândriu Coelho on 24/11/17.
//  Copyright © 2017 Alura. All rights reserved.
//

import UIKit

//Será necessário utilizar o protocolo criado na classe: ImagePicker
class AlunoViewController: UIViewController, ImagePickerSelectedPhoto  {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var viewImagemAluno: UIView!
    @IBOutlet weak var imageAluno: UIImageView!
    @IBOutlet weak var buttonFoto: UIButton!
    @IBOutlet weak var scrollViewPrincipal: UIScrollView!
    
    @IBOutlet weak var textFieldNome: UITextField!
    @IBOutlet weak var textFieldEndereco: UITextField!
    @IBOutlet weak var textFieldTelefone: UITextField!
    @IBOutlet weak var textFieldSite: UITextField!
    @IBOutlet weak var textFieldNota: UITextField!
    
    
    // MARK: - Atributos.
    let imagePicker = ImagePicker()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.arredondaView()
        self.setup()
        NotificationCenter.default.addObserver(self, selector: #selector(aumentarScrollView(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Métodos
    func setup(){
        //Definir o delegate da classe ImagePicker.
        imagePicker.protocolo = self
    }
    
    // MARK: Delegate
    func imagePickerSelectedPhoto(_foto: UIImage) {
        imageAluno.image = _foto
    }
    
    func arredondaView() {
        self.viewImagemAluno.layer.cornerRadius = self.viewImagemAluno.frame.width / 2
        self.viewImagemAluno.layer.borderWidth = 1
        self.viewImagemAluno.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @objc func aumentarScrollView(_ notification:Notification) {
        self.scrollViewPrincipal.contentSize = CGSize(width: self.scrollViewPrincipal.frame.width, height: self.scrollViewPrincipal.frame.height + self.scrollViewPrincipal.frame.height/2)
    }
    
    // MARK: - IBActions
    
    @IBAction func buttonFoto(_ sender: UIButton) {
        //Implementar a utilização da camera.
        let imageCamera = UIImagePickerController()
        
        //Tipo de midia.
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            imageCamera.sourceType = .camera
        } else if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            imageCamera.sourceType = .photoLibrary
        }
        
        //Delegando os métodos
        imageCamera.delegate = imagePicker
        
        //Apresentar
        self.present(imageCamera, animated: true, completion:nil)
        
    }
    
    @IBAction func stepperNota(_ sender: UIStepper) {
        self.textFieldNota.text = "\(sender.value)"
    }
    
    
}
