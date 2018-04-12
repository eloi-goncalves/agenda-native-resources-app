//
//  CalculaMediaAPI.swift
//  Agenda
//
//  Created by Eloi Andre Goncalves on 10/04/2018.
//  Copyright © 2018 Alura. All rights reserved.
//

import UIKit

class CalculaMediaAPI: NSObject {
    
    func calculaMediaGeralAlunos (alunos:Array<Aluno>, sucesso:@escaping(_ dictionaryMedias:Dictionary<String,Any>)-> Void,
                                  falha:@escaping(_ error:Error)-> Void) {
        guard let url = URL(string: "https://www.caelum.com.br/mobile") else { return }
        
        var listaDeAlunos : Array<Dictionary<String,Any>> = []
        var json:Dictionary<String, Any> = [:]
        
        for aluno in alunos {
            
            guard let nome = aluno.nm_name else { break }
            guard let endereco = aluno.ds_endereco else { break }
            guard let telefone = aluno.ds_telefone else { break }
            guard let site = aluno.ds_site else { break }
            
            let dicionarioDeAlunos = [
                "id": "\(aluno.objectID)",
                "nome": nome,
                "endereco": endereco,
                "telefone": telefone,
                "site": site,
                "nota": String(aluno.nr_nota)
                ]
            
            listaDeAlunos.append(dicionarioDeAlunos as [String:Any])
        }
        
        json = [
            "list": [
                ["aluno": listaDeAlunos]
            ]
        ]

        do {
            var requisicao = URLRequest(url: url)

            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            print(data)
            requisicao.httpBody = data as! Data
            requisicao.httpMethod = "POST"
            requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: requisicao, completionHandler: { (data, response, error) in
                if error == nil {
                    do {
                        let dic = try JSONSerialization.jsonObject(with: data! , options: []) as! Dictionary<String,Any>
                        sucesso(dic)
                    } catch {
                        falha(error)
                    }
                }
                
            })
            task.resume()
        } catch {
            print(error.localizedDescription)
        }

    }

}
