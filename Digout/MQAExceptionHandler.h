//
//  MQAExceptionHandler.h
//  Digout
//
//  Created by Daniel Burkhardt on 2/5/16.
//  Copyright © 2016 Giganom LLC. All rights reserved.
//

#ifndef MQAExceptionHandler_h
#define MQAExceptionHandler_h

volatile void exceptionHandler(NSException *exception);
extern NSUncaughtExceptionHandler *exceptionHandlerPointer;


#endif /* MQAExceptionHandler_h */
