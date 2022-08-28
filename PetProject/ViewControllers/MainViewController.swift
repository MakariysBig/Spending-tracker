import UIKit
import CloudKit
import CoreData

class MainViewController: UIViewController {
    
    //MARK: - Private properties
    
    private let tabBar = UITabBarController()
    
    //MARK: - Properties
    
    var coreDataStack = CoreDataStack()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Transaction> = {
        let fetchRequest = Transaction.fetchRequest()
        let context = coreDataStack.managedContext
        
        let sort = NSSortDescriptor(key: #keyPath(Transaction.createdAt), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()
    
    //MARK: - Lifycicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTabBar()
    }
    
    //MARK: - Private Methods
    
    private func configureTabBar() {
        let vc1 = UINavigationController(rootViewController: TransactionViewController(coreDataStack: self.coreDataStack, fetchedResultsController: self.fetchedResultsController))
        let vc2 = UINavigationController(rootViewController: AddNewTransactionViewController(coreDataStack: coreDataStack, fetchedResultsController: fetchedResultsController))
        
        vc1.title = "Transactions"
        
        vc1.tabBarItem.image = UIImage(systemName: "briefcase.fill")
        vc2.tabBarItem.image = UIImage(systemName: "plus.circle.fill")
        
        tabBar.tabBar.tintColor = .black
        tabBar.tabBar.layer.borderWidth = 0.2
        tabBar.tabBar.layer.borderColor = UIColor.black.cgColor
        tabBar.tabBar.tintColor = .red
        tabBar.tabBar.backgroundColor = .white
        tabBar.modalPresentationStyle = .fullScreen
        
        tabBar.setViewControllers([vc1, vc2], animated: true)
        present(tabBar, animated: true)
    }
}

