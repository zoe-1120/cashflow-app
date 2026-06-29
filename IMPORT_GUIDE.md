# 📥 导入财务数据指南 · Import Data Guide

## 功能概览

你现在有了**完整的文件上传和数据导入系统**！

### ✨ 新增功能

✅ **Excel 文件上传** - 支持 .xlsx 格式（Bank Book）
✅ **CSV 文件上传** - 支持 .csv 格式（交易列表）
✅ **自动字段识别** - 智能匹配财务数据字段
✅ **两种部署方式** - Vercel（免费）+ 本地 Ruby（完整功能）

---

## 🚀 如何使用

### 本地使用（完整功能）

```bash
cd /Users/switch/Documents/MY\ CODING/cashflow-app
ruby server.rb
```

然后打开：
- **首页菜单**: http://localhost:3456/
- **数据导入页**: http://localhost:3456/import ← **新功能**
- **Executive Dashboard**: http://localhost:3456/boss
- **Live Monitor**: http://localhost:3456/monitor

### 步骤

1. **点击首页的"导入财务数据"按钮**
   ```
   📥 导入财务数据 · IMPORT DATA
   ```

2. **上传 Excel 或 CSV 文件**
   - 拖放到上传区，或点击选择
   - 支持格式：.xlsx, .csv

3. **查看数据预览**
   - 前3行数据会显示在页面上

4. **自动提取关键字段**
   - 系统自动识别：公司名、期间、现金、应收、库存等
   - 可手动修改或补充数据

5. **前往 Dashboard**
   - 点击"前往 Dashboard"按钮
   - 跳转到 Executive Dashboard
   - 手动复制粘贴数据到对应字段

---

## 📋 支持的文件格式

### Excel 格式 (.xlsx)

```
Company | Period | Cash | Overdraft | Receivables | Inventory | ...
```

**标准列名**：
- 公司 / Company
- 期间 / Period
- 现金 / Cash / Bank
- 透支 / Overdraft
- 应收 / Receivables
- 库存 / Inventory
- 应付 / Payables
- 成本 / COGS / Cost
- 等等

**注意**：列名可以是英文或中文，系统会自动识别

### CSV 格式 (.csv)

```csv
Company,Period,Cash,Overdraft,Receivables,Inventory,Payables
My Company,MA 2026,500000,0,50000,100000,25000
```

---

## 🌐 Vercel 部署（导入功能）

导入功能**完全基于 JavaScript**，不需要服务器，可以直接在 Vercel 上使用！

### 特点

✅ 在浏览器中解析文件（不上传到服务器）
✅ 支持 Excel 和 CSV
✅ 免费部署到 Vercel
✅ 完全离线可用（除了加载JS库）

### 部署步骤

1. 确保文件已推送到 GitHub：
   ```bash
   git push origin main
   ```

2. 在 Vercel 中部署（之前已做过）

3. 访问 Vercel URL 的 `/import` 页面
   ```
   https://your-domain.vercel.app/import
   ```

4. 直接在浏览器上传文件，自动解析！

---

## 🔄 工作流程

### 完整流程示例

```
1. 从银行下载交易数据 (CSV 或 Excel)
                  ↓
2. 打开 /import 页面
                  ↓
3. 拖放或上传文件
                  ↓
4. 查看数据预览
                  ↓
5. 复制提取的关键数据
                  ↓
6. 前往 Dashboard /boss
                  ↓
7. 在 "Live Input" 标签页粘贴数据
                  ↓
8. 所有6个标签页自动更新！
```

---

## 💡 最佳实践

### 数据准备

**格式标准化**：
- 日期格式：YYYY-MM-DD（如果有）
- 数字：不包含货币符号（如 RM）
- 列名：英文或中文都可以

**常见文件类型**：
- Bank Book（银行对账单）→ Excel
- 交易日记 → CSV
- 月度财务表 → Excel

### 字段映射

系统自动识别这些字段：
```
company     → 公司名称
period      → 报告期间
cash        → 现金/银行
od          → 银行透支
rec         → 应收账款
inv         → 库存
pay         → 应付账款
equity      → 股东权益
ltl         → 长期贷款
stl         → 短期贷款
rev         → 营业收入
cogs        → 货物成本
adm         → 行政费用
fin         → 财务费用
```

---

## 🎯 两个版本对比

| 功能 | Vercel 版本 | 本地版本 |
|------|-----------|---------|
| Executive Dashboard | ✅ 可用 | ✅ 可用 |
| 文件导入（Excel/CSV） | ✅ 可用 | ✅ 可用 |
| Live Monitor | ❌ 无法用 | ✅ 可用 |
| 离线使用 | ⚠️ 需要CDN | ✅ 完全离线 |
| 部署成本 | 免费 | 免费（本地）或 Heroku |

---

## ❓ 常见问题

**Q: 上传的文件会被保存吗？**
A: 不会。所有处理都在浏览器端进行，文件不会上传到服务器。

**Q: PDF 支持吗？**
A: 目前不支持，但可以用 Vercel 的免费工具转换为 CSV。

**Q: 支持多文件上传吗？**
A: 目前一次一个，但可以轮流上传多个文件。

**Q: 数据可以自动保存吗？**
A: 可以复制到剪贴板，也可以在 Dashboard 中手动保存。

**Q: 能否与会计软件集成？**
A: 可以将会计软件（如 Xero、QuickBooks）导出为 CSV 后导入。

---

## 🔒 隐私和安全

✅ **所有数据在本地处理** - 不上传到任何服务器
✅ **无服务器日志** - 不记录你的财务数据
✅ **开源代码** - 可以审计和修改
✅ **HTTPS** - Vercel 自动使用 HTTPS 加密

---

## 📚 相关资源

- README.md - 项目概览
- SETUP.md - 完整部署指南
- IMPLEMENTATION_SUMMARY.md - 技术实现细节
- QUICKSTART.txt - 快速开始

---

**版本**: 2.1（加入导入功能）
**更新日期**: June 30, 2026
**状态**: ✅ 生产就绪

