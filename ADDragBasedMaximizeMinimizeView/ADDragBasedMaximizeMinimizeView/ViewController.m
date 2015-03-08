//
//  ViewController.m
//  ADDragBasedMaximizeMinimizeView
//
//  Created by Aditya on 08/03/15.
//  Copyright (c) 2015 Aditya. All rights reserved.
//

#import "ViewController.h"

#define DRAG_VIEW_MINIMIZED_STATE_HEIGHT 70
#define DRAG_VIEW_TOP_MARGIN 20


@interface ViewController ()
{
    CGPoint _pointDragStart;
    CGPoint _pointDragStartOffset;
    UIPanGestureRecognizer* _panGesture;
    CGFloat _heightScreen;
}

@property (weak, nonatomic) IBOutlet UIView *viewDraggable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintDraggableViewHeight;

-(void)performSetup;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self performSetup];
}


#pragma mark - Initializations

-(void)performSetup
{
    //1. Set default height
    _constraintDraggableViewHeight.constant = DRAG_VIEW_MINIMIZED_STATE_HEIGHT;
    
    //2. Set pan gesture
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning:)];
    [_viewDraggable addGestureRecognizer:_panGesture];
    
    //3. Set screen height
    _heightScreen = [[UIScreen mainScreen] bounds].size.height;

}


#pragma mark - UIGestureRecognizer Callback

- (void)handlePanning:(UIPanGestureRecognizer *)gestureRecognizer
{
    switch ([gestureRecognizer state])
    {
        case UIGestureRecognizerStateBegan:
            [self draggingStarted:gestureRecognizer];
            break;
            
        case UIGestureRecognizerStateChanged:
            [self dragInProgresss:gestureRecognizer];
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            [self dragFinished:gestureRecognizer];
            break;
            
        default:
            break;
    }
}


#pragma mark - Dragging Handling

- (void)draggingStarted:(UIPanGestureRecognizer *)gestureRecognizer
{
    _pointDragStart = [gestureRecognizer locationInView:self.view];
    _pointDragStartOffset = [gestureRecognizer locationInView:_viewDraggable];
}


- (void)dragInProgresss:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint pointDragLocation = [gestureRecognizer locationInView:self.view];

    float heightToSet = _heightScreen - pointDragLocation.y + _pointDragStartOffset.y;
    
    if(heightToSet >= DRAG_VIEW_MINIMIZED_STATE_HEIGHT && heightToSet <= _heightScreen  - DRAG_VIEW_TOP_MARGIN)
    {
        _constraintDraggableViewHeight.constant = heightToSet;
    }
}


- (void)dragFinished:(UIPanGestureRecognizer *)gestureRecognizer
{
    if(_constraintDraggableViewHeight.constant < _heightScreen / 2) // Minimize
    {
        [UIView animateWithDuration:0.5 animations:
         ^{
            _constraintDraggableViewHeight.constant = DRAG_VIEW_MINIMIZED_STATE_HEIGHT;
            [_viewDraggable layoutIfNeeded];
        }];
    }
    else // Full View
    {
        [UIView animateWithDuration:0.5 animations:
         ^{
            _constraintDraggableViewHeight.constant = _heightScreen - DRAG_VIEW_TOP_MARGIN;
            [_viewDraggable layoutIfNeeded];
        }];
    }
}


@end
