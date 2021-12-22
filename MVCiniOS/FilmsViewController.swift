//
//  FilmsViewController.swift
//  GETFilms
//
//  Created by admin on 22/12/2021.
//

import UIKit

class FilmsViewController: UIViewController {

    var filmsList = [String]()
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StarWarsModel.getAllFilms { data, response, error in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    if let results = jsonResult["results"] as? NSArray {
                        for person in results {
                            let personDict = person as! NSDictionary
                            self.filmsList.append(personDict["title"]! as! String)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                }
            } catch {
                print("Something went wrong")
            }
        }
        mainTableView.dataSource = self
    }
}

extension FilmsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilmsCell", for: indexPath)
        cell.textLabel?.text = filmsList[indexPath.row]
        return cell
    }
}
