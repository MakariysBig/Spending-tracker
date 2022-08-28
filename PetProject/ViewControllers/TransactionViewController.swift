import UIKit
import CoreData

class TransactionViewController: UIViewController {
    
    //MARK: - Private properties
    
    private let views = Views()
    private var expenseCount = 0.0
    private var incomeCount = 0.0
    
    //MARK: - Properties
    
    var coreDataStack: CoreDataStack
    var fetchedResultsController: NSFetchedResultsController<Transaction>
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        views.loadViews(view)
        
        configureTableView()
        configureSearchBar()
        setUpNavigationBarLayout()
        
        getItems()
        
        fetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getItems()
        expenseCount = 0.0
        incomeCount = 0.0
        calculateExpense()
        calculateIncome()
        
        views.yourBalanceLabel.text  = "Your balance: \(incomeCount)"
        views.calculateAmountLabel.text = "Your spent: \(expenseCount)"
        
        fetchedResultsController.delegate = self
        views.tableView.reloadData()
    }
    
    //MARK: - Initialaze
    
    init(coreDataStack: CoreDataStack, fetchedResultsController: NSFetchedResultsController<Transaction> ) {
        self.coreDataStack = coreDataStack
        self.fetchedResultsController = fetchedResultsController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    
    private func calculateExpense() {
        let transaction = fetchedResultsController.fetchedObjects ?? []
        var arrayExpense = [(Int, Double)]()
        
        for (index, amount) in transaction.enumerated() {
            arrayExpense += [(index, amount.amount)]
        }
        print("calcualte amount\(arrayExpense)")
        
        for (_, amount) in arrayExpense {
            expenseCount += amount
        }
        print("calcualte amount\(expenseCount)")
    }
    
    private func calculateIncome() {
        let transaction = fetchedResultsController.fetchedObjects ?? []
        var arrayAmount = [(Int, Double)]()
        var arrayIncome = [(Int, Double)]()
        
        for (index, amount) in transaction.enumerated() {
            arrayAmount += [(index, amount.amount)]
        }
        
        var expenseCount = 0.0
        
        for (_, amount) in arrayAmount {
            expenseCount += amount
        }
        
        for (index, income) in transaction.enumerated() {
            arrayIncome += [(index, income.income)]
        }
        print(arrayIncome)
        
        for (_, income) in arrayIncome {
            incomeCount += income
        }
        incomeCount -= expenseCount
        print("calcualte income \(incomeCount)")
    }
    
    private func configureTableView() {
        views.tableView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        views.tableView.delegate = self
        views.tableView.dataSource = self
    }
    
    private func setUpNavigationBarLayout() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.red]
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureSearchBar() {
        views.searchBar.delegate = self
    }
    
    private func deleteTransaction(at indexPath: IndexPath) {
        let transaction = fetchedResultsController.object(at: indexPath)
        let context = coreDataStack.managedContext
        
        expenseCount -= transaction.amount
        incomeCount += transaction.amount
        incomeCount -= transaction.income
        
        views.calculateAmountLabel.text = "Your spent: \(expenseCount)"
        views.yourBalanceLabel.text = "Your balance: \(incomeCount)"
        
        context.delete(transaction)
        
        do {
            try context.save()
        } catch {
            print("I can't save")
        }
    }
    
    private func getItems() {
        do {
            try fetchedResultsController.performFetch()
            
        } catch {
            print("I can't fetch transactions")
        }
        views.tableView.reloadData()
    }
    
    private func getItems(for name: String) {
        var predicte: NSPredicate?
        
        if !name.isEmpty {
            predicte = NSPredicate(format: "note contains[c] '\(name)'")
        } else {
            predicte = nil
        }
        
        fetchedResultsController.fetchRequest.predicate = predicte
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("I can't fetch transactions")
        }
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension TransactionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?.first?.numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell",
                                                       for: indexPath) as? CustomCell else
                                                       { return UITableViewCell() }
                
        let transaction = fetchedResultsController.object(at: indexPath)
        
        let fullFormatter = DateFormatter()
        let dayFormatter = DateFormatter()
        
        fullFormatter.dateFormat = "LLL yyyy, EEEE"
        
        dayFormatter.dateFormat = "dd"
        
        fullFormatter.locale = Locale(identifier: "en")
        dayFormatter.locale = Locale(identifier: "en")
        
        let date = fullFormatter.string(from: transaction.createdAt ?? Date())
        let day = dayFormatter.string(from: transaction.createdAt ?? Date())
        
        if transaction.amount == 0.0 {
            cell.amountLabel.text = String(transaction.income )
            cell.amountLabel.textColor = .green
        } else {
            cell.amountLabel.text = String(transaction.amount)
            cell.amountLabel.textColor = .red
        }
        
        cell.dateLabel.text = date
        cell.dayLabel.text = day
        cell.noteLabel.text = transaction.note
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTransaction(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let transactionInfoViewController = TransactionInfoViewController(indexPath: indexPath,
                                                                          coreDataStack: coreDataStack,
                                                                          fetchedResultsController: fetchedResultsController)
        
        transactionInfoViewController.title = "Transaction Info"
        navigationController?.pushViewController(transactionInfoViewController, animated: true)
    }
}

//MARK: - UISearchBarDelegate

extension TransactionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getItems(for: searchText)
        expenseCount = 0.0
        calculateExpense()
        
        views.yourBalanceLabel.text = "Your balance: \(incomeCount)"
        views.calculateAmountLabel.text = "Your spent: \(expenseCount)"
        
        views.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        views.searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        views.searchBar.endEditing(true)
        views.searchBar.text = nil
        views.searchBar.showsCancelButton = false
        views.tableView.reloadData()
        getItems()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        views.searchBar.endEditing(true)
        views.searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        views.searchBar.endEditing(true)
        views.searchBar.showsCancelButton = false
    }
}

//MARK: - NSFetchedResultsControllerDelegate

extension TransactionViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                    at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                self.views.tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                views.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .move:
            if let indexPath = indexPath {
                views.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let newIndexPath = newIndexPath {
                print("Move:\(newIndexPath)")
                views.tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath {
                views.tableView.reloadRows(at: [indexPath], with: .fade)
            }
            break
        @unknown default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            views.tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
            break
        case .delete:
            views.tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
            break
        default:
            break
        }
    }
}
