//
//  EntryEditorView.swift
//  Inbox
//
//  Created by Max Zhang on 2022/8/10.
//

import UIKit
import SnapKit

class EntryEditorView: UIStackView {
    // MARK: - Property
    var sendButton  = UIButton()
    var textView    = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews()
        self.setupViews()
        self.setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewSetup
    func addSubviews() {
        self.addArrangedSubview(textView)
        self.addArrangedSubview(sendButton)
    }

    func setupViews() {
        self.axis           = .vertical
        self.distribution   = .fill
        self.spacing        = UIStackView.spacingUseSystem
        
        self.isLayoutMarginsRelativeArrangement = true
        self.directionalLayoutMargins           = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(UIColor.white, for: .normal)
        
        sendButton.backgroundColor      = UIColor.tintColor
        sendButton.layer.cornerRadius   = 20
        sendButton.titleLabel?.font     = .systemFont(ofSize: 15)
        
        
        textView.isEditable         = true
        textView.font               = .systemFont(ofSize: 15)
        textView.contentInset       = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0)
        textView.layer.borderColor  = CGColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        textView.layer.cornerRadius = 20
    }

    func setupLayout() {
        sendButton.snp.makeConstraints { (make) in
            make.height.equalTo(40)
        }
    }

    // MARK: - Private

}
