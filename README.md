# itsusheng 的博客

基于 Hexo + Butterfly 主题，通过 GitHub Actions 自动部署到 GitHub Pages。

## 本地开发

```bash
npm install          # 安装依赖
npm run server       # 本地预览 http://localhost:4000
npm run build        # 生成静态文件到 public/
```

## 日常发布流程（每天用这个，傻瓜式）

桌面上有两个图标，日常更新只用它们：

1. **双击桌面「写新文章.bat」** → 输入文章标题（比如"今天学了Python"）→ 回车。
   脚本会自动在 `source/_posts/` 建好一个 `.md` 文件，标题、日期、标签、分类都填好，并自动用记事本打开。
2. **在记事本里写正文**（最上面 `---` 之间的是文章信息，别乱动），写完按 `Ctrl+S` 保存，关掉记事本。
3. **双击桌面「一键发布博客.bat」** → 出现 `SUCCESS!` 即成功。如弹出 GitHub 登录窗口，点开授权一次即可。
4. **等 1–2 分钟**，刷新 `https://itsusheng.github.io` 就能看到新文章。

> **这个博客没有网页后台**（不像 WordPress 那样登录网址写文章）。更新内容就是改 `source/_posts/` 里的 `.md` 文件，再通过脚本传上 GitHub，全程在电脑上完成。
>
> 注意：发布脚本固定走本机代理 `127.0.0.1:7897`（科学上网工具），用前请先开启；端口变了用记事本改 `publish.bat` 里的 `7897`。
>
> 命令行老手也可以不用脚本：`npx hexo new "标题"` 建文章，`npx hexo server` 本地预览 `http://localhost:4000/`。构建部署由 GitHub Actions 自动完成，无需手动 `hexo g`/`hexo d`。

## 手动发布（不用脚本时）

```bash
git add -A
git commit -m "post: 今天学了什么"
git push origin main
```
手动推时同样需要先开代理；如果在普通 cmd 里敲 `git` 提示找不到命令，是因为 Git 没加入 PATH，用脚本则无此问题。

## 部署上线

1. 账号：`itsUsheng`（由 `tekikoyo` 改名而来；`usheng`/`teki` 已被占用且 GitHub 不释放，故选用 `itsUsheng`）。
2. 仓库：`itsUsheng/itsUsheng.github.io`（Public，用户主页仓库）。GitHub 用户名和仓库名大小写不敏感，网址统一用小写 `https://itsusheng.github.io`。
3. 在本目录更新远程地址并推送（GitHub 会自动重定向旧地址）：

```bash
git remote set-url origin https://github.com/itsUsheng/itsUsheng.github.io.git
git push -u origin main
```

4. 推送后 GitHub Actions 会自动构建并部署到 `gh-pages` 分支。
5. 到仓库 **Settings → Pages → Build and deployment**，Source 选择 **Deploy from a branch**，Branch 选 `gh-pages` / `/ (root)`，保存。
6. 访问 `https://itsusheng.github.io`。

> 如果推送时没有弹出登录窗口，可改用 Personal Access Token：GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)，勾选 `repo` 权限生成，推送时密码框粘贴 token（不是账号密码）。

## 一键发布脚本：踩坑记录（以后别再踩）

脚本是 `一键发布.bat`（纯英文内容）+ `setup_env.ps1`（配置逻辑）。下面的坑都真实踩过并修好了，改动脚本时务必注意：

1. **bat 文件绝对不能用 UTF-8 中文**。Windows 的 cmd 按 GBK 读中文，UTF-8 中文会被拆成乱码字节、其中一些字节被当成命令分隔符，导致 `'m' 不是内部命令` 这类诡异报错。所以 bat 内容一律纯英文 ASCII；中文说明只写在 README。验证方法：文件内非 ASCII 字节数必须为 0。
2. **变量名绝不能叫 `GIT_DIR`**。这是 Git 的保留环境变量，含义是"仓库目录在这里"。一旦设成 PortableGit 的路径，git 就会报 `fatal: not a git repository: '...PortableGit'`。脚本里已改名 `PGROOT`，并在开头主动 clear `GIT_DIR/GIT_WORK_TREE/GIT_INDEX_FILE/GIT_CONFIG` 这几个保留变量。其他要避开的保留名：`GIT_WORK_TREE`、`GIT_INDEX_FILE`、`GIT_CONFIG`。
3. **代理端口写死为 `127.0.0.1:7897`**。这是本机科学上网工具的端口。换端口时改 bat 里的 `PROXY` 和 `PROXY_PORT`（或 setup_env.ps1），两处都要改。
4. **失败提示必须显示 git 原始输出**。早期版本把 push 的错误输出吞掉了，只显示笼统提示，无法排查。现在 push 输出直接打印在 `===== upload details =====` 区块里，报错时看那里的原文即可。
5. **不要吞掉 `%ERRORLEVEL%`**。push 后用 `set "PUSH_CODE=%ERRORLEVEL%"` 立即保存返回码再判断，否则会被后续命令覆盖。

### 排查清单（双击脚本报 FAILED 时按此顺序看 window 里的原文）

| 报错原文 | 原因 | 处理 |
|---|---|---|
| `fatal: not a git repository: '...PortableGit'` | 有脚本设置了保留变量 GIT_DIR | 见坑 2，脚本已内置清除 |
| `CONNECT tunnel failed 502` / `Could not resolve host` | 代理没开或端口不对 | 开科学上网工具，核对端口 7897 |
| `Repository not found` | 远程地址/仓库名不对 | `git remote -v` 核对是否为 `itsUsheng/itsUsheng.github.io` |
| `nothing to commit` | 没有新改动（不是错误） | 属正常，不影响 push，可忽略 |
| 卡住不动 | 在等 GitHub 授权窗口 | 看任务栏，点开窗口授权一次 |
