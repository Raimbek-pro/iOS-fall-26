//
//  MovieCell.swift
//  cinema4EXTRA
//
//  Created by Райымбек Омаров on 13.10.2026.
//

import UIKit
class MovieCell : UITableViewCell {
    var  imageCanvas   : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "photo.artframe")
        return imageView

    }()
    
    var myView = UIView()
    let label : UILabel  = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints  = false
        label.font = .systemFont(ofSize: 20)
        label.textColor = .label
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
 
        myView.addSubview(imageCanvas)
        
        contentView.addSubview(myView)
        myView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myView.topAnchor.constraint(equalTo: contentView.topAnchor),
            myView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            myView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            myView.bottomAnchor.constraint(equalTo: label.topAnchor),
            myView.heightAnchor.constraint(equalToConstant: 200),
            
            imageCanvas.topAnchor.constraint(equalTo: myView.topAnchor),
            imageCanvas.leadingAnchor.constraint(equalTo: myView.leadingAnchor),
            imageCanvas.trailingAnchor.constraint(equalTo: myView.trailingAnchor),
            imageCanvas.bottomAnchor.constraint(equalTo: myView.bottomAnchor),
            
            label.topAnchor.constraint(equalTo: myView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            label.heightAnchor.constraint(equalToConstant: 30)

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(image : UIImage? , name : String) {
        self.imageCanvas.image = image ?? UIImage(systemName: "photo.artframe")
        
     
        self.label.text = name
        
    }
}
