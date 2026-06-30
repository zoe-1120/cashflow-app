#!/usr/bin/env python3
"""
安全的 HTML 功能添加脚本
用法：
  python3 add_feature.py --update-function processAndEnter "新代码"
  python3 add_feature.py --add-styles "CSS代码"
  python3 add_feature.py --show-function processAndEnter
"""

import sys
import re

def read_file(path):
    with open(path, 'r', encoding='utf-8') as f:
        return f.read()

def write_file(path, content):
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)

def show_function(content, func_name):
    """显示某个 JavaScript 函数的代码"""
    pattern = rf'function {func_name}\(\).*?(?=\nfunction |\n// |\Z)'
    match = re.search(pattern, content, re.DOTALL)
    if match:
        print(f"✅ 找到函数 {func_name}:\n")
        print(match.group(0)[:500] + "...")
        return True
    print(f"❌ 未找到函数 {func_name}")
    return False

def replace_function(content, func_name, new_code):
    """替换某个函数（只替换函数体）"""
    pattern = rf'(function {func_name}\(\) \{{)(.*?)(\n\}}'
    
    if not re.search(pattern, content, re.DOTALL):
        print(f"❌ 未找到函数 {func_name}")
        return content
    
    new_content = re.sub(
        pattern,
        rf'\1\n{new_code}\n\3',
        content,
        flags=re.DOTALL
    )
    
    print(f"✅ 已更新函数 {func_name}")
    return new_content

def add_styles(content, css_code):
    """在 <style> 标签中添加 CSS"""
    if '</style>' not in content:
        print("❌ 未找到 </style> 标签")
        return content
    
    new_content = content.replace(
        '    </style>',
        f'    {css_code}\n    </style>'
    )
    print("✅ 已添加 CSS 样式")
    return new_content

def main():
    html_file = '/Users/switch/Documents/MY\ CODING/cashflow-app/index.html'
    content = read_file(html_file)
    
    if len(sys.argv) < 2:
        print("用法: python3 add_feature.py [选项]")
        print("\n选项:")
        print("  --show-function <名称>           显示某个函数的代码")
        print("  --update-function <名称> <文件>  从文件更新函数")
        print("  --add-styles <文件>              添加 CSS 代码")
        print("  --list-functions                 列出所有函数")
        return
    
    if sys.argv[1] == '--show-function' and len(sys.argv) > 2:
        show_function(content, sys.argv[2])
    
    elif sys.argv[1] == '--list-functions':
        funcs = re.findall(r'function (\w+)\(\)', content)
        print("✅ 找到以下 JavaScript 函数:")
        for func in funcs:
            print(f"  - {func}()")
    
    elif sys.argv[1] == '--update-function' and len(sys.argv) > 3:
        func_name = sys.argv[2]
        code_file = sys.argv[3]
        try:
            with open(code_file, 'r', encoding='utf-8') as f:
                new_code = f.read()
            content = replace_function(content, func_name, new_code)
            write_file(html_file, content)
            print(f"💾 已保存到 {html_file}")
        except FileNotFoundError:
            print(f"❌ 找不到文件 {code_file}")
    
    elif sys.argv[1] == '--add-styles' and len(sys.argv) > 2:
        css_file = sys.argv[2]
        try:
            with open(css_file, 'r', encoding='utf-8') as f:
                css_code = f.read()
            content = add_styles(content, css_code)
            write_file(html_file, content)
            print(f"💾 已保存到 {html_file}")
        except FileNotFoundError:
            print(f"❌ 找不到文件 {css_file}")
    
    else:
        print("❌ 不认识的选项")

if __name__ == '__main__':
    main()
