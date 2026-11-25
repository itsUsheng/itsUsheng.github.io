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

1. 在 GitHub 创建仓库，名字必须是 `itsusheng.github.io`，设为 Public，**不要**勾选初始化 README。
2. 在本目录执行（把 `YOUR_TOKEN` 换成你的 GitHub Personal Access Token，需勾选 `repo` 权限）：

```bash
git remote add origin https://github.com/itsusheng/itsusheng.github.io.git
git push -u origin main
```

3. 推送后 GitHub Actions 会自动构建并部署到 `gh-pages` 分支。
4. 到仓库 **Settings → Pages → Build and deployment**，Source 选择 **Deploy from a branch**，Branch 选 `gh-pages` / `/ (root)`，保存。
5. 访问 `https://itsusheng.github.io`。

> 说明：Personal Access Token 在 GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic) 生成。推送时密码框粘贴 token（不是账号密码）。
