import UIKit
import CoreData

class AddNewTransactionViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    let contentView = UIView()
    let coverView = UIView()
    
    
    let dateTextField = UITextField()
    let datePicker = UIDatePicker()
    let dateLabel = UILabel()
    
    let saveExpenseButton = UIButton()
    let saveIncomeButton = UIButton()
    
   
    
    let amountLabel = UILabel()
    let amountTextField = UITextField()
    
    let noteLabel = UILabel()
    let noteTextField = UITextField()
    
    let coreDataStack = CoreDataStack()
    
    let mainViewController = MainViewController()
    let transactionViewController = TransactionViewController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Transaction> = {
        let fetchRequest = Transaction.fetchRequest()
        
        let sort = NSSortDescriptor(key: #keyPath(Transaction.createdAt), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpContentViewLayout()
        setUpCoverViewLayout()
        
        setUpExpenseAmountTextFieldLayout()
//        setUpAmountLabelLayout()

        setUpNoteTextFieldLayout()
        setUpNotetLabelLayout()

        seUpTextDatePickerLayout()
        setUpDatePickerLayout()
        setUpDateLabelLAyout()
        
        
        saveExpenseButtonLayout()
//        saveIncomeButtonLayout()
        setUpsegmentedControllerLayout()
        fetchedResultsController.delegate = self
        
        
        
        view.backgroundColor = .white
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        noteTextField.placeholder = "Enter note"
        noteTextField.text = ""
        amountTextField.placeholder = "Enter amount"
        amountTextField.text = ""
        let dateFormatter = DateFormatter()
    
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateFormatter.locale = Locale(identifier: "en")
        
        dateTextField.text = dateFormatter.string(from: Date())
        
    }
    
    private func setUpsegmentedControllerLayout() {
        let items = ["Expense", "Income"]
        let segmentedController = UISegmentedControl(items: items)
        
        
        contentView.addSubview(segmentedController)
        segmentedController.translatesAutoresizingMaskIntoConstraints = false
        segmentedController.layer.borderWidth = 2
        segmentedController.layer.borderColor = UIColor.black.cgColor
        segmentedController.selectedSegmentIndex = 0
        segmentedController.backgroundColor = .lightGray
//        segmentedController.selectedSegmentTintColor = .red
        
        NSLayoutConstraint.activate([
            segmentedController.trailingAnchor.constraint(equalTo: amountTextField.trailingAnchor),
            segmentedController.leadingAnchor.constraint(equalTo: amountTextField.leadingAnchor),

            segmentedController.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            segmentedController.bottomAnchor.constraint(equalTo: amountTextField.topAnchor, constant: -4)
//            segmentedController.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            segmentedController.widthAnchor.constraint(equalToConstant: 200),
//            segmentedController.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        segmentedController.addTarget(self, action: #selector(changeSignAction), for: .valueChanged)
    }
    
    @objc func changeSignAction(sender: UISegmentedControl) {
        print(#function)
        switch sender.selectedSegmentIndex {
        case 0:
            saveExpenseButtonLayout()
            print("sell")
        case 1:
//            saveExpenseButton.isHidden = true
            saveIncomeButtonLayout()
//            saveExpenseButton.isHidden = true
            print("income")
        default:
            saveExpenseButtonLayout()
            print("default")
        }
    }
    
    
    
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
        
        datePicker.addTarget(self, action: #selector(chooseDate), for: .valueChanged)
        
    }
    
    @objc func chooseDate() {
        let dateFormatter = DateFormatter()
    
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateFormatter.locale = Locale(identifier: "en")
        
        dateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    private func seUpTextDatePickerLayout() {
        coverView.addSubview(dateTextField)
        
        let dateFormatter = DateFormatter()
    
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateFormatter.locale = Locale(identifier: "en")
        
        dateTextField.text = dateFormatter.string(from: Date())
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    private func setUpNoteTextFieldLayout() {
        coverView.addSubview(noteTextField)
        
        noteTextField.placeholder = "Enter note"
//        noteTextField.text = "0"
        noteTextField.borderStyle = .roundedRect
        noteTextField.layer.borderWidth = 2
        noteTextField.layer.cornerRadius = 10
        
        
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
    
    
    
    private func setUpExpenseAmountTextFieldLayout() {
        coverView.addSubview(amountTextField)
        
        amountTextField.placeholder = "Enter amount"

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
    
    private func saveExpenseButtonLayout() {
        contentView.addSubview(saveExpenseButton)
        saveExpenseButton.setTitle("Save expense", for: .normal)
        saveExpenseButton.setTitleColor(.white, for: .normal)
        saveExpenseButton.backgroundColor = .orange
        saveExpenseButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        saveExpenseButton.layer.cornerRadius = 10
        
        
        saveExpenseButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveExpenseButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            saveExpenseButton.heightAnchor.constraint(equalToConstant: 50),
            saveExpenseButton.leadingAnchor.constraint(equalTo: coverView.leadingAnchor),
            saveExpenseButton.trailingAnchor.constraint(equalTo: coverView.trailingAnchor),
        ])
        
        saveExpenseButton.addTarget(self, action: #selector(saveExpenseAction), for: .touchUpInside)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Somthing wrong!!!", message: "Pleas write amount", preferredStyle: .alert)
        

        
        let cancelAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    
    @objc func saveExpenseAction() {
        
        guard let amountText = amountTextField.text, !amountText.isEmpty else { return showAlert() }
        
        let noteText = noteTextField.text ?? ""
        
        guard let convertTextAmount = Double(amountText) else { return }
        
//        self.save(withAmount: convertTextAmount, textNote: noteText)
        save(withAmount: convertTextAmount, textNote: noteText)

        tabBarController?.selectedIndex = 0
        
    }
    
    
    
    func save(withAmount amount: Double, textNote note: String) {

        let context = coreDataStack.managedContext
        let transaction = Transaction(context: context)
        
        transaction.amount = amount
        transaction.income = 0.0
        transaction.createdAt = Date()
        transaction.note = note
        
        coreDataStack.save()
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
    //
    
    private func setUpAmountTextFieldLayout() {
        coverView.addSubview(amountTextField)
        
        amountTextField.placeholder = "Enter amount"

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
    
    private func saveIncomeButtonLayout() {
        contentView.addSubview(saveIncomeButton)
        saveIncomeButton.setTitle("Save income", for: .normal)
        saveIncomeButton.setTitleColor(.white, for: .normal)
        saveIncomeButton.backgroundColor = .orange
        saveIncomeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        saveIncomeButton.layer.cornerRadius = 10
        
        
        saveIncomeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveIncomeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            saveIncomeButton.heightAnchor.constraint(equalToConstant: 50),
            saveIncomeButton.leadingAnchor.constraint(equalTo: coverView.leadingAnchor),
            saveIncomeButton.trailingAnchor.constraint(equalTo: coverView.trailingAnchor),
        ])
        
        saveIncomeButton.addTarget(self, action: #selector(saveIncomeAction), for: .touchUpInside)
    }
    
//    private func showAlert() {
//        let alert = UIAlertController(title: "Somthing wrong!!!", message: "Pleas write amount", preferredStyle: .alert)
//
//
//
//        let cancelAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
//
//        alert.addAction(cancelAction)
//
//        present(alert, animated: true)
//
//    }
    
    @objc func saveIncomeAction() {
        print(#function)
        guard let amountText = amountTextField.text, !amountText.isEmpty else { return showAlert() }
        
        let noteText = noteTextField.text ?? ""
        
        guard let convertTextAmount = Double(amountText) else { return }
        
        saveIncome(withAmount: convertTextAmount, textNote: noteText)

        tabBarController?.selectedIndex = 0
        
    }
    
    
    
    func saveIncome(withAmount amount: Double, textNote note: String) {

        let context = coreDataStack.managedContext
        let transaction = Transaction(context: context)
//        let profit = Profit(context: context)
        
        transaction.amount = 0.0
        transaction.income = amount
        transaction.createdAt = Date()
        transaction.note = note
        
//        transaction.income += amount
        
        
        coreDataStack.save()
    }
}
    




