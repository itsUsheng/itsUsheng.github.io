# itsusheng 的博客

基于 Hexo + Butterfly 主题，通过 GitHub Actions 自动部署到 GitHub Pages。

## 本地开发

```bash
npm install          # 安装依赖
npm run server       # 本地预览 http://localhost:4000
npm run build        # 生成静态文件到 public/
```

## 日常发布流程（每天用这个）

1. **写文章**：在项目目录执行
   ```bash
   npx hexo new "文章标题"
   ```
   编辑 `source/_posts/文章标题.md`，开头有 `title/date/tags/categories` 等字段，正文用 Markdown 写。

2. **本地预览**（可选）：
   ```bash
   npx hexo server
   ```
   打开 `http://localhost:4000` 看效果，满意后按 `Ctrl+C` 停止。

3. **一键发布**：双击项目根目录的 **`publish.bat`**，它会自动提交并把代码推到 GitHub。推送时如弹出 GitHub 登录窗口，授权一次即可（之后记住）。

4. **等 1–2 分钟**，访问 `https://tekikoyo.github.io/itsusheng.github.io/` 就能看到新文章。构建和部署由 GitHub Actions 自动完成，无需手动 `hexo g` 或 `hexo d`。

> 注意：脚本里固定走了本机代理 `127.0.0.1:7897`（你的科学上网工具），用脚本前请确保代理已开启。若代理端口变了，用记事本打开 `publish.bat` 修改里面的 `7897`。

## 手动发布（不用脚本时）

```bash
git add -A
git commit -m "post: 今天学了什么"
git push origin main
```
手动推时同样需要先开代理；如果在普通 cmd 里敲 `git` 提示找不到命令，是因为 Git 没加入 PATH，用脚本则无此问题。

## 部署上线

1. 仓库已创建：`tekikoyo/tekikoyo.github.io`（Public，空仓库）。
2. 在本目录执行，推送时弹出的登录窗口用 GitHub 账号授权即可（凭据管理器已配置好，不用手动建 token）：

```bash
git remote add origin https://github.com/tekikoyo/tekikoyo.github.io.git
git push -u origin main
```

3. 推送后 GitHub Actions 会自动构建并部署到 `gh-pages` 分支。
4. 到仓库 **Settings → Pages → Build and deployment**，Source 选择 **Deploy from a branch**，Branch 选 `gh-pages` / `/ (root)`，保存。
5. 访问 `https://tekikoyo.github.io`。

> 如果推送时没有弹出登录窗口，可改用 Personal Access Token：GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)，勾选 `repo` 权限生成，推送时密码框粘贴 token（不是账号密码）。
