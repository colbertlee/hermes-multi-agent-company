# Version Release SOP

> **老板原话**：「版本号的迭代跟着软件迭代一起更新，也就是版本的 SOP」

老板发布新版本时，云间按 7 步强制执行。

## 7 步发版 SOP

### Step 1: 检查变更

```bash
cd ~/projects/<project>
git status --short
```

工作树必须 clean，否则先 commit。

### Step 2: 更新 CHANGELOG.md

将 `[Unreleased]` 内容移到新版本段：

```markdown
## [Unreleased]
## [1.2.0] - YYYY-MM-DD
### Added
- 新增 XXX
### Changed
- 修改 YYY
```

### Step 3: 更新 README.md 版本 badge

```markdown
[![Version: v1.2.0](https://img.shields.io/badge/version-v1.2.0-blue.svg)]
```

### Step 4: 写 RELEASE_NOTES_v{VERSION}.md

参照现有 `RELEASE_NOTES_v1.1.0.md` 模板。

### Step 5: 提交 + 打 tag

```bash
git add .
git commit -m "chore: bump v{VERSION}"
git tag -a v{VERSION} -m "v{VERSION}: <headline>"
```

### Step 6: 推送 + 创建 release

```bash
git push origin main
git push origin v{VERSION}
gh release create v{VERSION} \
    --title "v{VERSION} — <headline>" \
    --notes-file RELEASE_NOTES_v{VERSION}.md \
    --latest
```

### Step 7: 更新 MEMORY.md

把变更摘要加进 `W{N}` 周报条目。

## 版本号规则 (SemVer)

| 类型 | 触发条件 | 示例 |
|------|---------|------|
| **MAJOR** | 新增/删除/合并 Agent，架构变更 | v1.x → v2.0 |
| **MINOR** | 新增 Skill / Sub-skill / 工具 | v1.1 → v1.2 |
| **PATCH** | Bug fix、docs、依赖 | v1.1.0 → v1.1.1 |

## 自动化检查清单

发版前必过：

- [ ] `bash install/sanitize-check.sh` — 无敏感数据
- [ ] `bash install/validate.sh` — 结构完整
- [ ] `git status --short` — 工作树 clean
- [ ] CHANGELOG.md 已更新
- [ ] README.md badge 已更新
- [ ] RELEASE_NOTES 已写
- [ ] MEMORY.md 已更新

## 反模式（绝对禁止）

- ❌ 只 commit 不打 tag
- ❌ tag 不带 release notes
- ❌ CHANGELOG 只更新不 commit
- ❌ README badge 滞后于实际版本
- ❌ 「Unreleased」段忘了写
- ❌ 发版前未跑 sanitize-check

## 频率建议

| 类型 | 频率 |
|------|------|
| PATCH | 每周 0-3 次 |
| MINOR | 每月 1-2 次 |
| MAJOR | 每季度 0-1 次 |

## 完整版本 SOP 在云间

云间会自动按这个 SOP 发版。老板只需说「发版」/「发布 v1.2.0」。

详见云间 skill: `~/.hermes/skills/version-sop/SKILL.md`

---

*最后更新：2026-08-08 · SOP v1.0*