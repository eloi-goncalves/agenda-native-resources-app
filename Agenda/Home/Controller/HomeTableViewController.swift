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
    func getAlunos(name:String = "") {
        let alunosRequest: NSFetchRequest = Aluno.fetchRequest()
        let orderByName = NSSortDescriptor(key: "nm_name", ascending: true)
        alunosRequest.sortDescriptors = [orderByName]
        
        if verifyIfUseFilter(name) {
            alunosRequest.predicate = filtraAluno(name);
        }
        
        gerenciadorDeBuscaAlunos =  NSFetchedResultsController(fetchRequest: alunosRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        gerenciadorDeBuscaAlunos?.delegate = self
        
        do {
            try gerenciadorDeBuscaAlunos?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func filtraAluno(_ filtro:String) -> NSPredicate {
        return NSPredicate(format: "nm_name CONTAINS %@", filtro)
    }
    
    func verifyIfUseFilter(_ filtro:String) -> Bool {
        if filtro.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    
    
    //MARK: - Variáveis
    let searchController = UISearchController(searchResultsController: nil)
    var alunoViewController:AlunoViewController?
    var messageSMS =  Mensagem()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configuraSearch()
        self.getAlunos()
    }
    
    // MARK: - Métodos
    
    @objc func openActionSheet(_ longPress:UILongPressGestureRecognizer) {
        if longPress.state == .began {
            //Para ter acesso ao aluno selecionado vou utulizar o gerenciador de busca de aluno e a informação de longPress tag.
            guard let alunoSelecionado = gerenciadorDeBuscaAlunos?.fetchedObjects?[(longPress.view?.tag)!] else { return }
            
            let menu = MenuOpcaoAluno().configureMenuOption(completion: { (opcao) in
                switch opcao {
                case .sms:
                    if let componentMessage = self.messageSMS.configureSMS(alunoSelecionado) {
                        componentMessage.messageComposeDelegate = self.messageSMS
                        self.present(componentMessage, animated: true, completion: nil )
                    }
                break
                case .ligacao:
                    guard let number = alunoSelecionado.ds_telefone else { return }
                    //Funcionalidade de chamada.
                    if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    
                    break
                case .waze:
                    
                    if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
                        guard let enderecoSelecionado = alunoSelecionado.ds_endereco else { return }
                        Localizacao().converterEnderecoEmCoordenada(enderecoSelecionado, local: { (localizacaoEncontrada) in
                           let latitude = String(describing: localizacaoEncontrada.location!.coordinate.latitude)
                           let longitude = String(describing: localizacaoEncontrada.location!.coordinate.longitude)
                           let url:String = "waze://?ll=\(latitude),\(longitude)&navigate=yes"
                            
                            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
                        })
                    }
                    
                    break
                case .mapa:
                    let mapa = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapa") as! MapaViewController
                    
                    mapa.aluno = alunoSelecionado
                    self.navigationController?.pushViewController(mapa, animated: true)
                    
                    break
                }
            })
            self.present(menu, animated: true, completion: nil)
        }
    }
    
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

        //Criar o método longPress da Celula
        let longPress = UILongPressGestureRecognizer(target:  self, action:  #selector(openActionSheet(_:)))
        
        //Adicionar agora o longPress criado na celular.
        cell.addGestureRecognizer(longPress)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //Vefirica se o usuário que está tentando deletar o aluno está autenticado.
            AutenticacaoLocal().autorizaUsuario(completion: { (autenticado) in
                if autenticado {
                    //Será utilizado o dispach para colocar a theard no main.
                    DispatchQueue.main.async {
                        // Delete the row from the data source
                        //Capturar primeira o aluno que deseja que seja deletado.
                        guard let aluno = self.gerenciadorDeBuscaAlunos?.fetchedObjects![indexPath.row] as? Aluno else { return }
                        
                        self.context.delete(aluno)
                        do {
                            try  self.context.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    
                }
            })
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
    @IBAction func btnCalculaMedia(_ sender: UIBarButtonItem) {
        guard let listaAlunos = gerenciadorDeBuscaAlunos?.fetchedObjects else { return }
        CalculaMediaAPI().calculaMediaGeralAlunos(alunos: listaAlunos, sucesso: { (dicionary) in
            if let alerta = Notificacoes().exibeMediaAlunos(dicitonary: dicionary) {
                self.present(alerta, animated: true, completion: nil)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //MARK: - SearchBarDelegate (Controla os métodos do search bar).
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Capiturar o que foi digitato no search.
        guard let alunoProcurado = searchBar.text else { return }
        self.getAlunos(name: alunoProcurado)
        self.tableView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.getAlunos()
        self.tableView.reloadData()
    }
    
}
