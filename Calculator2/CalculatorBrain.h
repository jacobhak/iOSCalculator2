//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Jacob Håkansson on 2012-11-23.
//  Copyright (c) 2012 Jacob Håkansson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
-(double)performOperation:(NSString *)operation;
- (void)clear;
@end
