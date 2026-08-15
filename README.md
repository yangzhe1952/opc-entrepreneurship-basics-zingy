# OPC 创业基础课 · 8 个 Skill 安装包

**opc-entrepreneurship-basics-zingy** — OPC（One Person Company）创业基础课的全套人机协同 Skill，覆盖 M1–M8 八个教学模块。

## 包含的 Skill（v0.7 · 已对齐 2026-08 最新版）

| Skill | 模块 | 输入 → 输出 | 使用主体 |
|-------|------|-------------|----------|
| opc-m1-track-analysis | M1 赛道分析 | 行业 → 行业分析报告 → 备选赛道 → **赛道画像（五要素）** | 小组 |
| opc-m2-track-profile | M2 真实问题定义 | 赛道画像 → 赛道深度分析 → 真实语料 → **20 条痛点** → **HMW 问题卡** | 个人 |
| opc-m3-solution-design | M3 方案生成 | HMW → 4–6 候选方案（四维评分）→ **3 核心功能（产品任务书）** | 个人 |
| opc-m4-requirements | M4 需求梳理 | 产品任务书 → 10 题探索 → **八大字段需求文档**（可交秒哒） | 个人 |
| opc-m5-ai-testing | M5 产品测试 | 产品链接 → AI 模拟测试 + **人测试** → **双源四象限测试报告** | 个人 |
| opc-m6-iteration | M6 迭代执行 | 测试反馈 → 人决策 → **V0.2 迭代说明 + 秒哒指令** | 个人 |
| opc-m7-pitch | M7 路演生成 | 前序成果物 → **6 页路演 PPT**（整合 Dashi PPT） | 个人 |
| opc-m8-assets | M8 资产整理 | M1–M7 → **HTML 项目档案 + 个人反思** | 个人 |

## 设计理念

- **人机协同**：每个 Skill = 分段生成 + 人机多轮交互（A 开场收集 / B 中间选择 / C 反馈修正 / D 确认定稿）
- **AI 只做执行层，人做判断层**：AI 检索/生成/整理，人选择/判断/创造/反思；AI 不替人决策，最终由人落笔署名
- **强制联网检索**：M1/M2/M3 需联网获取真实数据，证据分级 E1/E2/E3，数据可追溯
- **HTML 成果物 Awwwards 级**：所有模块定稿后导出精美 HTML（Lucide 图标、深色沉浸风、滚动动效），底部落款「子谦国际 OPC 创业基础」

## 快速安装（新电脑 / WorkBuddy）

**方法一（推荐）**：解压后双击运行安装脚本

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1
```

- 默认（`-Target auto`）同时安装到 `~\.agents\skills` 和 `~\.claude\skills`
- 只用 opencode：`-Target agents`
- 只用 Claude Code：`-Target claude`
- WorkBuddy / Marvis / 其他 Agent：skill 文件放在任意位置、读取 `SKILL.md` 即可——解压后把 `skills\` 里的 8 个文件夹放到你的 agent 的 skills 目录即可

**方法二（手动）**：把 `skills\` 里的 8 个文件夹复制到对应 skills 目录即可。

安装完成后**重启 opencode / Claude Code / WorkBuddy**，skill 生效。

## 额外依赖

- **M7 路演 PPT（Dashi PPT）**：`opc-m7-pitch` 会调用 `dashi-ppt` skill 生成浏览器可编辑的 HTML 路演 PPT。需单独安装：
  ```
  npx --registry=https://registry.npmmirror.com dashi-ppt-skill@latest
  ```
  （装到 `~/.agents/skills/dashi-ppt`；导出 PPTX/PDF 需本机 Chrome/Edge + Node 20+）
- M1/M2/M3 需要 **WebSearch / WebFetch** 能力（联网检索真实数据）

## 来源

设计文档与全部成果物：`E:\05opencode\OPC-Skills\`
