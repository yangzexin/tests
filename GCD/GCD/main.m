//
//  main.m
//  GCD
//
//  Created by yangzexin on 11/18/14.
//  Copyright (c) 2014 sf-express. All rights reserved.
//

#import <Foundation/Foundation.h>

void test_dispatch_group()
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"b1");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"b2");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"b3");
    });
    
    dispatch_group_enter(group);// 手动进入
    dispatch_async(queue, ^{
        NSLog(@"b4");
        [NSThread sleepForTimeInterval:1.0f];
        dispatch_group_leave(group);// 手动退出
    });
    
    dispatch_group_notify(group, queue, ^{
        // 当group里面的所有block执行完毕，当前回调会得到通知
        NSLog(@"group finished");
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"group finished wait");
}

void myFinalizerFunction(void *context)
{
    NSLog(@"finalize");
}

void test_dispatch_barrier()
{
    dispatch_queue_t queue = dispatch_queue_create("test_dispatch_barrier", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_set_finalizer_f(queue, myFinalizerFunction);
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:.20f];
        NSLog(@"b1");
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:.20f];
        NSLog(@"b2");
    });
    dispatch_barrier_async(queue, ^{
        [NSThread sleepForTimeInterval:.50f];
        NSLog(@"barrier_async");
    });
    dispatch_async(queue, ^{
        NSLog(@"b3");
    });
}

void test_dispatch_apply()
{
    dispatch_apply(10, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
        NSLog(@"%ld", index);
    });
}

void test_dispatch_semaphore()
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(10); // 创建资源为10的信号量
    
    for (NSInteger i = 0; i < 100; ++i) {
        NSLog(@"try run:%ld", i);
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);// 等待直到有资源可用

        NSLog(@"resource available");
        // 执行到这里说明等待到可用资源
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"running:%ld", i);
            sleep(1);
            dispatch_semaphore_signal(sema);// 执行操作完成，发通知信号，返回资源
        });
    }
    // 上述创建了一个资源为10的semaphore，dispatch_semaphore_wait会阻塞线程知道资源可用，
    // 在做完需要做的操作之后，必须调用dispatch_semaphore_signal来还资源给semaphore，
    // 这样其他等待的操作才能继续使用这个资源
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //test_dispatch_group();
        test_dispatch_barrier();
        //test_dispatch_apply();
        //test_dispatch_semaphore();
        
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
    }
    return 0;
}
