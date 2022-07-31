import UIKit
import CoreData

class TransactionViewController: UIViewController {
    
    //MARK: - Properties
    
    var amountTextField: UITextField?
    let yourBalanceLabel = UILabel()
    var transactions: [Transaction] = []
    
    var yourBalance = 1000.0
    var endingBalance = 0.0
    
    var collectionView: UICollectionView?

    
//    let addNewTransactionViewController = AddNewTransactionViewController()
    
    let coreDataStack = CoreDataStack()
    
    let tableView = UITableView()
    let searchBar = UISearchBar()
    
    var fullAmount = 0.0
    var maounthSet: Set<String> = []
    var monthArray: [String] = []
    
    let plusButton = UIButton()
    
    let calculateAmountLabel = UILabel()
    
    
    
    lazy var fetchedResultsController: NSFetchedResultsController<Transaction> = {
        
        let fetchRequest = Transaction.fetchRequest()
        let context = coreDataStack.managedContext
        
        
        let sort = NSSortDescriptor(key: #keyPath(Transaction.createdAt), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        
        return fetchedResultsController
    }()
    
    lazy var fetchedResultsControllerProfit: NSFetchedResultsController<Profit> = {
        
        let fetchRequest = Profit.fetchRequest()
        let context = coreDataStack.managedContext
        
        
//        let sort = NSSortDescriptor(key: #keyPath(Profit.createdAt), ascending: false)
//        fetchRequest.sortDescriptors = [sort]
        
        
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        
        return fetchedResultsController
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.collectionView = setUpCollectionViewLayout()
        
        setUpTableViewLayout()
        configureTableView()
        setUpNavigationBarLayout()
        getItems()
       
        setUpSearchBarLayout()
        setUpCalculateAmountLayout()
        setUpYourBalanceLayout()
        fetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        getItems()
//        getItemsForReloadTable()
        
    }
    //MARK: - Private Methods
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.endEditing(true)
//    }
    
    private func getItemsForReloadTable() {
        
        let name = ""
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
    
    func calculateSomthing() -> [Transaction]? {
        let context = coreDataStack.managedContext
        let transaction = Transaction(context: context)
        
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        do {
            let array = try context.fetch(fetchRequest) as [Transaction]
            return array
        } catch let error {
            print("error \(error)")
        }
        
        return nil
        
    }
    
    private func calculateCellForCollectionView(indexPath: IndexPath) {
        let transaction = fetchedResultsController.object(at: indexPath)
        
        let dateFormater = DateFormatter()
        
        dateFormater.dateFormat = "MMMM"
        dateFormater.locale = Locale(identifier: "En")
        
        let date = dateFormater.string(from: transaction.createdAt!) //July
        
        if self.maounthSet.insert(date).inserted == true {
            maounthSet.insert(date)
            monthArray.append(date)
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
        viewColl.backgroundColor = .white
        viewColl.delegate = self
        viewColl.dataSource = self
        
        viewColl.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        viewColl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewColl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewColl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewColl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewColl.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        return viewColl
    }
    
    private func setUpYourBalanceLayout() {
        view.addSubview(yourBalanceLabel)
        yourBalanceLabel.text = "Your balance: \(yourBalance)"
        yourBalanceLabel.textColor = .black
        yourBalanceLabel.backgroundColor = .white
        
        yourBalanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            yourBalanceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            yourBalanceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            yourBalanceLabel.bottomAnchor.constraint(equalTo: calculateAmountLabel.topAnchor, constant: 10),
            yourBalanceLabel.heightAnchor.constraint(equalToConstant: 40)

        ])
    }
    
    private func setUpCalculateAmountLayout() {
        view.addSubview(calculateAmountLabel)
        calculateAmountLabel.text = "Spent: \(fullAmount)"
        calculateAmountLabel.textColor = .black
        calculateAmountLabel.backgroundColor = .white
        
        calculateAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calculateAmountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calculateAmountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calculateAmountLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calculateAmountLabel.heightAnchor.constraint(equalToConstant: 40)

        ])
    }
    
    private func setUpTableViewLayout() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: collectionView!.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureTableView() {
        tableView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setUpNavigationBarLayout() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.red]
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .done, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .red
        
        navigationController?.navigationBar.tintColor = .red
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setUpAmountTextField(textField: UITextField) {
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

        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let amountTextField = alert.textFields?.first,
                  let amountText = amountTextField.text, !amountText.isEmpty else { return }
            
            guard let noteTextField = alert.textFields?.last else { return }
            let noteText = noteTextField.text ?? ""

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
    
    private func save(withAmount amount: Double, textNote note: String) {
        let context = coreDataStack.managedContext
        let transaction = Transaction(context: context)
        
        transaction.amount = amount
        transaction.createdAt = Date()
        transaction.note = note

        fullAmount += amount
        calculateAmountLabel.text = "Amount \(fullAmount)"
        
        coreDataStack.save()
    }
    
    private func deleteTransaction(at indexPath: IndexPath) {
        let transaction = fetchedResultsController.object(at: indexPath)
//        let transaction = transactions[indexPath.row]
        let context = coreDataStack.managedContext
        
        fullAmount -= transaction.amount
        yourBalance += transaction.amount
        calculateAmountLabel.text = "Spent in this month: \(fullAmount)"
        yourBalanceLabel.text = "Your balance: \(yourBalance)"
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
    
    private func getItemsByMonth(indexPath: IndexPath) {
        let name = "f"
        let reversedMonhtArray: [String] = Array(monthArray.reversed())
        let month = reversedMonhtArray[indexPath.row]
        
//        let month = monthArray[indexPath.row]

        let dateFormatterrr = DateFormatter()
        dateFormatterrr.locale = Locale(identifier: "en")
        dateFormatterrr.dateFormat = "MMMM"

        let monthDate = dateFormatterrr.date(from: month)

        func startOfMonth() -> Date? {
            var comp: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Calendar.current.startOfDay(for: monthDate!))
            comp.day! += 1
            comp.year = 2022
                return Calendar.current.date(from: comp)!
        }

        func endOfMonth() -> Date? {
            var comp: DateComponents = Calendar.current.dateComponents([.year, .month , .day], from: Calendar.current.startOfDay(for: monthDate!))
            comp.month! += 1
            comp.year = 2022
                return Calendar.current.date(from: comp)!
        }

        let firstDay = startOfMonth()
        let lastDay = endOfMonth()
        
        let dateFormatterToString = DateFormatter()
        dateFormatterToString.dateFormat = "MM/dd/yyyy"

        var predicte: NSPredicate?
        
        if !name.isEmpty {
            predicte = NSPredicate(format: "createdAt >= %@ AND createdAt <= %@", firstDay! as NSDate, lastDay! as NSDate)
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
        
        if transaction.amount == 0.0 {
            cell.amountLabel.text = String(transaction.income)
            cell.amountLabel.textColor = .green
        } else {
            cell.amountLabel.text = String(transaction.amount)
        }
        
//        cell.amountLabel.text = String(transaction.amount)
        cell.dateLabel.text = date
        cell.dayLabel.text = day
        cell.noteLabel.text = transaction.note
        
        yourBalance -= transaction.amount
        fullAmount += transaction.amount
        
        print("\(yourBalance)- your Balance")
        print("\(fullAmount)- fullAmount")
        
        yourBalanceLabel.text = "Your balance: \(yourBalance)"
        calculateAmountLabel.text = "Spent in this month: \(fullAmount)"

        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = nil
        searchBar.showsCancelButton = false
        tableView.reloadData()
        getItems()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTransaction(at: indexPath)

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let transactionInfoViewController = TransactionInfoViewController(indexPath: indexPath)
        
        transactionInfoViewController.title = "Transaction Info"
        navigationController?.pushViewController(transactionInfoViewController, animated: true)
        

    }
    
}

//MARK: - UISearchBarDelegate

extension TransactionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getItems(for: searchText)
        fullAmount = 0.0
        yourBalance = 1000
        tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        getItemsByMonth(indexPath: indexPath)
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

//MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension TransactionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maounthSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
        
        let reversedMonhtArray: [String] = Array(monthArray.reversed())
             
        let month = reversedMonhtArray[indexPath.row]

        let dateFormatterrr = DateFormatter()
        dateFormatterrr.locale = Locale(identifier: "en")
        dateFormatterrr.dateFormat = "MMMM"

        let monthDate = dateFormatterrr.date(from: month)

        func startOfMonth() -> Date? {
            var comp: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Calendar.current.startOfDay(for: monthDate!))
            comp.year = 2022
                return Calendar.current.date(from: comp)!
        }

        func endOfMonth() -> Date? {
            var comp: DateComponents = Calendar.current.dateComponents([.year, .month , .day], from: Calendar.current.startOfDay(for: monthDate!))
            comp.month! += 1
            comp.day = 0
            comp.year = 2022
                return Calendar.current.date(from: comp)!
        }

        let firstDay = startOfMonth()
        let lastDay = endOfMonth()
        
        let dateFormatterrrr = DateFormatter()
        dateFormatterrrr.locale = Locale(identifier: "en")
        dateFormatterrrr.dateFormat = "dd/MM/yyyy"

        let firstD = dateFormatterrrr.string(from: firstDay!)
        let lastD = dateFormatterrrr.string(from: lastDay!)

        
        cell.textLabel.text = "\(firstD) - \(lastD)"

        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension TransactionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 220, height: 40)
    }
}


