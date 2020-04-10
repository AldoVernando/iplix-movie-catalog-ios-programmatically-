//
//  MovieDetailViewController.swift
//  iplix
//
//  Created by TEMP on 4/7/20.
//  Copyright © 2020 aldovernando. All rights reserved.
//

import UIKit
import SDWebImage

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var foregroundPoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieReleasedDate: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var releasedDate: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    @IBOutlet weak var aboutBarBtn: UIBarButtonItem!
    @IBOutlet weak var infoBarBtn: UIBarButtonItem!
    @IBOutlet weak var reviewBarBtn: UIBarButtonItem!
    
    
    let network = ViewController.network
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        poster.addBlurEffect()
        foregroundPoster.layer.masksToBounds = true
        foregroundPoster.layer.borderWidth = 1.5
        foregroundPoster.layer.borderColor = UIColor.white.cgColor
        
        if let mov = movie {
            if let backdrop = mov.backdrop_path {
                poster.sd_setImage(with: URL(string: network.posterURL + backdrop))
            }
            if let poster = mov.poster_path {
                foregroundPoster.sd_setImage(with: URL(string: network.posterURL + poster))
            }
            movieTitle.text = mov.title
            releasedDate.text = mov.release_date
            rating.text = String(mov.vote_average!)
        }
        
        aboutBarBtn(aboutBarBtn)
        
    }
    
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func aboutBarBtn(_ sender: UIBarButtonItem) {
        
        changeColor(sender: sender)
        let vc = showViewController(controller: "MovieAboutViewController") as! MovieAboutViewController
        vc.movie = movie
        contentView.addSubview(vc.view)
        
    }
    
    @IBAction func infoBarBtn(_ sender: UIBarButtonItem) {
        
        changeColor(sender: sender)
        let vc = showViewController(controller: "MovieInformationViewController") as! MovieInformationViewController
        
        if let mov = movie {
            network.getMovieDetail(movieId: String(mov.id!)) { response in
                vc.movieDetail = response
                DispatchQueue.main.async {
                    self.contentView.addSubview(vc.view)
                }
            }
        }
        
    }
    
    @IBAction func reviewBarBtn(_ sender: UIBarButtonItem) {
        
        changeColor(sender: sender)
        let vc = showViewController(controller: "MovieReviewViewController") as! MovieReviewViewController
        
        if let mov = movie {
            vc.movie = mov
            network.getMovieReview(movieId: String(mov.id!)) { response in
                vc.reviews = response
                DispatchQueue.main.async {
                    self.addChild(vc)
                    self.contentView.addSubview(vc.view)
                }
            }
        }
        
    }
    
}


// MARK: UIImageView
extension UIImageView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds

        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    
}


// MARK: UIView
extension UIView {

    enum ViewSide {
        case Left, Right, Top, Bottom
    }

    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {

        let border = CALayer()
        border.backgroundColor = color

        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }

        layer.addSublayer(border)
    }
}


// MARK: Functions
extension MovieDetailViewController {
    
    
    // change selected bar color
    func changeColor(sender: UIBarButtonItem) {
        
        aboutBarBtn.tintColor = #colorLiteral(red: 0.2093600929, green: 0.3236650825, blue: 0.4488521814, alpha: 1)
        infoBarBtn.tintColor = #colorLiteral(red: 0.2093600929, green: 0.3236650825, blue: 0.4488521814, alpha: 1)
        reviewBarBtn.tintColor = #colorLiteral(red: 0.2093600929, green: 0.3236650825, blue: 0.4488521814, alpha: 1)
        sender.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    
    // show selected view controller
    func showViewController(controller: String) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: controller)
        
        return viewController
    }
    
}