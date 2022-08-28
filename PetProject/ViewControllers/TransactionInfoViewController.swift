import UIKit
import CoreData

class TransactionInfoViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    //MARK: - Private properies
    
    private let views = Views()
    
    //MARK: - Properties
    
    var coreDataStack: CoreDataStack
    var indexPath: IndexPath
    var fetchedResultsController: NSFetchedResultsController<Transaction>
    
    //MARK: - Initialize
    
    init(indexPath: IndexPath, coreDataStack: CoreDataStack, fetchedResultsController: NSFetchedResultsController<Transaction>) {
        self.indexPath = indexPath
        self.coreDataStack = coreDataStack
        self.fetchedResultsController = fetchedResultsController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        views.loadViews(view)
        setUpDelegates()
        setUpTargets()
        
        getItems()
        
        view.backgroundColor = .white
    }
    
    //MARK: - Private methods
    
    private func setUpDelegates() {
        views.noteTextField.delegate = self
        fetchedResultsController.delegate = self
    }
    
    private func setUpTargets() {
        views.datePicker.addTarget(self, action: #selector(chooseDate), for: .valueChanged)
        views.saveButton.addTarget(self, action: #selector(saveExpenseAction), for: .touchUpInside)
    }
    
    private func save(withAmount amount: Double, textNote note: String, textDate date: Date) {
        let transaction = fetchedResultsController.object(at: indexPath)
        
        if transaction.amount == 0.0 {
            transaction.income = amount
        } else {
            transaction.amount = amount
        }
        
        transaction.note = note
        transaction.createdAt = date
        
        coreDataStack.save()
    }
    
    private func getItems() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("I can't fetch transactions")
        }
        
        let transaction = fetchedResultsController.object(at: indexPath)
        
        if transaction.amount == 0.0 {
            views.amountTextField.text = "\(transaction.income )"
        } else {
            views.amountTextField.text = "\(transaction.amount)"
        }
        
        views.noteTextField.text = "\(transaction.note ?? "")"
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateFormatter.locale = Locale(identifier: "en")
        
        let date = dateFormatter.string(from: transaction.createdAt!)
        
        views.dateTextField.text = "\(date)"
    }
    
    private func showAlertNumbers() {
        let alert = UIAlertController(title: "Error", message: "How did it get here? Try again but use numbers!!!", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Somthing wrong!!!", message: "Pleas write amount", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    //MARK: - Ovveride methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: - Action
    
    @objc func saveExpenseAction() {
        guard let amountText = views.amountTextField.text, !amountText.isEmpty else { return showAlert() }
        
        guard let convertTextAmount = Double(amountText) else { return showAlertNumbers() }
        
        save(withAmount: Double(convertTextAmount),
             textNote: views.noteTextField.text ?? "",
             textDate: views.datePicker.date)
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func chooseDate() {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateFormatter.locale = Locale(identifier: "en")
        
        views.dateTextField.text = dateFormatter.string(from: views.datePicker.date)
    }
}

//MARK: - UITextFieldDelegate

extension TransactionInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        views.noteTextField.resignFirstResponder()
        return true
    }
}
