//
//  AlunoViewController.swift
//  Agenda
//
//  Created by Ândriu Coelho on 24/11/17.
//  Copyright © 2017 Alura. All rights reserved.
//

import UIKit
import CoreData

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
    
    
     //MARK: - Context
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    // MARK: - Atributos.
    let imagePicker = ImagePicker()
    var aluno: Aluno?
    
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.arredondaView()
        self.setup()
        self.carregarAluno()
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
    
    func carregarAluno() {
        guard let alunoCarregado =  aluno  else { return }
            textFieldNome.text = alunoCarregado.nm_name
            textFieldNota.text =  (alunoCarregado.nr_nota as NSNumber).stringValue
            textFieldSite.text = alunoCarregado.ds_site
            textFieldEndereco.text = alunoCarregado.ds_endereco
            textFieldTelefone.text = alunoCarregado.ds_telefone
            imageAluno.image = alunoCarregado.img_photo as? UIImage
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
    
    //MARK: CriarCaminhoImagens
    func creatImagePath(_ photo : UIImage) -> String {
        let caminhoSistemaArquivos = NSHomeDirectory() as NSString
        let diretorioImagens = "Documents/Images"
        let caminhoCompleto = caminhoSistemaArquivos.appendingPathComponent(diretorioImagens)
        
        let gerenciadorDeArquivos = FileManager.default
        
        if !gerenciadorDeArquivos.fileExists(atPath: caminhoCompleto) {
            do {
                try gerenciadorDeArquivos.createDirectory(atPath: caminhoCompleto, withIntermediateDirectories: false, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        //Criar o nome da imagem que deve ser único para armazenarmos.
        let imageName = String(format: "%@,jpeg", aluno!.objectID.uriRepresentation().lastPathComponent)
        
        //Criar a url onde vai ser concatenado  caminho + nome da imagem.
        let url = URL(fileURLWithPath: String(format: "%@/%@", caminhoCompleto, imageName));
        
        //Converter a imagem em data para conseguir salva-la.
        guard let data = UIImagePNGRepresentation(photo) else { return "empty"}
        
        do {
            try data.write(to: url)
            return String(format: "%@/%@", caminhoCompleto, imageName)
        } catch {
            print(error.localizedDescription)
            return "empty"
        }
    }
    
    @IBAction func stepperNota(_ sender: UIStepper) {
        self.textFieldNota.text = "\(sender.value)"
    }
    
    @IBAction func save(_ sender: UIButton) {

        if  self.aluno == nil {
            self.aluno =  Aluno(context: context)
        }
            self.aluno?.ds_site  = textFieldSite.text
            self.aluno?.nm_name  = textFieldNome.text
            self.aluno?.ds_endereco = textFieldEndereco.text
            self.aluno?.ds_telefone = textFieldTelefone.text
            self.aluno?.nr_nota    = (textFieldNota.text as! NSString).doubleValue
            //Tratar a foto para salvar no caminho.
        
        var pathImage = creatImagePath(imageAluno.image!)
        
        if !(pathImage == "empty") {
            self.aluno?.img_photo  = pathImage
        }
        
        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
}
