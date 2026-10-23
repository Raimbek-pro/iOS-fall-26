//
//  ViewController.swift
//  cinema4EXTRA
//
//  Created by Райымбек Омаров on 13.10.2026.
//

import UIKit




class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource  {
    let movies : [Movie] = [Movie(name: "Undertale movie" , image:  UIImage(named: "Undertale"), movieLink: "NEUTRAL") , Movie(name: "Haizenfin",image: UIImage(named: "Haizenfin"), movieLink: "goodedit") ]
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController( MovieController(name: movies[indexPath.row].name, image:  movies[indexPath.row].image, movieLink: movies[indexPath.row].movieLink), animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Movie", for: indexPath) as? MovieCell  else {
            print("gg")
            return UITableViewCell()}
        
   
        cell.configure(image: movies[indexPath.row].image, name: movies[indexPath.row].name)
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
 
        // Do any additional setup after loading the view.
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.register(MovieCell.self , forCellReuseIdentifier: "Movie")
        
    }


}

