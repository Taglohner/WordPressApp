//
//  MainTableViewController.swift
//  WordPressBlogApp
//
//  Created by Steven Taglohner on 31/08/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import UIKit
import CoreData
import Reachability

class MainTableViewController: CoreDataTableViewController {
    
    //MARK: Properties
    
    let reachability = Reachability()!
    var page = 1
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* UI configuration */
        self.tableView.separatorColor = .white
        self.navigationItem.titleView = UIImageView(image: StyleKit.imageOfSwiftPadawanLogo())
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Oxygen-Light", size: 18)!], for: .normal)
        
        /* creates a fetch request */
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.stack.context, sectionNameKeyPath: "date", cacheName: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateData()
        
        /* UI configuration */
        self.navigationController?.hidesBarsOnSwipe = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
    }
    
    
    // MARK: - TableView Data Source
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainTableViewCell", for: indexPath) as! MainTableViewCell
        
        if let post = fetchedResultsController?.object(at: indexPath) as? Post {
            if let postImage = post.featuredImage {
                cell.postImage.image = UIImage(data: postImage)
            } else {
                cell.postImage.image = UIImage(named: "placeholder")
            }
            cell.configureCellLayout(post: post)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let totalItems = fetchedResultsController?.fetchedObjects?.count {
            let lastItem = totalItems - 4
            if indexPath.row == lastItem && page < Response.numberOfPages {
                getPosts(page: page + 1, number: nil)
                page += 1
            } else {
                return
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
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
            headerLabel.backgroundColor = .clear
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
    
    /* get new posts from WordPress */
    func getPosts(page: Int, number: Int?) {
        RequestWordPressData.sharedInstance().getPostsFromWordPress(page: page, numberOfPosts: number) { (result) in
            switch result {
            case .Success(let data):
                self.saveInCoreDataWith(dictionary: data)
            case .Error(let error):
                print(error)
            }
        }
    }
    
    /* observe the internet connectivity */
    func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable {
            print("Online")
        } else {
            print("Internet connection appears to be offline")
        }
    }
    
    /* update data based on internet availability */
    func updateData() {
        reachability.whenReachable = { reachability in
            DispatchQueue.main.async {
                if reachability.isReachable {
                    self.clearData()
                    self.getPosts(page: 1, number: nil)
                }
            }
        }
        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                print("Internet is not reachable")
            }
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    /* creates a NSManagedObject from a PostObject */
    private func createPhotoEntityFrom(json: [String : AnyObject]) -> NSManagedObject? {
        let context = AppDelegate.stack.context
        if let postEntity = NSEntityDescription.insertNewObject(forEntityName: "Post", into: context) as? Post {
            
            let object = PostObject(json: json)
            
            postEntity.type = object?.type
            postEntity.id = object?.id ?? 1
            postEntity.title = object?.title
            postEntity.modified = object?.modified
            postEntity.link = object?.link
            postEntity.excerpt = object?.excerpt
            postEntity.featuredImageURL = object?.imageURL
            
            /* converting date format before saving to Core Data */
            DispatchQueue.main.async {
                postEntity.date = object?.date.toDateString(inputFormat: "yyyy-MM-dd'T'HH:mm:ss", outputFormat: "EEEE, dd MMMM")
            }
            
            if let photoURL = postEntity.featuredImageURL {
                RequestWordPressData.sharedInstance().imageDataFrom(photoURL) { (result) in
                    
                    switch result {
                    case .Success(let imageData):
                        DispatchQueue.main.async {
                            postEntity.featuredImage = imageData
                            AppDelegate.stack.save()
                        }
                    case .Error(let error):
                        print(error)
                    }
                }
            }
            return postEntity
        }
        return nil
    }
    
    /* save objects to core data after converting to a managed onject */
    private func saveInCoreDataWith(dictionary: [[String : AnyObject]]) {
        for object in dictionary {
            _  = createPhotoEntityFrom(json: object)
            AppDelegate.stack.save()
        }
    }
    
    /* clear the data base data */
    private func clearData() {
        do {
            let context = AppDelegate.stack.context
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
            do {
                if let fetchedObjects  = try context.fetch(fetchRequest) as? [NSManagedObject] {
                    for object in fetchedObjects {
                        context.delete(object)
                    }
                    AppDelegate.stack.save()
                } else {
                    print("Error fetching objects.")
                }
            }
        } catch let error {
            print("ERROR DELETING : \(error)")
        }
    }
}


