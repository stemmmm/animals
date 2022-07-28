//
//  MainViewController.swift
//  Animals
//
//  Created by 정호윤 on 2022/07/11.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - 네트워크 매니저
    
    private var networkManager = NetworkManager.shared
    private var region = Region.none
    private var pageNumber = 1
    private var fetchMore = false
    
    // MARK: - 유기동물 데이터 배열
    
    private var animals: [Item] = []
    
    // MARK: - 코어 데이터 매니저
    
    private var coreDataManager = CoreDataManager.shared
    
    // MARK: -  테이블 뷰 생성
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    // MARK: - 네비게이션 바 버튼
    
    // 지역 선택 컨텍스트 메뉴
    private lazy var regionMenu: UIMenu = {
        var actions = Region.allCases.map { region in
            UIAction(title: region.name) { action in
                self.navRegionSelectButton.setTitle(action.title, for: .normal)
                self.makeRegionQuery(action.title)
                self.setDatas(by: self.region)
            }
        }
        
        let menu = UIMenu(children: actions)
        return menu
    }()
    
    // 지역 선택 버튼
    private lazy var navRegionSelectButton: RegionSelectButton = {
        let button = RegionSelectButton()
        button.setTitle("전국 ", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        
        button.menu = regionMenu
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    // 하트 버튼
    private lazy var navHeartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.addTarget(self, action: #selector(navHeartButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // 필터 버튼
    private lazy var navFilterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        button.addTarget(self, action: #selector(navFilterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setNavBar()
        setNavigationBarItemConstraints()
        
        setTableView()
        setTableViewConstraints()
        
        setDatas(by: region)
    }
    
    // MARK: - (임시) viewWillAppear로 네비게이션 ui 다시 세팅
    
    override func viewWillAppear(_ animated: Bool) {
        setNavBar()
    }
    
    
    // MARK: - 네비게이션 바 세팅
    
    private func setNavBar() {
        // 다음화면 뒤로가기 버튼 레이블 삭제
        navigationItem.backButtonTitle = ""
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // 버튼 추가
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navRegionSelectButton)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: navFilterButton), UIBarButtonItem(customView: navHeartButton)]
    }
    
    // 바 아이템 오토레이아웃 - 지역 선택 글자 길어지면 짤리는거 없애기 위해
    private func setNavigationBarItemConstraints() {
        navRegionSelectButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - 관심 목록 버튼
    
    @objc private func navHeartButtonTapped() {
        let likeListVC = LikeListViewController()
        navigationController?.pushViewController(likeListVC, animated: true)
    }
    
    // MARK: - 필터 버튼
    
    @objc private func navFilterButtonTapped() {
        let filterVC = FilterViewController()
        filterVC.delegate = self
        
        setDatas(by: region)
        present(filterVC, animated: true)
    }
    
    // MARK: - 테이블 뷰 세팅
    
    private func setTableView() {
        // seperator inset 설정
        tableView.separatorInset = UIEdgeInsets.zero
        
        tableView.backgroundColor = .white
        
        // 델리게이트 설정
        tableView.dataSource = self
        tableView.delegate = self
        
        // 셀 등록
        tableView.register(AnimalCell.self, forCellReuseIdentifier: "AnimalCell")
    }
    
    // 오토레이아웃 설정
    private func setTableViewConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - fetch 함수들
    
    // 지역에 맞는 데이터
    private func setDatas(by region: Region) {
        networkManager.fetchAnimal(region: region) { [weak self] result in
            switch result {
            case .success(let animalDatas):
                self?.animals = animalDatas
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 무한 스크롤용
    private func appendDatas() {
        networkManager.fetchAnimal(pageNumber: pageNumber, region: region) { [weak self] result in
            self?.pageNumber += 1
            switch result {
            case .success(let animalDatas):
                self?.animals.append(contentsOf: animalDatas)
                self?.fetchMore = false
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 필터용
    private func setDatasByFilter(kind: Kind?) {
        networkManager.fetchAnimal(pageNumber: pageNumber, region: region, kind: kind) { result in
            switch result {
            case .success(let animalDatas):
                self.animals = animalDatas
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - 지역 문자열로 regionQuery에 할당
    
    private func makeRegionQuery(_ string: String) {
        if string == "전국" {
            region = Region.none
        } else if string == "서울특별시" {
            region = Region.seoul
        } else if string == "부산광역시" {
            region = Region.busan
        } else if string == "대구광역시" {
            region = Region.daegu
        }  else if string == "인천광역시" {
            region = Region.incheon
        } else if string == "광주광역시" {
            region = Region.gwangju
        } else if string == "대전광역시" {
            region = Region.daejeon
        } else if string == "울산광역시" {
            region = Region.ulsan
        } else if string == "경기도" {
            region = Region.gyeonggi
        } else if string == "강원도" {
            region = Region.gangwon
        } else if string == "충청북도" {
            region = Region.choongbook
        } else if string == "충청남도" {
            region = Region.choongnam
        } else if string == "전라북도" {
            region = Region.jeonbook
        } else if string == "전라남도" {
            region = Region.jeonnam
        } else if string == "경상북도" {
            region = Region.gyeongbook
        } else if string == "경상남도" {
            region = Region.gyeongnam
        } else if string == "제주특별자치도" {
            region = Region.jeju
        }
    }
    
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 힙에 올라간 셀 사용
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalCell", for: indexPath) as! AnimalCell
        
        cell.delegate = self
        
        // 셀에 데이터 전달
        cell.imageUrl = animals[indexPath.row].detailImage
        cell.animal = animals[indexPath.row]
        
        cell.selectionStyle = .none
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    // 셀 높이 유동적으로 조절
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 172
    }
    
    // 테이블 뷰 헤더
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TableHeaderView()
    }
    
    // 헤더 높이
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 140
    }
    
    // 다음 화면
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

// MARK: - 무한 스크롤

extension MainViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView.contentOffset.y >= self.tableView.contentSize.height - self.tableView.bounds.height {
            if !fetchMore {
                fetchMore = true
                appendDatas()
            }
        }
    }
    
}

// MARK: - FilterDelegate

extension MainViewController: FilterDelegate {
    
    func applyFilter(kind: Kind?) {
        setDatasByFilter(kind: kind)
    }
    
}

// MARK: - ButtonDelegate

extension MainViewController: ButtonDelegate {
    
    func heartButtonTapped(send item: Item) {
        if item.isLiked {
            coreDataManager.saveLikedAnimal(with: item)
        } else {
            coreDataManager.deleteLikedAnimal(by: item)
        }
    }
    
}
