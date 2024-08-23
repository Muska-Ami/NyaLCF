使用方法请参考 NyaLCF Wiki 食用~ [Wiki](https://docs-nyalcf.1l1.icu)

**Breaking changes: 本版本修改了启动器包名，需要手动迁移配置文件位置**
****

请参照 [如何重置启动器](https://docs-nyalcf.1l1.icu/gui/chang-jian-wen-ti-jie-da#q-ru-he-zhong-zhi-qi-dong-qi) 找到您的数据目录，并将 `moe.xmcn.nyanana` 文件夹改名为 `moe.muska.ami`，造成不便请谅解。

此外，要使用 LoCyan Mirrors 镜像源，请修改你的 `frpc.json` :

```json
{
  // ...
  "lists": {
    // ...
    "frpc_download_mirrors": [
      // ...
      {
        "name": "LoCyan Mirrors",
        "id": "locyan-mirror",
        // 将这里的 github-releases 改成 github-release
        // 请不要把注释粘进去
        "format": "https://mirrors.locyan.cn/github-release/{owner}/{repo}/{release_name}/frp_LoCyanFrp-{version_pure}_{platform}_{arch}.{suffix}"
      }
    ]
  }
}

```

[//]: # (应用户需求，Nya LoCyanFrp! 开始开发 CLI 版本，欢迎使用和反馈问题！)

## 更新日志

### GUI

- 更改了包名
- 修复写错了一个镜像信息

### CLI

-/-

### 其他

-/-

## 版本信息

- nyalcf_gui: 0.2.1
- nyalcf_cli: 0.0.1
- nyalcf_core,nyalcf_inject: 0.1.6

<!-- Some change log here -->
