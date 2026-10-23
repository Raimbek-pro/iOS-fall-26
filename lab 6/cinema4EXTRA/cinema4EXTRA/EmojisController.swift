//
//  EmojisController.swift
//  cinema4EXTRA
//
//  Created by Райымбек Омаров on 14.10.2026.
//

import Foundation


import UIKit

class EmojisController : UIViewController {
    var onTap : ((Int) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scroll = UIScrollView()
        let stack = UIStackView()
        
        
        scroll.addSubview(stack)
        view.addSubview(scroll)
       
        scroll.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.axis = .horizontal
        stack.spacing = 10
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        for i in 1...9 {
            let box = UIView()
            
            let emoji = UIImageView(image: UIImage(named: "emoji\(i)"))
            emoji.contentMode = .scaleAspectFit
            emoji.translatesAutoresizingMaskIntoConstraints = false
            box.addSubview(emoji)
            box.widthAnchor.constraint(equalToConstant: 100).isActive = true
            box.tag = i
            
            NSLayoutConstraint.activate([
                emoji.topAnchor.constraint(equalTo: box.topAnchor),
                emoji.bottomAnchor.constraint(equalTo: box.bottomAnchor),
                emoji.leadingAnchor.constraint(equalTo: box.leadingAnchor),
                emoji.trailingAnchor.constraint(equalTo: box.trailingAnchor)
            ])
           
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleViewTap(_:)))
            box.addGestureRecognizer(tapGesture)
            stack.addArrangedSubview(box)
        }
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor ),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor),
            stack.heightAnchor.constraint(equalTo: scroll.frameLayoutGuide.heightAnchor),
            
            ])

    }
    @objc func handleViewTap( _ sender : UITapGestureRecognizer){
        if let tag = sender.view?.tag {
            onTap?(tag)
        }
    }
}
