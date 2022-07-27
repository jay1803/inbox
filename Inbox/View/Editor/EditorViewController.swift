//
//  EditorViewController.swift
//  Flash-UIKit
//
//  Created by Max Zhang on 2022/7/19.
//

import UIKit
import SnapKit

class EditorViewController: UIViewController {
    // MARK: - Property
    var textView = UITextView()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
    }

    // MARK: - ViewSetup
    func addSubviews() {
        view.addSubview(textView)
    }
    
    func setupNavigationBar() {

    }
    
    func setupViews() {
        textView.font = UIFont.systemFont(ofSize: 14)
    }

    func setupLayout() {
        textView.snp.makeConstraints { (make) in
            make.top.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
        }
    }

    // MARK: - Private


}
