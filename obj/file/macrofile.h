//
//  macrofile.h
//  DialProject
//
//  Created by 开发者1 on 16/12/30.
//  Copyright © 2016年 jcd. All rights reserved.
//

#ifndef macrofile_h
#define macrofile_h

#define KSCREENW [UIScreen mainScreen].bounds.size.width
#define KSCREENH [UIScreen mainScreen].bounds.size.height
#define KSUSERDEFAULT [NSUserDefaults standardUserDefaults]
#define JCDRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]
#define COLOR_THEME JCDRGBA(48, 119, 223, 1)
#define COLOR_BLACK JCDRGBA(70, 70, 70, 1)
#define COLOR_BACK JCDRGBA(243, 246, 249, 1)

#define WeakSelf __weak typeof(self) weakSelf = self;
#define CALL_CENTER @"call_center"
#define CALL_CATE_STATE @"call_cate_state"

#endif /* macrofile_h */
