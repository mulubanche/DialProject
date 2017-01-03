//
//  apifile.h
//  DialProject
//
//  Created by 开发者1 on 16/12/30.
//  Copyright © 2016年 jcd. All rights reserved.
//

#ifndef apifile_h
#define apifile_h

//http://139.196.227.36:8055/CosService.asmx
#ifdef DEBUG  // 调试状态
#define DebugLog(s, ...) NSLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#pragma mark 测试URL
#define CODE_URL            @"http://139.196.227.36:8055/"
#else // 发布状态
#define DebugLog(s, ...)
#pragma mark 正式URL
#define CODE_URL            @"http://139.196.227.36:8055/"
#endif


#pragma mark ASMX
#define COSSERVICE          @"CosService.asmx"


#pragma mark 存沙盒宏
#define SAVE_SELF_TELL      @"save_self_tell_number"

#endif /* apifile_h */
