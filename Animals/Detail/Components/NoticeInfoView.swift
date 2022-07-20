//
//  NoticeInfoView.swift
//  STUDI
//
//  Created by peo on 2022/07/14.
//

import UIKit

class NoticeInfoView: UIView {
    // Notice Name
    let noticeName: UILabel = {
        let label = UILabel()
        label.text = "경남-함안-2022-00286"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .init(red: 13/255, green: 13/255, blue: 13/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Notice Date
    let noticeDate: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    let noticeDateTitle: UILabel = {
        let label = UILabel()
        label.text = "공고 기간"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .init(red: 142/255, green: 142/255, blue: 146/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let noticeDateNumber: UILabel = {
        let label = UILabel()
        label.text = "20220702 - 20220712"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .init(red: 13/255, green: 13/255, blue: 13/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        makeSubviews()
        makeConstraints()
    }
    
    private func makeSubviews() {
        [noticeName, noticeDate].forEach { self.addSubview($0) }
        [noticeDateTitle, noticeDateNumber].forEach { self.noticeDate.addArrangedSubview($0) }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - Make Constraints

extension NoticeInfoView {
    private func makeConstraints() {
        let noticeNameConstraints = [noticeName.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     noticeName.topAnchor.constraint(equalTo: self.topAnchor),]

        let noticeDateConstraints = [noticeDate.topAnchor.constraint(equalTo: noticeName.bottomAnchor, constant: 8),
                                     noticeDate.leadingAnchor.constraint(equalTo: noticeName.leadingAnchor),
                                     noticeDate.bottomAnchor.constraint(equalTo: self.bottomAnchor)]
        
        [noticeNameConstraints, noticeDateConstraints].forEach { NSLayoutConstraint.activate($0) }
    }
}
