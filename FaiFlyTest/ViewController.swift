

import UIKit
import SwiftyJSON

class ViewController: UIViewController {

    var arrayOfCountries:[String] = []
    var arrayOfCities = [String]()

    @IBOutlet weak var countryPicker: UIPickerView!
    
    @IBOutlet weak var sitiesTableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var stupidBG: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryPicker.dataSource = self
        countryPicker.delegate = self
        
        sitiesTableView.delegate = self
        sitiesTableView.dataSource = self
        
        sitiesTableView.tableFooterView = UIView()
        
        
        // проверить интернет соединение

        downloadData()
    }
    
    @IBAction func unwindSegueToMainVC(segue: UIStoryboardSegue) {
    
    }
 
    private func downloadData() {
        DispatchQueue.global(qos: .userInitiated).async {
            RequesManager.shared.downloadData(completionHandler: {
                DispatchQueue.main.async {
                    self.arrayOfCountries = CoreDataManager.shared.getSavedCountriesArray()
//                    self.arrayOfCountries = RequesManager.shared.getArrayOfCountries()
                    self.countryPicker.reloadAllComponents()
                    self.updateSitiesForSelectedCountry()
                    self.stupidBG.alpha = 0
                    self.activityIndicator.stopAnimating()
                }
            })
        }
        
    }
 
    
    private func updateSitiesForSelectedCountry() {
        let country = arrayOfCountries[countryPicker.selectedRow(inComponent: 0)]
        arrayOfCities = CoreDataManager.shared.getSavedCitiesArrayBy(country: country) 
        sitiesTableView.reloadData()
    }
    
    private func presentExtendedInformationFor(city: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let targetVC = storyboard.instantiateViewController(withIdentifier: "ExtendedInformationViewControllerIdentifier") as! ExtendedInformationViewController
        
        self.present(targetVC, animated: true) {
            targetVC.city = city
        }
        
    }
    

}

//MARK: extentions

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SityCell", for: indexPath) as! SityTableViewCell
        cell.sityNameLabel.text = arrayOfCities[indexPath.row]
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentExtendedInformationFor(city: arrayOfCities[indexPath.row])
    }
    
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayOfCountries.count
    }
    
    
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayOfCountries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateSitiesForSelectedCountry()
    }
    
    
}
