//
//  GraphViewController.m
//  Calculator2
//
//  Created by Jacob Håkansson on 2012-12-07.
//  Copyright (c) 2012 Jacob Håkansson. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrain.h"
#import "CalculatorViewController.h"


@interface GraphViewController () <GraphViewDataSource>
@property (nonatomic, weak)IBOutlet GraphView * graphView;
@end

@implementation GraphViewController

@synthesize function = _function;

//- (id)function {
//    NSLog([@"get" stringByAppendingString:[CalculatorBrain descriptionOfProgram:_function]]);
//    if (_function == nil) {
//        return [NSArray arrayWithObjects:@"x", @"cos", nil];
//    } else return _function;
//    //return _function;
//}

- (void)setFunction:(id)function {
    _function = function;
    NSLog([@"set" stringByAppendingString:[CalculatorBrain descriptionOfProgram:self.function]]);
    //[self.graphView setNeedsDisplay];
}

- (void)setGraphView:(GraphView *)graphView {
    _graphView = graphView;
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    self.graphView.dataSource = self;
}

- (BOOL) shouldAutorotate {
    return YES;
}

- (float)valueForGraphView:(GraphView *)sender atPoint:(float)x {
    NSDictionary *dict;
    dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:x],@"x",nil];
    float val = [CalculatorBrain runProgram:self.function usingVariableValues:dict];
    //NSLog([@"value: " stringByAppendingString:[[NSNumber numberWithFloat:val] description]]);
    return val;
}

@end
