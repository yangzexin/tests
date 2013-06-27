//
//  MSTxtMessageDao.h
//  MessageSlave
//
//  Created by yangzexin on 13-4-28.
//  Copyright (c) 2013年 yangzexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSMessageDAO.h"

@interface MSTxtMessageDao : NSObject <MSMessageDAO>

- (id)initWithTxtFilePath:(NSString *)txtFilePath content:(NSString *)content;

@end
