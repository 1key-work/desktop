# electron诡异的bug

如果 package.json 中的 projectName 叫做 一键办公 · 表格文档 , 清理缓存后第一次打开是白屏

看起来是serviceWorker fetch的时候会pending住

把 projectName 中的 · 删除就可以了，不知道为什么，非常诡异

