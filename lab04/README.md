Core Data Relationships and Fetching<br/>
◦ Tạo hai thực thể (entities) "Book" và "Author" với mối quan hệ nhiều-nhiều.<br/>
◦ Tạo các fetch request phức tạp để truy vấn và hiển thị sách theo tác giả và ngược lại.<br/>
<br>
App iOS, min ios 13<br/>
Chọn lại Team để run dự án<br/>
Có thể chạy trên máy ảo iPhone 13 pro<br/>
Sample tìm kiếm theo tên, lowercase, tồn tại chuỗi tìm kiếm<br/>
<br>
```swift
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
```
<br>
<br>
1 vài ảnh của dự án<br>
<br>
<img src="https://github.com/user-attachments/assets/abb93cc5-205f-4f8f-9d04-8175f507760f" width="200" />
<img src="https://github.com/user-attachments/assets/15b78656-7e98-4a66-af33-800167cf0f61" width="200" />
<img src="https://github.com/user-attachments/assets/92d8919a-1599-4988-ab4e-0ea43ec00f05" width="200" />
