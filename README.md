# OPC 创业基础课 · 技能包（M1–M8）

> ## ⚠️ 本仓库已停止更新：Skill 已迁至 OPC 档案馆
>
> **2026-11-03 起，课程 Skill 统一由子谦服务器（OPC 档案馆）分发**，安装更快、版本更新更及时，不再需要 GitHub。
>
> **新地址：<https://opc.zingyfac.cn/archive/skills>**
>
> - **让 Agent 自己装（最省事）**：把这句话发给 WorkBuddy、Claude Code、Cursor、Codex、ZCode 等任意 Agent——
>   > 请阅读 https://opc.zingyfac.cn/archive/skills/install.md ，按里面的说明把 OPC 创业基础课程的 M1–M8 skill 安装到你的 skills 目录，装好后告诉我版本。
> - **macOS / Linux**：`curl -fsSL https://opc.zingyfac.cn/archive/skills/install.sh | bash`
> - **Windows（PowerShell）**：`irm https://opc.zingyfac.cn/archive/skills/install.ps1 | iex`
> - **整包离线下载**：<https://opc.zingyfac.cn/archive/skills/opc-skills.zip>
> - **版本清单（JSON）**：<https://opc.zingyfac.cn/archive/api/skills>
> - 装到非默认目录时先设 `OPC_SKILLS_DIR`（Windows：`$env:OPC_SKILLS_DIR`）；默认装到 `~/.claude/skills`。
>
> 本仓库的 `install.ps1` 与 `skills/` 目录是 **v2.7（2026-10-04）历史版本**，仅作留档，**不再更新**。

「子谦国际 OPC 创业基础」课程的 8 个人机协同教学智能体。学生在一学期里走完一条完整的创业行动链：选赛道 → 定义真实问题 → 设计方案 → 需求分析 → 产品测试 → 产品迭代 → 产品路演 → 结课归档。每个模块产出一份可直接提交的 HTML 成果物；M8 档案提交 OPC 档案馆评审，合格即由档案馆颁发学习证书。

**核心理念**：AI 只做检索、分析与生成；判断、选择、定稿、反思全部由学生完成——每个模块都划定了"越界红线"，AI 不替学生做任何关键决定。

## 八个模块

| 模块 | 干什么 | 学生拿到 |
|------|--------|----------|
| M1 赛道分析 | 从想法或行业出发，用带数字的行业分析圈定赛道 | 《OPC 赛道画像》+ 全过程报告 |
| M2 问题定义 | 抓真实用户语料，科学筛选痛点并定稿 HMW | 20 条痛点摘要 + 《HMW 问题卡》 |
| M3 方案设计 | 候选方案四维评分 + 三轮 Yes and 共创 | 《产品任务书》（3 个核心功能） |
| M4 需求分析 | 十题深探 → 八大字段需求文档，人逐字段改写 | 需求文档 + 秒哒/WorkBuddy 双提示词 |
| M5 产品测试 | AI 模拟画像遍历 + 真人测试双源分析 | 《产品测试报告》（四象限画布） |
| M6 产品迭代 | 学生决定改不改，AI 出修改方案与回归清单 | V0.2 迭代修改说明 + 可复制指令 |
| M7 产品路演 | 八页路演 PPT，故事必须学生自己写 | 8 页 HTML 路演 PPT + 讲稿底稿 |
| M8 档案生成 | 汇总全部成果，方法由 AI 复盘备选、学生选择 | 《项目档案》+ 档案馆档案链接与学习证书 PNG |

## 安装

**请到档案馆安装：<https://opc.zingyfac.cn/archive/skills>**（一键脚本 / Agent 自装 / 离线 zip 三种方式，说明见上方迁移提示）。

装完**重启**你使用的宿主应用（opencode / Claude Code / WorkBuddy / PI-Desktop）才会加载。

每个模块都是自包含的，可以只装一个、按任意顺序补装或重装。

## 怎么用

重启宿主后，对智能体说「开始 M1 赛道分析」即可进入对应模块（各模块都认自己的关键词：问题定义、方案设计、需求分析、产品测试、产品迭代、产品路演、项目档案等）。

- AI 每一步都会停下来等学生做判断；定稿后自动生成 HTML 成果物，并**自动打开所在文件夹**
- M1–M7 每个模块结尾有一道必答反思题
- M8 汇总 M1–M7 全部成果生成《项目档案》，**档案定稿后自动提交 OPC 档案馆评审**；评审 ≥60 分即由档案馆颁发带编号与验证二维码的学习证书
- **课时由学生不用填**：档案馆按 M1–M8 各成果物的完成时间自动判定（集中完成 8 课时、分散完成 16 课时）
- 证书上用到的学校、姓名在 M1 开场时收集，请如实回答

## 可选依赖（默认不需要）

M7 路演 PPT 默认使用内置 16:9 翻页模板（纯 HTML 单文件，开箱即用）。可选开源方案：[dashi-ppt-skill](https://github.com/chuspeeism/dashi-ppt-skill)、[guizang-ppt-skill](https://github.com/op7418/guizang-ppt-skill)（需 Node 20+；下载失败会自动回退内置模板）。

## 常见问题

**装完没反应？** 重启宿主应用再试。

**从本仓库装还是从档案馆装？** 从档案馆装。本仓库内容停留在 v2.7（2026-10-04），M8 还是本地生成证书的旧流程。

**只装一个模块够用吗？** 够。模块按课程顺序设计，但每个都能独立运行；后续需要时随时补装。

**M8 提交失败？** 需要 Python 3（脚本只用标准库，无需 pip）；没有 Python 时 Skill 会改用 curl 提交。仍失败请按档案馆反馈页反馈。

**HTML 打开是乱码？** 直接双击用浏览器打开；如用编辑器保存过，请保持 UTF-8 编码。

---

内部教学使用 · 子谦国际 OPC 创业基础
