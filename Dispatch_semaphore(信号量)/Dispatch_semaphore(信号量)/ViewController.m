//
//  ViewController.m
//  dispatch_semaphore
//
//  Created by soliloquy on 2017/8/8.
//  Copyright © 2017年 soliloquy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dispatch_semaphore];
}


/*
 需求介绍
 
 这是一个很常见的需求：项目中的业务接口请求的时候需要Token验证。我们最简化这个需求就是：两个请求，请求1成功返回所需参数之后，才能开始请求2。
 */
// 信号量
- (void)dispatch_semaphore {
    
    /*
     //创建信号量
     dispatch_semaphore_create
     //发送信号量
     dispatch_semaphore_signal
     //等待信号量
     dispatch_semaphore_wait
     */
    
    dispatch_async(dispatch_queue_create("ptl", DISPATCH_QUEUE_CONCURRENT), ^{
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        // 请求接口1
        [self getToken:semaphore];
        //此时的信号量为0，只有token请求成功发送信号量之后，才会往下执行[self request]方法，否则会一直等下去;
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 请求接口2
        [self requestData1:semaphore];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        // 请求接口3
        [self requestData2];
    });
    
}

- (void)getToken:(dispatch_semaphore_t)semaphore
{
    // 模仿网络请求
    for (NSInteger i = 0; i < 20; i ++) {
        NSLog(@"请求1-------%zd", i);
        // 模仿请求成功
        //成功拿到token，发送信号量
        dispatch_semaphore_signal(semaphore);
    }
    NSLog(@"------------请求1成功-----------------");
}

- (void)requestData1:(dispatch_semaphore_t)semaphore {
    for (NSInteger i = 0; i < 20; i ++) {
        NSLog(@"请求2-------%zd", i);
        dispatch_semaphore_signal(semaphore);
    }
    NSLog(@"------------请求2成功-----------------");
}

- (void)requestData2 {
    for (NSInteger i = 0; i < 20; i ++) {
        NSLog(@"请求3-------%zd", i);
    }
    NSLog(@"------------请求3成功-----------------");
}

@end
