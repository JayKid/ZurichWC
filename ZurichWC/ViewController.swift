//
//  ViewController.swift
//  ZurichWC
//
//  Created by Josep Lopez Fernandez on 24.09.17.
//  Copyright © 2017 Josep Lopez Fernandez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var wcList = [WC]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.delegate = self
        collectionView.dataSource = self
        title = "Zurich WC list"
        retrieveWCs()
        let nib = UINib(nibName: "WCCell", bundle: nil)
        navigationController?.hidesBarsOnSwipe = true
        collectionView.register(nib, forCellWithReuseIdentifier: WCCell.reuseIdentifier)
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
                        let wcList = try? JSONDecoder().decode(WCStore.self, from: data).values {
                            self.wcList = wcList
                        }
                        self.collectionView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseIn], animations: {
            cell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.2, options: [], animations: {
                cell?.transform = CGAffineTransform.identity
            }, completion: nil)
        })
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wcList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.bounds.width) - 40
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WCCell.reuseIdentifier,
            for: indexPath) as! WCCell
        
        cell.configure(wcList[indexPath.row])
        
        return cell
    }
}

