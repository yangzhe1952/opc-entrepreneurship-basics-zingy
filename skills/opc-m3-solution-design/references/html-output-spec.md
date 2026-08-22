# HTML 成果物输出规范（V2 · Awwwards 级设计标准）

> 适用：OPC 8 个 Skill 的最终成果物导出。D 定稿后，AI 必须把成果物渲染成一份**自包含 HTML 文件**（内联 CSS，单文件可打开），**对标 Awwwards / FWA / CSS Design Awards 顶级网站设计品质**，供学生直接保存提交。

---

## 1. 硬性要求

1. **单文件自包含**：所有样式写在 `<style>` 内，不引用外部 CSS；图标统一用 **Lucide**（`<script src="https://unpkg.com/lucide@latest"></script>` + `<i data-lucide="...">`，JS 端 `lucide.createIcons()`）。
2. **全程禁止 emoji**：所有图标一律用 Lucide，不出现 🐱📊✅ 等表情符号。
3. **底部落款（必须）**：页面最底部固定一行小字，居中小字号：

   ```html
   <div class="footer">子谦国际 OPC 创业基础</div>
   ```

4. **成果物对齐**：HTML 呈现的就是该模块最终要提交的成果物（M1 赛道画像 / M2 HMW问题卡 / M3 产品任务书 / M4 需求文档 / M5 测试报告 / M6 迭代说明 / M7 路演大纲 / M8 项目档案）。

---

## 2. Awwwards 级设计标准

| 维度 | 标准 |
|------|------|
| **创意自由度** | 把浏览器视作交互式艺术画布，跳出传统卡片布局，追求先锋视觉、实验性排版、冲击力文字版式 |
| **视觉系统** | 深色沉浸式背景（如 `#0a0c10`）为主，金色/电光强调色；细网格 + 胶片噪点纹理叠加 |
| **文字版式** | 超大字号标题（clamp 响应式，最大 100px+），可叠加**描边空心字**（`-webkit-text-stroke`）、透明字、渐变字 |
| **布局实验** | 1px 网格缝卡片墙、交错网格、放射光晕、大引用块（Georgia 引号）、编号章节（01/02/03） |
| **动效** | 滚动入场渐显（IntersectionObserver + `.reveal`）、按钮悬浮上浮+光晕、浮动提示动画；物理感缓动（cubic-bezier） |
| **交互细节** | 按钮/卡片 hover 变换、表格行悬停高亮、证据级别标签（E1/E2）、局部吸顶导航 |
| **沉浸统一** | 全屏 hero + 网格背景渐隐蒙版；整页风格统一，无割裂 |
| **响应式** | 移动端单列、导航收敛、字号 clamp 自适应 |

**配色基调**（可微调，风格统一即可）：
- 背景 `#0a0c10`、卡片 `#11141a`
- 主文字 `#f4efe6`、次要 `#8b8f98`
- 强调金 `#e8b34b`、辅助蓝 `#4a90d9`
- 分隔线 `rgba(244,239,230,.1)`

---

## 3. 通用 HTML 骨架（每个 Skill 按成果物填充）

```html
<!DOCTYPE html>
<html lang="zh">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{成果物名}｜{产品/赛道名}</title>
<script src="https://unpkg.com/lucide@latest"></script>
<style>
  :root{--bg:#0a0c10;--ink:#f4efe6;--dim:#8b8f98;--line:rgba(244,239,230,.1);--accent:#e8b34b;--accent-2:#4a90d9;--card:#11141a;}
  /* ...Awwwards 级样式（含网格背景/噪点/超大文字/滚动动效）... */
</style>
</head>
<body>
<div class="grid-bg"></div>
<div class="grain"></div>
<nav>…</nav>
<div class="wrap">
  <section class="hero">…</section>
  <section class="section">…成果物内容…</section>
  <footer><div class="brand">{品牌} 子谦国际 OPC 创业基础</div></footer>
</div>
<script>lucide.createIcons(); /* IntersectionObserver 滚动入场 */</script>
</body>
</html>
```

---

## 4. 各模块成果物的 HTML 区块（Block 清单）

| Skill | 区块（section 顺序） |
|-------|-----------------|
| M1 赛道分析 | **全过程报告**：Hero（赛道名超大标题）｜赛道画像五要素（网格缝卡片墙）｜小组定稿理由（大引用块）｜数据来源附录（表+E级标签） |
| M2 真实问题定义 | Hero｜20 条痛点摘要（交错网格/编号）｜深挖版｜选定条目与理由｜HMW问题卡（四字段高亮卡）｜数据附录 |
| M3 方案生成 | Hero｜候选方案（表）｜四维评分与选定（数据卡）｜**三轮共创记录（每轮：人的点子 + AI 受启发想法）**｜产品任务书（表）｜创新点 |
| M4 需求梳理 | Hero｜产品形态（醒目标签）｜八大字段（编号分区：背景/用户/功能/流程/字段/视觉/非功能/验收标准）｜MIAODA 粘贴版 |
| M5 AI 模拟测试 | Hero｜测试任务｜模拟画像遍历（+/？/−/！）｜**四象限便利贴画布**｜需求挖掘（L1-L4）｜问题分类统计表｜总结（无迭代建议） |
| M6 迭代执行 | Hero｜待决策清单｜修改方案｜发现→修改对照表｜**秒哒可复制指令**（编号文字）｜回归验收清单 |
| M7 路演生成 | Hero｜7 页路演大纲（首页+六段卡片，含迭代计划）｜演讲稿底稿｜演示动线（注：M7 另用 dashi-ppt 生成正式 PPT，此 HTML 为大纲版） |
| M8 资产整理 | Hero｜**1.基本信息（含产品截图）**｜2.时间线｜3.成果物清单｜4.关键决策记录｜5.方法论（人提交）｜6.个人成长（4F 反思，人提交）——六大部分，尽量详细呈现人做选择与决策的关键内容（理由、Yes and 点子） |

---

## 5. 触发与交付

- **触发**：D 定稿后，AI 主动询问"是否需要导出为 HTML？"；或用户说「导出 HTML」「做成文件」时执行。
- **交付**：输出**完整可运行的 HTML 代码**（不是示意图），提示用户保存为 `{成果物名}.html` 打开。
- **底部落款**：任何情况下不得遗漏「子谦国际 OPC 创业基础」。
