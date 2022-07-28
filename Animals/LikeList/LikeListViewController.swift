//
//  LikeListViewController.swift
//  Animals
//
//  Created by 정호윤 on 2022/07/16.
//

import UIKit

final class LikeListViewController: UIViewController {
    
    // MARK: - 컬렉션 뷰 생성
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: ColumnFlowLayout())
    
    // MARK: - 네트워크 매니저
    private let coreDataManager = CoreDataManager.shared
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setNavBar()
        
        setCollectionView()
        setCollectionViewConstraints()
    }
    
    // MARK: - 네비게이션 바 세팅
    private func setNavBar() {
        navigationItem.title = "관심 목록"
    }
    
    // MARK: - 컬렉션 뷰 세팅
    private func setCollectionView() {
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
        // 셀 등록
        collectionView.register(LikeCell.self, forCellWithReuseIdentifier: "LikeCell")
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
    }
    
    // 컬렉션 뷰 오토레이아웃 세팅
    private func setCollectionViewConstraints() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

// MARK: - UICollectionViewDataSource
extension LikeListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        coreDataManager.getLikedAnimals().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikeCell", for: indexPath) as! LikeCell
        cell.delegate = self
        cell.imageUrl = coreDataManager.getLikedAnimals()[indexPath.row].detailImage
        cell.animal = coreDataManager.getLikedAnimals()[indexPath.row]
        return cell
    }
    
    // 헤더
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! CollectionHeaderView
        return headerView
    }
    
}

extension LikeListViewController: ButtonDelegate {
    
    func heartButtonTapped(send likedAnimal: LikedAnimal, _ isLiked: Bool) {
        if !isLiked {
            coreDataManager.deleteLikedAnimal(by: likedAnimal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.collectionView.reloadData()
            }
        }
    }
    
}
