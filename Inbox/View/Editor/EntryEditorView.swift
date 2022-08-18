//
//  EntryEditorView.swift
//  Inbox
//
//  Created by Max Zhang on 2022/8/10.
//

import UIKit
import CoreData
import SnapKit

class EntryEditorView: UIStackView {
    // MARK: - Property
    var sendButton      = UIButton()
    var sendButtonView  = UIView()
    var textView        = UITextView()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        self.addArrangedSubview(sendButtonView)
        sendButtonView.addSubview(sendButton)
    }

    func setupViews() {
        self.axis           = .horizontal
        self.distribution   = .fill
        self.spacing        = UIStackView.spacingUseSystem
        
        self.isLayoutMarginsRelativeArrangement = true
        self.directionalLayoutMargins           = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        var buttonConfig            = UIButton.Configuration.borderless()
        buttonConfig.image          = UIImage(systemName: "arrow.up.circle.fill")
        buttonConfig.preferredSymbolConfigurationForImage   = UIImage.SymbolConfiguration(pointSize: 30)
        buttonConfig.imagePlacement = .all
        buttonConfig.contentInsets  = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        buttonConfig.cornerStyle    = .capsule
        buttonConfig.imagePadding   = 0
        sendButton.configuration    = buttonConfig
        
        textView.font               = .systemFont(ofSize: 17)
        textView.isEditable         = true
        textView.layer.borderColor  = CGColor(red: 0, green: 0, blue: 0, alpha: 0.18)
        textView.layer.borderWidth  = 1
        textView.layer.cornerRadius = 20
        textView.contentInset       = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        textView.frame.size.height  = 40
    }

    func setupLayout() {
        sendButtonView.snp.makeConstraints { (make) in
            make.width.equalTo(40)
        }
        sendButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(40)
            make.bottom.equalToSuperview()
        }
    }

    // MARK: - Private

}
