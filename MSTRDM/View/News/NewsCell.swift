//
//  NewsCell.swift
//  MSTRDM
//
//  Created by Zakirov Tahir on 28.12.2020.
//

import UIKit

class NewsCell: BaseCell {
    
    let blackView = UIView()
    var imageView = UIImageView(cornerRadius: 16)
    var titleLabel = UILabel(text: "textlabel", font: .boldSystemFont(ofSize: 22), numberOfLines: 3, textColor: .white)
    let desctiptionLabel = UILabel(text: "descriptionlabel", font: .systemFont(ofSize: 14), numberOfLines: 3, textColor: .white)
    let dateLabel = UILabel(text: "date", font: .systemFont(ofSize: 12), textColor: .white)
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)

        shadowLabel(shadowOpacity: 0.5, shadowOffset: .init(width: 0, height: 0), shadowRadius: 5, to: titleLabel)
        shadowLabel(shadowOpacity: 0.5, shadowOffset: .init(width: 0, height: 0), shadowRadius: 5, to: desctiptionLabel)
    
        blackView.backgroundColor = .black
        blackView.layer.cornerRadius = 16
        blackView.layer.opacity = 0.3
        
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView
        ])

        let stackBlackView = UIStackView(arrangedSubviews: [
            blackView
        ])

        let labels = VerticalStackView(arrangedSubviews: [
            dateLabel, UIView(), titleLabel, desctiptionLabel
        ])



        addSubview(stackView)
        stackView.addSubview(stackBlackView)
        stackBlackView.addSubview(labels)

        stackBlackView.fillSuperview(padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        dateLabel.anchor(top: imageView.topAnchor, leading: imageView.leadingAnchor, bottom: nil, trailing: imageView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        titleLabel.anchor(top: nil, leading: imageView.leadingAnchor, bottom: nil, trailing: imageView.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        desctiptionLabel.anchor(top: titleLabel.bottomAnchor, leading: imageView.leadingAnchor, bottom: imageView.bottomAnchor, trailing: imageView.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shadowLabel(shadowOpacity: Float, shadowOffset: CGSize, shadowRadius: CGFloat, to labelText: UILabel) {
        labelText.layer.shadowOpacity = shadowOpacity
        labelText.layer.shadowOffset = shadowOffset
        labelText.layer.shadowRadius = shadowRadius
        labelText.layer.shouldRasterize = true
    }
    
}
