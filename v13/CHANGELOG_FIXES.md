# CHANGELOG - Apex v13 Patches (4.5 -> 8.5/10)

## v13.1 - HookManager & Stealth (7.0/10)
- Added core/hook_manager.lua (96 lines)
- Fixed loader pending, anticheat/remote collision, combat humanized (3), services TP/Tween/Fly, Noclip/Flight stealth

## v13.2 - Performance & Data (7.8/10)
- Fixed anticheat CooldownCheck duplicate, HookIndex no-op, remote fallback, Governor integration, tick fallback, wall jitter, forensic counter
- Added ScanForDetection caching, Perf delegation

## v13.3 - Architecture (8.1/10)
- Config: HttpService JSON, DefaultC fix, Fruits dedup, BountyRange validator
- Movement: delegated to TP, Zones data-driven
- Services: EventBus delegated

## v13.4 - Final Push (8.5/10) [CURRENT]
- Combat: 12 HumanizedApproach sites (was 4)
- Anticheat: ScanForDetection throttled + limited ReplicatedStorage only
- Services: Perf/EventBus fully delegated
- UI: Themes pruned 88->12 lines, CanvasSize debounced 0.08s, protect_gui fallback
- Docs: ARCHITECTURE.md + smoke_test.lua (7 tests)

Total: 71 FIX refs across 9 files, 74 files total
