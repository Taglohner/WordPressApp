//
//  MainTableViewController.swift
//  WordPressBlogApp
//
//  Created by Steven Taglohner on 31/08/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: CoreDataTableViewController, NVActivityIndicatorViewable {
    
    //MARK: Properties
    
    var topRefreshControl = UIRefreshControl()
    let reachability = Reachability()!
    let coreDataStack = AppDelegate.stack
    let wordpressAPIService = APIService.sharedInstance()
    let messageLabel = UILabel()
    let lightGrayColor = UIColor(r: 236, g: 236, b: 236, alpha: 1)
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64), type: nil, color: .orange, padding: 184)
    
    var page = 1
    var lastFetchTotalPages = Int()
    var lastFecthTotalPosts = Int()
    var lastConnectionStatusConnected = true
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchFreshData()
        
        /* creates a Fetch Request */
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.context, sectionNameKeyPath: "date", cacheName: nil)
        
        /* UI configuration */
        
        activityIndicatorView.backgroundColor = lightGrayColor
        navigationController?.view.addSubview(activityIndicatorView)
        navigationController?.view.addSubview(messageLabel)
        
        self.navigationController?.navigationBar.tintColor = .orange
        self.tableView.backgroundColor = lightGrayColor
        self.navigationItem.titleView = UIImageView(image: StyleKit.imageOfSwiftPadawanLogo())
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Oxygen-Light", size: 18)!], for: .normal)
        
        /* connection status label */
        messageLabel.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: 24)
        messageLabel.autoresizingMask = .flexibleWidth
        messageLabel.text = "Check your internet connectivity"
        messageLabel.font = UIFont(name: "Oxygen-Light", size: 14)
        messageLabel.textColor = .black
        messageLabel.backgroundColor = .orange
        messageLabel.textAlignment = .center
        messageLabel.isHidden()
        
        tableView.refreshControl = topRefreshControl
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if topRefreshControl.isRefreshing {
            
            wordpressAPIService.getPosts(page: 1, numberOfPosts: 1, save: false) { (pages,posts, error) in
                
                guard error == nil else {
                    return print(error ?? "")
                }
                guard let posts = posts else {
                    return print("error occurred couting posts and pages")
                }
                
                if posts > self.lastFecthTotalPosts {
                    
                    self.wordpressAPIService.getPosts(page: 1, numberOfPosts: (posts - self.lastFecthTotalPosts), save: true) { (pages, posts, error) in
                        
                        guard error == nil else {
                            return print(error ?? "")
                        }
                        guard let pages = pages, let posts = posts else {
                            return print("error occurred couting posts and pages")
                        }
                        self.lastFecthTotalPosts = posts
                        self.lastFetchTotalPages = pages
                    }
                }
            }
            topRefreshControl.endRefreshing()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let yOffSet = tableView.contentOffset.y
        let tableHeight = tableView.contentSize.height - tableView.frame.size.height
        let scrolledPercentage = yOffSet / tableHeight
        
        if scrolledPercentage > 0.45 && scrolledPercentage < 0.65 && page < lastFetchTotalPages {
            wordpressAPIService.getPosts(page: page + 1, numberOfPosts: nil, save: true) { (pages, posts, error) in }
            page += 1
        } else {
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.last != nil {
            activityIndicatorView.stopAnimating()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        tableView.estimatedRowHeight = 320
        tableView.rowHeight = UITableViewAutomaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: Notification.Name.reachabilityChanged,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: reachability)
    }
    
    // MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let post = fetchedResultsController?.object(at: indexPath) as? Post, let postTitle = post.title, let postExcerpt = post.excerpt, let postImage = post.featuredImage, let author = post.author else {
            return UITableViewCell()
        }
        
        if post.cellType == "featured" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "featuredPostCell", for: indexPath) as! FeaturedPostTableViewCell
            
            DispatchQueue.main.async {
                cell.featuredImage.image = UIImage(data: postImage)
                cell.titleLabel.text = postTitle
                cell.excerptLabel.text = postExcerpt
                
                if let avatarImageData = author.avatarImageData {
                    cell.avatarImage.image = UIImage(data: avatarImageData)
                } else {
                    cell.avatarImage.image = UIImage(named: "avatar")
                }
                
                if let authorDisplayName = author.displayName {
                    cell.authorNameLabel.text = authorDisplayName
                } else {
                    cell.authorNameLabel.text = "Unknown Author"
                }
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "regularPostCell", for: indexPath) as! RegularPostTableViewCell
            
            DispatchQueue.main.async {
                cell.postImage.image = UIImage(data: postImage)
                cell.titleLabel.text = postTitle
                cell.excerptLabel.text = postExcerpt
                
                if let avatarImageData = author.avatarImageData {
                    cell.avatarImage.image = UIImage(data: avatarImageData)
                } else {
                    cell.avatarImage.image = UIImage(named: "avatar")
                }
                
                if let authorDisplayName = author.displayName {
                    cell.authorNameLabel.text = authorDisplayName
                } else {
                    cell.authorNameLabel.text = "Unknown Author"
                }
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let post = fetchedResultsController?.object(at: indexPath) as? Post, let cellType = post.cellType else {
            return 0
        }
        if cellType == "featured" {
            return 400
        }
        else {
            return 250
        }
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard let post = fetchedResultsController?.object(at: indexPath) as? Post, let cellType = post.cellType else {
//            return 0
//        }
//        if cellType == "featured" {
//            return 440
//        }
//        else {
//            return 237
//        }
//    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 26
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let sectionName = fetchedResultsController?.sections![section].name {
            
            /* configure the blur effect */
            let blurEffect = UIBlurEffect(style: .light)
            
            /* creates the blurry view */
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 24)
            blurEffectView.autoresizingMask = .flexibleWidth
            
            /* creates the header text label */
            let headerLabel = UILabel()
            headerLabel.frame = blurEffectView.frame
            headerLabel.autoresizingMask = .flexibleWidth
            headerLabel.text = sectionName
            headerLabel.font = UIFont(name: "Oxygen-Light", size: 14)
            headerLabel.textColor = .orange
            headerLabel.textAlignment = .center
            
            /* add the label to the view */
            blurEffectView.contentView.addSubview(headerLabel)
            return blurEffectView
        }
        return nil
    }
    
    // MARK: Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationViewController = self.storyboard!.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        if let selectedPost = fetchedResultsController?.object(at: indexPath) as? Post {
            destinationViewController.postID = Int(selectedPost.id)
            self.navigationController!.pushViewController(destinationViewController, animated: true)
        } else {
            return
        }
    }
    
    // MARK: Supporing methods
    
    /* observe the internet connectivity */
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi, .cellular:
            self.messageLabel.fadeOut()
            self.tableView.bounces = true
            
            /* fetch fresh data if the internet connection has been restablish after a connection break */
            if !lastConnectionStatusConnected {
                fetchFreshData()
            }
        case .none:
            self.messageLabel.fadeIn()
            self.tableView.bounces = false
            lastConnectionStatusConnected = false
        }
    }
    
    func clearData(){
        do {
            let context = coreDataStack.context
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
            do {
                guard let objects = try context.fetch(fetchRequest) as? [NSManagedObject] else {
                    print("Error fetching data to delete.")
                    return
                }
                for object in objects {
                    context.delete(object)
                }
            }
            catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    func fetchFreshData(){
        activityIndicatorView.startAnimating()
        if reachability.connection != .none {
            /* reset the page you're on */
            page = 1
            
            /* clear all data */
            self.clearData()
            
            /* fetch new data */
            wordpressAPIService.getPosts(page: 1, numberOfPosts: nil, save: true) { (pages, posts, error) in
                guard error == nil else {
                    return print(error ?? "")
                }
                
                guard let pages = pages, let posts = posts else {
                    return print("error occurred couting posts and pages")
                }
                self.lastFetchTotalPages = pages
                self.lastFecthTotalPosts = posts
                self.lastConnectionStatusConnected = true
            }
        } else {
            lastConnectionStatusConnected = false
        }
    }
}


