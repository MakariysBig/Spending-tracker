import UIKit
import CoreData

class TransactionInfoViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    //MARK: - Private properies
    
    private let contentView = UIView()
    private let coverView = UIView()
    
    private let dateLabel = UILabel()
    private let amountLabel = UILabel()
    private let noteLabel = UILabel()
    
    private let saveButton = UIButton()
    
    private let datePicker = UIDatePicker()
    
    private let dateTextField = UITextField()
    private let amountTextField = UITextField()
    private let noteTextField = UITextField()
    
    private let customCell = CustomCell()
    private let coreDataStack = CoreDataStack()
    private let transactionViewController = TransactionViewController()
    
    var indexPath: IndexPath
    
    lazy var fetchedResultsController: NSFetchedResultsController<Transaction> = {
        let fetchRequest = Transaction.fetchRequest()
        
        let sort = NSSortDescriptor(key: #keyPath(Transaction.createdAt), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()
    
    //MARK: - Initialize
    
    init(indexPath: IndexPath) {
        self.indexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpContentViewLayout()
        setUpCoverViewLayout()
        setUpAmountTextFieldLayout()
        setUpAmountLabelLayout()
        setUpNoteTextFieldLayout()
        setUpNotetLabelLayout()
        seUpTextDatePickerLayout()
        setUpDatePickerLayout()
        setUpDateLabelLAyout()
        
        saveButtonLayout()
        
        getItems()
        
        fetchedResultsController.delegate = self
        
        view.backgroundColor = .white
    }
    
    //MARK: - Private methods
    
    private func setUpCoverViewLayout() {
        contentView.addSubview(coverView)
        
        coverView.backgroundColor = .white
        
        coverView.translatesAutoresizingMaskIntoConstraints = false
        coverView.layer.cornerRadius = 20
        
        NSLayoutConstraint.activate([
            coverView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            coverView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            coverView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            coverView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5)
        ])
    }
    
    private func setUpDatePickerLayout() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        let loc = Locale(identifier: "en")
        datePicker.locale = loc
        
        datePicker.addTarget(self, action: #selector(chooseDate), for: .valueChanged)
    }
    
    private func seUpTextDatePickerLayout() {
        coverView.addSubview(dateTextField)
        
        dateTextField.placeholder = "Pick your date"
        dateTextField.font = UIFont.systemFont(ofSize: 20)
        dateTextField.borderStyle = .roundedRect
        dateTextField.tintColor = .black
        dateTextField.layer.borderWidth = 2
        dateTextField.layer.cornerRadius = 10
        
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        dateTextField.inputView = datePicker
        
        NSLayoutConstraint.activate([
            dateTextField.leadingAnchor.constraint(equalTo: coverView.leadingAnchor, constant: 10),
            dateTextField.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -10),
            dateTextField.topAnchor.constraint(equalTo: noteTextField.bottomAnchor, constant: 40),
            dateTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setUpNoteTextFieldLayout() {
        coverView.addSubview(noteTextField)
        
        noteTextField.placeholder = "Enter note"
        noteTextField.text = "0"
        noteTextField.borderStyle = .roundedRect
        noteTextField.layer.borderWidth = 2
        noteTextField.layer.cornerRadius = 10
        noteTextField.delegate = self
        
        noteTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noteTextField.leadingAnchor.constraint(equalTo: coverView.leadingAnchor, constant: 10),
            noteTextField.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -10),
            noteTextField.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 40),
            noteTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setUpNotetLabelLayout() {
        coverView.addSubview(noteLabel)
        
        noteLabel.text = "Note: "
        noteLabel.textColor = .black
        
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noteLabel.leadingAnchor.constraint(equalTo: noteTextField.leadingAnchor),
            noteLabel.trailingAnchor.constraint(equalTo: noteTextField.trailingAnchor),
            noteLabel.bottomAnchor.constraint(equalTo: noteTextField.topAnchor),
        ])
    }
    
    private func setUpDateLabelLAyout() {
        coverView.addSubview(dateLabel)
        
        dateLabel.text = "Date: "
        dateLabel.textColor = .black
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: dateTextField.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: dateTextField.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: dateTextField.topAnchor),
        ])
    }
    
    private func setUpAmountLabelLayout() {
        coverView.addSubview(amountLabel)
        
        amountLabel.text = "Amount: "
        amountLabel.textColor = .black
        
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            amountLabel.leadingAnchor.constraint(equalTo: amountTextField.leadingAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: amountTextField.trailingAnchor),
            amountLabel.bottomAnchor.constraint(equalTo: amountTextField.topAnchor),
        ])
    }
    
    private func setUpAmountTextFieldLayout() {
        coverView.addSubview(amountTextField)
        
        amountTextField.placeholder = "here"
        amountTextField.text = "0"
        amountTextField.borderStyle = .roundedRect
        amountTextField.layer.borderWidth = 2
        amountTextField.layer.cornerRadius = 10
        amountTextField.keyboardType = .decimalPad
        
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            amountTextField.leadingAnchor.constraint(equalTo: coverView.leadingAnchor, constant: 10),
            amountTextField.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -10),
            amountTextField.topAnchor.constraint(equalTo: coverView.topAnchor, constant: 30),
            amountTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func saveButtonLayout() {
        contentView.addSubview(saveButton)
        saveButton.setTitle("Save transaction", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = .orange
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        saveButton.layer.cornerRadius = 10
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.leadingAnchor.constraint(equalTo: coverView.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: coverView.trailingAnchor),
        ])
        saveButton.addTarget(self, action: #selector(saveExpenseAction), for: .touchUpInside)
    }
    
    private func save(withAmount amount: Double, textNote note: String, textDate date: Date) {
        
        let transaction = fetchedResultsController.object(at: indexPath)
        
        if transaction.amount == 0.0 {
            transaction.income = amount
            
            coreDataStack.save()
        } else {
            transaction.amount = amount
            coreDataStack.save()
        }
        
        transaction.note = note
        transaction.createdAt = date
        
        coreDataStack.save()
        transactionViewController.tableView.reloadData()
        transactionViewController.tableView.reloadRows(at: [indexPath], with: .fade)
        transactionViewController.collectionView?.reloadData()
    }
    
    private func getItems() {
        do {
            try fetchedResultsController.performFetch()
            
        } catch {
            print("I can't fetch transactions")
        }
        
        let transaction = fetchedResultsController.object(at: indexPath)
        
        if transaction.amount == 0.0 {
            amountTextField.text = "\(transaction.income )"
            
        } else {
            amountTextField.text = "\(transaction.amount)"
        }
        
        noteTextField.text = "\(transaction.note ?? "")"
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateFormatter.locale = Locale(identifier: "en")
        
        let date = dateFormatter.string(from: transaction.createdAt!)
        
        dateTextField.text = "\(date)"
    }
    
    private func setUpContentViewLayout() {
        view.addSubview(contentView)
        contentView.backgroundColor = .white
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func showAlertNumbers() {
        let alert = UIAlertController(title: "Error", message: "How did it get here? Try again but use numbers!!!", preferredStyle: .alert)
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
        guard let amountText = amountTextField.text, !amountText.isEmpty else { return }
        
        guard let convertTextAmount = Double(amountText) else { return showAlertNumbers() }
        
        save(withAmount: Double(convertTextAmount), textNote: noteTextField.text ?? "", textDate: datePicker.date)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func chooseDate() {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateFormatter.locale = Locale(identifier: "en")
        
        dateTextField.text = dateFormatter.string(from: datePicker.date)
    }
}

//MARK: - UITextFieldDelegate
extension TransactionInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        noteTextField.resignFirstResponder()
        return true
    }
}
