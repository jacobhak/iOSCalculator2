//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Jacob Håkansson on 2012-11-23.
//  Copyright (c) 2012 Jacob Håkansson. All rights reserved.
//

//
//  CalculatorBrain.m
//  Calculator
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University.
//  All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

- (NSMutableArray *)programStack {
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (id)program {
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program {
    return @"Implement this in Homework #2";
}

- (void)pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushVariable:(NSString *)variable {
    [self.programStack addObject:variable];
}

- (double)performOperation:(NSString *)operation {
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack {
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] +
            [self popOperandOffProgramStack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack] *
            [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"π"]) {
            result = 3.14;
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}

+ (NSSet *)twoOperandOperations {
    return [NSSet setWithObjects:@"+",@"-",@"/",@"*", nil];
}

+ (NSSet *)operations {
    return [[NSSet setWithObjects:@"sin",@"cos",@"sqrt",@"π", nil] setByAddingObjectsFromSet:[self twoOperandOperations]];
}

+ (BOOL)isOperation:(NSString *)operation {
    if ([[self operations] containsObject:operation]) return YES;
    return NO;
}

+ (BOOL)isTwoOperandOperation:(NSString *)operation {
    if ([[self twoOperandOperations] containsObject:operation]) return YES;
    return NO;
}

+ (NSSet *)variablesUsedInProgram:(id)program {
    NSSet *set;
    if ([program isKindOfClass:[NSArray class]]) {
        for (id op in program) {
            if ([op isKindOfClass:[NSString class]]&& ![self isOperation:op]) {
                if (set == nil) set = [NSSet set];
                set = [set setByAddingObject:op];
            }
        }
    }
    return set;
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    for (int i = 0; i < stack.count; i++) {
        id obj = [stack objectAtIndex:i];
        if ([obj isKindOfClass:[NSString class]]&& ![self isOperation:obj]) {
            NSNumber *value = [variableValues valueForKey:[stack objectAtIndex:i]];
            if (value == nil) {
                value = [NSNumber numberWithDouble:0];
            }
            [stack setObject:value atIndexedSubscript:i];
        }
    }
    return [self popOperandOffProgramStack:stack];
}

- (void)clear {
    self.programStack = nil;
}

@end
