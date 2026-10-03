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
FONT_RATIO = 0.024          # 字号 = 底图宽 * 比例
LINE_HEIGHT_RATIO = 1.8     # 行高 = 字号 * 倍数
TEXT_COLOR = (60, 60, 60)
MAX_WIDTH_RATIO = 0.76      # 每行最大宽度占底图宽比例
GAP_BELOW_TITLE = 0.016     # 正文块顶部与标题区下缘的间距（占底图高）
FALLBACK_TOP = 0.26         # 找不到标题时正文块顶部高度


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
    ap.add_argument("--out", default=None, help="输出 PNG 路径，默认 学习证书-<姓名>.png")
    a = ap.parse_args()

    d = a.date or f"{date.today().year}年{date.today().month}月{date.today().day}日"
    text = f"兹证明 {a.school}　{a.name} 于 {d} 完成OPC创业基础课程（M1–M8）的学习与实践。特发此证，以资证明。"

    img = Image.open(TEMPLATE).convert("RGB")
    W, H = img.size
    draw = ImageDraw.Draw(img)

    fs = max(28, int(W * FONT_RATIO))
    font = load_font(fs)
    lines = layout_lines(text, font, W * MAX_WIDTH_RATIO, draw)

    line_h = int(fs * LINE_HEIGHT_RATIO)
    tb = find_title_bottom(img.convert("L"))
    y0 = (tb + int(H * GAP_BELOW_TITLE)) if tb else int(H * FALLBACK_TOP)
    for i, ln in enumerate(lines):
        w = draw.textlength(ln, font=font)
        draw.text(((W - w) / 2, y0 + i * line_h), ln, font=font, fill=TEXT_COLOR)

    out = a.out or f"学习证书-{a.name}.png"
    img.save(out, "PNG")
    print(os.path.abspath(out))


if __name__ == "__main__":
    main()
