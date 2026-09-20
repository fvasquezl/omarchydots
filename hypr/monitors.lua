-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 2
local omarchy_monitor_scale = 1.6

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

-- Force legacy (non-atomic) KMS so the DRM/i915 bandwidth check that blocks
-- dual 4K@60 on this iGPU is skipped, matching what GNOME/Xorg allowed.
-- Requires a full Hyprland restart (logout/login) to take effect.
-- NOTE: Hyprland's DRM backend is Aquamarine, which reads AQ_NO_ATOMIC, not
-- the wlroots-era WLR_DRM_NO_ATOMIC (which aquamarine ignores entirely).
hl.env("AQ_NO_ATOMIC", "1")

-- With AQ_NO_ATOMIC alone, DP-1's legacy drmModeSetCrtc still fails
-- (Invalid argument) at both 3840x2160@60 and @30 -- the CRTC/pipe driving
-- DP-1 appears unable to scan out the Y_TILED_CCS (compressed) framebuffer
-- Aquamarine allocates by default. Force linear/uncompressed buffers to
-- rule that out.
hl.env("AQ_NO_MODIFIERS", "1")

-- Positions are in logical/layout space (post-scale), not raw pixel resolution.
-- Manual pixel math (e.g. 3840/1.3 ~= 2954) is fragile: Hyprland actually
-- applies scale 1.3333334 here instead of the configured 1.3 (real logical
-- width 2880, not 2954), which left a gap the cursor couldn't cross. Using
-- "auto-right" lets Hyprland compute the correct offset from whatever scale
-- it actually applies, instead of hardcoding a value that can drift.
-- Logical left/right order must match the physical desk layout, or the
-- cursor crosses on the outer edges instead of the inner (adjacent) ones.
-- DP-2 is physically on the left, DP-1 on the right.
hl.monitor({ output = "DP-2", mode = "3840x2160@60", position = "0x0", scale = 1.3 })
hl.monitor({ output = "DP-1", mode = "3840x2160@60", position = "auto-right", scale = 1.3 })

-- Pin workspaces 1-3 to DP-2 and 4-6 to DP-1.
hl.workspace_rule({ workspace = "1", monitor = "DP-2" })
hl.workspace_rule({ workspace = "2", monitor = "DP-2" })
hl.workspace_rule({ workspace = "3", monitor = "DP-2" })
hl.workspace_rule({ workspace = "4", monitor = "DP-1" })
hl.workspace_rule({ workspace = "5", monitor = "DP-1" })
hl.workspace_rule({ workspace = "6", monitor = "DP-1" })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
