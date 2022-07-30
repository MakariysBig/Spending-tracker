import UIKit
import CloudKit

class MainViewController: UIViewController {
    
    //MARK: - Properties
    
    let logInButton = UIButton()
    let tabBar = UITabBarController()
//    let addNewTransactionViewController = AddNewTransactionViewController()
    
    let button = UIButton()
    
//MARK: - Lifycicle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
//        setUpLogInButtonLayout()

        configureTabBar()
    }
    
    //MARK: - Private Methods
    
    private func setUpButtonLayout() {
        tabBar.tabBar.addSubview(button)
        
        button.backgroundColor = .green
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: tabBar.tabBar.centerYAnchor, constant: -40),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 50),
            button.centerXAnchor.constraint(equalTo: tabBar.tabBar.centerXAnchor),

        ])
    }

    private func setUpLogInButtonLayout() {
        view.addSubview(logInButton)
        
        logInButton.setTitle("Log In", for: .normal)
        logInButton.setTitleColor(.black, for: .normal)
        logInButton.backgroundColor = .blue
        logInButton.layer.cornerRadius = 15
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logInButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            logInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
        ])
        
        logInButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
    
   
    
    private func configureTabBar() {
//        let tabBar = UITabBarController()
        tabBar.tabBar.addSubview(button)
//        let button = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(addNewTransaction))
        let vc1 = UINavigationController(rootViewController: TransactionViewController())
        let vc2 = UINavigationController(rootViewController: FirstViewController())
        let vc3 = UINavigationController(rootViewController: AddNewTransactionViewController())
        
        
        
        
        
        vc1.title = "Transactions"
        vc2.title = "Settings"
        
        
        
        vc1.tabBarItem.image = UIImage(systemName: "briefcase.fill")
        vc2.tabBarItem.image = UIImage(systemName: "gear")
        vc3.tabBarItem.image = UIImage(systemName: "plus.circle.fill")
        
        tabBar.tabBar.tintColor = .black
//        tabBar.navigationItem.setLeftBarButton(button, animated: true)
        tabBar.setViewControllers([vc1, vc3, vc2], animated: true)
//        tabBar.setToolbarItems([button], animated: true)
        tabBar.tabBar.layer.borderWidth = 0.2
        tabBar.tabBar.layer.borderColor = UIColor.black.cgColor

        
        tabBar.tabBar.tintColor = .red
        tabBar.tabBar.backgroundColor = .white
        tabBar.modalPresentationStyle = .fullScreen
        
        present(tabBar, animated: true)
        
    }
    
    //MARK: - Actions
    
    @objc func tapButton() {
        configureTabBar()
    }
 
}

