//
//  BaseCell.swift
//  MSTRDM
//
//  Created by Zakirov Tahir on 03.01.2021.
//

import UIKit

class BaseCell: UICollectionViewCell {
    
    // срабатывает при касании на ячейку. Логическое значение, указывающее, рисует ли элемент управления выделение.
    override var isHighlighted: Bool {
        didSet {
            var transform: CGAffineTransform = .identity
            
            if isHighlighted {
                transform = .init(scaleX: 0.95, y: 0.95)
            }
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.transform = transform
                
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Создаем тени
        self.backgroundView = UIView()
        addSubview(self.backgroundView!)
        self.backgroundView?.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        self.backgroundView?.backgroundColor = .black
        self.backgroundView?.layer.cornerRadius = 16
        self.backgroundView?.layer.shadowOpacity = 0.1
        self.backgroundView?.layer.shadowRadius = 10
        self.backgroundView?.layer.shadowOffset = .init(width: 0, height: 10)
        self.backgroundView?.layer.shouldRasterize = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
