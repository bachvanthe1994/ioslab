//
//  ViewController.swift
//  lab04
//
//  Created by thebv on 10/10/2024.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tfGetBooksByAuthor: UITextField!
    @IBOutlet weak var tfGetAuthorsByBook: UITextField!
    @IBOutlet weak var lblDataType: UILabel!
    var datas: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        self.deleteData()
        self.saveData()
        self.btnGetBooksbyAuthorPressed()
    }
    
    func deleteData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        (try? context.fetch(Book.fetchRequest()))?.forEach({ obj in
            print("delete book: \(obj)")
            context.delete(obj)
        })
        (try? context.fetch(Author.fetchRequest()))?.forEach({ obj in
            print("delete author: \(obj)")
            context.delete(obj)
        })
        // Lưu vào Core Data
        do {
            try context.save()
            print("Data saved successfully")
        } catch {
            print("Failed to save data: \(error.localizedDescription)")
        }
    }
    
    func saveData() {
        let books = self.fetchBooks(by: "")
        if (books.count > 0) {
            //ignore
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

            // Tạo Author
            let author1 = Author(context: context)
            author1.name = "Author One"
            
            let author2 = Author(context: context)
            author2.name = "Author Two"
            
            // Tạo Book
            let book1 = Book(context: context)
            book1.title = "Book One"
            
            let book2 = Book(context: context)
            book2.title = "Book Two"
            
            let book3 = Book(context: context)
            book3.title = "Book Three"
            
            book1.addToAuthors([author1, author2])
            book2.addToAuthors([author1, author2])
            book3.addToAuthors([author1])
            
            author1.addToBooks([book1, book2, book3])
            author2.addToBooks([book1, book2])
            
            // Lưu vào Core Data
            do {
                try context.save()
                print("Data saved successfully")
            } catch {
                print("Failed to save data: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchBooks(by authorName: String) -> [String] {
        print("------------")
        var result: [String] = []
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        
        // Thiết lập bộ lọc để tìm sách của tác giả cụ thể
        if (authorName.trimmingCharacters(in: .whitespaces).count > 0) {
            fetchRequest.predicate = NSPredicate(format: "ANY authors.name LIKE[cd] %@", "*\(authorName)*")
        }
        
        do {
            let books = try context.fetch(fetchRequest)
            for book in books {
                print("Book: \(book.title ?? "Unknown")")
                var strAuthors = ""
                if let authors = book.authors as? Set<Author> {
                    for author in authors {
                        print("Author: \(author.name ?? "Unknown")")
                        strAuthors += "\(author.name ?? "Unknown"), "
                    }
                }
                result.append("book.title: \(book.title ?? ""), authors: \(strAuthors)")
            }
        } catch {
            print("Failed to fetch books: \(error.localizedDescription)")
        }
        return result
    }
    
    func fetchAuthors(by bookTitle: String) -> [String] {
        print("------------")
        var result: [String] = []
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Author> = Author.fetchRequest()
        
        // Thiết lập bộ lọc để tìm tác giả của một cuốn sách cụ thể
        if (bookTitle.trimmingCharacters(in: .whitespaces).count > 0) {
            fetchRequest.predicate = NSPredicate(format: "ANY books.title LIKE[cd] %@", "*\(bookTitle)*")
        }
        
        do {
            let authors = try context.fetch(fetchRequest)
            for author in authors {
                print("Author: \(author.name ?? "Unknown")")
                var strBooks = ""
                if let books = author.books as? Set<Book> {
                    for book in books {
                        print("Book: \(book.title ?? "Unknown")")
                        strBooks += "\(book.title ?? "Unknown"), "
                    }
                }
                result.append("author.title: \(author.name ?? ""), books: \(strBooks)")
            }
        } catch {
            print("Failed to fetch authors: \(error.localizedDescription)")
        }
        
        return result
    }

    @IBAction func btnGetBooksbyAuthorPressed(_ sender: Any? = nil) {
        self.lblDataType.text = "Data type: GetBooksByAuthor"
        let str = self.tfGetBooksByAuthor.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.datas = self.fetchBooks(by: str)
        self.tableView.reloadData()
    }
    
    @IBAction func btnGetAuthorbyBooksPressed(_ sender: Any? = nil) {
        self.lblDataType.text = "Data type: GetAuthorsByBook"
        let str = self.tfGetAuthorsByBook.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.datas = self.fetchAuthors(by: str)
        self.tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let str = "\(indexPath.row) - \(self.datas[indexPath.row])"
        if #available(iOS 14.0, *) {
            // Sử dụng UIListContentConfiguration cho iOS 14 trở lên
            var content = cell.defaultContentConfiguration()
            content.text = str
            cell.contentConfiguration = content
        } else {
            // Sử dụng các phương pháp cũ cho iOS 13 trở xuống
            cell.textLabel?.text = str
        }
        return cell
    }
}

