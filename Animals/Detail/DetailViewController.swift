//
//  DetailViewController.swift
//  STUDI
//
//  Created by peo on 2022/07/13.
//

import UIKit

class DetailViewController: UIViewController {
    let detailView = DetailView()
    
    var navBarAppearance: UINavigationBarAppearance = {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .clear
        navBarAppearance.shadowColor = .clear
        return navBarAppearance
    }()
    
    var defaultScrollIndex: CGFloat = 0
    
    var isLiked = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAttributes()
        
        configureTapGestures()
    }
    
    override func loadView() {
        super.loadView()
        self.view = detailView
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        self.navigationController?.navigationBar.tintColor = .systemBlue
//
//        navBarAppearance.backgroundColor = .init(white: 1, alpha: 1)
//        navBarAppearance.shadowColor = .init(red: 0, green: 0, blue: 0, alpha: 0.3)
//        
//        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
//        self.navigationController?.navigationBar.compactAppearance = navBarAppearance
//        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
}

// MARK: - Attributes

extension DetailViewController {
    
    // MARK: - Default Settings
    
    private func setAttributes() {
        detailView.tabbar.delegate = self

        detailView.scrollView.delegate = self
        detailView.scrollView.contentInsetAdjustmentBehavior = .scrollableAxes
        defaultScrollIndex = self.detailView.scrollView.contentOffset.y
        
        setNavBarAttributes()
    }
    
    // MARK: - Navigation Bar
    /// NavigationBar의 아이템 색상을 white, 배경색을 clear로 설정하여 이미지 위에 뒤로가기 버튼만 보이게 설정
    private func setNavBarAttributes() {
        self.navigationController?.navigationBar.tintColor = .white
        
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.compactAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    // MARK: - Information
    
    private func setInfo() {
        
        // TODO: - 동물 정보 배치 추후 구현
        
    }
}

// MARK: - Scroll Delegate

extension DetailViewController: UIScrollViewDelegate {
    
    // TODO: - 이미지 비율 자연스럽게 변경 추후 구현
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// 일정 거리만큼 스크롤 시, 이미지의 비율을 변경하여 아래 정보들의 배치가 안 무너지게 설정
        if scrollView.contentOffset.y > defaultScrollIndex - 44 {
            detailView.animalImageView.contentMode = .scaleToFill
        } else {
            detailView.animalImageView.contentMode = .scaleAspectFill
        }
        
        /// 밑으로 내릴수록 NavigationBar의 아이템 색상을 검게, 배경색을 하얗게 변경
        if scrollView.contentOffset.y > defaultScrollIndex {
            let position = scrollView.contentOffset.y + defaultScrollIndex
            self.navigationController?.navigationBar.tintColor = .init(red: (1 - position / 185), green: (1 - position / 185), blue: (1 - position / 185), alpha: 1)
            
            navBarAppearance.backgroundColor = .init(white: position / 185, alpha: position / 185)
            navBarAppearance.shadowColor = .init(red: 0, green: 0, blue: 0, alpha: ((position / 185) * 0.3))
        } else {
            self.navigationController?.navigationBar.tintColor = .white
            
            navBarAppearance.backgroundColor = .clear
            navBarAppearance.shadowColor = .clear
        }
        
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.compactAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
}

// MARK: - Tap

extension DetailViewController {
    private func configureTapGestures() {
        self.detailView.animalImageView.isUserInteractionEnabled = true
        self.detailView.animalImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animalImageViewDidTap)))
    }
    
    // MARK: - Animal Image View Tap
    
    @objc func animalImageViewDidTap() {
        let vc = DetailedImageViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

// MARK: - Tabbar Delegate

extension DetailViewController: DetailViewTabbarDelegate {
    
    // TODO: - 전화 걸기 기능 추후 구현
    
    func contactButtonDidTap() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "전화 " + "010 1234 1234", style: .default , handler:{ _ in
            print("전화 걸기")
        }))
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler:{ _ in
            print("취소 버튼 탭")
        }))
        
        self.present(alert, animated: true, completion: {
            print("액션 시트 올라옴")
        })
    }
    
    // TODO: - 관심 목록 추가 기능 추후 구현
    
    func likeButtonDidTap() {
        if isLiked {
            detailView.tabbar.likeButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            detailView.tabbar.likeButton.tintColor = .gray
        } else {
            detailView.tabbar.likeButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
            detailView.tabbar.likeButton.tintColor = .systemPink
        }
        isLiked.toggle()
    }
}
