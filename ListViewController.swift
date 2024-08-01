//
//  ListViewController.swift
//  TravelBook
//
//  Created by Sabri Çetin on 18.05.2024.
//

import UIKit
import CoreData

class ListViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var tittleArray = [String]()
    var idArray = [UUID]()
    var chosenTitle = ""
    var chosenİd : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
           NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newPlace"), object: nil)
       }
    
    //Verileri TableView'de Göstermek
    
   @objc func getData () {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                self.tittleArray.removeAll(keepingCapacity: false)
                self.idArray.removeAll(keepingCapacity: false)
                
                for result in results   as! [NSManagedObject] {
                    if let tittle =  result.value(forKey: "tittle") as? String {
                        self.tittleArray.append(tittle)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        self.idArray.append(id)
                    }
                    tableView.reloadData()
                }
            }
            
        }catch {
            print ("error!!!")
        }
    }
    
    //Diğer Sayfaya Gitme
    
    @objc func addButtonClicked () {
        chosenTitle = ""
        performSegue(withIdentifier: "toViewController", sender: nil)    }
    
    //TableView Ayarları
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tittleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = tittleArray[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    // Seçilen Veriyi Yollamak
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenTitle = tittleArray[indexPath.row]
        chosenİd = idArray[indexPath.row]
        
        performSegue(withIdentifier: "toViewController", sender: nil )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toViewController" {
            let destinationVC = segue.destination as! ViewController
            destinationVC.selectedTitle = chosenTitle
            destinationVC.selectedİd = chosenİd
            
        }
    }
}
