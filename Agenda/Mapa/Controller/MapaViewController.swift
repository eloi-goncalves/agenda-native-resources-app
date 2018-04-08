//
//  MapaViewController.swift
//  Agenda
//
//  Created by Eloi Andre Goncalves on 08/04/2018.
//  Copyright © 2018 Alura. All rights reserved.
//

import UIKit
import MapKit

class MapaViewController: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var mapa: MKMapView!
    
    
    //MARK: Variáveis
    var aluno : Aluno?
    
    //MARK: View CycleLife
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = getTitulo()
        localizacaoInicial()
        localizarAluno()
        // Do any additional setup after loading the view.
    }
    
    //MARK: Métodos.
    func getTitulo() -> String {
        return "Localizar Alunos"
    }
    
    func localizarAluno() {
        if let aluno = aluno  {
            Localizacao().converterEnderecoEmCoordenada((aluno.ds_endereco)!) { (localizacaoAluno) in
                let pinoAluno = self.configurarPino(title: aluno.nm_name!, localizacaoPino: localizacaoAluno)
                self.mapa.addAnnotation(pinoAluno)
            }
        }
    }
    
    func localizacaoInicial(){
        Localizacao().converterEnderecoEmCoordenada("Furb - Blumenau") { (localizacaoEncontrada) in
            let pinoInicial = self.configurarPino(title: "Furb", localizacaoPino: localizacaoEncontrada)
            let regiao = MKCoordinateRegionMakeWithDistance(pinoInicial.coordinate, 5000, 5000)
            self.mapa.setRegion(regiao, animated: true)
            self.mapa.addAnnotation(pinoInicial)
        }
    }
    
    func configurarPino(title:String, localizacaoPino: CLPlacemark) -> MKPointAnnotation {
        let pino = MKPointAnnotation()
        pino.title = title
        pino.coordinate = (localizacaoPino.location?.coordinate)!
        
        return pino
    }
}
