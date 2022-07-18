//
//  ViewController.swift
//  UsecaseDemo
//
//  Created by Ramel Rana on 14/07/22.
//

import UIKit

struct DataModel {
    var title: String
    let description: String
    var detail: String

}

class CollectionViewCell: UICollectionViewCell{
    @IBOutlet var titleLbl : UILabel!
    @IBOutlet var detailLbl : UILabel!
    @IBOutlet var descriptionLbl : UILabel!
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    

    var dataList = [DataModel]()
    @IBOutlet var collectionView : UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = .systemGreen
        navigationItem.title = "Demo"

        loadSampleData()
        intializeCollectionView()
        
    }
    
    
    func loadSampleData() {
        
        dataList.append(DataModel(title: "Cell 1", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", detail: "Lorem Ipsum is simply dummy text of the printing and typesetting industry."))
        dataList.append(DataModel(title: "Cell 2", description: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).", detail: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English."))
        dataList.append(DataModel(title: "Cell 3", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", detail: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."))
    }
    
    func intializeCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        let layout = CollectionFlowLayout()
        //Get device width
        let width = UIScreen.main.bounds.width
        //set section inset as per your requirement.
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        //set cell item size here
        layout.itemSize = CGSize(width: width / 2, height: width / 2)
        //set Minimum spacing between 2 items
        layout.minimumInteritemSpacing = 5
        //set minimum vertical line spacing here between two lines in collectionview
        layout.minimumLineSpacing = 5
        
        layout.estimatedItemSize = .zero
        //apply defined layout to collectionview
        collectionView!.collectionViewLayout = layout
        // Do any additional setup after loading the view.
        
      

        self.collectionView?.setCollectionViewLayout(layout,
                    animated: true)

        let pinchRecognizer = UIPinchGestureRecognizer(target: self,
                            action: #selector(handlePinch))
        self.collectionView?.addGestureRecognizer(pinchRecognizer)

    }
    
    @objc func handlePinch(gesture: UIPinchGestureRecognizer) {
        let layout = self.collectionView?.collectionViewLayout
            as! CollectionFlowLayout
        if gesture.state == UIGestureRecognizer.State.began
        {
            // Get the initial location of the pinch?
            let initialPinchPoint =
                gesture.location(in: self.collectionView)
            // Convert pinch location into a specific cell
            if let pinchedCellPath =
                self.collectionView?.indexPathForItem(at: initialPinchPoint) {
            // Store the indexPath to cell
                layout.currentCellPath = pinchedCellPath as NSIndexPath
            }
        }
        else if gesture.state == UIGestureRecognizer.State.changed
        {
            // Store the new center location of the selected cell
            layout.currentCellCenter =
                gesture.location(in: self.collectionView)
            // Store the scale value
            layout.setCurrentCellScale(scale: gesture.scale)
        }
        else
        {
            self.collectionView?.performBatchUpdates({
                layout.currentCellPath = nil
                layout.currentCellScale = 1.0}, completion:nil)
        }
    }
    
    // MARK: Collectionview Delegate methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        cell.titleLbl.text = dataList[indexPath.item].title
        cell.detailLbl.text = dataList[indexPath.item].detail
        cell.descriptionLbl.text = dataList[indexPath.item].description
        return cell
    }
    
}


extension ViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            var nameHeight: CGFloat = 0
            var popHeight: CGFloat = 0
            var desHeight: CGFloat = 0
            let padding: CGFloat = 1
            //estimate each cell's height
            nameHeight = estimateFrameForText(text: dataList[indexPath.item].title).height + padding
            popHeight = estimateFrameForText(text: dataList[indexPath.item].detail).height + padding
            desHeight = estimateFrameForText(text: dataList[indexPath.item].description).height + padding
      
            return CGSize(width: self.view.frame.width-20, height: max(nameHeight, popHeight, desHeight))
    }
   func estimateFrameForText(text: String) -> CGRect {
        //we make the height arbitrarily large so we don't undershoot height in calculation
        let height: CGFloat = 0

        let size = CGSize(width: (self.view.frame.width-20)/3, height: height)
       let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
       let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)]

       return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
  
}

