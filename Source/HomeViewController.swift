//
//  HomeViewController.swift
//  QavaShop
//
//  Created by Shairjeel Ahmed on 16/04/2019.
//  Copyright © 2019 Shairjeel Ahmed. All rights reserved.
//

import UIKit
//import AVKit
//import AVFoundation
//import Moya
//import SwiftyJSON

class HomeViewController: UIViewController {
	
}
/*	class func instantiateFromStoryboard() -> HomeViewController {
		return Constants.storyBoard.MAIN.instantiateViewController(withIdentifier: String(describing: self)) as! HomeViewController
	}
	
	@IBOutlet weak var tableView: UITableView! {
		didSet {
			self.registerNibs()
		}
	}
	private var pullControl = UIRefreshControl()
	let searchController = UISearchController(searchResultsController: nil)
	lazy  var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 320, height: 20))

	var arrSliderBanners: Array<Slides> = Array<Slides> ()
	var arrVendors: Array<VendorModel> = Array<VendorModel> ()
	var arrfilterVendors: Array<VendorModel> = Array<VendorModel> ()
	var selectedVendor:VendorModel?
	var isSearch:Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.getHomeData()
		self.placeNavBar(isSearh: false)
		self.pullToRefresh()
	}
	
	private func registerNibs() {
		self.tableView.register(UINib(nibName: String(describing: BannerSliderViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: BannerSliderViewCell.self))
		self.tableView.register(UINib(nibName: String(describing: HomeRestaurentTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: HomeRestaurentTableViewCell.self))
	}
	
	private func getHomeData(){
		self.getHeader()
		self.getVendors()
	}
	
	func placeNavBar(isSearh:Bool){
		if isSearh == false{
			self.navigationItem.leftBarButtonItem = nil
			self.navigationItem.titleView = nil
			self.navigationItem.rightBarButtonItem = nil
			self.addTitleViewInNavigationBar()
			let searchBtn = self.makeSearchButton()
			let sideMenu = self.makeSideMenuBtn()
			self.navigationItem.leftBarButtonItem = sideMenu
			self.navigationItem.rightBarButtonItem = searchBtn
		}else{
			navBarForSearch()
		}
		
	}
	
	func navBarForSearch(){
		self.navigationItem.titleView = nil
		self.navigationItem.rightBarButtonItem = nil
		self.navigationItem.rightBarButtonItem = self.makeCrossBtn()
		let leftNavBarButton = UIBarButtonItem(customView:searchBar)
		self.navigationItem.leftBarButtonItem = leftNavBarButton
		SetSearchBar()

	}
	
	func SetSearchBar(){
		//searchBar.searchTextField.delegate = self
		searchBar.becomeFirstResponder()
		searchBar.placeholder = "Quick search by name"
		searchBar.delegate = self
		searchBar.returnKeyType = .default
		//searchBar.searchTextField.addTarget(self, action: #selector(HomeViewController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

	}
	
	private func pullToRefresh(){
		pullControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
		pullControl.addTarget(self, action: #selector(refreshListData(_:)), for: .valueChanged)
		tableView.addSubview(pullControl)
	}
	
	override func didTapOnSearchBtn() {
		//self.isSearch = true
		self.placeNavBar(isSearh: true)
	}
	
	override func didTapOnCrossButton() {
		self.isSearch = false
		self.placeNavBar(isSearh: false)
		self.tableView.reloadData()
	}
	
	@objc private func refreshListData(_ sender: Any) {
		self.pullControl.endRefreshing() // You can stop after API Call
		// Call API
		self.getHomeData()
	}
	
	//MARK: Api Mark
	func getHeader(){
		let city_id = 1
		let category_id = 1
		let slider_type = "category"
		let param:[String:Any] = ["city_id":city_id,"category_id":category_id,"slider_type":slider_type]
		HomeServices.GetTopHomeHeader(parameters: param) { (success, result) in
			if success == true{
				self.arrSliderBanners.removeAll()
				let array = result.arrayValue
				for obj in array {
					let jsonObj = BannerModel.init(json: obj)
					for obj in  jsonObj.slides ?? []{
						self.arrSliderBanners.append(obj)
					}
				}
				self.tableView.reloadData()
			}
		}
	}
	
	func getVendors(){
		let city_id = 1
		let category_id = 1
		let offer_id = 1
		let param:[String:Any] = ["city_id":city_id,"category_id":category_id,"offer_id":offer_id]
		HomeServices.vendors(parameters: param) { (success, result) in
			self.arrVendors.removeAll()
			if success == true{
				let array = result.arrayValue
				for obj in array {
					let jsonObj = VendorModel.init(json: obj)
					self.arrVendors.append(jsonObj)
				}
				self.tableView.reloadData()
			}
		}
	}
	

	
	func getVendorsDetail(vendor_id:Int){
		var vendorID = vendor_id
		//vendorID = 3149
		let param:[String:Any] = [:]
		HomeServices.vendorsByID(vendorId: vendorID, parameters: param) { (success, result) in
			if success == true{
				print(result)
				self.selectedVendor = nil
				self.selectedVendor = VendorModel.init(json: result)
				let rootDetailVc = RootDetailViewController.instantiateFromStoryboard()
				rootDetailVc.vendor = self.selectedVendor
				self.navigationController?.pushViewController(rootDetailVc, animated: true)
			}
		}
	}
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 1
		case 1:
			return isSearch == false ? self.arrVendors.count : self.arrfilterVendors.count
			return self.arrVendors.count
		default:
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch indexPath.section {
		case 0:
			let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BannerSliderViewCell.self), for: indexPath) as! BannerSliderViewCell
			cell.backgroundColor = .clear
			cell.dataSource =  self.arrSliderBanners
			cell.pageControl.isHidden = false
			return cell
			
		case 1:
			let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeRestaurentTableViewCell.self), for: indexPath) as! HomeRestaurentTableViewCell
			//let imageUrl = self.arrVendors[indexPath.row].logo ?? Constants.PlaceHolderConstants.placeHolder
			//cell.restaurentImageView.setImageFromUrl(urlStr:imageUrl)
			let vendor = self.isSearch == false ? self.arrVendors[indexPath.row] : self.arrfilterVendors[indexPath.row]
			cell.setdata(vendor: vendor)
			return cell
			
		default:
			return UITableViewCell()
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		//return UITableView.automaticDimension
		switch indexPath.section {
		case 0:
			return   (self.arrSliderBanners.count > 0) ? 250 : 0
		case 1:
			return  isSearch == false ? ((self.arrVendors.count > 0 ) ? 200 : 0) : ((self.arrfilterVendors.count > 0 ) ? 200 : 0)
		default:
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 0 {
			return 0
		}
		
		return 0
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		(cell as? HomeRestaurentTableViewCell)?.backgroundViewBlack.roundCorners([.bottomLeft,.bottomRight], radius: 4)
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = UIView()
		headerView.backgroundColor = .clear
		return headerView
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.section {
		case 0:
			return
		case 1:
			self.getVendorsDetail(vendor_id: self.isSearch == false ? (self.arrVendors[indexPath.row].id ?? 0) :
				(self.arrfilterVendors [indexPath.row].id ?? 0) )
		default:
			fatalError()
		}
	}
}

extension HomeViewController:UISearchBarDelegate{
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		let str = searchText
		if str == ""{
			self.arrfilterVendors.removeAll()
			self.tableView.reloadData()
			return
		}
		isSearch = true
		self.arrfilterVendors.removeAll()
		let arr = arrVendors.filter { $0.name!.contains(str) }
		for obj in arr{
			self.arrfilterVendors.append(obj)
		}
		self.tableView.reloadData()
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
}*/
