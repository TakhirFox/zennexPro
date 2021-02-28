//
//  DetailNewsController.swift
//  MSTRDM
//
//  Created by Zakirov Tahir on 27.02.2021.
//

import UIKit
import WebKit

class DetailNewsController: BaseListController, WKUIDelegate {
    
    var webPage: WKWebView!
    var url: String?
    let connectMessage = UILabel(text: "Инторнет вам не нужон?", font: .boldSystemFont(ofSize: 24), numberOfLines: 2, textColor: .white)
    let negativeEmoji = UILabel(text: "🥺", font: .boldSystemFont(ofSize: 154), numberOfLines: 1)
    let jerryImage = UIImageView(image: UIImage(named: "jerry"))

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if Reachability.isConnected(){
            configWeb()
            guard let urlPage = URL(string: url ?? "") else { return }
            let request = URLRequest(url: urlPage)
            webPage.load(request)
        } else {
            
            let verticalStackView = VerticalStackView(arrangedSubviews: [
                jerryImage, connectMessage
            ])
            
            collectionView.addSubview(verticalStackView)
            
            jerryImage.constrainHeight(constant: 200)
            connectMessage.textAlignment = .center

            verticalStackView.centerXInSuperview()
            
            
        }
        
        
    }
    
    private func configWeb() {
        let webConfig = WKWebViewConfiguration()
        webPage = WKWebView(frame: .zero, configuration: webConfig)
        webPage.uiDelegate = self
        view = webPage
    }
    
    
}
