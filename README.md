# OPC 创业基础课 · 技能包（M1–M8）

「子谦国际 OPC 创业基础」课程的 8 个人机协同教学智能体。学生在一学期里走完一条完整的创业行动链：选赛道 → 定义真实问题 → 设计方案 → 需求分析 → 产品测试 → 产品迭代 → 产品路演 → 结课归档。每个模块产出一份可直接提交的 HTML 成果物，结课自动生成学习证书。

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
| M8 档案生成 | 汇总全部成果，方法由 AI 复盘备选、学生选择 | 《项目档案》+ 学习证书 PNG |

## 安装

前置：Windows 自带 PowerShell 即可；装完**重启**你使用的宿主应用（opencode / Claude Code / WorkBuddy / PI-Desktop）才会加载。

### 一键安装全部模块

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "iwr https://raw.githubusercontent.com/yangzhe1952/opc-entrepreneurship-basics-zingy/master/install.ps1 -UseBasicParsing | iex"
```

### 只安装某一个模块

把 `-Only m4` 换成想要的模块编号（m1–m8；多个用英文逗号，如 `-Only m1,m4`）：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "& ([scriptblock]::Create((iwr https://raw.githubusercontent.com/yangzhe1952/opc-entrepreneurship-basics-zingy/master/install.ps1 -UseBasicParsing))) -Only m4"
```

### 本地安装（已下载/解压本仓库时）

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1 -Only m4   # 单个模块
powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1            # 全部模块
```

| 参数 | 说明 |
|------|------|
| `-Only m4` / `-Only m1,m4` | 只装指定模块（默认装全部 8 个） |
| `-Target` | 安装位置：`auto`（默认，装到 `.agents\skills` 和 `.claude\skills`）/ `agents` / `claude` / `workbuddy` / `custom:<绝对路径>` |
| `-Force` | 覆盖已安装版本（默认自动备份旧版后跳过，防止误覆盖） |

每个模块都是自包含的，可以只装一个、按任意顺序补装或重装；重装同名模块时旧版本会自动备份。

## 怎么用

重启宿主后，对智能体说「开始 M1 赛道分析」即可进入对应模块（各模块都认自己的关键词：问题定义、方案设计、需求分析、产品测试、产品迭代、产品路演、项目档案等）。

- AI 每一步都会停下来等学生做判断；定稿后自动生成 HTML 成果物，并**自动打开所在文件夹**
- M1–M7 每个模块结尾有一道必答反思题；M8 汇总 M1–M7 全部成果生成《项目档案》与学习证书 PNG
- 证书上用到的学校、姓名在 M1 开场时收集，请如实回答

## 可选依赖（默认不需要）

M7 路演 PPT 默认使用内置 16:9 翻页模板（纯 HTML 单文件，开箱即用）。可选开源方案：[dashi-ppt-skill](https://github.com/chuspeeism/dashi-ppt-skill)、[guizang-ppt-skill](https://github.com/op7418/guizang-ppt-skill)（需 Node 20+；下载失败会自动回退内置模板）。

## 常见问题

**装完没反应？** 重启宿主应用再试。

**只装一个模块够用吗？** 够。模块按课程顺序设计，但每个都能独立运行；后续需要时随时补装。

**M8 证书上的信息不对？** 学校、姓名来自 M1 开场收集的回答，产品名来自档案——回对应模块修正后重新生成即可。

**HTML 打开是乱码？** 直接双击用浏览器打开；如用编辑器保存过，请保持 UTF-8 编码。

**PowerShell 脚本报错/乱码？** 本包 .ps1 均为 UTF-8 with BOM，请勿用会去掉 BOM 的编辑器重新保存。

---

内部教学使用 · 子谦国际 OPC 创业基础
