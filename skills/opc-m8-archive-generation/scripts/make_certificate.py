# -*- coding: utf-8 -*-
"""OPC 学习证书生成：在证书底图上叠印文字，输出 PNG（与底图同分辨率 3508x2481，300dpi）。

用法：
  python make_certificate.py --school 某某大学 --name 张三 [--out "学习证书-张三.png"] [--date 2026年10月4日]

说明：
  - 底图：../assets/certificate-template.png（子谦国际证书底图，含标题与签章，本脚本不修改底图内容）
  - 文字固定模板：兹证明 {学校}　{姓名} 于 {yyyy年m月d日} 完成OPC创业基础课程（M1–M8）的学习与实践。特发此证，以资证明。
  - 文字位置已按底图标定：正文块位于标题区下方留白处，水平居中，楷体。
"""
import argparse
import os
import sys
import time
from datetime import date

import numpy as np
from PIL import Image, ImageDraw, ImageFont

HERE = os.path.dirname(os.path.abspath(__file__))
TEMPLATE = os.path.normpath(os.path.join(HERE, "..", "assets", "certificate-template.png"))

FONT_CANDIDATES = [
    r"C:\Windows\Fonts\simkai.ttf",   # 楷体
    r"C:\Windows\Fonts\simfang.ttf",  # 仿宋
    r"C:\Windows\Fonts\msyh.ttc",     # 微软雅黑
    r"C:\Windows\Fonts\simhei.ttf",   # 黑体
]

# 标定常量（相对底图尺寸，底图更换时按百分比微调）
FONT_RATIO = 0.024          # 正文字号 = 底图宽 * 比例
TEXT_COLOR = (60, 60, 60)
UNDERLINE_COLOR = (47, 125, 107)   # 姓名/学校下划线（子谦绿）
MAX_WIDTH_RATIO = 0.76      # 每行最大宽度占底图宽比例
BLOCK_CENTER_Y = 0.50       # 文字块中心高度：页面正中


def load_font(size):
    for p in FONT_CANDIDATES:
        if os.path.exists(p):
            try:
                return ImageFont.truetype(p, size)
            except Exception:
                continue
    return ImageFont.load_default()


def layout_lines(text, font, max_w, draw):
    """整段放得下就一行；否则按固定语义拆行：兹证明…／于…实践。／特发此证…。"""
    if draw.textlength(text, font=font) <= max_w:
        return [text]
    m1 = " 完成OPC创业基础课程"
    m2 = "特发此证"
    i1 = text.find(m1)
    i2 = text.find(m2)
    if i1 > 0 and i2 > i1:
        return [text[:i1].strip(), text[i1:i2].strip(), text[i2:].strip()]
    # 兜底：贪心按宽断行
    lines, cur = [], ""
    for ch in text:
        if draw.textlength(cur + ch, font=font) > max_w:
            lines.append(cur)
            cur = ch
        else:
            cur += ch
    if cur:
        lines.append(cur)
    return lines


def find_title_bottom(img_gray):
    """自动定位底图顶部标题区（证书/CERTIFICATE）的下缘。"""
    try:
        a = np.asarray(img_gray)
        H, W = a.shape
        dark = a < 100
        rows = [y for y in range(int(H * 0.05), int(H * 0.40))
                if dark[y, int(W * 0.20):int(W * 0.80)].mean() > 0.01]
        if rows:
            return rows[-1]
    except Exception:
        pass
    return None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--school", required=True, help="学校名称")
    ap.add_argument("--name", required=True, help="学生姓名")
    ap.add_argument("--date", default=None, help="完成日期，格式 yyyy年m月d日，默认当天")
    ap.add_argument("--product", default=None, help="产品名称（数智产品名）；缺省则证书不含该句")
    ap.add_argument("--out", default=None, help="输出 PNG 路径，默认 学习证书-<姓名>.png")
    a = ap.parse_args()

    d = a.date or f"{date.today().year}年{date.today().month}月{date.today().day}日"

    img = Image.open(TEMPLATE).convert("RGB")
    W, H = img.size
    draw = ImageDraw.Draw(img)

    fs_body = max(28, int(W * FONT_RATIO))
    font_body = load_font(fs_body)
    max_w = W * MAX_WIDTH_RATIO

    # 文字布局（2026-10-04 依用户参考样张定稿）：
    #   第 1 行：学校姓名（加大加粗，整条下划线，无"兹证明"）
    #   第 2 行：于{日期}完成OPC创业基础课程（M1–M8）的学习与实践，
    #   第 3 行：并开发出{产品名}数智产品。
    #   第 4 行：特发此证，以资证明。
    line1 = f"{a.school}{a.name}"
    if a.product:
        rows_body = [f"于{d}完成OPC创业基础课程（M1–M8）的学习与实践，",
                     f"并开发出{a.product}数智产品。",
                     "特发此证，以资证明。"]
    else:
        rows_body = [f"于{d}完成OPC创业基础课程（M1–M8）的学习与实践。",
                     "特发此证，以资证明。"]

    fs_name = int(fs_body * 1.35)
    while fs_name > fs_body and draw.textlength(line1, font=load_font(fs_name)) > max_w:
        fs_name -= 3  # 超长校名+姓名时逐步缩小，最低缩到正文字号
    font_name = load_font(fs_name)
    sw_name = max(2, int(fs_name * 0.028))  # 楷体无粗体，用同色描边模拟加粗

    h1 = int(fs_name * 1.3)    # 行 1 占位（含下划线空间）
    h2 = int(fs_body * 0.4)    # 行距
    block = h1 + h2 + int(fs_body * 1.9) * len(rows_body)

    tb = find_title_bottom(img.convert("L"))
    y0 = int(H * BLOCK_CENTER_Y) - block // 2
    if tb and y0 <= tb + int(H * 0.02):
        y0 = tb + int(H * 0.02)  # 安全兜底：不许顶到标题

    w1 = draw.textlength(line1, font=font_name)
    draw.text(((W - w1) / 2, y0), line1, font=font_name, fill=TEXT_COLOR,
              stroke_width=sw_name, stroke_fill=TEXT_COLOR)
    y_u = y0 + int(fs_name * 1.18)
    pad = int(fs_name * 0.3)
    draw.line([((W - w1) / 2 - pad, y_u), ((W + w1) / 2 + pad, y_u)],
              fill=UNDERLINE_COLOR, width=max(4, int(fs_name * 0.05)))

    y_row = y0 + h1 + h2
    for ln in rows_body:
        w = draw.textlength(ln, font=font_body)
        draw.text(((W - w) / 2, y_row), ln, font=font_body, fill=TEXT_COLOR)
        y_row += int(fs_body * 1.9)

    out = a.out or f"学习证书-{a.name}.png"
    tmp = out + ".part"
    img.save(tmp, "PNG")
    for _ in range(8):  # 目标文件可能正被图片查看器占用，等它释放
        try:
            os.replace(tmp, out)
            print(os.path.abspath(out))
            break
        except OSError:
            time.sleep(0.5)
    else:
        print(os.path.abspath(tmp) + "（目标被占用，内容已写到 .part 文件）")


if __name__ == "__main__":
    main()
