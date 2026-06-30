# 功能添加指南 - 安全且快速的方式

## 当前系统中的所有函数

- `showPage()` - 页面切换
- `switchTab()` - 标签页切换
- `handleFileInput()` - 文件输入处理
- `handleFile()` - 单个文件处理
- `updateResult()` - 上传结果显示
- `processAndEnter()` - 数据提取和进入 Dashboard
- `recalculate()` - 重新计算所有分析

## 使用脚本添加功能

### 1. 查看某个函数的代码

```bash
python3 add_feature.py --show-function processAndEnter
python3 add_feature.py --show-function recalculate
```

### 2. 修改某个函数

```bash
# 步骤 1: 创建新代码文件
cat > new_processAndEnter.js << 'ENDCODE'
  // 你的新代码
  console.log("新的 processAndEnter");
ENDCODE

# 步骤 2: 应用到 HTML
python3 add_feature.py --update-function processAndEnter new_processAndEnter.js
```

### 3. 添加 CSS 样式

```bash
# 创建样式文件
cat > new_styles.css << 'ENDCSS'
.my-new-style {
  color: red;
}
ENDCSS

# 添加到 HTML
python3 add_feature.py --add-styles new_styles.css
```

## 现在你想要什么功能？

告诉我：
1. **你想修改哪个函数？** (showPage, processAndEnter, recalculate 等)
2. **你想加什么功能？** (图表、警告框、多年对比等)
3. **我会给你生成那个函数的代码，你审查后，我用脚本安全地应用**

这样不会丢失其他功能！
