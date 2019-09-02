//
//  MovieDetailsViewController.swift
//  SearchBarAssignment
//
//  Created by Taniya on 22/07/19.
//  Copyright 2019 viktaan.com. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController, webServiceDelegate, UITextViewDelegate {
    
    // MARK: - define & declare objects
    @IBOutlet var SelectedMovieDetailedImage: UIImageView!
    @IBOutlet var movieOverviewTextView : UITextView!
    @IBOutlet weak var movieTitleL: UILabel!
    @IBOutlet var languageL: UILabel!
    @IBOutlet var releaseDateL: UILabel!
    @IBOutlet var ratingL: UILabel!
    
    var detailMovie = SetMovieDescription.MovieList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBtn: UIButton = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "back_icon"), for: [])
        backBtn.addTarget(self, action: #selector(logoutUser), for: .touchUpInside)
        backBtn.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
        backBtn.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        
        let backButton = UIBarButtonItem(customView: backBtn)
        self.navigationItem.setLeftBarButtonItems([backButton], animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.movieTitleL?.text = "\(self.detailMovie.name)"
        self.movieOverviewTextView.text = "\(self.detailMovie.overView)"
        self.languageL.text = "\(self.detailMovie.language)"
        self.releaseDateL.text = "\(self.detailMovie.releaseDate)"
        self.ratingL.text = "\(self.detailMovie.rating)"
        self.SelectedMovieDetailedImage.image = self.detailMovie.ImgV
    }
    
    func setStructDataReference(structDataReference:SetMovieDescription.MovieList)
    {
        detailMovie = structDataReference;
        detailMovie.printMovieData()
    }
    
    @objc func logoutUser(){
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
