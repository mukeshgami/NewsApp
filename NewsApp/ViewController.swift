//
//  ViewController.swift
//  NewsApp
//
//  Created by Mukesh Gami on 22/05/19.
//  Copyright © 2019 Mukesh Gami. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var news = [Article]()
    var refreshControl = UIRefreshControl()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableCell", for: indexPath) as? NewsTableCell
        let article = news[indexPath.row]
        
        guard let imageUrl =  URL(string: article.urlToImage ?? "" ) else {
            return cell!
        }
        
        cell?.articleImage.load(url: imageUrl)
        
        cell?.articleTitle.text = article.title
        cell?.articleDescription.text = article.articleDescription
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        cell?.articleDate.text = dateFormatterGet.string(from: article.publishedAt!)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell tapped")
        let article = news[indexPath.row]
        guard let articleUrl =  URL(string: article.url ?? "") else {
           //articleUrl = URL(string: "www.google.com")
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(articleUrl, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(articleUrl)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        fetchData()
    }
    
    func fetchData() {
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=in&apiKey=9b1efd00a49348d99756019e0f40367c&page=1")!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let newsVal = try? newJSONDecoder().decode(News.self, from: data!) {
                self.news = newsVal.articles!
                print("news123", self.news)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }
        task.resume()
    }
    
    @objc func refresh() {
        print("refresh strart")
        fetchData()
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
