# Nya LoCyanFrp! Launcher

<img src="https://apac-cloudflare-r2.img.1l1.icu/2024/05/02/66329275b94be.webp" width="100%" alt="NyaLCF Banner" />

下一代 LoCyanFrp 启动器。

The next generation of LoCyanFrp launcher.

## 为什么选择 Nya LoCyanFrp! (GUI)？

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

## 开发计划

- [ ] CLI 版本
  - [x] 登录
  - [x] 隧道启动
  - [ ] 进程管理
  - [ ] 用户信息展示
  - [CLI Features Design](./nyalcf_cli/README.md#设计功能)
- [x] GUI 版本
  - [GUI Features Design](./nyalcf_gui/README.md#设计功能)
- CI/CD
  - GUI 版本
    - [x] 自动构建
    - [x] 自动发布
  - CLI 版本
    - [x] 自动构建
    - [ ] 自动发布
  - [x] Pull Request 自动检查
  - [x] 开源协议/许可证兼容性检查
  - [x] 代码质量检查

## 软件测试

以下是本软件测试运行状况，若您发现无法正常运作，请提交Issue。

- GUI版本: [GUI Test Status](./nyalcf_gui/README.md#运行测试)
- CLI版本: [CLI Test Status](./nyalcf_gui/README.md#运行测试)

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
