//
//  GraphView.h
//  Calculator2
//
//  Created by Jacob Håkansson on 2012-12-07.
//  Copyright (c) 2012 Jacob Håkansson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;
@protocol GraphViewDataSource
- (float) valueForGraphView:(GraphView *)sender atPoint:(float)x;
@end

@interface GraphView : UIView

@property (nonatomic) CGFloat scale;
- (void)pinch:(UIPinchGestureRecognizer *)gesture;
@property (nonatomic,weak) IBOutlet id <GraphViewDataSource> dataSource;
@end
