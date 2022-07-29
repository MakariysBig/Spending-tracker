import UIKit
import CoreData

class TransactionViewController: UIViewController {
    
    //MARK: - Properties
    
//    let amountTextField = UITextField()
    var amountTextField: UITextField?
    
    
    
    var collectionView: UICollectionView?
//    = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    
    let addNewTransactionViewController = AddNewTransactionViewController()
    
    let coreDataStack = CoreDataStack()
//    let transactionInfoViewController: TransactionInfoViewController?
    
    let tableView = UITableView()
    let searchBar = UISearchBar()
    
    var fullAmount = 0.0
    var maounthSet: Set<String> = []
    var mounthArray: [String] = []
    
    let plusButton = UIButton()
    
    let calculateAmountLabel = UILabel()
    
    
//    var transactions: [Transaction] = []
    
    lazy var fetchedResultsController: NSFetchedResultsController<Transaction> = {
        let fetchRequest = Transaction.fetchRequest()
        
        let sort = NSSortDescriptor(key: #keyPath(Transaction.createdAt), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        
        return fetchedResultsController
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
//        setUpCollectionViewLayout()
        
        self.collectionView = setUpCollectionViewLayout()
        
        setUpTableViewLayout()
        configureTableView()
        setUpNavigationBarLayout()
        getItems()
       
        setUpSearchBarLayout()
        setUpPlusButton()
        setUpCalculateAmountLayout()
        fetchedResultsController.delegate = self

//        title = "fdsaf"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getItems()
//        tableView.reloadData()
        
//        fullAmount += amount
//        calculateAmountLabel.text = "Amount \(fullAmount)"
    }
    
    //MARK: - Private Methods
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.endEditing(true)
//    }
    private func calculateCellForCollectionView(indexPath: IndexPath) {
        let transaction = fetchedResultsController.object(at: indexPath)
        
        let dateFormater = DateFormatter()
        
        dateFormater.dateFormat = "MMMM"
        dateFormater.locale = Locale(identifier: "En")
        
        let date = dateFormater.string(from: transaction.createdAt!) //July
        
        if self.maounthSet.insert(date).inserted == true {
            maounthSet.insert(date)
            mounthArray.append(date)
        }
    }
    
    private func setUpCollectionViewLayout() -> UICollectionView {
//        view.addSubview(collectionView)
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .horizontal
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        
        let viewColl = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(viewColl)
        
        viewColl.showsHorizontalScrollIndicator = false
        viewColl.backgroundColor = .red
        viewColl.delegate = self
        viewColl.dataSource = self
        
//        collectionView.backgroundColor = .red
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.scrollDirection = .horizontal
        viewColl.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        
//        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        
        
        viewColl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewColl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewColl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewColl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewColl.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return viewColl
    }
    
    private func setUpCalculateAmountLayout() {
        view.addSubview(calculateAmountLabel)
        calculateAmountLabel.text = "Amount: \(fullAmount)"
        calculateAmountLabel.textColor = .red
        calculateAmountLabel.backgroundColor = .black
        
        calculateAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calculateAmountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calculateAmountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calculateAmountLabel.bottomAnchor.constraint(equalTo: plusButton.topAnchor),
            calculateAmountLabel.heightAnchor.constraint(equalToConstant: 40)

        ])
        
    }
    
    private func setUpPlusButton() {
        view.addSubview(plusButton)
        
        plusButton.backgroundColor = .blue
        plusButton.setTitle("Add new transaction", for: .normal)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            plusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            plusButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            plusButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            plusButton.heightAnchor.constraint(equalToConstant: 40)

        ])
        
        plusButton.addTarget(self, action: #selector(addNewTransactionAction), for: .touchUpInside)
    }
    
    @objc func addNewTransactionAction() {
        addNewTransactionViewController.modalPresentationStyle = .formSheet
        self.present(addNewTransactionViewController, animated: true)
    }
    
    private func setUpTableViewLayout() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: collectionView!.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureTableView() {
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setUpNavigationBarLayout() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.red]
        title = "Transaction"
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .done, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .red

        navigationController?.navigationBar.tintColor = .red
        
        navigationItem.rightBarButtonItem = addButton
    }
    
    func setUpAmountTextField(textField: UITextField) {
        self.amountTextField = textField
        self.amountTextField?.placeholder = "Enter your amount"
        
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Add new transaction", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Write amount"
            textField.keyboardType = .decimalPad
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Write note"
        }
        
        
