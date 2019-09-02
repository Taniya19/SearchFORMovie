//
//  MovieList.swift
//  SearchBarAssignment
//
//  Created by Taniya on 22/07/19.
//  Copyright 2019 viktaan.com. All rights reserved.
//

import Foundation
import UIKit

class SetMovieDescription {

    struct MovieList {
        var category : String
        var name : String
        var ImgV: UIImage?
        var overView : String
        var language : String
        var releaseDate : String
        var rating : Float

        func printMovieData() {
            print("\(self.name) \(self.ImgV ?? UIImage(named: "TMDB-green"))")
        }
        
        init()
        {
            name = "Unknown";
            ImgV = UIImage(named: "TMDB-green")
            category = "-"
            overView = "-"
            language = "en"
            releaseDate = "-"
            rating = 0.0
        }
    }
}
