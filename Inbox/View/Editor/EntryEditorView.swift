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
    var sendButtonView  = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    var textField       = UITextField(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
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
        self.addArrangedSubview(textField)
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
        
        textField.font              = .systemFont(ofSize: 15)
        textField.borderStyle       = .roundedRect
        textField.clearButtonMode   = .whileEditing
        textField.placeholder       = "Your note..."
        
        textField.spellCheckingType     = .yes
        textField.autocorrectionType    = .yes
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
