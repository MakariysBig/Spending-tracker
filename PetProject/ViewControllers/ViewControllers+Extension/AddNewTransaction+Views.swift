import UIKit

extension AddNewTransactionViewController {
    final class Views {
        
        //MARK: - Properties
        
        let contentView = UIView()
        let dateTextField = UITextField()
        let datePicker = UIDatePicker()
        let amountTextField = UITextField()
        let noteTextField = UITextField()
        let saveExpenseButton = UIButton()
        let saveIncomeButton = UIButton()
        
        //MARK: - Private Properties
        
        private let coverView = UIView()
        private let dateLabel = UILabel()
        private let amountLabel = UILabel()
        private let noteLabel = UILabel()
        
        //MARK: - Methods
        
        func loadViews(_ view: UIView) {
            setUpContentViewLayout(view)
            setUpCoverViewLayout()
            setUpExpenseAmountTextFieldLayout()
            setUpNoteTextFieldLayout()
            setUpNotetLabelLayout()
            seUpTextDatePickerLayout()
            setUpDatePickerLayout()
            setUpDateLabelLAyout()
            saveExpenseButtonLayout()
        }
        
        //MARK: - Methods
        
        func saveIncomeButtonLayout() {
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
        }
        
        func saveExpenseButtonLayout() {
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
        }
        
        //MARK: - Private methods
        
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
        
        private func setUpContentViewLayout(_ view: UIView) {
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
        
        private func setUpNoteTextFieldLayout() {
            coverView.addSubview(noteTextField)
            
            noteTextField.placeholder = "Enter note"
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
        
        private func setUpDatePickerLayout() {
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .inline
            let loc = Locale(identifier: "en")
            datePicker.locale = loc
        }
        
        private func setUpCoverViewLayout() {
            contentView.addSubview(coverView)
            
            coverView.backgroundColor = .white
            coverView.layer.cornerRadius = 20
            
            coverView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                coverView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                coverView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                coverView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                coverView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5)
            ])
        }
    }
}
