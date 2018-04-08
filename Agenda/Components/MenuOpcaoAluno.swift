//
//  MenuOpcaoAluno.swift
//  Agenda
//
//  Created by Eloi Andre Goncalves on 08/04/2018.
//  Copyright © 2018 Alura. All rights reserved.
//

import UIKit

enum MenuOptionsAlunos {
    case sms
    case ligacao
}

class MenuOpcaoAluno: NSObject {
    
    func configureMenuOption(completion: @escaping(_ opcao:MenuOptionsAlunos) -> Void) -> UIAlertController {
        let menu =  UIAlertController(title: "Information", message: "Choose the following options", preferredStyle: .actionSheet)
        
        //Option send sms.
        let sms = UIAlertAction(title: "Send SMS", style: .default) { (acao) in
            //Implements
            completion(.sms)
        }
        
        //Option cancel
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //Option Call
        let call = UIAlertAction(title: "Call", style: .default) { (call) in
            completion(.ligacao)
        }
        
        menu.addAction(sms)
        menu.addAction(cancel)
        menu.addAction(call)
        return menu
    }
}
