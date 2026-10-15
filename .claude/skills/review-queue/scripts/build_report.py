import html
import json
import re
import sys
from datetime import date
from pathlib import Path

queue_path = Path(sys.argv[1])
reviews_dir = Path(sys.argv[2])
out_path = Path(sys.argv[3])

data = json.loads(queue_path.read_text())
META = {q["mr"]: q for q in data["queue"]}

missing = [mr for mr in META if not (reviews_dir / f"{mr.replace('!', '-')}.json").exists()]
if missing:
    sys.exit(f"missing review json for: {', '.join(missing)}")


def short_path(loc):
    parts = loc.split("/")
    return loc if len(parts) <= 3 else "…/" + "/".join(parts[-3:])


def rich(text):
    escaped = html.escape(text)
    return re.sub(r"`([^`]+)`", r"<code>\1</code>", escaped)


def finding(f, kind):
    return (
        f'<li class="finding {kind}">'
        f'<span class="loc" title="{html.escape(f["loc"])}">{html.escape(short_path(f["loc"]))}</span>'
        f'<p>{rich(f["issue"])}</p></li>'
    )


def card(r, body):
    m = META[r["mr"]]
    chips = []
    if m["draft"]:
        chips.append('<span class="chip draft">Draft</span>')
    elif m["approvals_left"]:
        s = "" if m["approvals_left"] == 1 else "s"
        chips.append(f'<span class="chip">{m["approvals_left"]} approval{s} left</span>')
    if r.get("note"):
        chips.append(f'<span class="chip">{html.escape(r["note"])}</span>')
    box_id = "done-" + re.sub(r"[^a-z0-9]", "-", r["mr"])
    return f"""
<article class="mr">
  <header>
    <div class="top">
      <a class="ref" href="{html.escape(m["url"])}">{html.escape(r["mr"])}</a>
      <label class="check" for="{box_id}"><input type="checkbox" id="{box_id}" data-mr="{html.escape(r["mr"])}"> Reviewed</label>
    </div>
    <h3>{html.escape(m["title"])}</h3>
    <div class="meta"><span>by {html.escape(m["author"])}</span>{"".join(chips)}</div>
  </header>
  <p class="summary">{rich(r["summary"])}</p>
  {body}
</article>"""


def optional(r):
    return f'<p class="aside">Optional: {rich(r["optional"])}</p>' if r.get("optional") else ""


def or_none(cards):
    return cards or '<p class="sec-note">None.</p>'


reviews = [json.loads((reviews_dir / f"{mr.replace('!', '-')}.json").read_text()) for mr in META]
for r, mr in zip(reviews, META):
    r["mr"] = mr
# non-drafts first, then by finding count
reviews.sort(key=lambda r: (META[r["mr"]]["draft"], -len(r["should_fix"])))

clean = [r for r in reviews if not r["must_fix"] and not r["should_fix"]]
should = [r for r in reviews if not r["must_fix"] and r["should_fix"]]
must = [r for r in reviews if r["must_fix"]]

clean_html = "".join(card(r, optional(r)) for r in clean)

should_html = ""
for r in should:
    items = "".join(finding(f, "should") for f in r["should_fix"])
    should_html += card(r, f'<ol class="findings">{items}</ol>{optional(r)}')

must_html = ""
for r in must:
    m = "".join(finding(f, "must") for f in r["must_fix"])
    s = "".join(finding(f, "should") for f in r["should_fix"])
    body = f'<ol class="findings">{m}</ol>'
    if s:
        body += (
            f'<details><summary>Also {len(r["should_fix"])} should fix</summary>'
            f'<ol class="findings">{s}</ol></details>'
        )
    must_html += card(r, body)

n_should = sum(len(r["should_fix"]) for r in should)
today = date.today()
skipped = data["skipped_approved"]
skipped_note = f" {len(skipped)} MR{'' if len(skipped) == 1 else 's'} Ben already approved {'is' if len(skipped) == 1 else 'are'} left out." if skipped else ""

page = (Path(__file__).parent / "report_template.html").read_text()
page = (
    page.replace("{{TITLE_DATE}}", f"{today:%b} {today.day}")
    .replace("{{DATE}}", today.isoformat())
    .replace("{{TOTAL}}", str(len(reviews)))
    .replace("{{SKIPPED_NOTE}}", skipped_note)
    .replace("{{CLEAN_COUNT}}", str(len(clean)))
    .replace("{{SHOULD_COUNT}}", str(len(should)))
    .replace("{{SHOULD_FINDINGS}}", str(n_should))
    .replace("{{MUST_COUNT}}", str(len(must)))
    .replace("{{CLEAN}}", or_none(clean_html))
    .replace("{{SHOULD}}", or_none(should_html))
    .replace("{{MUST}}", or_none(must_html))
)
out_path.write_text(page)
(out_path.parent / "checked.json").write_text(json.dumps({"checked": {}}))
print(len(clean), len(should), len(must), n_should)
