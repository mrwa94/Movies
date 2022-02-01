//
//  ViewController.swift
//  Movies
//
//  Created by Ayman alsubhi on 29/06/1443 AH.
//

import UIKit
import Alamofire
import AlamofireImage

class ViewController: UIViewController {
    
    var moveis =  [[String: Any]]()
    let url = "https://api.tvmaze.com/shows"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
      collectionView.delegate = self
     
        fetchData()
        
    
    }


    func fetchData(){
        AF.request(url).responseJSON(){ response in
            switch response.result {
            case.success(let data):
                DispatchQueue.main.async {
                    self.moveis = (data) as! [[String : Any]]
                    self.collectionView.reloadData()
                }
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        
            
        }
      
    }
    
    
}

extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moveis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionViewCell", for: indexPath) as! MoviesCollectionViewCell
      
        
        cell.title_label.text = moveis[indexPath.row]["name"] as! String

        //Get Images
        cell.imageView.layer.cornerRadius = 9

        let urlImage = moveis[indexPath.row]["image"] as? [String: Any]
    
        let imgURL = urlImage!["medium"] as? String
        
        AF.request(imgURL!).responseImage { response in
            if case .success(let image) = response.result {
                DispatchQueue.main.async {
                    cell.imageView.image = image
                }
                
            } else if case .failure(let error) = response.result {
                print(error.localizedDescription)
            }
     
        
    }
    
        return cell
}
    
   

    
}


extension ViewController :UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 300)
    }
    
}

extension ViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsID") as! DetailsViewController
        // move to details view
         present(vc, animated: true, completion: nil)
     // info transfer to other view
        vc.summry_label.text = moveis[indexPath.row] ["summary"] as? String
        
        let Rating = moveis[indexPath.row]["rating"] as? [String: Any]
        vc.rating_label.text = "Rating: "+String(describing: Rating!["average"] as! Double)
        
        vc.languge_label.text? =  moveis[indexPath.row]["language"] as! String
    
        //Get Images
        let urlImage = moveis[indexPath.row]["image"] as? [String: Any]
    
        let imgURL = urlImage!["medium"] as? String
        
        AF.request(imgURL!).responseImage { response in
            if case .success(let image) = response.result {
                DispatchQueue.main.async {
                    vc.imageView.image = image
                }
                
            } else if case .failure(let error) = response.result {
                print(error.localizedDescription)
            }
     
        
    }
         
      
    
    }
    
}
