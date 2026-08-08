#!/usr/bin/env python3
"""Markdown → PDF 转换脚本（Designer Skill）"""
import sys
import argparse
from pathlib import Path

try:
    from reportlab.lib.pagesizes import A4
    from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
    from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle
    from reportlab.lib import colors
except ImportError:
    print("ERROR: reportlab not installed. Run: pip install reportlab", file=sys.stderr)
    sys.exit(1)


def md_to_pdf(input_path: str, output_path: str):
    md_file = Path(input_path)
    pdf_file = Path(output_path)
    pdf_file.parent.mkdir(parents=True, exist_ok=True)

    content = md_file.read_text(encoding="utf-8")

    doc = SimpleDocTemplate(str(pdf_file), pagesize=A4,
                            rightMargin=50, leftMargin=50,
                            topMargin=50, bottomMargin=50)

    styles = getSampleStyleSheet()
    h1_style = ParagraphStyle('H1', parent=styles['Heading1'], fontSize=18, spaceAfter=12, textColor=colors.HexColor('#0076CE'))
    h2_style = ParagraphStyle('H2', parent=styles['Heading2'], fontSize=14, spaceAfter=10, textColor=colors.HexColor('#0076CE'))
    body_style = ParagraphStyle('Body', parent=styles['BodyText'], fontSize=10, spaceAfter=8, leading=14)

    story = []
    in_code = False
    code_buffer = []

    for line in content.split('\n'):
        if line.startswith('```'):
            if in_code:
                story.append(Paragraph('<br/>'.join(code_buffer).replace('<', '&lt;').replace('>', '&gt;'), body_style))
                code_buffer = []
                in_code = False
            else:
                in_code = True
            continue
        if in_code:
            code_buffer.append(line)
            continue

        if line.startswith('# '):
            story.append(Paragraph(line[2:].strip(), h1_style))
        elif line.startswith('## '):
            story.append(Paragraph(line[3:].strip(), h2_style))
        elif line.startswith('### '):
            story.append(Paragraph(f"<b>{line[4:].strip()}</b>", body_style))
        elif line.startswith('- ') or line.startswith('* '):
            story.append(Paragraph(f"• {line[2:].strip()}", body_style))
        elif line.strip() == '---':
            story.append(Spacer(1, 12))
        elif line.strip().startswith('|') and line.count('|') > 2:
            # Markdown table - simplified
            cells = [c.strip() for c in line.strip().strip('|').split('|')]
            story.append(Paragraph(' | '.join(cells), body_style))
        elif line.strip():
            story.append(Paragraph(line, body_style))
        else:
            story.append(Spacer(1, 6))

    doc.build(story)
    print(f"PDF generated: {pdf_file}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Convert Markdown to PDF")
    parser.add_argument("--input", "-i", required=True, help="Input markdown file")
    parser.add_argument("--output", "-o", required=True, help="Output PDF path")
    args = parser.parse_args()

    md_to_pdf(args.input, args.output)