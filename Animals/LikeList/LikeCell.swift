//
//  LikeCell.swift
//  Animals
//
//  Created by 정호윤 on 2022/07/16.
//

import UIKit

final class LikeCell: UICollectionViewCell {
    
    // MARK: - 하트 버튼 델리게이트
    weak var delegate: ButtonDelegate?
    
    var isLiked: Bool = true {
        didSet {
            heartButton.setImage(UIImage(systemName: isLiked ? "heart.fill" : "heart"), for: .normal)
            heartButton.tintColor = isLiked ? .red : .gray
        }
    }
    
    // MARK: - 받아온 데이터 세팅
    var animal: LikedAnimal? {
        didSet {
            leftDaysLabel.text = "공고 종료 \(animal?.noticeLeftDays ?? "??")일 전"
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
    
    private let leftDaysLabel: UILabel = {
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
        button.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
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
    
    // MARK: - heart button tapped
    
    @objc private func heartButtonTapped(sender: UIButton) {
        isLiked.toggle()
        self.delegate?.heartButtonTapped(send: animal!, isLiked)
    }
    
    // MARK: - 뷰 세팅
    private func setView() {
        self.addSubview(thumbnailImageView)
        self.addSubview(leftDaysLabel)
        self.addSubview(heartButton)
        
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        leftDaysLabel.translatesAutoresizingMaskIntoConstraints = false
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: self.topAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            leftDaysLabel.heightAnchor.constraint(equalToConstant: 24),
            leftDaysLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            leftDaysLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 27),
            leftDaysLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -28),
            
            heartButton.widthAnchor.constraint(equalToConstant: 20),
            heartButton.heightAnchor.constraint(equalToConstant: 20),
            heartButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            heartButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
        ])
    }
    
    // MARK: - loadImage
    private func loadImage() {
        guard let urlString = imageUrl, let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            guard urlString == url.absoluteString else { return }
            
            DispatchQueue.main.async {
                self.thumbnailImageView.image = UIImage(data: data)
            }
        }
    }
    
}
