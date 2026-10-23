//
//  MovieController.swift
//  cinema4EXTRA
//
//  Created by Райымбек Омаров on 13.10.2026.
//

import UIKit
import AVKit
class MovieController : UIViewController  , AVPlayerViewControllerDelegate ,UIPopoverPresentationControllerDelegate {
    var name : String
    var movieLink : String
    var playerViewControllerIfLoaded  : AVPlayerViewController?
    var emojisStack = UIStackView()
    var myView = UIView()
    var cancelButton = UIButton()
    var overlayView = UIView()
    var myRect = UIView()
    var backOverlay = UIView()
    var newone = UIImageView()
    var pickedEmojis : [String] = []
    var  imageCanvas   : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "photo.artframe")
        return imageView

    }()
    
  
    
    let label : UILabel  = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints  = false
        label.font = .systemFont(ofSize: 20)
        label.textColor = .label
        return label
    }()
    
    init(name: String, image: UIImage? = nil , movieLink : String) {
        self.imageCanvas.image = image ?? UIImage(systemName: "photo.artframe")
        self.name = name
      
        self.label.text = name
        self.movieLink = movieLink
        super.init(nibName: nil, bundle:  nil)
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        myView.addSubview(imageCanvas)
        
        
        
        myView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleViewTap(_:)))
        myView.addGestureRecognizer(tapGesture)
        view.addSubview(myView)
        myRect.backgroundColor  = .gray
        view.addSubview(myRect)
        view.addSubview(label)
        myView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        myRect.translatesAutoresizingMaskIntoConstraints = false

        loadPlayerViewControllerIfNeeded()
        
        let tapGestureVideo = UILongPressGestureRecognizer(target: self, action: #selector(handleVideoTap(_:)))
        tapGestureVideo.minimumPressDuration = 1.0
        myRect.addGestureRecognizer(tapGestureVideo)

   
        
        view.addSubview(emojisStack)
        emojisStack.translatesAutoresizingMaskIntoConstraints = false
        emojisStack.alignment = .fill
        emojisStack.spacing = 5
        guard let playerViewController = playerViewControllerIfLoaded else { return }
        playerViewController.delegate = self
        
     
        guard let videoUrl = Bundle.main.url(forResource: movieLink, withExtension: "mp4") else {
            print("NEUTRAL.mp4 not found in bundle")
            return
        }
        playerViewController.player = AVPlayer(url: videoUrl)
        
   

        addChild(playerViewController)
        myRect.addSubview(playerViewController.view)
        myRect.clipsToBounds = true
        
        
  

 
        let pv = playerViewController.view!
        pv.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            myView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myView.leadingAnchor.constraint(equalTo:    view.leadingAnchor),
            myView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myView.bottomAnchor.constraint(equalTo: label.topAnchor),
            myView.heightAnchor.constraint(equalToConstant: 200),
            
            imageCanvas.topAnchor.constraint(equalTo: myView.topAnchor),
            imageCanvas.leadingAnchor.constraint(equalTo: myView.leadingAnchor),
            imageCanvas.trailingAnchor.constraint(equalTo: myView.trailingAnchor),
            imageCanvas.bottomAnchor.constraint(equalTo: myView.bottomAnchor),
            
        
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: myRect.topAnchor, constant: -8),
            label.heightAnchor.constraint(equalToConstant: 30),
            
          
            myRect.leadingAnchor.constraint(equalTo:    view.leadingAnchor , constant: 16),
            myRect.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16 ),
            myRect.heightAnchor.constraint(equalToConstant: 200),
            
            pv.topAnchor.constraint(equalTo: myRect.topAnchor),
            pv.leadingAnchor.constraint(equalTo: myRect.leadingAnchor),
            pv.trailingAnchor.constraint(equalTo: myRect.trailingAnchor),
            pv.bottomAnchor.constraint(equalTo: myRect.bottomAnchor),
            
            emojisStack.topAnchor.constraint(equalTo: myRect.bottomAnchor, constant: 5),
            emojisStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            
            emojisStack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -5),
            emojisStack.heightAnchor.constraint(equalToConstant: 50)
            

        ])
        playerViewController.didMove(toParent: self)
   //     playerViewController.player?.play()
    }
    
    @objc private func handleVideoTap(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began, presentedViewController == nil else { return }
      let new =   EmojisController()
        new.modalPresentationStyle = .popover
        new.onTap = {[weak self] index in
            guard let self = self else {return}
            self.pickedEmojis.append("emoji\(index)")
            let boxi = UIView()
           
            let canvas = UIImageView(image: UIImage(named: self.pickedEmojis.last!))
            canvas.contentMode = .scaleAspectFit
            boxi.widthAnchor.constraint(equalToConstant: 50).isActive = true
            boxi.addSubview(canvas)
            
            canvas.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                canvas.topAnchor.constraint(equalTo: boxi.topAnchor ),
                canvas.leadingAnchor.constraint(equalTo: boxi.leadingAnchor),
                canvas.trailingAnchor.constraint(equalTo: boxi.trailingAnchor),
                canvas.bottomAnchor.constraint(equalTo: boxi.bottomAnchor),
            ])
            emojisStack.addArrangedSubview(boxi)
        }
        let width: CGFloat = 320
                  let minHeight: CGFloat = 140
                  let maxHeight: CGFloat = 340   // raised from 280

               
                  let clampedHeight = min(max(100, minHeight), maxHeight)

                  new.preferredContentSize = CGSize(width: width, height: clampedHeight)

        
        if let popover = new.popoverPresentationController {
            popover.sourceView = myRect
            popover.sourceRect = myRect.bounds
            popover.permittedArrowDirections = .any
            popover.delegate = self
        }
        self.present(new,animated: true)
        
    }
    
    @objc private func handleViewTap(_ sender: UITapGestureRecognizer) {
        print("MY VIEW TAPPED!")
         newone =  UIImageView(image: imageCanvas.image)
        
        newone.translatesAutoresizingMaskIntoConstraints = false
        newone.contentMode = .scaleAspectFit
        backOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(backOverlay)
        backOverlay.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(newone)
        view.addSubview(overlayView)
        cancelButton.setImage(UIImage(systemName: "x.circle"), for: .normal)
        cancelButton.tintColor = .white
        cancelButton.addTarget(self, action: #selector(closeWindow), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        let wantWidth = newone.widthAnchor.constraint(equalTo: overlayView.widthAnchor, multiplier: 2.0)
        wantWidth.priority = .defaultHigh   // 750
        let wantHeight = newone.heightAnchor.constraint(equalTo: overlayView.heightAnchor, multiplier: 2.0)
        wantHeight.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
           
            overlayView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.heightAnchor.constraint(equalToConstant: 200),
            
            backOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            backOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            newone.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            newone.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            // Limits: never go past the screen (required)
               newone.widthAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.widthAnchor, constant: -32),
               newone.heightAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor, constant: -32),

               wantWidth,
               wantHeight,
            cancelButton.widthAnchor.constraint(equalToConstant: 44),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            cancelButton.bottomAnchor.constraint(equalTo: overlayView.topAnchor),
            
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
           
        ])
    }
    @objc private func closeWindow() {
        cancelButton.removeFromSuperview()
        overlayView.removeFromSuperview()
        backOverlay.removeFromSuperview()
        newone.removeFromSuperview()
    }
    
    private func loadPlayerViewControllerIfNeeded() {
        if playerViewControllerIfLoaded == nil {
            playerViewControllerIfLoaded = AVPlayerViewController()
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController,
                                   traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        .none
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
    
}
