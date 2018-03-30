//
//  ImagePicker.swift
//  Agenda
//
//  Created by Eloi Andre Goncalves on 30/03/2018.
//  Copyright © 2018 Alura. All rights reserved.
//

import Foundation
import UIKit

//Criar um protocolo para atualizar a foto do aluno.

protocol ImagePickerSelectedPhoto {
    func imagePickerSelectedPhoto(_foto:UIImage)
}

class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    //MARK - Atributos.
    
    //Criar um delegate do tipo do protocolo criado, como option porque não sabemos se vai ou não possuir valor.
    var protocolo : ImagePickerSelectedPhoto?
     
    //MARK - Metodos.
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Método chamado quando é fechado a camera.
        let foto = info[UIImagePickerControllerOriginalImage] as! UIImage
        protocolo?.imagePickerSelectedPhoto(_foto: foto)
        //Fechar a camera.
        picker.dismiss(animated: true, completion: nil)
    }
}
