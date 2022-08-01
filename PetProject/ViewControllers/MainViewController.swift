import UIKit
import CloudKit

class MainViewController: UIViewController {
    
    //MARK: - Private properties
    
    private let logInButton = UIButton()
    private let button      = UIButton()
    
    private let tabBar = UITabBarController()
    
//MARK: - Lifycicle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
        tabBar.tabBar.addSubview(button)
        
        let vc1 = UINavigationController(rootViewController: TransactionViewController())
        let vc3 = UINavigationController(rootViewController: AddNewTransactionViewController())
        
        vc1.title = "Transactions"
        
        vc1.tabBarItem.image = UIImage(systemName: "briefcase.fill")
        vc3.tabBarItem.image = UIImage(systemName: "plus.circle.fill")
        
        tabBar.tabBar.tintColor = .black
        tabBar.tabBar.layer.borderWidth = 0.2
        tabBar.tabBar.layer.borderColor = UIColor.black.cgColor
        tabBar.tabBar.tintColor = .red
        tabBar.tabBar.backgroundColor = .white
        tabBar.modalPresentationStyle = .fullScreen
        
        tabBar.setViewControllers([vc1, vc3], animated: true)
        present(tabBar, animated: true)
    }
    
    //MARK: - Actions
    
    @objc func tapButton() {
        configureTabBar()
    }
}

