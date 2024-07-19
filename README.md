# Nya LoCyanFrp! Launcher

<img src="https://apac-cloudflare-r2.img.1l1.icu/2024/05/02/66329275b94be.webp" width="100%" alt="NyaLCF Banner" />

下一代 LoCyanFrp 启动器。

The next generation of LoCyanFrp launcher.

## 为什么选择 Nya LoCyanFrp？

- [x] 质感，美观，基于 Material Design 3 设计
- [x] 跨平台可用
- [x] 高性能，低占用
- [x] 轻量化体积，启动器总大小不超过 50 MB，本体不足 1 MB
- [x] 流畅的界面动画
- [x] 可爱喵！にゃ~
- [x] HarmonyOS Sans 字体，可读性强

## 项目结构

- [nyalcf_core](./nyalcf_core) - 核心模块
- [nyalcf_inject](./nyalcf_inject) - 通讯模块
- [nyalcf_gui](./nyalcf_gui) - 图形化版本
  - [nyalcf_ui](./nyalcf_gui/nyalcf_ui) - 用户界面模块
  - [nyalcf_core_extend](./nyalcf_gui/nyalcf_core_extend) - 核心扩展模块
  - [nyalcf_inject_extend](./nyalcf_gui/nyalcf_inject_extend) - 通讯扩展模块
- [nyalcf_cli](nyalcf_cli) - 命令行版本

## 设计功能

标识\*的代表未完全实现，或未达到预期效果仍需测试。

- [ ] CLI 版本
- [x] 登录
- [x] 注册
- [x] 自动登录
- [ ] Frpc 管理
- [x] 进程管理器
- [x] Token 复制
- [x] 隧道信息展示
- [x] 隧道启动
- [x] 高级启动
- [x] 控制台
- [ ] 隧道编辑
- [x] 公告
- [x] 通知
- [x] 暗色主题
- [x] 仅 Frp Token 模式

本软件运行需要 Microsoft Visual C++ Redistributable 运行时，如无法打开请尝试从此处下载安装运行时再使用。
[https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist](https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist)

## 软件测试

以下是本软件测试运行状况，若您发现无法正常运作，请提交Issues。

| 打包类型          | 系统类型    | 状态 | 已测试通过环境                                                       |
|---------------|---------|----|---------------------------------------------------------------|
| EXE Installer | Windows | ✅  | Windows 11 (Home&Student, Pro)                                |
| Portable ZIP  | Windows | ✅  | Windows 11 (Pro)                                              |
| AppImage      | Linux   | ✅  | Kali Linux(With WSL, Linux5.9), Manjaro Linux(Linux 6.1)      |
| DEB           | Linux   | ✅  | Kali Linux(With WSL, Linux5.9), Debian 12(Linux5.9, Linux6.1) |
| RPM           | Linux   | ❓  | -                                                             |
| DMG           | MacOS   | 💠 | Tested by Community                                           |

## Repo stats

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/de384a8e9f2a47b5b26f80c61c2a8bfd)](https://app.codacy.com/gh/Muska-Ami/NyaLCF/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2FMuska-Ami%2FNyaLCF.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2FMuska-Ami%2FNyaLCF?ref=badge_shield)

<img src="https://repobeats.axiom.co/api/embed/8657905cfb65146e66a5d6039165f705d6403531.svg" alt="Repobeats analytics image" width="100%">

### License Status
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2FMuska-Ami%2FNyaLCF.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2FMuska-Ami%2FNyaLCF?ref=badge_large)

### How to contribute

请 Fork `dev` 分支，并在此分支基础上修改。在 `Pull request` 之前，请先测试是否能够正常运行。请不要 `Pull request` 到 `main` 分支。

#### 安装依赖

```shell
bash install-dependecy.sh
```

### 感谢我们的开发者！是他们使NyaLCF变的更好！
<a href="https://github.com/Muska-Ami/NyaLCF/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=Muska-Ami/NyaLCF" height="32px"  alt="Contributors"/>
</a>
