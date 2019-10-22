```
zsh: /usr/local/bin/pod: bad interpreter: /System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby: no such file or directory
```
这是Mac升级系统导致，当你的Mac系统升级为macOS Catalina 的时候，别忘记更新cocoapods。

% sudo gem update --system
% sudo gem install cocoapods -n/usr/local/bin
