//
//  ViewController.swift
//  MVCiniOS
//
//  Created by admin on 22/12/2021.
//

import UIKit

class PeopleViewController: UIViewController {

    
    var pageNumber = 1
    var peopleList = [String]()
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var pageNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        check()
        gettingPeopleList()
        mainTableView.dataSource = self
    }
    
    func gettingPeopleList() {
        peopleList.removeAll()
        StarWarsModel.getAllPeople(pageNumber: self.pageNumber, completionHandler: { // passing what becomes "completionHandler" in the 'getAllPeople' function definition in StarWarsModel.swift
            data, response, error in
            do {
                // Try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    if let results = jsonResult["results"] as? NSArray {
                        for person in results {
                            let personDict = person as! NSDictionary
                            self.peopleList.append(personDict["name"]! as! String)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.mainTableView.reloadData()
                }
            } catch {
                print("Something went wrong")
            }
        })
    }

    @IBAction func nextButtonPressed(_ sender: UIButton) {
        pageNumber += 1
        pageNumberLabel.text = "Page: \(pageNumber)/9"
        check()
        gettingPeopleList()
    }
    @IBAction func previousButtonPressed(_ sender: UIButton) {
        pageNumber -= 1
        pageNumberLabel.text = "Page: \(pageNumber)/9"
        check()
        gettingPeopleList()
    }
    func check() {
        if pageNumber == 9 {
            nextButton.isEnabled = false
        }else {
            nextButton.isEnabled = true
        }
        if pageNumber == 1 {
            previousButton.isEnabled = false
        }else {
            previousButton.isEnabled = true
        }
    }
    
}

extension PeopleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = peopleList[indexPath.row]
        return cell
    }
    
    
}
