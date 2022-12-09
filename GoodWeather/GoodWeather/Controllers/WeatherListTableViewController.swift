//
//  WeatherListTableViewController.swift
//  GoodWeather
//
//  Created by Gaurav Semwal on 08/12/22.
//  Copyright © 2022 Gaurav Semwal. All rights reserved.
//

import UIKit

class WeatherListTableViewController: UITableViewController, AddWeatherDelegate {
    private var weatherListViewModel = WeatherListViewModel()
    private var lastUnitSelection: Unit!
    
    func addWeatherDidSave(vm: WeatherViewModel) {
        weatherListViewModel.addWeatherViewModel(vm)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let userDefaults = UserDefaults.standard
        if let value = userDefaults.value(forKey: "unit") as? String {
            self.lastUnitSelection = Unit(rawValue: value)!
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherListViewModel.numberOfRows(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        
        let weatherVM = weatherListViewModel.modelAt(indexPath.row)
        
        cell.configure(weatherVM)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddWeatherCityViewController" {
            prepareSequeForAddWeatherCityViewController(segue: segue)
        } else if segue.identifier == "SettingTableViewController" {
            prepareSegueForSettingsTableViewController(segue: segue)
        }
        
        
    }
    
    func prepareSequeForAddWeatherCityViewController(segue: UIStoryboardSegue){
        guard let nav = segue.destination as? UINavigationController else {
            fatalError("Navigation controller not found")
        }
        
        guard let addWeatherCityVC = nav.viewControllers.first as? AddWeatherViewController else {
            fatalError("AddWeatherViewController not found")
        }
        
        addWeatherCityVC.delegate = self
    }
    
    func prepareSegueForSettingsTableViewController(segue: UIStoryboardSegue) {
        guard let nav = segue.destination as? UINavigationController else {
            fatalError("Navigation controller not found")
        }
        
        guard let addWSettingsVC = nav.viewControllers.first as? SettingTableViewController else {
            fatalError("SettingTableViewController not found")
        }
        
        addWSettingsVC.delegate = self
    }
    
}

extension WeatherListTableViewController: SettingDelegate {
    func settingsDone(vm: SettingsViewModel) {
        if lastUnitSelection.rawValue != vm.selectedUnit.rawValue {
            weatherListViewModel.updateUnit(to: vm.selectedUnit)
            tableView.reloadData()
            lastUnitSelection = Unit(rawValue: vm.selectedUnit.rawValue)!
        }
    }
}
