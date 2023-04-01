//
//  HomeVc.swift
//  DemoAssignment
//
//  Created by Pooja Raghuwanshi on 31/03/23.
//

import UIKit

class HomeVc: UIViewController {
    
    static let  identifier = "HomeVc"
    
    @IBOutlet private weak var tableView :UITableView!
    @IBOutlet private weak var loaderView :UIActivityIndicatorView!

    var viewModel = HomeViewModel()
    var tempCategoryData = [CategoryMDL]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        self.loaderView.isHidden  = false
        self.loaderView.startAnimating()
       
        if Reachability.isConnected() {
           
            self.viewModel.fetchDataFromServer { catMdlData in
                
                guard let mdl = catMdlData, mdl.count > 0 else{return}
                self.tempCategoryData.append(mdl[0])
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    self.tableView.reloadData()
                }
            }
        }
        else{
            self.AlertShows(msg: ErrorHandling.InterNetConnection.rawValue)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loaderView.isHidden = true
            self.loaderView.stopAnimating()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBarForHomePage()
        
    }
    
    //MARK: FUNCTION
    
    func registerCell(){
        tableView.register(UINib.init(nibName: HomeCell.identifier, bundle: nil), forCellReuseIdentifier: HomeCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
}

extension HomeVc : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tempCategoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeCell.identifier, for: indexPath) as? HomeCell
        else{
            return UITableViewCell()
        }
        cell.categoryMdl = self.tempCategoryData[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row ==  self.tempCategoryData.count - 1 {
            
            var indexValue = indexPath.row
            self.viewModel.moreDataFetch(indexValue: &indexValue) { tempData in
                
                for i in 0...tempData.count - 1{
                    self.tempCategoryData.append(tempData[i])
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: StroyboardName.main.rawValue, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: CategoryDetailVc.identifier) as? CategoryDetailVc ,self.tempCategoryData.count > indexPath.row {
            
            vc.catTitle = self.tempCategoryData[indexPath.row].title ?? "Category"
            vc.CategoryData = self.tempCategoryData[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