//        alert.addTextField(configurationHandler: setUpAmountTextField)
        
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let amountTextField = alert.textFields?.first,
                  let amountText = amountTextField.text, !amountText.isEmpty else { return }
            
            guard let noteTextField = alert.textFields?.last else { return }
//                  let secondtext = secondtextField.text, !secondtext.isEmpty else { return }
            let noteText = noteTextField.text ?? ""
//            let note = Transaction(amount: 0, note: text, date: "0")
//
//            self.transactions.append(note)
            
            
            guard let convertTextAmount = Double(amountText) else { return }
            self.save(withAmount: convertTextAmount, textNote: noteText)
            self.fullAmount = 0.0
            self.tableView.reloadData()
            self.collectionView?.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true)
        
    }
    
    private func setUpSearchBarLayout() {
        searchBar.searchBarStyle = .default
        searchBar.placeholder = "Search for note"
        searchBar.sizeToFit()
        searchBar.delegate = self
        
        tableView.tableHeaderView = searchBar
    }
    
    @objc func addButtonTapped() {
        showAlert()
    }
    
    func save(withAmount amount: Double, textNote note: String) {
        let context = coreDataStack.managedContext
        let transaction = Transaction(context: context)
        
        transaction.amount = amount
        transaction.createdAt = Date()
        transaction.note = note
//        guard let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: context) else { return }
//
//        let transaction = NSManagedObject(entity: entity, insertInto: context)
//
//        transaction.setValue(note, forKey: "note")
        fullAmount += amount
        calculateAmountLabel.text = "Amount \(fullAmount)"
        
        coreDataStack.save()
//        transactions.append(transaction)
    }
    
    func deleteTransaction(at indexPath: IndexPath) {
        let transaction = fetchedResultsController.object(at: indexPath)
//        let transaction = transactions[indexPath.row]
        let context = coreDataStack.managedContext
        
        fullAmount -= transaction.amount
        calculateAmountLabel.text = "Amount \(fullAmount)"
        
        context.delete(transaction)
        
        do {
//            transactions.remove(at: indexPath.row)
            try context.save()
        } catch {
            print("I can't save")
        }
        

    }
    
    func getItems() {
//        let context = coreDataStack.managedContext
//        let fetchRequest = Transaction.fetchRequest()
//
        
        do {
            try fetchedResultsController.performFetch()
            
        } catch {
            print("I can't fetch transactions")
        }
    }
    
    func getItems(for name: String) {
        
        var predicte: NSPredicate?
        
        if !name.isEmpty {
            predicte = NSPredicate(format: "note contains[c] '\(name)'")
        } else {
            predicte = nil
        }
        
        fetchedResultsController.fetchRequest.predicate = predicte
        
        do {
            try fetchedResultsController.performFetch()
            //                transactions = try context.fetch(fetchRequest)
        } catch {
            print("I can't fetch transactions")
        }
    }
    
    func getItemsWithDate() {
        print(#function)
        let name = "680"
        
        
        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let date1 = dateFormatter.date(from: "07/01/2022")
        let date2 = dateFormatter.date(from: "07/31/2022")


        var predicte: NSPredicate?
        
        if !name.isEmpty {
            predicte = NSPredicate(format: "createdAt >= %@ AND createdAt <= %@", date1! as NSDate, date2! as NSDate)
        } else {
            predicte = nil
        }
        
        fetchedResultsController.fetchRequest.predicate = predicte
        
        do {
            try fetchedResultsController.performFetch()
            //                transactions = try context.fetch(fetchRequest)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomCell else { return UITableViewCell() }
        
        calculateCellForCollectionView(indexPath: indexPath)
        
        let transaction = fetchedResultsController.object(at: indexPath)
        
        let fullFormatter = DateFormatter()
        let dayFormatter = DateFormatter()

//        fullFormatter.dateFormat = "EEEE dd LLLL"
        fullFormatter.dateFormat = "LLL yyyy, EEEE"

        dayFormatter.dateFormat = "dd"

        fullFormatter.locale = Locale(identifier: "en")
        dayFormatter.locale = Locale(identifier: "en")
        
        let date = fullFormatter.string(from: transaction.createdAt!)
        let day = dayFormatter.string(from: transaction.createdAt!)
        
//        cell.textLabel?.text = transaction.value(forKey: "note") as? String
//        cell.textLabel?.text = String(transaction.amount)
        
        cell.amountLabel.text = String(transaction.amount)
        cell.dateLabel.text = date
        cell.dayLabel.text = day
        cell.noteLabel.text = transaction.note
        
        fullAmount += transaction.amount
        calculateAmountLabel.text = "Amount \(fullAmount)"
//        navigationItem.title = "Amount \(fullAmount)"
//        self.amount += Double(transaction.note!)!
//        print(amount)
        
//        calculateAmount(at: indexPath)
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headreView = UIView()
//        headreView.backgroundColor = .clear
//
//        return headreView
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTransaction(at: indexPath)
//            transactionInfoViewController.deleteTransactionOBJC(at: indexPath)
//            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let transactionInfoViewController = TransactionInfoViewController(indexPath: indexPath)
        
        transactionInfoViewController.title = "Transaction Info"
        navigationController?.pushViewController(transactionInfoViewController, animated: true)
        
//        tableView.deselectRow(at: indexPath, animated: false)
//        let currentUser = items[indexPath.section][indexPath.row]
//        let infoViewController = UserInfoViewController(user: currentUser)
//        infoViewController.title = "Star War user info"
//        navigationController?.pushViewController(infoViewController, animated: true)
    }
    
}

//MARK: - UISearchBarDelegate

extension TransactionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getItems(for: searchText)
        fullAmount = 0.0
        tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        getItemsWithDate()
        fullAmount = 0.0
        tableView.reloadData()
    }
    
}

