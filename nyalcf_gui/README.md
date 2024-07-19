# NyaLCF GUI

基于图形化的 Nya LoCyanFrp! Core 调用实现。

- nyalcf_ui 图形化主体模块
- nyalcf_core_ui 对 NyaLCF Core 的扩展模块
- nyalcf_inject_ui 对 NyaLCF Inject 的扩展模块

## 运行测试

| 打包类型          | 系统类型    | 状态 | 已测试通过环境                                                       |
|---------------|---------|----|---------------------------------------------------------------|
| EXE Installer | Windows | ✅  | Windows 11 (Home&Student, Pro)                                |
| Portable ZIP  | Windows | ✅  | Windows 11 (Pro)                                              |
| AppImage      | Linux   | ✅  | Kali Linux(With WSL, Linux5.9), Manjaro Linux(Linux 6.1)      |
| DEB           | Linux   | ✅  | Kali Linux(With WSL, Linux5.9), Debian 12(Linux5.9, Linux6.1) |
| RPM           | Linux   | ❓  | -                                                             |
| DMG           | MacOS   | 💠 | Tested by Community                                           |

### Windows

本软件运行需要 Microsoft Visual C++ Redistributable 运行时，如无法打开请尝试从此处下载安装运行时再使用。
[https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist](https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist)

### Linux

系统托盘需要 `libayatana-appindicator3` ，若缺失将不会显示托盘图标。
