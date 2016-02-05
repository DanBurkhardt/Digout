//
//  MQAExceptionHandler.m
//  Digout
//
//  Created by Daniel Burkhardt on 2/5/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


void exceptionHandler(NSException *exception) {}
NSUncaughtExceptionHandler *exceptionHandlerPointer = &exceptionHandler;