//MARK: - NSFetchedResultsControllerDelegate

extension TransactionViewController: NSFetchedResultsControllerDelegate {
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.reloadData()
//    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
        case .move:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .update:
            self.tableView.reloadRows(at: [indexPath!], with: .fade)
        @unknown default:
            break
        }
    }
    
    
    
}

extension TransactionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return fetchedResultsController.sections?.first?.numberOfObjects ?? 0
        return maounthSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
        
        let transaction = fetchedResultsController.object(at: indexPath)
        
        
        
        let item = mounthArray[indexPath.row]
        
//        let dateFormater = DateFormatter()
//
//        dateFormater.dateFormat = "MMMM"
//        dateFormater.locale = Locale(identifier: "En")
//
//        let date = dateFormater.string(from: transaction.createdAt!) //July
//
//        if self.maounthSet.insert(date).inserted == true {
//            return cell
//        }
        
        let mounth = item
        
        cell.textLabel.text = mounth
        
        return cell
    }
    
    
}

extension TransactionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 220, height: 40)
    }
    
    
}

//extension NSDate {
//
//    func startOfMonth() -> Date? {
//
//        let calendar = NSCalendar.current
//        let currentDateComponents = calendar.dateComponents([.month], from: self as Date)
//        let startOfMonth = calendar.date(from: currentDateComponents)
//
//        return startOfMonth
//    }
//
//    func dateByAddingMonths(monthsToAdd: Int) -> NSDate? {
//
//        let calendar = NSCalendar.current
//        let months = NSDateComponents()
//        months.month = monthsToAdd
//
//        return calendar.dateByAddingComponents(months, toDate: self, options: [])
//    }
//
//    func endOfMonth() -> NSDate? {
//
//        let calendar = NSCalendar.currentCalendar()
//        if let plusOneMonthDate = dateByAddingMonths(1) {
//            let plusOneMonthDateComponents = calendar.components([.Year, .Month], fromDate: plusOneMonthDate)
//
//            let endOfMonth = calendar.dateFromComponents(plusOneMonthDateComponents)?.dateByAddingTimeInterval(-1)
//
//            return endOfMonth
//        }
//    }
//}
