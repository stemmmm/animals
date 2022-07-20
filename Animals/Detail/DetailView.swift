//
//  DetailView.swift
//  STUDI
//
//  Created by peo on 2022/07/12.
//

import UIKit

class DetailView: UIView {
    
    // MARK: - Scroll View
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    // MARK: - Animal Image View
    
    let animalImageContainer: UIView = {
        let animalImageContainer = UIView()
        animalImageContainer.translatesAutoresizingMaskIntoConstraints = false
        return animalImageContainer
    }()
    
    let animalImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "test"))
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Content View
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let noticeInfoView: NoticeInfoView = {
        let noticeInfoView = NoticeInfoView()
        noticeInfoView.translatesAutoresizingMaskIntoConstraints = false
        return noticeInfoView
    }()
    let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .init(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let animalCharacterInfoView: AnimalCharacterInfoView = {
        let animalCharacterInfoView = AnimalCharacterInfoView()
        animalCharacterInfoView.translatesAutoresizingMaskIntoConstraints = false
        return animalCharacterInfoView
    }()
    
    let animalShelterInfoView: AnimalShelterInfoView = {
        let animalShelterInfoView = AnimalShelterInfoView()
        animalShelterInfoView.translatesAutoresizingMaskIntoConstraints = false
        return animalShelterInfoView
    }()
    
    // MARK: - Tabbar
    let tabbar: DetailViewTabbar = {
        let tabbar = DetailViewTabbar()
        tabbar.translatesAutoresizingMaskIntoConstraints = false
        return tabbar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        makeSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func makeSubviews() {
        [scrollView, tabbar].forEach { self.addSubview($0) }
        
        [animalImageContainer, animalImageView, contentView].forEach { scrollView.addSubview($0) }
        
        [noticeInfoView, divider, animalCharacterInfoView, animalShelterInfoView].forEach { self.contentView.addSubview($0) }
    }
}

// MARK: - Make Constraints

extension DetailView {
    private func makeConstraints() {
        makeScrollViewConstraints()
        
        makeImageViewConstraints()
        
        makeContentViewConstraints()
        
        makeTabbarConstraints()
    }
    
    private func makeScrollViewConstraints() {
        let scrollViewConstraints = [scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     scrollView.topAnchor.constraint(equalTo: topAnchor),
                                     scrollView.bottomAnchor.constraint(equalTo: tabbar.topAnchor)]
        NSLayoutConstraint.activate(scrollViewConstraints)
    }
    
    private func makeImageViewConstraints() {
        let animalImageContainerConstraints = [animalImageContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
                                               animalImageContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
                                               animalImageContainer.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
                                               animalImageContainer.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: -20),
                                               animalImageContainer.heightAnchor.constraint(equalToConstant: 420),
                                               animalImageContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor)]
        
        let animalImageViewConstraints = [animalImageView.leadingAnchor.constraint(equalTo: animalImageContainer.leadingAnchor),
                                          animalImageView.trailingAnchor.constraint(equalTo: animalImageContainer.trailingAnchor),
                                          animalImageView.bottomAnchor.constraint(equalTo: animalImageContainer.bottomAnchor)]
        
        let topConstraints = animalImageView.topAnchor.constraint(equalTo: topAnchor)
        topConstraints.priority = .defaultHigh
        
        let heightConstraints = animalImageView.heightAnchor.constraint(greaterThanOrEqualTo: animalImageContainer.heightAnchor, constant: -40)
        heightConstraints.priority = .required
        
        [animalImageContainerConstraints, animalImageViewConstraints, [topConstraints, heightConstraints]].forEach { NSLayoutConstraint.activate($0) }
    }
    
    private func makeContentViewConstraints() {
        let contentViewConstraints = [contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
                                      contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
                                      contentView.topAnchor.constraint(equalTo: animalImageContainer.bottomAnchor, constant: 20),
                                      contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)]
        
        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor, constant: -300)
        contentViewHeight.priority = .required
        
        [contentViewConstraints, [contentViewHeight]].forEach { NSLayoutConstraint.activate($0) }
        
        makeContentSubViewsConstraints()
    }
    
    private func makeContentSubViewsConstraints() {
        // Notice Info
        let noticeInfoViewConstraints = [noticeInfoView.topAnchor.constraint(equalTo: contentView.topAnchor),
                                         noticeInfoView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)]
        NSLayoutConstraint.activate(noticeInfoViewConstraints)
        
        // Divider
        let dividerConstraints = [divider.topAnchor.constraint(equalTo: noticeInfoView.bottomAnchor, constant: 20),
                                  divider.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                  divider.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                                  divider.heightAnchor.constraint(equalToConstant: 8)]
        NSLayoutConstraint.activate(dividerConstraints)
        
        let animalCharacterInfoViewConstraints = [animalCharacterInfoView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                                                  animalCharacterInfoView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                                                  animalCharacterInfoView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 20)]
        NSLayoutConstraint.activate(animalCharacterInfoViewConstraints)
        
        let animalShelterInfoViewConstraints = [animalShelterInfoView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                                                animalShelterInfoView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                                                animalShelterInfoView.topAnchor.constraint(equalTo: animalCharacterInfoView.bottomAnchor, constant: 40)]
        NSLayoutConstraint.activate(animalShelterInfoViewConstraints)
    }
    
    private func makeTabbarConstraints() {
        let tabbarConstraints = [tabbar.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
                                 tabbar.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
                                 tabbar.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                 tabbar.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
                                 tabbar.heightAnchor.constraint(equalToConstant: 114)]
        NSLayoutConstraint.activate(tabbarConstraints)
    }
}
