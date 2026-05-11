# {{project_name}}

{{project_description}}

## 常用命令

```bash
{{dev_command}}    # 开发模式
{{build_command}}  # 完整构建
{{test_command}}   # 类型检查 / 测试
```

## 开发工作流

### 1. 规划阶段 — OpenSpec

新功能使用 OpenSpec 规范化：
- `/aix-plan` — 需求探索与设计
- `/opsx:propose <feature-name>` — 创建规范（proposal.md, specs/, design.md, tasks.md）
- `/opsx:explore` — 需求探索与澄清

### 2. 实施阶段 — Superpowers

遵循 Superpowers 方法论：
- brainstorming → 设计批准 → TDD → subagent 并行
- `/aix-code` — 实施入口
- 每次变更后执行 `{{test_command}} && {{build_command}}` 验证

### 3. 审查阶段 — gstack / aix

- `/aix-review` — 代码审查
- `/aix-qa` — QA 测试
- `/aix-cso` — 安全审计
- `npm run check:conflicts` — 冲突标记扫描（stash pop / merge 后必跑）

### 4. 发布阶段

- `/aix-ship` — 版本发布

## 多 agent 协作

- **Claude Code**: 规划 + 审查
- **Codex CLI + OMX**: 并行执行
- 交接通过 `.omx/plans/` 目录

## 项目结构

```
项目主要结构说明
```

## 关键架构约束

<!-- 在此填写项目特定的架构约束 -->

1. <!-- 约束 1 -->
2. <!-- 约束 2 -->

## OpenSpec

OpenSpec CLI 已全局安装。
项目级 skill 已生成在 `.claude/skills/openspec-*`。

## gstack

gstack skills 已注册。
