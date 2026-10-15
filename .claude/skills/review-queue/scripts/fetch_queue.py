import json
import os
import subprocess
import sys
from pathlib import Path
from urllib.parse import quote

USERNAME = "ben.heath"
DEVELOPER = Path.home() / "Developer"
out_path = Path(sys.argv[1])


def api(path):
    env = {**os.environ, "GITLAB_HOST": "gitlab.rechargeapps.net"}
    res = subprocess.run(["glab", "api", path], capture_output=True, text=True, env=env, check=True)
    return json.loads(res.stdout)


mrs = api(f"merge_requests?scope=all&reviewer_username={USERNAME}&state=opened&per_page=100")
queue = []
skipped = []
for m in mrs:
    project = m["references"]["full"].split("!")[0]
    pid = quote(project, safe="")
    iid = m["iid"]
    slug = f"{project.split('/')[-1]}!{iid}"
    reviewers = api(f"projects/{pid}/merge_requests/{iid}/reviewers")
    my_state = next((r["state"] for r in reviewers if r["user"]["username"] == USERNAME), None)
    if my_state == "approved":
        skipped.append(slug)
        continue
    approvals_left = api(f"projects/{pid}/merge_requests/{iid}/approvals").get("approvals_left")
    repo_skill = DEVELOPER / project.split("/")[-1] / ".claude/skills/review-code/SKILL.md"
    queue.append({
        "mr": slug,
        "project": project,
        "iid": iid,
        "title": m["title"].removeprefix("Draft: "),
        "author": m["author"]["username"],
        "draft": m["draft"],
        "url": m["web_url"],
        "approvals_left": approvals_left,
        "repo_skill": str(repo_skill) if repo_skill.exists() else None,
    })

out_path.write_text(json.dumps({"queue": queue, "skipped_approved": skipped}, indent=2))
for q in queue:
    print(q["mr"], "draft" if q["draft"] else f"{q['approvals_left']} left", q["title"], sep=" | ")
print(f"{len(queue)} to review, {len(skipped)} already approved by {USERNAME}: {skipped}")
