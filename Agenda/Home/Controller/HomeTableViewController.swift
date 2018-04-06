//
//  HomeTableViewController.swift
//  Agenda
//
//  Created by Ândriu Coelho on 24/11/17.
//  Copyright © 2017 Alura. All rights reserved.
//

import UIKit
import CoreData

class HomeTableViewController: UITableViewController, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
    
    
    //MARK: - Context
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    var gerenciadorDeBuscaAlunos: NSFetchedResultsController<Aluno>?
    
    
    //MARL: - getAlunos
    
    func getAlunos() {
        var alunosRequest: NSFetchRequest = Aluno.fetchRequest()
        var orderByName = NSSortDescriptor(key: "nm_name", ascending: true)
        alunosRequest.sortDescriptors = [orderByName]
        
        gerenciadorDeBuscaAlunos =  NSFetchedResultsController(fetchRequest: alunosRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        gerenciadorDeBuscaAlunos?.delegate = self
        
        do {
            try gerenciadorDeBuscaAlunos?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    //MARK: - Variáveis
    let searchController = UISearchController(searchResultsController: nil)
    var alunoViewController:AlunoViewController?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configuraSearch()
        self.getAlunos()        
    }
    
    // MARK: - Métodos
    
    func configureTable() {
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit" {
            alunoViewController =  segue.destination as? AlunoViewController
        } else if  (segue.identifier == "newRecord") {
            alunoViewController =  segue.destination as? AlunoViewController
            alunoViewController?.aluno = nil
        }
    }
    
    func configuraSearch() {
        self.searchController.searchBar.delegate = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
    }
    
    
    //Set size cell.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sizeListAlunos = gerenciadorDeBuscaAlunos?.fetchedObjects?.count else { return 0 }
        
        return sizeListAlunos
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula-aluno", for: indexPath) as! HomeTableViewCell
        
        let aluno = gerenciadorDeBuscaAlunos?.fetchedObjects![indexPath.row] as! Aluno
        cell.setupCell(aluno)

        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //Capturar primeira o aluno que deseja que seja deletado.
            
            guard let aluno = gerenciadorDeBuscaAlunos?.fetchedObjects![indexPath.row] as? Aluno else { return }
            
            context.delete(aluno)
            do {
                try  context.save()
            } catch {
                print(error.localizedDescription)
            }
        
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let alunoSelecionado = gerenciadorDeBuscaAlunos?.fetchedObjects![indexPath.row] else { return  }
        alunoViewController?.aluno = alunoSelecionado
    }
    
    //MARK: FetchController
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
                //Implenets in the future.
                guard let index = indexPath else { return }
                tableView.deleteRows(at: [index], with: .fade)
                break
        default:
                tableView.reloadData()
        }
    }

}
