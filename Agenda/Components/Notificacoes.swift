//
//  Notificacoes.swift
//  Agenda
//
//  Created by Eloi Andre Goncalves on 11/04/2018.
//  Copyright © 2018 Alura. All rights reserved.
//

import UIKit

class Notificacoes: NSObject {

    func exibeMediaAlunos(dicitonary: Dictionary<String,Any>) -> UIAlertController? {
        if let media = dicitonary["media"] as? String {
            let alert = UIAlertController(title: "Média dos alunos", message: "A média geral dos alunos: \(media)", preferredStyle: .alert)
            let btnOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alert.addAction(btnOk)
            
            return alert
        } else {
            return nil
        }
    }
}
