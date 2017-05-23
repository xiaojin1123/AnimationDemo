//
//  ViewController.m
//  AnimationDemo
//
//  Created by 11 on 2017/5/23.
//  Copyright © 2017年 11. All rights reserved.
//

#import "ViewController.h"

#define kTAG_BASE_VALUE 90


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *threeView;
@property (weak, nonatomic) IBOutlet UIView *fourView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //离屏后会remove animation，这里重新添加
    [self restartAnimation];
    //程序从后台进入激活状态需要重新添加Animation
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restartAnimation) name:@"APPEnterForeground" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"APPEnterForeground" object:nil];
}

- (void)initSubViews{
    [self initUI];
    [self restartAnimation];
}
-(void)initUI{
    //1
    CGRect frame = self.firstView.bounds;
    UIImageView *imageView = [self createImageViewWithFrame:frame tag:kTAG_BASE_VALUE named:@"pic_ceshi2_biaoqian"];
    imageView.layer.anchorPoint = CGPointMake(28.5/ 45.0, 16/ 45.0);
    imageView.frame = frame;
    [self.firstView addSubview:imageView];
    imageView = [self createImageViewWithFrame:frame tag:kTAG_BASE_VALUE+1 named:@"pic_ceshi2_xingxing1"];
    [self.firstView addSubview:imageView];
    imageView = [self createImageViewWithFrame:frame tag:kTAG_BASE_VALUE+2 named:@"pic_ceshi2_xingxing2"];
    [self.firstView addSubview:imageView];
    
    //2
    frame = self.secondView.bounds;
    imageView = [self createImageViewWithFrame:frame tag:kTAG_BASE_VALUE named:@"pic_ceshi1_biaoqian"];
    [self.secondView addSubview:imageView];
    
    frame = CGRectMake(45 - 18, 0, 18, 19.5);
    UIView *contentView = [[UIView alloc]init];
    contentView.layer.anchorPoint = CGPointMake(0, 1);
    contentView.frame = frame;
    contentView.tag = kTAG_BASE_VALUE + 10;
    [self.secondView addSubview:contentView];
    imageView = [self createImageViewWithFrame:contentView.bounds tag:kTAG_BASE_VALUE named:@"pic_ceshi1_qipao(1)"];
    [contentView addSubview:imageView];
    imageView = [self createImageViewWithFrame:contentView.bounds tag:kTAG_BASE_VALUE+1 named:@"pic_ceshi1_zi"];
    imageView.layer.anchorPoint = CGPointMake(0, 1);
    imageView.frame = contentView.bounds;
    [contentView addSubview:imageView];
    
    //3
    frame = self.threeView.bounds;
    imageView = [self createImageViewWithFrame:frame tag:kTAG_BASE_VALUE named:@"pic_ceshi3_biaoqian"];
    imageView.layer.anchorPoint = CGPointMake(0.5, 12/ 45.0);
    imageView.frame = frame;
    [self.threeView addSubview:imageView];
    
    //4
    frame = self.fourView.bounds;
    imageView = [self createImageViewWithFrame:frame tag:kTAG_BASE_VALUE named:@"pic_ceshi2_biaoqian"];
    [self.fourView addSubview:imageView];
    imageView = [self createImageViewWithFrame:frame tag:kTAG_BASE_VALUE+1 named:@"pic_ceshi2_xingxing1"];
    [self.fourView addSubview:imageView];
    imageView = [self createImageViewWithFrame:frame tag:kTAG_BASE_VALUE+2 named:@"pic_ceshi2_xingxing2"];
    [self.fourView addSubview:imageView];

}

- (UIImageView *)createImageViewWithFrame:(CGRect)frame tag:(NSInteger)tag named:(NSString *)name{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.tag = tag;
    imageView.image = [UIImage imageNamed:name];
    return imageView;
}
- (void)restartAnimation{
    [self startAnimationForFirstView];
    [self startAnimationForSecodView];
    [self startAnimationForThirdView];
    [self startAnimationForFourthView];
}


- (void)startAnimationForFirstView{
    id fromValue = [NSNumber numberWithFloat:-M_PI/ 10.0];
    id toValue = [NSNumber numberWithFloat:M_PI/ 10.0];
    UIImageView *imageView = [self.firstView viewWithTag:kTAG_BASE_VALUE];
    [self animationWithView:imageView keyPath:@"transform.rotation.z" fromValue:fromValue toValue:toValue];
    
    fromValue = @1;
    toValue = @0.1;
    imageView = [self.firstView viewWithTag:kTAG_BASE_VALUE + 1];
    [self animationWithView:imageView keyPath:@"opacity" fromValue:fromValue toValue:toValue];
    
    fromValue = @0.1;
    toValue = @1;
    imageView = [self.firstView viewWithTag:kTAG_BASE_VALUE + 2];
    [self animationWithView:imageView keyPath:@"opacity" fromValue:fromValue toValue:toValue];
}

