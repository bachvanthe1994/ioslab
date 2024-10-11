//
//  ViewController.swift
//  lab03
//
//  Created by thebv on 09/10/2024.
//

import UIKit
import SDWebImage

class TopAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var imageSizeMapping: [Int:CGSize] = [:]
    var numberOfItems = 0
    var minHeightOfItem: CGFloat = 0
    var minWidthOfItem: CGFloat = 0
    var cache: [Int:UICollectionViewLayoutAttributes] = [:]
    
    var contentHeight = 0
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: Int(UIScreen.main.bounds.width) - 20*2, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes: [UICollectionViewLayoutAttributes]? = super.layoutAttributesForElements(in: .init(origin: rect.origin, size: .init(width: rect.width, height: rect.height)))
        var leftY: CGFloat = 0
        var rightY: CGFloat = 0
        var arr: [UICollectionViewLayoutAttributes] = []
        for index in 0..<self.numberOfItems {
            var layoutAttribute: UICollectionViewLayoutAttributes? = attributes?.first(where: { a in
                return a.indexPath.row == index
            })
            if layoutAttribute == nil {
                let indexPath = IndexPath(item: index, section: 0)
                layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            }
            if var newSize = self.imageSizeMapping[index] {
                let newFrameHeight = newSize.height > 0 ? newSize.height : self.minHeightOfItem
                if (index % 2 == 0) {
                    let newFrame: CGRect = .init(origin: .init(x: 0, y: leftY), size: newSize)
                    layoutAttribute?.frame = newFrame
                    leftY += newFrameHeight + self.minimumLineSpacing
                } else {
                    let newFrame: CGRect = .init(origin: .init(x: self.minWidthOfItem + self.minimumInteritemSpacing, y: rightY), size: newSize)
                    layoutAttribute?.frame = newFrame
                    rightY += newFrameHeight + self.minimumLineSpacing
                }
            }
            if let layoutAttribute = layoutAttribute {
                self.cache[index] = layoutAttribute
            }
            if let att = self.cache[index] {
                arr.append(att)
            }
        }
        
        if (arr.count == self.numberOfItems) {
            contentHeight = Int(max(leftY, rightY))
            print("arr.count == self.numberOfItems")
        } else {
            contentHeight = Int(max(leftY, rightY) + 10000)
        }
        
        return arr
    }
}


