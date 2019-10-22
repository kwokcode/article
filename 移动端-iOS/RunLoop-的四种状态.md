# RunLoop 的四种状态
1. source0 // 处理触摸事件 例如:performSelector:onThread
2. Source1 // 基于Port 的线程间通信
3. Timers // NSTimer performSelector:withObject:afterDelay
4. Observers // 用于监听RunLoop的状态 UI 刷新 (BeforeWaiting) AutoRelease pool (BeforeWaiting)