- (void)startAnimationForSecodView{
    id fromValue = [NSNumber numberWithFloat:-M_PI/ 12.0];
    id toValue = [NSNumber numberWithFloat:0];
    NSString *rAnimationKey = @"transform.rotation.z";
    NSString *sAnimationKey = @"transform.scale";
    
    CAAnimation *rAnimation = [self createSAnimationWithKeyPath:rAnimationKey fromValue:fromValue toValue:toValue];
    CAAnimation *sAnimation = [self createSAnimationWithKeyPath:sAnimationKey fromValue:@0.9 toValue:@1];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.repeatCount = HUGE_VALF;
    animationGroup.duration = 1;
    animationGroup.autoreverses = YES;
    animationGroup.animations = @[rAnimation, sAnimation];
    UIView *contentView = [self.secondView viewWithTag:kTAG_BASE_VALUE + 10];
    [contentView.layer addAnimation:animationGroup forKey:nil];
    
    UIImageView *imageView = [contentView viewWithTag:kTAG_BASE_VALUE + 1];
    fromValue = [NSNumber numberWithFloat:0];
    toValue = [NSNumber numberWithFloat:-M_PI/ 30.0];
    CAAnimation *ziAnimation = [self createKAnimationWithKeyPath:rAnimationKey fromValue:fromValue toValue:toValue];
    [imageView.layer addAnimation:ziAnimation forKey:nil];
}

- (void)startAnimationForThirdView{
    id fromValue = [NSNumber numberWithFloat:-M_PI/ 10.0];
    id toValue = [NSNumber numberWithFloat:M_PI/ 10.0];
    UIImageView *imageView = [self.threeView viewWithTag:kTAG_BASE_VALUE];
    [self animationWithView:imageView keyPath:@"transform.rotation.z" fromValue:fromValue toValue:toValue];
}

- (void)startAnimationForFourthView{
    UIImageView *imageView = [self.fourView viewWithTag:kTAG_BASE_VALUE];
    id fromValue = [NSValue valueWithCGPoint:CGPointMake(45/ 2 + 1.5, 45/ 2 + 1.5)];
    id toValue = [NSValue valueWithCGPoint:CGPointMake(45/ 2 - 1.5, 45/ 2 - 1.5)];
    [self animationWithView:imageView keyPath:@"position" fromValue:fromValue toValue:toValue duration:0.6];
    
    imageView = [self.fourView viewWithTag:kTAG_BASE_VALUE + 1];
    fromValue = @1;
    toValue = @0.1;
    [self animationWithView:imageView keyPath:@"opacity" fromValue:fromValue toValue:toValue duration:0.6];
    
    imageView = [self.fourView viewWithTag:kTAG_BASE_VALUE + 2];
    fromValue = @0.1;
    toValue = @1;
    [self animationWithView:imageView keyPath:@"opacity" fromValue:fromValue toValue:toValue duration:0.6];
}

- (void)animationWithView:(UIView *)view keyPath:(NSString *)keyPath fromValue:(id)fromValue toValue:(id)toValue{
    CAAnimation *animation = [self createAnimationWithKeyPath:keyPath fromValue:fromValue toValue:toValue];
    [view.layer addAnimation:animation forKey:nil];
}

- (void)animationWithView:(UIView *)view
                  keyPath:(NSString *)keyPath
                fromValue:(id)fromValue
                  toValue:(id)toValue
                 duration:(CGFloat)duration{
    CAAnimation *animation = [self createAnimationWithKeyPath:keyPath fromValue:fromValue toValue:toValue];
    animation.duration = duration;
    [view.layer addAnimation:animation forKey:nil];
}

- (CAAnimation *)createSAnimationWithKeyPath:(NSString *)keyPath fromValue:(id)fromValue toValue:(id)toValue{
    CAMediaTimingFunction *mediaTiming = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.timingFunction = mediaTiming;
    animation.duration = 0.2;
    animation.repeatCount = 1;
    animation.fromValue =  fromValue;// 起始角度
    animation.toValue = toValue; // 终止角度
    //kCAFillModeRemoved | kCAFillModeForwards | kCAFillModeBoth | kCAFillModeBackwards
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    return animation;
}

- (CAAnimation *)createKAnimationWithKeyPath:(NSString *)keyPath fromValue:(id)fromValue toValue:(id)toValue{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    animation.duration = 2;
    animation.calculationMode = kCAAnimationCubic;
    animation.repeatCount = HUGE_VALF;
    animation.values = @[fromValue, fromValue, @(-[toValue floatValue]/ 2.0), toValue, fromValue, fromValue];
    animation.keyTimes = @[@(0), @(0.075), @(0.09), @(0.13), @(0.16), @(1)];
    return animation;
}

- (CAAnimation *)createAnimationWithKeyPath:(NSString *)keyPath fromValue:(id)fromValue toValue:(id)toValue{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.duration = 1.5; // 持续时间
    
    CAMediaTimingFunction *mediaTiming = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.timingFunction = mediaTiming;
    animation.repeatCount = HUGE_VALF; // 重复次数
    animation.fromValue =  fromValue;// 起始角度
    animation.toValue = toValue; // 终止角度
    animation.autoreverses = YES;
    return animation;
}


@end
