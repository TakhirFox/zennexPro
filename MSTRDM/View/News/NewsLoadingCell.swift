//
//  NewsLoadingCell.swift
//  MSTRDM
//
//  Created by Zakirov Tahir on 02.01.2021.
//

import UIKit

class NewsLoadingCell: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let activityIndicatior = UIActivityIndicatorView(style: .medium)
        activityIndicatior.color = .darkGray
        activityIndicatior.startAnimating()
        
        let loadingLabel = UILabel(text: "Секундочку", font: .systemFont(ofSize: 16))
        loadingLabel.textAlignment = .center
        
        let stackView = VerticalStackView(arrangedSubviews: [
            activityIndicatior, loadingLabel
        ], spacing: 8)
        
        addSubview(stackView)
        stackView.centerInSuperview(size: .init(width: 200, height: 0))
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
