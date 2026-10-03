# OPC 创业基础课 · 技能包（M1–M8）

给「子谦国际 OPC 创业基础课」用的一套人机协同教学智能体。8 个模块，从选赛道到结课归档，每个模块产出一份可提交的 HTML 成果物。

**核心理念**：AI 只做检索、分析与生成；**判断、选择、定稿、反思全部由人完成**。AI 绝不替学生推荐唯一赛道、不给唯一答案、不代写反思。

---

## 版本与生效副本（先看这一段）

| 位置 | 说明 |
|------|------|
| 用户主目录里的 `skills` 目录（位于隐藏文件夹 `.agents` 内，本机形如 `C:\Users\你的用户名` 下面的那个） | **实际生效副本**。智能体真正加载的就是这里。 |
| 本仓库 | **它的镜像**。发布流程是「生效副本 → 仓库」，不是反过来。 |

**维护规则**：改内容请改生效副本，然后跑 `release.ps1` 同步回仓库。**不要**直接改仓库再安装——那会用旧内容覆盖你的新改动。

> 历史教训：本仓库曾经落后生效副本 5 个版本（仓库 v2.1 小组版 vs 生效 v2.6 单人版）。而旧版 `install.ps1` 会**静默删除**目标目录再覆盖，跑一次安装就把新版降级回去了。现在 `install.ps1` 默认**备份后跳过**，需要覆盖必须显式加 `-Force`。

---

## 安装

### 方式一：在线（推荐）

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "& { iwr https://raw.githubusercontent.com/yangzhe1952/opc-entrepreneurship-basics-zingy/master/install.ps1 -UseBasicParsing | iex } -Source github"
```

脚本会自动判断：定位不到本地 `skills\` 目录时自动切到 github 源，所以 `irm | iex` 这类写法也不会报错。

### 方式二：离线（本机已解压）

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1
```

### 参数

| 参数 | 取值 | 说明 |
|------|------|------|
| `-Source` | `auto`（默认）/ `github` / `local` | 安装源 |
| `-Repo` / `-Branch` | 默认 `yangzhe1952/opc-entrepreneurship-basics-zingy` / `master` | 仓库与分支 |
| `-Target` | `auto`（默认）/ `agents` / `claude` / `workbuddy` / `custom:绝对路径` | 安装到哪 |
| `-Force` | 开关 | 覆盖已存在的同名目录（默认**不覆盖**，只备份） |
| `-NoBackup` | 开关 | 关闭自动备份（不推荐） |

安装后**重启** opencode / Claude Code / WorkBuddy / PI-Desktop 才会加载。

---

## 包含什么

```
opc-m1-track-analysis/          M1 赛道分析
opc-m2-problem-definition/      M2 问题定义（痛点 → HMW 问题卡）
opc-m3-solution-design/         M3 方案设计（产品任务书）
opc-m4-requirements-analysis/   M4 需求分析（八大字段 + 秒哒/WorkBuddy 双提示词）
opc-m5-product-testing/         M5 产品测试（双源四象限）
opc-m6-product-iteration/       M6 产品迭代（V0.2 修改说明）
opc-m7-product-pitch/           M7 产品路演（8 页 HTML PPT）
opc-m8-archive-generation/      M8 档案生成（项目档案 + 反思 + 学习证书）
```

每个模块自包含：`references\`（规范与模板）、`examples\`（示例）随模块一起安装，**不依赖任何公共目录**——单独安装任意一个模块都能正常使用。M8 另带 `assets\`（证书底图）与 `scripts\`（证书生成脚本）。

每个模块的产物：

| 模块 | 产物 |
|------|------|
| M1 | 《OPC 赛道画像》（五要素）+ 行业分析报告 + 备选赛道清单 |
| M2 | 20 条 [用户+场景→痛点] 摘要 + 《HMW 问题卡》 |
| M3 | 《产品任务书》（产品名 + 3 核心功能 + 创新点） |
| M4 | 结构化需求文档（八大字段）+ 秒哒 / WorkBuddy 两套生成提示词 |
| M5 | 《产品测试报告》（AI 模拟 + 真实用户双源，四象限） |
| M6 | V0.2 迭代修改说明 + 秒哒或 WorkBuddy 可复制指令 + 回归验收清单 |
| M7 | 8 页路演 HTML PPT + 演讲稿底稿 |
| M8 | 《OPC 项目档案》HTML（含 M1–M7 二级页面 + 反思）+ 学习证书 PNG |

---

## 三个关键机制

### 1. 人做判断（越界红线）

每个模块都有明确的**越界红线**：AI 不替人选赛道、不替人选方案、不替人决定改什么、不代写反思与理由。AI 产出候选与草稿，**选择、修改、定稿必须由学生完成**——产物必须"像这个人做的"。

### 2. 反思闸门（对话内硬规则）

M1–M7 每个模块定稿后、生成 HTML 前，AI 必须**原样提出固定反思问题**（一级标题加粗）：

> **请写下本模块最大的收获**

并附小提示：*完成每个模块的内容和反思，在课程结束时可以获得学习证书*。

**学生没回答，就真的生成不了 HTML**——这是写进每个模块的硬约束，不是提示。M8 的方法选择理由与 4F 反思（Facts / Feelings / Findings / Future）必须**由人书写并先提交**，提交完成才生成最终档案。

### 3. M8 学习证书自动生成

项目档案定稿后，M8 自动校验完成条件（M1–M8 八个 HTML 齐、所有反思已填、姓名与学校已知），**缺任何一项列出清单提醒补充**；条件满足即在证书底图上叠印文字，生成 300dpi 的 `学习证书-<姓名>.png`（与档案同目录），并自动打开所在文件夹。

---

## 可选依赖（不随包分发）

| 用途 | 获取方式 |
|------|----------|
| M7 路演 PPT · 方案 B（dashi-ppt） | `npx --registry=https://registry.npmmirror.com dashi-ppt-skill@latest`，或 https://github.com/chuspeeism/dashi-ppt-skill |
| M7 路演 PPT · 方案 C（guizang-ppt） | https://github.com/op7418/guizang-ppt-skill |
| 无联网 / 不想装依赖 | **方案 A**：内置 16:9 翻页模板，纯 HTML 单文件，开箱即用（B/C 下载失败时会自动回退到 A） |

需要 Node 20+ 与 Chrome/Edge（导出 PPTX/PDF 时）。

---

## 常见问题

**装完没反应？** 重启宿主应用（opencode / Claude Code / WorkBuddy / PI-Desktop）。

**只装了单个模块？** 没问题——每个模块都自包含，单独装也能正常用。

**AI 直接跳过反思生成了 HTML？** 那是违反设计，应当要求它补反思重做；各模块自检清单里有对应检查项。

**HTML 打开是乱码？** 保存时编码没选 UTF-8。记事本 → 文件 → 另存为 → 编码选 UTF-8（推荐用 VS Code）。

**PowerShell 脚本中文乱码？** 本包的 `.ps1` 都是 **UTF-8 with BOM**——PowerShell 5.1 会把无 BOM 的 UTF-8 当 ANSI 读，导致解析错误。修改脚本时请保留 BOM。

---

## 许可与致谢

内部教学使用。
