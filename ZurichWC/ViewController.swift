//
//  ViewController.swift
//  ZurichWC
//
//  Created by Josep Lopez Fernandez on 24.09.17.
//  Copyright © 2017 Josep Lopez Fernandez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var wcList = [WC]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        title = "Zurich WC list"
        retrieveWCs()
    }
    
    func retrieveWCs() {
        let urlString: String = "https://data.stadt-zuerich.ch/dataset/zueri_wc_rollstuhlgaengig/resource/e2ce2b3d-cb2f-4414-b0c3-f510d7d39376/download/zueriwcrollstuhlgaengig.json"
        
        let url = URL(string: urlString)!
        
        URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                
                if let _ = error {
                    // : (
                    self.alertError()
                } else {
                    if let data = data,
                        let wrappedJson = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                        let json = wrappedJson as? [AnyHashable: Any],
                        let features = json["features"] as? [[AnyHashable: Any]] {
                        
                        self.wcList = features.map { wcInformation in
                            
                            guard let properties = wcInformation["properties"] as? [AnyHashable: Any],
                                  let name = properties["name"] as? String
                                    else { return WC(name: "fuckedName") }
                            return WC(name: name)
                        }.filter { wc in
                            return wc.name != "fuckedName"
                        }
                        self.tableView.reloadData()
                    }
                }
                
            }
            }.resume()
    }
    
    func alertError() {
        let alert = UIAlertController(title: "Error", message: "WC Kaputt :(", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "wcCell")
        cell.textLabel?.text = wcList[indexPath.row].name
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wcList.count
    }
}

