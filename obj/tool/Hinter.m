//
//  Popup.m
//  Qipai
//
//  Created by Terence on 15/10/27.
//  Copyright © 2015年 MT. All rights reserved.
//

#import "Hinter.h"
#import "MBProgressHUD.h"


static MBProgressHUD* m_hud;

@implementation Hinter


+ (void) updateTitle:(NSString *)title Msg:(NSString *)msg
{
    if(m_hud){
        m_hud.label.text = title;
        m_hud.detailsLabel.text = msg;
    }
}

+ (void) title:(NSString*)title msg:(NSString*)msg indicator:(BOOL) indicator hideAfter:(float)life  view:(UIView*)v onHide:(void(^)())onHide
{
    [Hinter hide];
    dispatch_async(dispatch_get_main_queue(), ^{
        m_hud = [MBProgressHUD showHUDAddedTo:v animated:YES];
        m_hud.margin = 10.f;
        m_hud.removeFromSuperViewOnHide = YES;
        m_hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        m_hud.color = [UIColor colorWithWhite:1 alpha:0.8];
        m_hud.dimBackground = NO;
        m_hud.square = NO;
        if(indicator) m_hud.mode = MBProgressHUDModeIndeterminate;
        else m_hud.mode = MBProgressHUDModeText;
        m_hud.label.text = title;
        m_hud.detailsLabel.text = [msg isKindOfClass:[NSNull class]]?@"":msg;
        
        if(life>0){
            [m_hud hideAnimated:YES afterDelay:life];
            m_hud = nil;
            if(onHide){
                dispatch_queue_t myqueue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL);
                dispatch_async(myqueue, ^{
                    sleep(life);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        onHide();
                    });
                });
            }
        }
    });
}
+ (void) title:(NSString*)title msg:(NSString*)msg indicator:(BOOL) indicator hideAfter:(float)life  view:(UIView*)v
{
    [self title:title msg:msg indicator:indicator hideAfter:life view:v onHide:nil];
}

+ (void) hideAfter:(NSInteger)delay
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(m_hud){
            [m_hud hideAnimated:YES afterDelay:delay];
            m_hud = nil;
        }
    });
}

+ (void) hide
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(m_hud){
            [m_hud hideAnimated:YES];
            m_hud = nil;
        }
    });
}


@end
