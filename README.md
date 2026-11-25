# itsusheng 的博客

基于 Hexo + Butterfly 主题，通过 GitHub Actions 自动部署到 GitHub Pages。

## 本地开发

```bash
npm install          # 安装依赖
npm run server       # 本地预览 http://localhost:4000
npm run build        # 生成静态文件到 public/
```

## 写文章

```bash
npx hexo new "文章标题"
```

编辑 `source/_posts/` 下生成的 Markdown 文件，然后本地预览确认效果。

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
