//
//  LikeCell.swift
//  Animals
//
//  Created by 정호윤 on 2022/07/16.
//

import UIKit

final class LikeCell: UICollectionViewCell {
    
    // MARK: - 받아온 데이터 세팅
    var animal: Item? {
        didSet {
            durationDateLabel.text = "공고 종료 \(animal?.noticeLeftDays ?? 0)일 전"
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
    
    private let heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .red
        return button
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 뷰 세팅
    private func setView() {
        self.addSubview(thumbnailImageView)
        self.addSubview(durationDateLabel)
        self.addSubview(heartButton)
        
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        durationDateLabel.translatesAutoresizingMaskIntoConstraints = false
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: self.topAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            durationDateLabel.heightAnchor.constraint(equalToConstant: 24),
            durationDateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            durationDateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 27),
            durationDateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -28),
            
            heartButton.widthAnchor.constraint(equalToConstant: 20),
            heartButton.heightAnchor.constraint(equalToConstant: 20),
            heartButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            heartButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
        ])
    }
    
    // MARK: - loadImage
    private func loadImage() {
        guard let urlString = imageUrl, let url = URL(string: urlString) else { return }
        
        // 비동기 처리(Data 메서드가 동기적이라)
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
