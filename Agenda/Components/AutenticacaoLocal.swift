//
//  AutenticacaoLocal.swift
//  Agenda
//
//  Created by Eloi Andre Goncalves on 01/05/2018.
//  Copyright © 2018 Alura. All rights reserved.
//

import UIKit
import LocalAuthentication

class AutenticacaoLocal: NSObject {
    
    var error:NSError?
    
    func autorizaUsuario(completion:@escaping(_ autenticado:Bool)-> Void ) {
        //Criando uma constante do Local autentication.
        let context = LAContext()
        
        //Verificando a disposnibilidade do recurso (Somente podera ser utilizado em Devices reais e não em simuladores).
        
        if (context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "É necessário autenticação para apagar um aluno.", reply: { (resposta, erro) in
                if (erro != nil) {
                    completion(resposta)
                } else {
                    print(erro?.localizedDescription)
                }
            })
        }
    }

}
