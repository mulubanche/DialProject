//
//  Popup.h
//  Qipai
//
//  Created by Terence on 15/10/27.
//  Copyright © 2015年 MT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Hinter : NSObject

+ (void) updateTitle:(NSString*) title Msg:(NSString*) msg;
+ (void) title:(NSString*)title msg:(NSString*)msg indicator:(BOOL) indicator hideAfter:(float)life  view:(UIView*)v onHide:(void(^)())onHide;
+ (void) title:(NSString*)title msg:(NSString*)msg indicator:(BOOL) indicator hideAfter:(float)life  view:(UIView*)v;
+ (void) hideAfter:(NSInteger) delay;
+ (void) hide;

@end
