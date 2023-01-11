//
//  File.swift
//  flavrRecipes
//
//  Created by apple on 28.08.2022.
//

import UIKit
import Photos

class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var images = [UIImage]()
//    let picker = UIImagePickerController()
    var selectedImage : UIImage?
    var assets = [PHAsset]()
    var header: PhotoSelectorHeader?

    override func viewDidLoad() {
        super.viewDidLoad()
//        picker.delegate = self
        collectionView.backgroundColor = .white
        settingNavBar()
        collectionView.register(PhotoSelectorCollectionCell.self, forCellWithReuseIdentifier: "CellId")
        collectionView.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        fetchPhotos()
        fetchPhotosTest()
    }

    
 
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! PhotoSelectorCollectionCell
        cell.currentPhoto.image = images[indexPath.item]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = images[indexPath.item]
        print(selectedImage)
        DispatchQueue.main.async {
            self.selectedImage = selectedImage
            self.collectionView.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (view.frame.width - 5) / 4
        return .init(width: side, height: side)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 1, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! PhotoSelectorHeader

        header.mainPhotoImage.image = selectedImage
        if let selectedImage = selectedImage {
            if let index = self.images.firstIndex(of: selectedImage) {
                let selectedAsset = self.assets[index]

                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil, resultHandler: { (image, info) in
                    
                    header.mainPhotoImage.image = image
                    
                })

            }
        }
        self.header = header
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width)
    }
    fileprivate func fetchPhotosTest() {

        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 10

        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
       
        allPhotos.enumerateObjects({ (asset, count, stop) in
            print(asset)
            let imageManager = PHImageManager.default()
            let targetSize = CGSize(width: 350, height: 350)
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: nil, resultHandler: { (image, info) in
                
                print(image)

                
            })
            
        })
    }
    fileprivate func fetchPhotos(){
        print("Fetch Photo")
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 10
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        allPhotos.enumerateObjects { asset, count, stop in
            print(asset)
            let imageManager = PHImageManager.default()
            let targetSize = CGSize(width: 200, height: 200)
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { image, info in
                if let image = image {
                self.images.append(image)
                self.assets.append(asset)
                    if self.selectedImage == nil {
                        self.selectedImage = image
                    }
                }
                if count == self.images.count - 1 {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
                
            }
        }
    }
    fileprivate func settingNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
        navigationController?.navigationBar.tintColor = .black
    }
    @objc private func handleDismiss() {
      
        dismiss(animated: true)
    }
    @objc private func handleNext() {
        let sharedPhotoController = SharedPhotoController()
        guard let image = header?.mainPhotoImage.image else { return }
        sharedPhotoController.seledtedImage = image
        navigationController?.pushViewController(sharedPhotoController, animated: true)
    }
}





//extension PhotoSelectorController:  UIImagePickerControllerDelegate,
//                                    UINavigationControllerDelegate  {
//     func imagePickerController(_ picker: UIImagePickerController,
//        didFinishPickingMediaWithInfo info: [String : AnyObject])
//    {
//             print("DEBAG: delegate")
//    }
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        print("DEBAG: delegate")
//    }
//    }
