//
//  Localizacao.swift
//  Agenda
//
//  Created by Eloi Andre Goncalves on 08/04/2018.
//  Copyright © 2018 Alura. All rights reserved.
//

import UIKit
import CoreLocation

class Localizacao: NSObject {
    
    //Criar uma closure para devolver a localização.
    func converterEnderecoEmCoordenada(_ endereco:String, local: @escaping(_ local:CLPlacemark) -> Void) {
        let conversor = CLGeocoder()
        conversor.geocodeAddressString(endereco) { (listLocalization, error) in
            if error != nil {
                if let localization = listLocalization?.first {
                    local(localization)
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }

}
