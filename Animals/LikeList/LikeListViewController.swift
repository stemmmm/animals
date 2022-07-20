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
    private let networkManager = NetworkManager.shared
    
    // MARK: - 유기동물 데이터 배열
    private var animals: [Item] = []

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setNavBar()
        
        setCollectionView()
        setCollectionViewConstraints()
        
        setDatas()
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
    
    // MARK: - 데이터 세팅
    private func setDatas() {
        networkManager.fetchAnimal { result in
            switch result {
            case .success(let animalDatas):
                self.animals = animalDatas
                // 데이터 받아온 후 메인 쓰레드에서 테이블 뷰 리로드
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

// MARK: - UICollectionViewDataSource
extension LikeListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        animals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikeCell", for: indexPath) as! LikeCell
        
        // 데이터 전달
        cell.imageUrl = animals[indexPath.row].detailImage
        cell.animal = animals[indexPath.row]
        
        return cell
    }
    
    // 헤더
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! CollectionHeaderView
        return headerView
    }
    
}
