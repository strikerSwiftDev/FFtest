
import UIKit

class ExtendedInformationViewController: UIViewController {
    
    
    var city = "" {
        didSet {
            cityLabel.text = city
            initialise()
        }
    }
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    
    @IBOutlet weak var stupidBGView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func initialise() {
        DispatchQueue.global(qos: .default).async {
            RequesManager.shared.getDataFor(city: self.city) { (stringDatas) in
                DispatchQueue.main.async {
                    
                    if !stringDatas.isEmpty {
                        self.summaryTextView.text = stringDatas[0]
                        self.longitudeLabel.text = stringDatas[1]
                        self.latitudeLabel.text = stringDatas[2]
                        self.stupidBGView.alpha = 0
                        self.activityIndicator.stopAnimating()
                    } else {
                        self.proceedNoDataForCity()
                    }
                    
                }
                
            }
        }
        
    }
    
    
    func proceedNoDataForCity(){
        summaryTextView.text = ""
        longitudeLabel.text = "no data"
        latitudeLabel.text = "no data"
        stupidBGView.alpha = 0
        activityIndicator.stopAnimating()
    }
    
   
    
    

}
