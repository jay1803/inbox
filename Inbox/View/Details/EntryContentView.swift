//
//  EntryContentView.swift
//  Inbox
//
//  Created by Max Zhang on 2022/8/10.
//

import UIKit
import SnapKit

class EntryContentView: UIView {
    
    var content: String?
    var quote: String?
    
    var textView        = UITextView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 0))
    var quoteTextView   = UITextView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 0))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews()
        self.setupViews()
        self.setupLayouts()
        
        if let quote = self.quote {
            quoteTextView.snp.remakeConstraints { (make) in
                make.top.equalTo(self.snp.top).offset(20)
                make.left.equalTo(self).offset(20)
                make.right.equalTo(self).offset(-20)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Setup
    func addSubviews() {
        self.addSubview(textView)
        self.addSubview(quoteTextView)
    }
    
    func setupViews() {
        quoteTextView.font              = UIFont.systemFont(ofSize: 15)
        quoteTextView.isEditable        = false
        quoteTextView.isSelectable      = false
        quoteTextView.isScrollEnabled   = false
        quoteTextView.backgroundColor   = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)


        if let quote = self.quote {
            quoteTextView.text          = quote
        }
        
        textView.font               = UIFont.systemFont(ofSize: 19)
        textView.text               = self.content
        textView.isSelectable       = true
        textView.isScrollEnabled    = false
        textView.isEditable         = false
    }
    
    func setupLayouts() {
        quoteTextView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(0)
        }
        
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(quoteTextView.snp.bottom)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }
    }
}
