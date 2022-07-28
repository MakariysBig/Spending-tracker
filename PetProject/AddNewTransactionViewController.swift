import UIKit

class AddNewTransactionViewController: UIViewController {
    
    let firstViewController = FirstViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        firstViewController.modalPresentationStyle = .formSheet
        self.present(firstViewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    



}
