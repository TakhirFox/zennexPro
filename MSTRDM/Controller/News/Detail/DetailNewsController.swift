//
//  DetailNewsController.swift
//  MSTRDM
//
//  Created by Zakirov Tahir on 27.02.2021.
//

import UIKit
import WebKit

class DetailNewsController: UIViewController, WKUIDelegate {
    
    // MARK: - Private Properties
    
    private var webPage: WKWebView!
    private let connectMessage = UILabel(text: "Инторнет вам не нужон?", font: .boldSystemFont(ofSize: 24), numberOfLines: 2, textColor: .white)
    private let negativeEmoji = UILabel(text: "🥺", font: .boldSystemFont(ofSize: 154), numberOfLines: 1)
    private let jerryImage = UIImageView(image: UIImage(named: "jerry"))
    
    // MARK: - Public Properties
    
    var baseURL: String?
    var titleBar: String?

    // MARK: - Lifecycle
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.tabBarController?.tabBar.frame.origin.y -= 100
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.tabBarController?.tabBar.frame.origin.y += 100
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkNetwork()
        setupNavigationBar()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationBar() {
        self.navigationItem.title = titleBar
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func checkNetwork() {
        if Reachability.isConnected(){
            configWeb()
            
            guard let urlPage = URL(string: baseURL ?? "") else { return }
            let request = URLRequest(url: urlPage)
            webPage.load(request)
        } else {
            
            let verticalStackView = VerticalStackView(arrangedSubviews: [
                jerryImage, connectMessage
            ])
            
            view.addSubview(verticalStackView)
            
            jerryImage.constrainHeight(constant: 200)
            connectMessage.textAlignment = .center

            verticalStackView.centerXInSuperview()
        }
    }
    
    // Configure webkit
    private func configWeb() {
        let webConfig = WKWebViewConfiguration()
        webPage = WKWebView(frame: .zero, configuration: webConfig)
        webPage.uiDelegate = self
        view = webPage
    }
    
    
}
