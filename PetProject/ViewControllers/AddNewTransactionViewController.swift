import UIKit
import CoreData

class AddNewTransactionViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    //MARK: - Private properties
    
    private let views = Views()

    //MARK: - Properties
    
    var coreDataStack: CoreDataStack
    var fetchedResultsController: NSFetchedResultsController<Transaction>
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        views.loadViews(view)
        
        setUpDelegates()
        setUpTargets()
        
        setUpSegmentedControllerLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        views.noteTextField.placeholder = "Enter note"
        views.noteTextField.text = ""
        views.amountTextField.placeholder = "Enter amount"
        views.amountTextField.text = ""
        let dateFormatter = DateFormatter()
    
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateFormatter.locale = Locale(identifier: "en")
        
        views.dateTextField.text = dateFormatter.string(from: Date())
    }
    
    //MARK: - Initialaze
    
    init(coreDataStack: CoreDataStack, fetchedResultsController: NSFetchedResultsController<Transaction>) {
        self.coreDataStack = coreDataStack
        self.fetchedResultsController = fetchedResultsController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    
    private func setUpDelegates() {
        views.noteTextField.delegate = self
        fetchedResultsController.delegate = self
    }
    
    private func setUpTargets() {
        views.datePicker.addTarget(self, action: #selector(chooseDate), for: .valueChanged)
        views.saveExpenseButton.addTarget(self, action: #selector(saveExpenseAction), for: .touchUpInside)
        views.saveIncomeButton.addTarget(self, action: #selector(saveIncomeAction), for: .touchUpInside)
    }
    
    private func setUpSegmentedControllerLayout() {
        let items = ["Expense", "Income"]
        let segmentedController = UISegmentedControl(items: items)
        
        views.contentView.addSubview(segmentedController)
        segmentedController.translatesAutoresizingMaskIntoConstraints = false
        segmentedController.layer.borderWidth = 2
        segmentedController.layer.borderColor = UIColor.black.cgColor
        segmentedController.selectedSegmentIndex = 0
        segmentedController.backgroundColor = .lightGray
        
        NSLayoutConstraint.activate([
            segmentedController.trailingAnchor.constraint(equalTo: views.amountTextField.trailingAnchor),
            segmentedController.leadingAnchor.constraint(equalTo: views.amountTextField.leadingAnchor),
            segmentedController.centerXAnchor.constraint(equalTo: views.contentView.centerXAnchor),
            segmentedController.bottomAnchor.constraint(equalTo: views.amountTextField.topAnchor, constant: -4)
        ])
        segmentedController.addTarget(self, action: #selector(changeSignAction), for: .valueChanged)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Somthing wrong!!!", message: "Pleas write amount", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func showAlertNumbers() {
        let alert = UIAlertController(title: "Error",
                                      message: "How did it get here? Try again but use numbers!!!",
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func save(withAmount amount: Double, textNote note: String) {
        let context = coreDataStack.managedContext
        let transaction = Transaction(context: context)
        
        transaction.amount = amount
        transaction.income = 0.0
        transaction.createdAt = Date()
        transaction.note = note
        
        coreDataStack.save()
    }
    
    private func saveIncome(withAmount amount: Double, textNote note: String) {
        let context = coreDataStack.managedContext
        let transaction = Transaction(context: context)
        
        transaction.amount = 0.0
        transaction.income = amount
        transaction.createdAt = Date()
        transaction.note = note
        
        coreDataStack.save()
    }
    
    //MARK: - Override methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: - Action
    
    @objc func saveIncomeAction() {
        guard let amountText = views.amountTextField.text, !amountText.isEmpty else { return showAlert() }
        
        let noteText = views.noteTextField.text ?? ""
        
        guard let convertTextAmount = Double(amountText) else { return showAlertNumbers() }
        
        saveIncome(withAmount: convertTextAmount, textNote: noteText)

        tabBarController?.selectedIndex = 0
    }
    
    @objc func saveExpenseAction() {
        guard let amountText = views.amountTextField.text, !amountText.isEmpty else { return showAlert() }
        
        let noteText = views.noteTextField.text ?? ""
        
        guard let convertTextAmount = Double(amountText) else { return showAlertNumbers() }
        
        save(withAmount: convertTextAmount, textNote: noteText)

        tabBarController?.selectedIndex = 0
    }
    
    @objc func chooseDate() {
        let dateFormatter = DateFormatter()
    
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateFormatter.locale = Locale(identifier: "en")
        
        views.dateTextField.text = dateFormatter.string(from: views.datePicker.date)
    }
    
    @objc func changeSignAction(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            views.saveExpenseButtonLayout()
        case 1:
            views.saveIncomeButtonLayout()
        default:
            views.saveExpenseButtonLayout()
        }
    }
}

//MARK: - UITextFieldDelegate

extension AddNewTransactionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        views.noteTextField.resignFirstResponder()
        return true
    }
}
