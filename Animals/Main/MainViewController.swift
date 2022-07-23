//
//  MainViewController.swift
//  Animals
//
//  Created by 정호윤 on 2022/07/11.
//

// 0. 필터
// TODO: 메인에서 필터에 대한 정보를 알아야 함 > 속성 하나 만들어서 저장하고 필터에 넘겨주고 그걸 받아서 다시 패치?
// TODO: 필터 다듬기(선택한 지역이 저장된 채로 필터가 돼야함)
// TODO: 필터 계속 적용되면 아무것도 안나옴 > 필터 제거 기능
// TODO: 리프레시 기능!! 데이터 안받아와지거나 서버 이상할때

// 2.
// TODO: fetch 기다릴때(맨 처음, 스크롤) 액티비티 인디케이터 or 플레이스 홀더
// 필터한 값 없으면 없다고 알려주기 /// 지역 바꾸면 화면 맨위로 자동으로 보내주기

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
    
    // 지역 선택 컨텍스트 메뉴
    private lazy var regionMenu: UIMenu = {
        var actions: [UIAction] = []
        let region = Region.allCases
        
        region.forEach { actions.append(UIAction(title: $0.name) { action in
            self.navRegionSelectButton.setTitle(action.title, for: .normal)
            self.makeRegionQuery(action.title)
            self.setDatas(by: self.regionQuery)
        })
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
        
        setDatas()
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
        
        setDatas(by: regionQuery)
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
    
    // MARK: - 지역 문자열로 regionQuery에 할당
    
    private func makeRegionQuery(_ string: String) {
        if string == "전국" {
            regionQuery = Region.none.query
        } else if string == "서울특별시" {
            regionQuery = Region.seoul.query
        } else if string == "부산광역시" {
            regionQuery = Region.busan.query
        } else if string == "대구광역시" {
            regionQuery = Region.daegu.query
        }  else if string == "인천광역시" {
            regionQuery = Region.incheon.query
        } else if string == "광주광역시" {
            regionQuery = Region.gwangju.query
        } else if string == "대전광역시" {
            regionQuery = Region.daejeon.query
        } else if string == "울산광역시" {
            regionQuery = Region.ulsan.query
        } else if string == "경기도" {
            regionQuery = Region.gyeonggi.query
        } else if string == "강원도" {
            regionQuery = Region.gangwon.query
        } else if string == "충청북도" {
            regionQuery = Region.choongbook.query
        } else if string == "충청남도" {
            regionQuery = Region.choongnam.query
        } else if string == "전라북도" {
            regionQuery = Region.jeonbook.query
        } else if string == "전라남도" {
            regionQuery = Region.jeonnam.query
        } else if string == "경상북도" {
            regionQuery = Region.gyeongbook.query
        } else if string == "경상남도" {
            regionQuery = Region.gyeongnam.query
        } else if string == "제주특별자치도" {
            regionQuery = Region.jeju.query
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
    
    // TODO: 필터에 포함돼있으면 처음부터 색깔 초록색으로 표시
    
    // TODO: 무한 스크롤 할 때도 필터 적용된 정보들만 로드
    
    func applyFilter(by filter: [String]) {
        let filteredAnimals = animals.filter { filter.contains(String($0.kind?.split(separator: "]").first?.split(separator: "[").last ?? "")) }
        animals = filteredAnimals

        tableView.reloadData()
    }
    
}

// MARK: - ButtonDelegate

extension MainViewController: ButtonDelegate {
    
    func buttonTapped() {
        print("main: button tapped")
        
    }
    
}
