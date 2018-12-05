////
////  ImagePickerManager+DelegateProxy.swift
////  SpecialTraining
////
////  Created by sw on 05/12/2018.
////  Copyright © 2018 youpeixun. All rights reserved.
////
//
//import Foundation
//import RxSwift
//import RxCocoa
//
//extension ImagePickerManager: HasDelegate {
//    
//
//    public typealias Delegate = ImagePickerDelegate
//}
//
//class RxImagePickerManagerDelegateProxy
//    : DelegateProxy<ImagePickerManager, ImagePickerDelegate>
//    , DelegateProxyType
//, ImagePickerDelegate {
//    
//    /// Typed parent object.
//    weak private(set) var manager: ImagePickerManager?
//    
//    /// - parameter tabBar: Parent object for delegate proxy.
//    public init(manager: ParentObject) {
//        self.manager = manager
//        super.init(parentObject: manager, delegateProxy: RxImagePickerManagerDelegateProxy.self)
//    }
//    
//    // Register known implementations
//    public static func registerKnownImplementations() {
//        self.register { RxImagePickerManagerDelegateProxy(manager: $0) }
//    }
//    
//    /// For more information take a look at `DelegateProxyType`.
//    open class func currentDelegate(for object: ParentObject) -> ImagePickerDelegate? {
//        return object.pickerDelegate
//    }
//    
//    /// For more information take a look at `DelegateProxyType`.
//    open class func setCurrentDelegate(_ delegate: ImagePickerDelegate?, to object: ParentObject) {
//        object.pickerDelegate = delegate
//    }
//}
//
//extension Reactive where Base: ImagePickerManager {
//
//    var delegate: DelegateProxy<ImagePickerManager, ImagePickerDelegate> {
//        return RxImagePickerManagerDelegateProxy.proxy(for: base)
//    }
//    
//    var finishPicker: ControlEvent<ImagePickerManager> {
//        let source = delegate.methodInvoked(#selector(ImagePickerDelegate.imagePickerController(_:didFinishPickingImage:editedImage:)))
//            .map { a in
//                return try castOrThrow(ImagePickerManager.self, a[1])
//        }
//        
//        return ControlEvent(events: source)
//    }
//}
//
//func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
//    guard let returnValue = object as? T else {
//        throw RxCocoaError.castingError(object: object, targetType: resultType)
//    }
//    
//    return returnValue
//}
