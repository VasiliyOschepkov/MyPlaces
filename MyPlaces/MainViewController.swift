//
//  MainViewController.swift
//  MyPlaces
//
//  Created by Vasiliy Oschepkov on 13/04/2019.
//  Copyright © 2019 Vasiliy Oschepkov. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var places: Results<Place>!
    private var filterPlases: Results<Place>!
    private var ascendingSorted = true
    private var searchController = UISearchController(searchResultsController: nil)
    private var isFiltering: Bool {
        return searchController.isActive && !searchTextIsEmpty
    }
    private var searchTextIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var sortingBarBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        places = realm.objects(Place.self)
        
        // Setup search controller
        searchController.searchResultsUpdater = self
        // Отключаем параметр, для того чтобы взаимодействовать с отображаемым результатом
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        // Интегрируем строку поиска в навигатор
        navigationItem.searchController = searchController
        // Отпускаем строку поиска при переходе на другой экран
        definesPresentationContext = true
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filterPlases.count
        }
        return places.isEmpty ? 0 : places.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomViewCell

        let place: Place
        if isFiltering {
            place = filterPlases[indexPath.row]
        }else {
            place = places[indexPath.row]
        }

        cell.nameLabel?.text = place.name
        cell.locationLabel?.text = place.location
        cell.typeLabel?.text = place.type
        cell.imageOfPlace.image = UIImage(data: place.image!)

        cell.imageOfPlace?.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
        cell.imageOfPlace?.clipsToBounds = true

        return cell
    }
    
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let place = places[indexPath.row]
        
        let actionDelete = UITableViewRowAction(style: .default, title: "Delete") { (_, _) in
            StorageManager.deleteObject(place)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return [actionDelete]
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetail") {
            guard let dvc = segue.destination as? NewPlaceViewController else {return}
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            
            let place: Place
            if isFiltering {
                place = filterPlases[indexPath.row]
            }else {
                place = places[indexPath.row]
            }
            
            dvc.currentPlace = place
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let svc = segue.source as? NewPlaceViewController else {return}
        svc.savePlace()
        tableView.reloadData()
    }
    
    @IBAction func ChangeSegmentedControl(_ sender: UISegmentedControl) {
        sorting()
    }
    
    @IBAction func sortedPlace(_ sender: UIBarButtonItem) {
        ascendingSorted.toggle()
        
        if ascendingSorted {
            sortingBarBtn.image = #imageLiteral(resourceName: "AZ")
        }else {
            sortingBarBtn.image = #imageLiteral(resourceName: "ZA")
        }
        
        sorting()
    }
    
    private func sorting() {
        if segmentedControl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorted)
        }else {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorted)
        }
        
        tableView.reloadData()
    }
}


extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchResult(searchController.searchBar.text!)
    }
    
    private func searchResult(_ searchText: String) {
        filterPlases = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)
        
        tableView.reloadData()
    }
}

