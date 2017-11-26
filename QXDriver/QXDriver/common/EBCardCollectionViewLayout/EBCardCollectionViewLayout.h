//
//  EBCardCollectionViewLayout.h
//  Vindeo
//
//  Created by Ezequiel A Becerra on 7/11/14.
//  Copyright (c) 2014 Ezequiel A Becerra. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EBCardCollectionLayoutType) {
    EBCardCollectionLayoutHorizontal,
    EBCardCollectionLayoutVertical
};

@interface EBCardCollectionViewLayout : UICollectionViewFlowLayout

@property (readonly) NSInteger currentPage;
@property (nonatomic,assign) BOOL isScale;
@property (nonatomic, assign) UIOffset offset;
@property (nonatomic, strong) NSDictionary *layoutInfo;
@property (assign) EBCardCollectionLayoutType layoutType;

- (CGRect)contentFrameForCardAtIndexPath:(NSIndexPath *)indexPath;
@end