class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let layout: TopAlignedCollectionViewFlowLayout = TopAlignedCollectionViewFlowLayout()
    var items = [
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-1.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-2.jpg",
        "https://innovavietnam.vn/wp-content/uploads/poster-561x800.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-3.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-4.jpg",
        "https://m.media-amazon.com/images/I/71xefrbhS8S._AC_SL1500_.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-5.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-6.jpg",
        "https://www.searchenginejournal.com/wp-content/uploads/2019/07/the-essential-guide-to-using-images-legally-online.png",
        "https://cdn.pixabay.com/photo/2021/11/14/18/36/telework-6795505_640.jpg",
        "https://instructor-academy.onlinecoursehost.com/content/images/2023/05/How-to-Create-an-Online-Course-For-Free--Complete-Guide--6.jpg",
        "https://innovavietnam.vn/wp-content/uploads/poster-561x800.jpg",
        "https://m.media-amazon.com/images/I/71xefrbhS8S._AC_SL1500_.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBv-Q87fv4sVPYmkuDyzvSYns_mmahT3lqrA&s",
        "https://www.online-image-editor.com/styles/2019/images/power_girl.png",
        "https://watermark.lovepik.com/photo/40008/0007.jpg_wh1200.jpg",
        "https://elearningindustry.com/wp-content/uploads/2020/10/advantages-and-disadvantages-of-online-learning.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-1.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-2.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-3.jpg",
        "https://m.media-amazon.com/images/I/71xefrbhS8S._AC_SL1500_.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-4.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-5.jpg",
        "https://innovavietnam.vn/wp-content/uploads/poster-561x800.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-6.jpg",
        "https://www.searchenginejournal.com/wp-content/uploads/2019/07/the-essential-guide-to-using-images-legally-online.png",
        "https://cdn.pixabay.com/photo/2021/11/14/18/36/telework-6795505_640.jpg",
        "https://instructor-academy.onlinecoursehost.com/content/images/2023/05/How-to-Create-an-Online-Course-For-Free--Complete-Guide--6.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBv-Q87fv4sVPYmkuDyzvSYns_mmahT3lqrA&s",
        "https://www.online-image-editor.com/styles/2019/images/power_girl.png",
        "https://watermark.lovepik.com/photo/40008/0007.jpg_wh1200.jpg",
        "https://m.media-amazon.com/images/I/71xefrbhS8S._AC_SL1500_.jpg",
        "https://elearningindustry.com/wp-content/uploads/2020/10/advantages-and-disadvantages-of-online-learning.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-1.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-2.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-3.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-4.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-5.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-6.jpg",
        "https://www.searchenginejournal.com/wp-content/uploads/2019/07/the-essential-guide-to-using-images-legally-online.png",
        "https://cdn.pixabay.com/photo/2021/11/14/18/36/telework-6795505_640.jpg",
        "https://instructor-academy.onlinecoursehost.com/content/images/2023/05/How-to-Create-an-Online-Course-For-Free--Complete-Guide--6.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBv-Q87fv4sVPYmkuDyzvSYns_mmahT3lqrA&s",
        "https://www.online-image-editor.com/styles/2019/images/power_girl.png",
        "https://m.media-amazon.com/images/I/71xefrbhS8S._AC_SL1500_.jpg",
        "https://innovavietnam.vn/wp-content/uploads/poster-561x800.jpg",
        "https://watermark.lovepik.com/photo/40008/0007.jpg_wh1200.jpg",
        "https://elearningindustry.com/wp-content/uploads/2020/10/advantages-and-disadvantages-of-online-learning.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-1.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-2.jpg",
        "https://innovavietnam.vn/wp-content/uploads/poster-561x800.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-3.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-4.jpg",
        "https://m.media-amazon.com/images/I/71xefrbhS8S._AC_SL1500_.jpg",
        "https://innovavietnam.vn/wp-content/uploads/poster-561x800.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-5.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-6.jpg",
        "https://www.searchenginejournal.com/wp-content/uploads/2019/07/the-essential-guide-to-using-images-legally-online.png",
        "https://cdn.pixabay.com/photo/2021/11/14/18/36/telework-6795505_640.jpg",
        "https://instructor-academy.onlinecoursehost.com/content/images/2023/05/How-to-Create-an-Online-Course-For-Free--Complete-Guide--6.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBv-Q87fv4sVPYmkuDyzvSYns_mmahT3lqrA&s",
        "https://www.online-image-editor.com/styles/2019/images/power_girl.png",
        "https://watermark.lovepik.com/photo/40008/0007.jpg_wh1200.jpg",
        "https://elearningindustry.com/wp-content/uploads/2020/10/advantages-and-disadvantages-of-online-learning.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-1.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-2.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-3.jpg",
        "https://m.media-amazon.com/images/I/71xefrbhS8S._AC_SL1500_.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-4.jpg",
        "https://innovavietnam.vn/wp-content/uploads/poster-561x800.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-5.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-6.jpg",
        "https://www.searchenginejournal.com/wp-content/uploads/2019/07/the-essential-guide-to-using-images-legally-online.png",
        "https://cdn.pixabay.com/photo/2021/11/14/18/36/telework-6795505_640.jpg",
        "https://instructor-academy.onlinecoursehost.com/content/images/2023/05/How-to-Create-an-Online-Course-For-Free--Complete-Guide--6.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBv-Q87fv4sVPYmkuDyzvSYns_mmahT3lqrA&s",
        "https://www.online-image-editor.com/styles/2019/images/power_girl.png",
        "https://watermark.lovepik.com/photo/40008/0007.jpg_wh1200.jpg",
        "https://elearningindustry.com/wp-content/uploads/2020/10/advantages-and-disadvantages-of-online-learning.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-1.jpg",
        "https://m.media-amazon.com/images/I/71xefrbhS8S._AC_SL1500_.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-2.jpg",
        "https://innovavietnam.vn/wp-content/uploads/poster-561x800.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-3.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-4.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-5.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-6.jpg",
        "https://www.searchenginejournal.com/wp-content/uploads/2019/07/the-essential-guide-to-using-images-legally-online.png",
        "https://cdn.pixabay.com/photo/2021/11/14/18/36/telework-6795505_640.jpg",
        "https://instructor-academy.onlinecoursehost.com/content/images/2023/05/How-to-Create-an-Online-Course-For-Free--Complete-Guide--6.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBv-Q87fv4sVPYmkuDyzvSYns_mmahT3lqrA&s",
        "https://www.online-image-editor.com/styles/2019/images/power_girl.png",
        "https://watermark.lovepik.com/photo/40008/0007.jpg_wh1200.jpg",
        "https://elearningindustry.com/wp-content/uploads/2020/10/advantages-and-disadvantages-of-online-learning.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-1.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-2.jpg",
        "https://innovavietnam.vn/wp-content/uploads/poster-561x800.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-3.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-4.jpg",
        "https://m.media-amazon.com/images/I/71xefrbhS8S._AC_SL1500_.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-5.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-6.jpg",
        "https://www.searchenginejournal.com/wp-content/uploads/2019/07/the-essential-guide-to-using-images-legally-online.png",
        "https://cdn.pixabay.com/photo/2021/11/14/18/36/telework-6795505_640.jpg",
        "https://innovavietnam.vn/wp-content/uploads/poster-561x800.jpg",
        "https://instructor-academy.onlinecoursehost.com/content/images/2023/05/How-to-Create-an-Online-Course-For-Free--Complete-Guide--6.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBv-Q87fv4sVPYmkuDyzvSYns_mmahT3lqrA&s",
        "https://www.online-image-editor.com/styles/2019/images/power_girl.png",
        "https://watermark.lovepik.com/photo/40008/0007.jpg_wh1200.jpg",
        "https://innovavietnam.vn/wp-content/uploads/poster-561x800.jpg",
        "https://innovavietnam.vn/wp-content/uploads/poster-561x800.jpg",
        "https://elearningindustry.com/wp-content/uploads/2020/10/advantages-and-disadvantages-of-online-learning.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-1.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-2.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-3.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-4.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-5.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-6.jpg",
        "https://www.searchenginejournal.com/wp-content/uploads/2019/07/the-essential-guide-to-using-images-legally-online.png",
        "https://cdn.pixabay.com/photo/2021/11/14/18/36/telework-6795505_640.jpg",
        "https://instructor-academy.onlinecoursehost.com/content/images/2023/05/How-to-Create-an-Online-Course-For-Free--Complete-Guide--6.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBv-Q87fv4sVPYmkuDyzvSYns_mmahT3lqrA&s",
        "https://www.online-image-editor.com/styles/2019/images/power_girl.png",
        "https://watermark.lovepik.com/photo/40008/0007.jpg_wh1200.jpg",
        "https://elearningindustry.com/wp-content/uploads/2020/10/advantages-and-disadvantages-of-online-learning.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-1.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-2.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-3.jpg",
        "https://m.media-amazon.com/images/I/71xefrbhS8S._AC_SL1500_.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-4.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-5.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-6.jpg",
        "https://www.searchenginejournal.com/wp-content/uploads/2019/07/the-essential-guide-to-using-images-legally-online.png",
        "https://cdn.pixabay.com/photo/2021/11/14/18/36/telework-6795505_640.jpg",
        "https://instructor-academy.onlinecoursehost.com/content/images/2023/05/How-to-Create-an-Online-Course-For-Free--Complete-Guide--6.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBv-Q87fv4sVPYmkuDyzvSYns_mmahT3lqrA&s",
        "https://www.online-image-editor.com/styles/2019/images/power_girl.png",
        "https://watermark.lovepik.com/photo/40008/0007.jpg_wh1200.jpg",
        "https://elearningindustry.com/wp-content/uploads/2020/10/advantages-and-disadvantages-of-online-learning.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-1.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-2.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-3.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-4.jpg",
        "https://innovavietnam.vn/wp-content/uploads/poster-561x800.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-5.jpg",
        "https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-6.jpg",
        "https://www.searchenginejournal.com/wp-content/uploads/2019/07/the-essential-guide-to-using-images-legally-online.png",
        "https://cdn.pixabay.com/photo/2021/11/14/18/36/telework-6795505_640.jpg",
        "https://m.media-amazon.com/images/I/71xefrbhS8S._AC_SL1500_.jpg",
        "https://innovavietnam.vn/wp-content/uploads/poster-561x800.jpg",
        "https://instructor-academy.onlinecoursehost.com/content/images/2023/05/How-to-Create-an-Online-Course-For-Free--Complete-Guide--6.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBv-Q87fv4sVPYmkuDyzvSYns_mmahT3lqrA&s",
        "https://www.online-image-editor.com/styles/2019/images/power_girl.png",
        "https://watermark.lovepik.com/photo/40008/0007.jpg_wh1200.jpg",
        "https://elearningindustry.com/wp-content/uploads/2020/10/advantages-and-disadvantages-of-online-learning.jpg",
    ]
    var imageSizeMapping: [Int:CGSize] = [:]
    var screenWidth: CGFloat = UIScreen.main.bounds.width
    var itemSize: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    func initView() {
        print("items: \(self.items.count)")
        self.itemSize = (screenWidth - 20*2 - 5)/2
//        self.layout.delegate = self
//        self.layout.numberOfColumns = 2
        self.layout.minHeightOfItem = self.itemSize
        self.layout.minWidthOfItem = self.itemSize
        self.layout.scrollDirection = .vertical
        self.layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.layout.itemSize = CGSize(width: itemSize, height: itemSize)
        self.layout.minimumInteritemSpacing = 5
        self.layout.minimumLineSpacing = 5
        self.layout.numberOfItems = self.items.count
        self.collectionView.decelerationRate = .fast
        self.collectionView.collectionViewLayout = layout
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "MyCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "MyCollectionViewCell")
        self.collectionView.reloadData()
    }


}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        self.collectionView.reloadData()
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        self.collectionView.reloadData()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as? MyCollectionViewCell
        if let cell = cell {
            cell.layer.borderColor = UIColor.green.cgColor
            cell.layer.borderWidth = 1
            let urlString = self.items[indexPath.row]
            cell.lbl.text = "\(indexPath.row)"
            cell.lbl.backgroundColor = .white
            cell.lbl.textColor = .black
            cell.iv.sd_setImage(with: .init(string: urlString)) { [weak self] img, error, tupe, url in
                guard let self = self else { return }
                if let img = img {
                    if (self.imageSizeMapping[indexPath.row] == nil) {
                        let w = min(img.size.width, self.itemSize)
                        let h = img.size.height * self.itemSize / img.size.width
                        self.imageSizeMapping[indexPath.row] = .init(width: w, height: h)
                        self.layout.imageSizeMapping = self.imageSizeMapping
                        self.collectionView.reloadData()
                    }
                }
            }
            return cell
        } else {
            print("ERROR: cell: MyCollectionViewCell nil pls recheck")
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let urlString = self.items[indexPath.row]
        if let size = self.imageSizeMapping[indexPath.row] {
            return size
        } else {
            return .init(width: itemSize, height: itemSize)
        }
    }
}

