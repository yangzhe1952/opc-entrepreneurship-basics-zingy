# OPC 创业基础课 · 8 个 Skill 安装包

**opc-entrepreneurship-basics-zingy** — OPC（One Person Company）创业基础课的全套人机协同 Skill，覆盖 M1–M8 八个教学模块。

## 包含的 Skill

| Skill | 模块 | 输入 → 输出 | 使用主体 |
|-------|------|-------------|----------|
| opc-m1-track-analysis | M1 赛道分析 | 行业 → 赛道画像 + 20 细分领域 | 小组 |
| opc-m2-track-profile | M2 细分领域分析 | 细分领域 → 20 条痛点摘要 → 1 条 HMW | 个人 |
| opc-m3-solution-design | M3 方案生成 | HMW → 4–6 候选方案 → 3 核心功能 | 个人 |
| opc-m4-requirements | M4 需求梳理 | 产品任务书 → 七大字段需求文档 | 个人 |
| opc-m5-ai-testing | M5 AI 模拟测试 | 产品链接 → AI 测试报告 | 个人 |
| opc-m6-iteration | M6 迭代执行 | 测试反馈 → V0.2 迭代说明 | 个人 |
| opc-m7-pitch | M7 路演生成 | 前序成果物 → 路演 PPT 大纲 | 个人 |
| opc-m8-assets | M8 资产整理 | M1–M7 → 项目档案 + 反思 | 个人 |

## 设计理念

- **人机协同**：每个 Skill = 分段生成 + 人机多轮交互（A 开场收集 / B 中间选择 / C 反馈修正 / D 确认定稿）
- **AI 只做执行层，人做判断层**：AI 检索/生成/整理，人选择/判断/创造/反思；AI 不替人决策，最终由人落笔署名
- **强制联网检索**：M1/M2 需联网获取真实市场/用户数据，证据分级 E1/E2/E3，数据可追溯

## 快速安装（新电脑）

**方法一（推荐）**：解压后双击运行安装脚本

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1
```

- 默认（`-Target auto`）同时安装到 `~\.agents\skills` 和 `~\.claude\skills`
- 只用 opencode：`-Target agents`
- 只用 Claude Code：`-Target claude`

**方法二（手动）**：把 `skills\` 里的 8 个文件夹复制到 `~\.agents\skills\`（或 `~\.claude\skills\`）即可。

安装完成后**重启 opencode / Claude Code**，skill 生效。

## 依赖说明

- M1/M2/M3 需要 **WebSearch / WebFetch** 能力（联网检索真实数据）
- 无需安装任何第三方包；skill 自带 references 与 examples

## 来源

设计文档：`E:\05opencode\OPC-Skills\`（8个Skill工作流设计V1/V2、Skill人机交互设计V1、成果物模拟演示）
