//
//  MainViewController.swift
//  Animals
//
//  Created by 정호윤 on 2022/07/11.
//

// TODO: 네비게이션 바 컨텍스트 메뉴 리팩토링

// 0. 필터
// TODO: 개 고양이 두번 리퀘스트 하는 방법?
// TODO: 메인에서 필터에 대한 정보를 알아야 함 > 속성 하나 만들어서 저장하고 필터에 넘겨주고 그걸 받아서 다시 패치?
// TODO: 필터 해주는 속성 만들어서
// TODO: 필터 다듬기(선택한 지역이 저장된 채로 필터가 돼야함) >> 지금 처럼 하면 메모리 사용량이 너무 올라가는데 어떡하지 뭐가 문제인지 모르겠음;;(클로저 때문인것 같긴함)

// 1.
// TODO: api 공고일로 검색 안되는데 어떡하지 >> 받아온 데이터를 sort?

// 2.
// TODO: 무한 스크롤 구현(https://velog.io/@yoonah-dev/Infinite-Scroll) > 왜 맨처음에 tableview bound가 작을까?
// TODO: fetch 기다릴때(맨 처음, 스크롤) 프로그레스 뷰 / 필터한 값 없으면 없다고 알려주기

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - 네트워크 매니저
    private var networkManager = NetworkManager.shared
    private var regionQuery = Region.none.query
    private var pageNumberQuery = 1
    private var fetchMore = false
    
    // MARK: - 유기동물 데이터 배열
    private var animals: [Item] = []
    
    // MARK: -  테이블 뷰 생성
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    // MARK: - 네비게이션 바 버튼
    private lazy var navRegionSelectButton: RegionSelectButton = {
        let button = RegionSelectButton()
        button.setTitle("지역 선택 ", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        
        button.menu = UIMenu(children: [no, seoul, gyeonggi])
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    private lazy var navHeartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.addTarget(self, action: #selector(navHeartButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var navFilterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        button.addTarget(self, action: #selector(navFilterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - 지역 선택 컨텍스트 메뉴
    private lazy var no = UIAction(title: "선택 안함") { [self] action in
        self.navRegionSelectButton.setTitle("지역 선택 ", for: .normal)
        regionQuery = Region.none.query
        setDatas(by: regionQuery)
    }
    
    private lazy var seoul = UIAction(title: "서울특별시") { [self] action in
        self.navRegionSelectButton.setTitle("서울특별시 ", for: .normal)
        regionQuery = Region.seoul.query
        setDatas(by: regionQuery)
    }
    
    private lazy var gyeonggi = UIAction(title: "경기도") { [self] action in
        self.navRegionSelectButton.setTitle("경기도 ", for: .normal)
        regionQuery = Region.gyeonggi.query
        setDatas(by: regionQuery)
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setNavBar()
        setNavigationBarItemConstraints()
        
        setTableView()
        setTableViewConstraints()
        
        setDatas()
    }
    
    // MARK: - (임시) viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        setNavBar()
    }
    
    
    // MARK: - 네비게이션 바
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
    
    // 바 버튼 함수
    @objc private func navHeartButtonTapped() {
        let likeListVC = LikeListViewController()
        navigationController?.pushViewController(likeListVC, animated: true)
    }
    
    @objc private func navFilterButtonTapped() {
        networkManager.fetchAnimal { result in
            switch result {
            case .success(let animalDatas):
                self.animals = animalDatas
                // 데이터 받아온 후 메인 쓰레드에서 테이블 뷰 리로드
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
        let filterVC = FilterViewController()
        filterVC.delegate = self
        present(filterVC, animated: true)
    }
    
    // MARK: - 테이블 뷰
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
    // 초기 세팅
    private func setDatas() {
        networkManager.fetchAnimal { result in
            switch result {
            case .success(let animalDatas):
                self.animals = animalDatas
                // 데이터 받아온 후 메인 쓰레드에서 테이블 뷰 리로드
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 지역에 맞는 데이터
    private func setDatas(by region: String) {
        networkManager.fetchAnimal(regionQuery: region) { result in
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
    
    // 무한 스크롤용
    private func appendDatas() {
        networkManager.fetchAnimal(regionQuery: regionQuery, pageNumberQuery: pageNumberQuery) { result in
            self.pageNumberQuery += 1
            print(self.pageNumberQuery)
            switch result {
            case .success(let animalDatas):
                self.animals.append(contentsOf: animalDatas)
                self.fetchMore = false
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
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
    
    // 셀의 높이 유동적으로 조절
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
    
    func applyFilter(by filter: [String]) {
        print("main: \(filter)")
        
        //        print(spices)
        let filtered = animals
            .filter { filter.contains(String($0.kind?.split(separator: "]").first?.split(separator: "[").last ?? "")) }
        animals = filtered
        
        //        if filter.count == 0 {
        //            return
        //        } else if filter.count == 1 {
        //            let filteredAnimals = animals.filter { $0.kind?.contains(filter[0]) ?? false }
        //            animals = filteredAnimals
        //        } else if filter.count == 2 {
        //            let firstFilteredAnimals = animals.filter { $0.kind?.contains(filter[0]) ?? false }
        //            let secondFilteredAnimals = animals.filter { $0.kind?.contains(filter[1]) ?? false }
        //            animals = firstFilteredAnimals
        //            animals.append(contentsOf: secondFilteredAnimals)
        //        } else if filter.count == 3 {
        //            return
        //        }
        
        print("main: \(animals)")
        tableView.reloadData()
    }
    
}

// MARK: - ButtonDelegate
extension MainViewController: ButtonDelegate {
    
    func buttonTapped() {
        print("main: button tapped")
        
    }
    
}
