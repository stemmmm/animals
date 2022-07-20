//
//  AnimalCell.swift
//  Animals
//
//  Created by 정호윤 on 2022/07/12.
//

import UIKit

final class AnimalCell: UITableViewCell {
    
    // MARK: - 받아온 데이터 세팅
    var animal: Item? {
        didSet {
            durationDateLabel.text = "공고 종료 \(animal?.noticeLeftDays ?? 0)일 전"
            kindLabel.text = animal?.kind
            informationLabel.text = animal?.age
            shelterLabel.text = animal?.shelterName
        }
    }
    
    // 이미지 URL을 전달받음
    var imageUrl: String? {
        didSet {
            loadImage()
        }
    }
    
    // MARK: - views
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 14
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let durationDateLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .red
        label.layer.cornerRadius = 13
        label.clipsToBounds = true
        return label
    }()
    
    private let kindLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let shelterLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .gray
        
//        button.addTarget(self, action: #selector(likeTapped), for: <#T##UIControl.Event#>)
        return button
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution  = .fill
        stackView.alignment = .leading
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        setView()
        
        setThumbnailImageViewConstraints()
        setLabelStackViewConstraints()
        setHeartButtonConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - prepareForReuse
    // 셀이 재사용되기 전에 호출
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // 이미지 바뀌는것처럼 보이는 현상 해결
        thumbnailImageView.image = nil
    }
    
    // MARK: - 뷰 세팅
    private func setView() {
        self.addSubview(thumbnailImageView)
        self.addSubview(labelStackView)
        
        labelStackView.addArrangedSubview(durationDateLabel)
        labelStackView.addArrangedSubview(kindLabel)
        labelStackView.addArrangedSubview(informationLabel)
        labelStackView.addArrangedSubview(shelterLabel)
        
        self.addSubview(heartButton)
    }
    
    // MARK: - 오토레이아웃
    private func setThumbnailImageViewConstraints() {
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            thumbnailImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            thumbnailImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 140),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    private func setLabelStackViewConstraints() {
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        durationDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 20),
            labelStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            
            durationDateLabel.widthAnchor.constraint(equalToConstant: 110),
            durationDateLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setHeartButtonConstraints() {
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heartButton.widthAnchor.constraint(equalToConstant: 20),
            heartButton.heightAnchor.constraint(equalToConstant: 20),
            heartButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            heartButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - loadImage
    private func loadImage() {
        guard let urlString = imageUrl, let url = URL(string: urlString) else { return }
        
        // 비동기 처리(Data 메서드가 동기라)
        DispatchQueue.global().async {
            // URL을 가지고 데이터를 만드는 메서드 (동기적인 실행)
            guard let data = try? Data(contentsOf: url) else { return }
            
            // 오래걸리는 작업이 일어나고 있는 동안에 url이 바뀔 가능성 제거
            guard urlString == url.absoluteString else { return }
            
            // 작업의 결과물을 이미지로 표시(메인 큐로 디스패치)
            DispatchQueue.main.async {
                self.thumbnailImageView.image = UIImage(data: data)
            }
        }
    }
    
}
