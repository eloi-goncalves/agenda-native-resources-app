//
//  HomeTableViewCell.swift
//  Agenda
//
//  Created by Ândriu Coelho on 24/11/17.
//  Copyright © 2017 Alura. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageAluno: UIImageView!
    @IBOutlet weak var labelNomeDoAluno: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(_ aluno : Aluno) {
        labelNomeDoAluno.text = aluno.nm_name
        
        if let img = aluno.img_photo as? UIImage {
            imageAluno.image = img
            roundedPhoto()
        }
    }
    
    func roundedPhoto() {
        imageAluno.layer.cornerRadius = imageAluno.layer.bounds.width / 2
        imageAluno.layer.masksToBounds = true
    }

}
