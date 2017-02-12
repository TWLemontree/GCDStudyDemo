//
//  ViewController.m
//  多线程练习
//
//  Created by yj on 2017/1/11.
//  Copyright © 2017年 csip. All rights reserved.
//

#import "ViewController.h"

#import <pthread.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // [self PthreadTest];
    
//    [self NSThreadTest];
    
    [self GCDTest];
}

//Pthreads练习
-(void)PthreadTest
{
    pthread_t thread;
    
    //创建一个线程并自动执行
    pthread_create(&thread, NULL, start, NULL);
}
void *start(void *data){
    NSLog(@"%@",[NSThread currentThread]);
    
    return NULL;
}

//NSThread练习
-(void)NSThreadTest
{
    //1.先创建线程类，再启动
//    NSThread *thread = [[NSThread alloc] initWithTarget:self
//                                               selector:@selector(run)
//                                                 object:nil];
//    [thread start];
    
    //2.创建并自动启动
    [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
    
    
}
-(void)run
{
    NSLog(@"%@",[NSThread currentThread]);
}

//GCD练习
-(void)GCDTest
{
    //主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    /**
        自己创建的队列
     */
    //串行队列：DISPATCH_QUEUE_SERIAL 或 NULL 表示创建串行队列
    dispatch_queue_t serialQueue1 = dispatch_queue_create("serialTestQueue1", NULL);
    dispatch_queue_t serialQueue2 = dispatch_queue_create("serialTestQueue2", DISPATCH_QUEUE_SERIAL);
    
    //并行队列：DISPATCH_QUEUE_CONCURRENT 表示创建并行队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    //全局并行队列：只要是并行任务一般都加入这个队列，这是系统提供的一个并发队列。
    dispatch_queue_t globalConcurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    /**
        创建任务
     */
 /*   //同步任务：会阻塞当前线程（SYNC）
    dispatch_sync(serialQueue1, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    
    //异步任务：不会阻塞当前线程（ASYNC）
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
  */
    
    //demo1:死锁
    /*
        解释：
        同步任务会阻塞当前线程，然后把Block中的任务放到指定的队列中执行，只有等Block中的任务完成后才会让当前线程继续往下运行。
        这里的步骤就是：打印完第一句话后，dispatch_sync立即阻塞当前的主线程，然后把Block中的任务放到main_queue中，可是main_queue中的任务会被取出来放到主线程中执行，但主线程这个时候已经被阻塞了，所以Block中的任务就不能完成，它不完成，dispatch_sync就会一直阻塞主线程，这就是死锁现象。导致主线程一直卡死。
     */
    NSLog(@"之前 - %@", [NSThread currentThread]);
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"sync - %@",[NSThread currentThread]);
    });
    NSLog(@"之后 - %@", [NSThread currentThread]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}














@end
