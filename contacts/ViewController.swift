import UIKit

class ViewController: UIViewController {
    private let tableView = UITableView()
    private let collectionView: UICollectionView
    private var data: [ContactSection] = []
    private var collapsedSections: Set<Int> = []
    private var isGridView = false
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        return layout
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        setupNavigationBar()
        setupData()
        setupTableView()
        setupCollectionView()
    }

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContact))
        
        let gridButton = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2"), style: .plain, target: self, action: #selector(toggleView))
        let listButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(toggleView))

        navigationItem.rightBarButtonItem = isGridView ? listButton : gridButton
    }

    @objc private func toggleView() {
        isGridView.toggle()
        
        let gridButton = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2"), style: .plain, target: self, action: #selector(toggleView))
        let listButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(toggleView))
        
        navigationItem.rightBarButtonItem = isGridView ? listButton : gridButton

        tableView.isHidden = isGridView
        collectionView.isHidden = !isGridView

        if isGridView {
            collectionView.reloadData()
        } else {
            tableView.reloadData()
        }
    }

    @objc private func addContact() {
           let alert = UIAlertController(title: "New Contact", message: "Enter name and phone number", preferredStyle: .alert)
           alert.addTextField { $0.placeholder = "Name" }
           alert.addTextField { $0.placeholder = "Phone Number"; $0.keyboardType = .phonePad }
   
           let addAction = UIAlertAction(title: "Add", style: .default) { _ in
               guard let name = alert.textFields?[0].text, !name.isEmpty,
                     let phone = alert.textFields?[1].text, !phone.isEmpty
               else {
                   self.showErrorPopup(message: "Both name and phone number are required.")
                   return
               }
               if self.checkValidation(name: name, phone: phone) {
                   self.insertContact(name: name, phone: phone)
               }
           }
   
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
   
           alert.addAction(addAction)
           alert.addAction(cancelAction)
           present(alert, animated: true)
       }
    
    private func setupData() {
        data.append(ContactSection(header: ContactHeaderModel(title: "A"), contacts: [Contact(name: "Ana", phoneNumber: "123456789")]))
        data.append(ContactSection(header: ContactHeaderModel(title: "B"), contacts: [Contact(name: "Bubuka", phoneNumber: "414141414"), Contact(name: "Bombora", phoneNumber: "123456788")]))
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.sectionHeaderTopPadding = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ContactCellForList.self, forCellReuseIdentifier: "ContactCellForList")
        tableView.register(ContactHeaderForList.self, forHeaderFooterViewReuseIdentifier: "ContactHeaderForList")
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = flowLayout
       collectionView.register(ContactCellForGrid.self, forCellWithReuseIdentifier: "ContactCellForGrid")
        collectionView.register(ContactHeaderForGrid.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ContactHeaderForGrid")
        collectionView.isHidden = true
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collapsedSections.contains(section) ? 0 : data[section].contacts.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCellForList", for: indexPath) as? ContactCellForList else {
            return UITableViewCell()
        }
        let contact = data[indexPath.section].contacts[indexPath.row]
        cell.configure(with: contact)
        return cell
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ContactHeaderForList") as? ContactHeaderForList else {
            return nil
        }
        header.configure(with: data[section].header, section: section, isCollapsed: collapsedSections.contains(section))
        header.delegate = self
        return header
    }
   
       func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           let delete = UIContextualAction(
               style: .destructive,
               title: "Delete",
               handler: { _, _, _ in
                   self.deleteContact(at: indexPath)
               }
           )
           return UISwipeActionsConfiguration(actions: [delete])
       }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collapsedSections.contains(section) ? 0 : data[section].contacts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactCellForGrid", for: indexPath) as? ContactCellForGrid else {
            return UICollectionViewCell()
        }
        let contact = data[indexPath.section].contacts[indexPath.row]
        cell.configure(with: contact)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ContactHeaderForGrid", for: indexPath) as? ContactHeaderForGrid else {
            return UICollectionReusableView()
        }
        header.configure(with: data[indexPath.section].header, section: indexPath.section, isCollapsed: collapsedSections.contains(indexPath.section))
        header.delegate = self

        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let contact = data[indexPath.section].contacts[indexPath.item]
        showDeleteConfirmation(for: contact, at: indexPath)
    }


}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
}


extension ViewController: ContactHeaderForListDelegate {
    func toggleSectionForList(_ header: ContactHeaderForList, section: Int) {
        if collapsedSections.contains(section) {
            collapsedSections.remove(section)
        } else {
            collapsedSections.insert(section)
        }
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}

extension ViewController: ContactHeaderForGridDelegate {
    func toggleSectionForGrid(_ header: ContactHeaderForGrid, section: Int) {
        if collapsedSections.contains(section) {
            collapsedSections.remove(section)
        } else {
            collapsedSections.insert(section)
        }
        collectionView.reloadSections(IndexSet(integer: section))
    }
}

extension ViewController {
    
    private func showDeleteConfirmation(for contact: Contact, at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Contact", message: "Are you sure you want to delete \(contact.name)?", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteContact(at: indexPath)
        }))

        present(alert, animated: true, completion: nil)
    }

    private func deleteContact(at indexPath: IndexPath) {
        if data[indexPath.section].contacts.count == 1 {
            data.remove(at: indexPath.section)
            collapsedSections.remove(indexPath.section)
            if(!isGridView){
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
            }else{
                collectionView.deleteSections(IndexSet(integer: indexPath.section))
            }
        } else {
            data[indexPath.section].contacts.remove(at: indexPath.row)
            if(!isGridView){
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }else{
                collectionView.deleteItems(at: [indexPath])
            }
        }
    }
}

extension ViewController{

    private func checkValidation(name: String, phone: String) -> Bool {
        let nameRegex = "^[a-zA-Z0-9]+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        if !namePredicate.evaluate(with: name) {
            showErrorPopup(message: "Name should contain only letters and numbers.")
            return false
        }

        let phoneRegex = "^[0-9]+$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        if !phonePredicate.evaluate(with: phone) {
            showErrorPopup(message: "Phone number should contain only numbers.")
            return false
        }
        return true

    }

    private func insertContact(name: String, phone: String) {
        let firstLetter = String(name.prefix(1)).uppercased()
        if let index = data.firstIndex(where: { $0.header.title == firstLetter }) {
            data[index].contacts.append(Contact(name: name, phoneNumber: phone))
            data[index].contacts.sort { $0.name < $1.name }
            if isGridView {
                collectionView.reloadData()
            }else{
                tableView.reloadData()
            }
                
        } else {
            let newSection = ContactSection(header: ContactHeaderModel(title: firstLetter), contacts: [Contact(name: name, phoneNumber: phone)])
            data.append(newSection)
            data.sort { $0.header.title < $1.header.title }
            if isGridView {
                collectionView.reloadData()
            }else{
                tableView.reloadData()
            }        }
    }

    private func showErrorPopup(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
