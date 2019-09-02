//
//  MovieListTableViewCell.swift
//  SearchBarAssignment
//
//  Created by Taniya on 7/23/19.
//  Copyright © 2019 Taniya. All rights reserved.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {
    
    // MARK: - Defining Cell Components
    
    @IBOutlet var movieListImages: UIImageView!
    @IBOutlet var movieTitleL: UILabel!
    @IBOutlet var movieRateL: UILabel!
    @IBOutlet var movieReleaseDateL: UILabel!
    @IBOutlet var movieOverviewL: UILabel!
    @IBOutlet weak var movieGetTag: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
