import json
import re
from pathlib import Path
from typing import Optional

from pypdf import PdfReader

PDF_PATH = Path("/Users/titus/Downloads/document_pdf.pdf")
OUTPUT_PATH = Path(__file__).resolve().parents[1] / "assets" / "fines.json"

SECTION_START = re.compile(r"^(c\.s|c\s*\.s|c\.s\.?|C\.S|C\.s|c\.S)")
LEVEL_AMOUNT_RE = re.compile(
    r"^(?P<body>.*?)(?P<level>[123])\s+(?P<amount>\d+\/\d+|\d+|Court|Caution)\s*$"
)


def normalize_line(line: str) -> str:
    line = line.replace("\u2026", " ")
    line = re.sub(r"[·•]+", " ", line)
    line = re.sub(r"\.{2,}", " ", line)
    line = re.sub(r"\s+", " ", line)
    return line.strip()


def is_header_or_footer(line: str) -> bool:
    if not line:
        return True
    if line.isdigit():
        return True
    if "NATIONAL SCHEDULE OF DEPOSIT FINES" in line:
        return True
    if line.startswith("SECTION") or line.startswith("OFFENCE/"):
        return True
    if line.startswith("(US$") or line == "(US$)":
        return True
    if "@" in line and " " in line:
        return True
    if line.startswith("NB:") or line.startswith("Note"):
        return True
    if line.startswith("\u2022") or line.startswith("\uf0a7"):
        return True
    return False


def is_act_line(line: str) -> bool:
    upper = line.upper()
    if "ACT" in upper and "CHAPTER" in upper:
        return True
    if "REGULATIONS" in upper or "REGS" in upper:
        return True
    if upper.startswith("S.I.") or upper.startswith("R.G.N") or upper.startswith("RGN"):
        return True
    return False


def is_group_heading(line: str) -> bool:
    upper = line.upper()
    return upper.endswith("OFFENCES") or upper.endswith("OFFENCE")


def is_letter_heading(line: str) -> Optional[str]:
    m = re.match(r"^([A-Z])\.\s+(.*)$", line)
    if not m:
        return None
    return m.group(2).strip()


def is_upper_heading(line: str) -> bool:
    return line.isupper() and len(line) > 2


def extract_section_and_text(line: str):
    # Normalize common variations
    line = line.replace("C.S", "c.s").replace("C.S.", "c.s")
    tokens = line.split()
    if not tokens:
        return None, line

    first = tokens[0].lower()
    if not first.startswith("c.s"):
        return None, line, False

    section_tokens = [tokens[0]]
    i = 1
    while i < len(tokens):
        tok = tokens[i]
        tok_lower = tok.lower()
        if tok_lower in {"a.r.w", "a.r.w.", "r.w", "or", "and"}:
            section_tokens.append(tok)
            i += 1
            continue
        if any(ch.isdigit() for ch in tok) or any(ch in "()./" for ch in tok):
            section_tokens.append(tok)
            i += 1
            continue
        break

    section = " ".join(section_tokens)
    remainder = " ".join(tokens[i:])
    return section, remainder, True


def make_explanation(offence: str) -> str:
    text = clean_offence(offence)
    if not text:
        return ""
    lower = text.lower()
    if lower.startswith("fail to"):
        return f"This applies when you {lower}."
    if lower.startswith("no "):
        return f"This applies when there is {lower}."
    if lower.startswith("drive"):
        return f"This applies when you {lower}."
    if lower.startswith("permit"):
        return f"This applies when you {lower}."
    if lower.startswith("display"):
        return f"This applies when you {lower}."
    return f"This offence covers: {text}."


def clean_offence(text: str) -> str:
    cleaned = re.sub(r"\s+", " ", text).strip()
    cleaned = re.sub(r"\s+\.", ".", cleaned)
    cleaned = re.sub(r"\.{2,}", ".", cleaned)
    cleaned = cleaned.rstrip(". ")
    return cleaned


def main():
    if not PDF_PATH.exists():
        raise SystemExit(f"PDF not found: {PDF_PATH}")

    reader = PdfReader(str(PDF_PATH))
    raw_text = "\n".join(page.extract_text() or "" for page in reader.pages)
    lines = [normalize_line(ln) for ln in raw_text.splitlines()]

    group = None
    act = None
    category = None
    subsection = None
    last_section = None
    prefix_text = None

    entries = []

    def add_entry(section, offence, level, amount):
        if not offence:
            return
        entries.append(
            {
                "id": f"fine_{len(entries)+1:04d}",
                "section": section or "",
                "offence": offence,
                "level": int(level) if level.isdigit() else level,
                "amount": amount,
                "group": group or "",
                "category": category or group or "",
                "subsection": subsection or "",
                "act": act or "",
                "explanation": make_explanation(offence),
            }
        )

    buffer_text = None
    buffer_section = None
    buffer_level = None
    buffer_amount = None

    for raw in lines:
        line = raw
        if is_header_or_footer(line):
            continue
        if not line:
            continue

        if is_group_heading(line):
            group = line.title()
            category = None
            subsection = None
            continue

        if is_act_line(line):
            act = line
            category = None
            subsection = None
            continue

        letter_heading = is_letter_heading(line)
        if letter_heading:
            category = letter_heading.title()
            subsection = None
            continue

        if is_upper_heading(line) and not SECTION_START.match(line):
            # Subsection within a larger category
            subsection = line.title()
            continue

        section, remainder, has_section = extract_section_and_text(line)
        if section:
            last_section = section
            text = remainder
            prefix_text = None
        else:
            text = line
            section = last_section

        # Remove stray placeholders
        if text in {"DAY/NIGHT", "DAY", "NIGHT"}:
            continue

        match = LEVEL_AMOUNT_RE.match(text)
        if match:
            body = match.group("body").strip(" -")
            level = match.group("level")
            amount = match.group("amount")

            if prefix_text and not has_section:
                body = f"{prefix_text} {body}".strip()

            add_entry(section, clean_offence(body), level, amount)
            buffer_text = None
            buffer_section = None
            buffer_level = None
            buffer_amount = None
            continue

        # Line without amount: treat as prefix for subsequent lines
        if has_section:
            prefix_text = text
        else:
            prefix_text = (prefix_text or text)

    # Post-process to merge obvious split lines where the second entry is a lowercase continuation.
    merged = []
    i = 0
    while i < len(entries):
        current = entries[i]
        if i + 1 < len(entries):
            nxt = entries[i + 1]
            end_word = current["offence"].split()[-1].lower() if current["offence"] else ""
            if (
                current["section"] == nxt["section"]
                and current["category"] == nxt["category"]
                and current["act"] == nxt["act"]
                and nxt["offence"]
                and nxt["offence"][0].islower()
                and end_word in {"of", "to", "with", "being", "by", "in", "on", "for"}
            ):
                current["offence"] = f"{current['offence']} {nxt['offence']}"
                current["explanation"] = make_explanation(current["offence"])
                i += 2
                merged.append(current)
                continue
        merged.append(current)
        i += 1

    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT_PATH.write_text(json.dumps(merged, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"Wrote {len(merged)} entries to {OUTPUT_PATH}")


if __name__ == "__main__":
    main()
