//
//  Mensagem.swift
//  Agenda
//
//  Created by Eloi Andre Goncalves on 08/04/2018.
//  Copyright © 2018 Alura. All rights reserved.
//

import UIKit
//Framework de mensagens.
import MessageUI

class Mensagem: NSObject, MFMessageComposeViewControllerDelegate {
    
    //MARK: MessageComposeDelegate
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Metodos
    func configureSMS(_ aluno:Aluno) -> MFMessageComposeViewController? {
        
        if MFMessageComposeViewController.canSendText() {
            let componentMessage = MFMessageComposeViewController()
            
            //Como o aluno é optional sempre devemos tratar com o guardlet.
            guard  let alunoNumberPhone = aluno.ds_telefone else {return componentMessage}
            //Definir o array de número dos alunos para enviar o SMS.
            componentMessage.recipients = [alunoNumberPhone ]
            
            //Definir o componentMesssage como delegate.
            componentMessage.messageComposeDelegate = self 
            return componentMessage
        }
        
        return nil
    }
}
