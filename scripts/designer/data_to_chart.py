#!/usr/bin/env python3
"""数据 → 图表生成脚本（Designer Skill）"""
import sys
import argparse
from pathlib import Path

try:
    import matplotlib
    matplotlib.use('Agg')
    import matplotlib.pyplot as plt
    import pandas as pd
except ImportError:
    print("ERROR: matplotlib/pandas not installed. Run: pip install matplotlib pandas", file=sys.stderr)
    sys.exit(1)


CHART_TYPES = ['line', 'bar', 'scatter', 'pie']


def data_to_chart(input_path: str, output_path: str, chart_type: str = 'line',
                  x_col: str = None, y_col: str = None, title: str = ""):
    df = pd.read_csv(input_path)
    chart_file = Path(output_path)
    chart_file.parent.mkdir(parents=True, exist_ok=True)

    plt.figure(figsize=(12, 6))
    plt.style.use('seaborn-v0_8-whitegrid')

    if chart_type == 'line':
        if x_col and y_col:
            plt.plot(df[x_col], df[y_col], marker='o', linewidth=2, color='#0076CE')
            plt.xlabel(x_col)
            plt.ylabel(y_col)
        else:
            for col in df.select_dtypes(include='number').columns:
                plt.plot(df.index, df[col], marker='o', label=col, linewidth=2)
            plt.legend()
    elif chart_type == 'bar':
        if x_col and y_col:
            plt.bar(df[x_col], df[y_col], color='#0076CE')
            plt.xlabel(x_col)
            plt.ylabel(y_col)
            plt.xticks(rotation=45)
        else:
            df.plot(kind='bar')
    elif chart_type == 'scatter':
        if x_col and y_col:
            plt.scatter(df[x_col], df[y_col], color='#0076CE', alpha=0.7)
            plt.xlabel(x_col)
            plt.ylabel(y_col)
    elif chart_type == 'pie':
        if y_col:
            plt.pie(df[y_col], labels=df[x_col] if x_col else df.index, autopct='%1.1f%%')

    if title:
        plt.title(title, fontsize=14, fontweight='bold')

    plt.tight_layout()
    plt.savefig(chart_file, dpi=150, bbox_inches='tight')
    plt.close()
    print(f"Chart generated: {chart_file}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate chart from data")
    parser.add_argument("--input", "-i", required=True, help="Input CSV file")
    parser.add_argument("--output", "-o", required=True, help="Output PNG path")
    parser.add_argument("--type", "-t", choices=CHART_TYPES, default='line', help="Chart type")
    parser.add_argument("--x", help="X column name")
    parser.add_argument("--y", help="Y column name")
    parser.add_argument("--title", help="Chart title")
    args = parser.parse_args()

    data_to_chart(args.input, args.output, args.type, args.x, args.y, args.title)