//
//  AnimalCharacterInfoView.swift
//  STUDI
//
//  Created by peo on 2022/07/14.
//

import UIKit

class AnimalCharacterInfoView: UIView {
    let title: UILabel = {
        let label = UILabel()
        label.text = "아이의 특징"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .init(red: 13/255, green: 13/255, blue: 13/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // Kind
    let kindInfo: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    let kindInfoTitle: CategoryLabel = {
        let label = CategoryLabel()
        label.text = "품종"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let kindInfoLabel: NormalTextLabel = {
        let label = NormalTextLabel()
        label.text = "[개] 불독"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Color
    let colorInfo: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    let colorInfoTitle: CategoryLabel = {
        let label = CategoryLabel()
        label.text = "색상"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let colorInfoLabel: NormalTextLabel = {
        let label = NormalTextLabel()
        label.text = "베이지"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Sex
    let sexInfo: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    let sexInfoTitle: CategoryLabel = {
        let label = CategoryLabel()
        label.text = "성별"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let sexInfoLabel: NormalTextLabel = {
        let label = NormalTextLabel()
        label.text = "M"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Neutering
    let neuteringInfo: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 27
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    let neuteringInfoTitle: CategoryLabel = {
        let label = CategoryLabel()
        label.text = "중성화"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let neuteringInfoLabel: NormalTextLabel = {
        let label = NormalTextLabel()
        label.text = "Y"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Age
    let ageInfo: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    let ageInfoTitle: CategoryLabel = {
        let label = CategoryLabel()
        label.text = "나이"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let ageInfoLabel: NormalTextLabel = {
        let label = NormalTextLabel()
        label.text = "2018(년생)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Weight
    let weightInfo: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    let weightInfoTitle: CategoryLabel = {
        let label = CategoryLabel()
        label.text = "체중"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let weightInfoLabel: NormalTextLabel = {
        let label = NormalTextLabel()
        label.text = "5(Kg)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Characters
    let charactersInfo: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    let charactersInfoTitle: CategoryLabel = {
        let label = CategoryLabel()
        label.text = "특징"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let charactersInfoLabel: NormalTextLabel = {
        let label = NormalTextLabel()
        label.text = "온순하고 차분함, 사상충감염"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Location
    let locationInfo: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 14
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    let locationInfoTitle: CategoryLabel = {
        let label = CategoryLabel()
        label.text = "발견장소"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let locationInfoLabel: NormalTextLabel = {
        let label = NormalTextLabel()
        label.text = "가야읍 왕궁2길 19-1"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeSubviews()
        makeConstraints()
    }
    
    private func makeSubviews() {
        [title, stackView].forEach { self.addSubview($0) }
        [kindInfo, colorInfo, sexInfo, neuteringInfo, ageInfo, weightInfo, charactersInfo, locationInfo].forEach { stackView.addArrangedSubview($0) }
        
        [kindInfoTitle, kindInfoLabel].forEach { kindInfo.addArrangedSubview($0) }
        [colorInfoTitle, colorInfoLabel].forEach { colorInfo.addArrangedSubview($0) }
        [sexInfoTitle, sexInfoLabel].forEach { sexInfo.addArrangedSubview($0) }
        [neuteringInfoTitle, neuteringInfoLabel].forEach { neuteringInfo.addArrangedSubview($0) }
        [ageInfoTitle, ageInfoLabel].forEach { ageInfo.addArrangedSubview($0) }
        [weightInfoTitle, weightInfoLabel].forEach { weightInfo.addArrangedSubview($0) }
        [charactersInfoTitle, charactersInfoLabel].forEach { charactersInfo.addArrangedSubview($0) }
        [locationInfoTitle, locationInfoLabel].forEach { locationInfo.addArrangedSubview($0) }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - Make Constraints

extension AnimalCharacterInfoView {
    private func makeConstraints() {
        let titleConstraints = [title.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                title.topAnchor.constraint(equalTo: self.topAnchor)]
        
        let stackViewConstraints = [stackView.leadingAnchor.constraint(equalTo: title.leadingAnchor),
                                    stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                    stackView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20),
                                    stackView.bottomAnchor.constraint(equalTo: bottomAnchor)]
        
        [titleConstraints, stackViewConstraints].forEach { NSLayoutConstraint.activate($0) }
    }
}
