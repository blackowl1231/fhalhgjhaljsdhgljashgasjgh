local function renameServices()
    local playersClient = game:FindFirstChild("Players - Client")
    if playersClient then
        playersClient.Name = "Players"
    end

    local workspaceClient = game:FindFirstChild("Workspace - Client")
    if workspaceClient then
        workspaceClient.Name = "Workspace"
    end
end

renameServices()
wait(2)


local Functions = {}
local SoundService = game:GetService("SoundService")

local PLAYER = Game.Players.LocalPlayer
local CurrentCam = Game.Workspace.CurrentCamera
local UIS = Game:GetService("UserInputService")
local mouseLocation = UIS.GetMouseLocation
local mouse = PLAYER:GetMouse()
local dwMouse = PLAYER:GetMouse()
local HttpService = game:GetService("HttpService")


local ZYPHERION = {
    Player = {
        WalkSpeed = false;
        Bhop = false;
        Fly = false;
        FlySpeedValue = 15;
        InfiniteJump = false;
        HoldJump = false;
        WalkSpeedValue = 16;
        Noclip = false;
        FireRate = false;
    }
}


local flyConnection
local walkSpeedConnection
local noclipConnection

--------------------------

local function setWalkSpeed()
    local hrp = PLAYER.Character and PLAYER.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local bv = hrp:FindFirstChild("BodyVelocity")
        if not bv then
            bv = Instance.new("BodyVelocity")
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.MaxForce = Vector3.new(100000, 0, 100000)
            bv.Parent = hrp
        end

        local moveDirection = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + CurrentCam.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - CurrentCam.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - CurrentCam.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + CurrentCam.CFrame.RightVector
        end

        bv.Velocity = moveDirection * ZYPHERION.Player.WalkSpeedValue
    end
end

-- Save the original walk speed
local originalWalkSpeed = 16 -- Default Roblox walk speed

-- Function to set the custom walk speed
local function setWalkSpeed()
    local hrp = PLAYER.Character and PLAYER.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local bv = hrp:FindFirstChild("BodyVelocity")
        if not bv then
            bv = Instance.new("BodyVelocity")
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.MaxForce = Vector3.new(100000, 0, 100000)
            bv.Parent = hrp
        end

        local moveDirection = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + CurrentCam.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - CurrentCam.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - CurrentCam.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + CurrentCam.CFrame.RightVector
        end

        bv.Velocity = moveDirection * ZYPHERION.Player.WalkSpeedValue
    end
end

local function resetWalkSpeed()
    local hrp = PLAYER.Character and PLAYER.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local bv = hrp:FindFirstChild("BodyVelocity")
        if bv then
            bv:Destroy()
        end
    end
end


local function startFly()
    if flyConnection then
        flyConnection:Disconnect()
    end
    local hrp = PLAYER.Character and PLAYER.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local fly = Instance.new("BodyVelocity")
        fly.Velocity = Vector3.new(0, 0, 0)
        fly.MaxForce = Vector3.new(100000, 100000, 100000)
        fly.Parent = hrp

        flyConnection =
            game:GetService("RunService").RenderStepped:Connect(
            function()
                local moveDirection = Vector3.zero
                if UIS:IsKeyDown(Enum.KeyCode.W) then
                    moveDirection = moveDirection + CurrentCam.CFrame.LookVector
                end
                if UIS:IsKeyDown(Enum.KeyCode.S) then
                    moveDirection = moveDirection - CurrentCam.CFrame.LookVector
                end
                if UIS:IsKeyDown(Enum.KeyCode.A) then
                    moveDirection = moveDirection - CurrentCam.CFrame.RightVector
                end
                if UIS:IsKeyDown(Enum.KeyCode.D) then
                    moveDirection = moveDirection + CurrentCam.CFrame.RightVector
                end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then
                    moveDirection = moveDirection + CurrentCam.CFrame.UpVector
                end
                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                    moveDirection = moveDirection - CurrentCam.CFrame.UpVector
                end

                fly.Velocity = moveDirection * ZYPHERION.Player.FlySpeedValue
                if moveDirection.Magnitude == 0 then
                    fly.Velocity = Vector3.new(0, 0, 0)
                end
            end
        )
    end
end

local function stopFly()
    if flyConnection then flyConnection:Disconnect() end
    local hrp = PLAYER.Character and PLAYER.Character:FindFirstChild("HumanoidRootPart")
    if hrp and hrp:FindFirstChildOfClass("BodyVelocity") then
        hrp:FindFirstChildOfClass("BodyVelocity"):Destroy()
    end
end

local function onJumpRequest()
    if ZYPHERION.Player.InfiniteJump then
        local character = PLAYER.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end

local function holdJump()
    if ZYPHERION.Player.HoldJump and UIS:IsKeyDown(Enum.KeyCode.Space) then
        local character = PLAYER.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end

local function noclip()
    if ZYPHERION.Player.Noclip then
        for _, v in pairs(PLAYER.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end
end


UIS.JumpRequest:Connect(onJumpRequest)

game:GetService('RunService').RenderStepped:Connect(function()

    if ZYPHERION.Player.WalkSpeed then
        setWalkSpeed()
    end

    if ZYPHERION.Player.HoldJump then
        holdJump()
    end

    if ZYPHERION.Player.Noclip then
        noclip()
    end

end)

local executor_used = tostring(identifyexecutor())
    local players_service = game:GetService("Players")
    local run_service = game:GetService("RunService")
    local user_input_service = game:GetService("UserInputService")
    local aimbot_enabled = false
    local aimbot_fov_size = 250
    local aimbot_aim_part = "Head"
    local aimbot_smoothness = 0
    local show_fov = false
    local aimbot_right_click = false
    local aimbot_keybind = Enum.UserInputType.MouseButton2
    local aimbot_smoothness_enabled = false
    local aimbot_prediction_enabled = false
    local aimbot_prediction_strength_x = 0
    local aimbot_prediction_strength_y = 0
    local aimbot_sticky_aim_enabled = false
    local locked_target = nil
    local visual_elements = {}
    local tp_behind_offset = 0
    local tp_behind_height = 6
    local teleporting = false
    local teamcheck_enabled = false

    local function is_teammate(player)
        local local_player = players_service.LocalPlayer
        return player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart:FindFirstChild("TeammateLabel")
    end

    function aimbot()
        if not aimbot_enabled then
            return
        end

        if aimbot_keybind == Enum.UserInputType.MouseButton2 then
            if not user_input_service:IsMouseButtonPressed(aimbot_keybind) then
                locked_target = nil
                return
            end
        else
            if not user_input_service:IsKeyDown(aimbot_keybind) then
                locked_target = nil
                return
            end
        end

        local camera = workspace.CurrentCamera
        local mouse = players_service.LocalPlayer:GetMouse()

        if locked_target and aimbot_sticky_aim_enabled then
            if locked_target.Character and locked_target.Character:FindFirstChild(aimbot_aim_part) then
                local part = locked_target.Character[aimbot_aim_part]
                local predicted_position = part.Position
                if aimbot_prediction_enabled then
                    local velocity = locked_target.Character.HumanoidRootPart.Velocity
                    predicted_position =
                        part.Position +
                        Vector3.new(
                            velocity.X * aimbot_prediction_strength_x * 0.1,
                            velocity.Y * aimbot_prediction_strength_y * 0.1,
                            0
                        )
                end
                local screen_pos = camera:WorldToViewportPoint(predicted_position)
                local target = Vector2.new(screen_pos.X, screen_pos.Y)
                local screen_center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                local move = target - screen_center

                if aimbot_smoothness_enabled then
                    local move_step = move / (aimbot_smoothness + 1)
                    mousemoverel(move_step.X, move_step.Y)
                else
                    mousemoverel(move.X, move.Y)
                end
                return
            else
                locked_target = nil
            end
        end

        local closest_player = nil
        local closest_distance = aimbot_fov_size

        for _, player in pairs(players_service:GetPlayers()) do
            if player ~= players_service.LocalPlayer and player.Character and player.Character:FindFirstChild(aimbot_aim_part) then
                if teamcheck_enabled and is_teammate(player) then
                    continue
                end
                
                local part = player.Character[aimbot_aim_part]
                local predicted_position = part.Position
                if aimbot_prediction_enabled then
                    local velocity = player.Character.HumanoidRootPart.Velocity
                    predicted_position =
                        part.Position +
                        Vector3.new(
                            velocity.X * aimbot_prediction_strength_x * 0.1,
                            velocity.Y * aimbot_prediction_strength_y * 0.1,
                            0
                        )
                end
                local screen_pos, on_screen = camera:WorldToViewportPoint(predicted_position)
                if on_screen then
                    local distance =
                        (Vector2.new(screen_pos.X, screen_pos.Y) -
                        Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)).magnitude
                    if distance < closest_distance then
                        closest_distance = distance
                        closest_player = player
                    end
                end
            end
        end

        if closest_player then
            locked_target = closest_player
            local part = closest_player.Character[aimbot_aim_part]
            local predicted_position = part.Position
            if aimbot_prediction_enabled then
                local velocity = closest_player.Character.HumanoidRootPart.Velocity
                predicted_position =
                    part.Position +
                    Vector3.new(
                        velocity.X * aimbot_prediction_strength_x * 0.1,
                        velocity.Y * aimbot_prediction_strength_y * 0.1,
                        0
                    )
            end
            local screen_pos = camera:WorldToViewportPoint(predicted_position)
            local target = Vector2.new(screen_pos.X, screen_pos.Y)
            local screen_center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
            local move = target - screen_center

            if aimbot_smoothness_enabled then
                local move_step = move / (aimbot_smoothness + 1)
                mousemoverel(move_step.X, move_step.Y)
            else
                mousemoverel(move.X, move.Y)
            end
        end
    end

    run_service.RenderStepped:Connect(aimbot)

    local fov_circle = Drawing.new("Circle")
    fov_circle.Color = Color3.fromRGB(19, 0, 255)
    fov_circle.Thickness = 1
    fov_circle.Transparency = 1
    fov_circle.Filled = false

    function update_fov_circle()
        if show_fov then
            local camera = workspace.CurrentCamera
            local viewportSize = camera.ViewportSize

            fov_circle.Radius = aimbot_fov_size
            fov_circle.Position = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
            fov_circle.Visible = true
        else
            fov_circle.Visible = false
        end
    end

    run_service.RenderStepped:Connect(update_fov_circle)
    





    local function loop_behind(target_player)
        teleporting = true
        local player = game.Players.LocalPlayer
    
        while teleporting do
            local target_character = target_player.Character
            local target_humanoid_root_part = target_character and target_character:FindFirstChild("HumanoidRootPart")
            local player_character = player.Character
            local player_humanoid_root_part = player_character and player_character:FindFirstChild("HumanoidRootPart")
    
            if player_humanoid_root_part and target_humanoid_root_part then
                local target_cframe = target_humanoid_root_part.CFrame
                local target_look_vector = target_cframe.LookVector
                local target_position = target_cframe.Position
                local new_position =
                    target_position - (target_look_vector * tp_behind_offset) + Vector3.new(0, tp_behind_height, 0)
                player_humanoid_root_part.CFrame = CFrame.new(new_position, new_position + target_look_vector)
            end
    
            task.wait()
        end
    end

    local Fluent =
        loadstring(game:HttpGet("https://twix.cyou/Fluent.txt"))()


    local UISettings = {
        TabWidth = 160,
        Size = { 690, 460 },
        Theme = "VSC Dark High Contrast",
        Acrylic = false,
        Transparency = true,
        ShowNotifications = true,
        ShowWarnings = true,
        AutoImport = true
    }

    local InterfaceManager = {}

    function InterfaceManager:ImportSettings()
        pcall(function()
            if not DEBUG and getfenv().isfile and getfenv().readfile and getfenv().isfile("UISettings.ttwizz") and getfenv().readfile("UISettings.ttwizz") then
                for Key, Value in next, HttpService:JSONDecode(getfenv().readfile("UISettings.ttwizz")) do
                    UISettings[Key] = Value
                end
            end
        end)
    end

    function InterfaceManager:ExportSettings()
        pcall(function()
            if not DEBUG and getfenv().isfile and getfenv().readfile and getfenv().writefile then
                getfenv().writefile("UISettings.ttwizz", HttpService:JSONEncode(UISettings))
            end
        end)
    end

    InterfaceManager:ImportSettings()

    UISettings.__LAST_RUN__ = os.date()
    InterfaceManager:ExportSettings()


    local Window =
        Fluent:CreateWindow(
        {
            Title = "ZYPHERION | Rivals",
            SubTitle = "",
            TabWidth = UISettings.TabWidth,
            Size = UDim2.fromOffset(690, 460),
            Theme = UISettings.Theme,
            Acrylic = UISettings.Acrylic,
            MinimizeKey = Enum.KeyCode.RightShift
        }
    )

    local Tabs = {
        aimbot_tab = Window:AddTab({Title = "Combat", Icon = "crosshair"}),
        visuals_tab = Window:AddTab({Title = "Visuals", Icon = "eye"}),
        player_tab = Window:AddTab({Title = "Player", Icon = "bot"}),
        teleport_tab = Window:AddTab({Title = "Teleport", Icon = "target"}),
        misc_tab = Window:AddTab({Title = "Misc", Icon = "edit"}),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),

    }

    do

        -- Aimbot & Silent aim tab
        Tabs.aimbot_tab:AddSection("Silent Aim")
        getgenv().SilentAimEnabled = false
        getgenv().UseFOVSilentaim = false
        getgenv().FOVSizeSilentaim = 500
        getgenv().FOVColorSilentaim = Color3.fromRGB(255, 0, 0)
        getgenv().WallCheck = true
        getgenv().TeamCheck = true
        getgenv().Hitchance = 100

        local fov_circle = Drawing.new("Circle")
        fov_circle.Color = getgenv().FOVColorSilentaim
        fov_circle.Thickness = 1
        fov_circle.Transparency = 1
        fov_circle.Filled = false
        fov_circle.NumSides = 60

        function update_fov_circle()
            if getgenv().UseFOVSilentaim then
                local camera = workspace.CurrentCamera
                local mousePos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

                fov_circle.Position = mousePos
                fov_circle.Radius = getgenv().FOVSizeSilentaim
                fov_circle.Color = getgenv().FOVColorSilentaim
                fov_circle.Visible = true
            else
                fov_circle.Visible = false
            end
        end

        local function isInFOV(target)
            if not getgenv().UseFOVSilentaim then
                return true
            end

            local screenPoint = workspace.CurrentCamera:WorldToScreenPoint(target.Position)
            local mousePos = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
            local distanceFromCenter = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude

            return distanceFromCenter <= getgenv().FOVSizeSilentaim
        end

        game:GetService("RunService").RenderStepped:Connect(update_fov_circle)

        local v0 = string.char;
        local v1 = string.byte;
        local v2 = string.sub;
        local v3 = bit32 or bit;
        local v4 = v3.bxor;
        local v5 = table.concat;
        local v6 = table.insert;

        local function v7(v66, v67)
            local v68 = {};
            for v168 = 1, #v66 do
                v6(v68, v0(v4(v1(v2(v66, v168, v168 + 1)), v1(v2(v67, 1 + (v168 % #v67), 1 + (v168 % #v67) + 1))) % 256));
            end
            return v5(v68);
        end

        local v24 = game:GetService(v7("\226\234\48\171\163\236\24", "\107\178\134\81\210\198\158")); --Players
        local v25 = v24.LocalPlayer;
        local v26 = v25:GetMouse();
        local v27 = game:GetService(v7("\10\27\140\245\175\42\24\139\197\175", "\202\88\110\226\166")); --Runservice
        local v28 = workspace.CurrentCamera;
        local v29 = RaycastParams.new();
        v29.FilterType = Enum.RaycastFilterType.Blacklist;
        v29.IgnoreWater = true;
        local v33 = CFrame.new(-(456.644211 - (10 + 327)), -(472.24993900000004 + 205), 1477.98853 - (118 + 220));
        local v34 = 117 + 233;

        local v45;
        local function v46(target)
            if not getgenv().WallCheck then
                return true
            end

            if not target or not target.Character or not target.Character:FindFirstChild("Head") then
                return false
            end

            local head = target.Character.Head
            local startPos = workspace.CurrentCamera.CFrame.Position
            local direction = (head.Position - startPos).Unit * 1000

            local ray = Ray.new(startPos, direction)
            local hitPart, hitPos = workspace:FindPartOnRayWithIgnoreList(ray, {game.Players.LocalPlayer.Character}, false, true)

            return hitPart and hitPart:IsDescendantOf(target.Character)
        end

        local function v47()
            local closestPlayer = nil
            local closestDistance = math.huge
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                    if getgenv().TeamCheck and is_teammate(player) then
                        continue
                    end

                    local head = player.Character.Head
                    local distance = (head.Position - workspace.CurrentCamera.CFrame.Position).Magnitude
                    
                    if math.random(1, 100) <= getgenv().Hitchance and distance < closestDistance and isInFOV(head) and v46(player) then
                        closestPlayer = player
                        closestDistance = distance
                    end
                end
            end
            return closestPlayer
        end

        local function v35()
            if v25.Character and v25.Character:FindFirstChild("HumanoidRootPart") then
                local v252 = v25.Character.HumanoidRootPart.Position
                local v253 = (v252 - v33.Position).Magnitude
                return v253 < v34
            end
            return false
        end

        v26.Button1Down:Connect(function()
            if getgenv().SilentAimEnabled and not v35() then
                local closestPlayer = v47()
                if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
                    local head = closestPlayer.Character.Head
                    v28.CFrame = CFrame.new(v28.CFrame.Position, head.Position)
                    v45 = v28.CFrame
                end
            end
        end)

        v26.Button1Up:Connect(function()
            if getgenv().SilentAimEnabled and v45 then
                v28.CFrame = v45
            end
        end)




        Tabs.aimbot_tab:AddToggle("SilentAimToggle", {
            Title = "Silent Aim",
            Default = false,
            Callback = function(value)
                getgenv().SilentAimEnabled = value
            end
        })

        Tabs.aimbot_tab:AddToggle("WallCheckToggle", {
            Title = "Wall Check",
            Default = getgenv().WallCheck,
            Callback = function(value)
                getgenv().WallCheck = value
            end
        })

        Tabs.aimbot_tab:AddToggle("TeamCheckToggle", {
            Title = "Team Check",
            Default = getgenv().TeamCheck,
            Callback = function(value)
                getgenv().TeamCheck = value
            end
        })

        Tabs.aimbot_tab:AddToggle("UseFOVToggle", {
            Title = "Use FOV",
            Default = getgenv().UseFOVSilentaim,
            Callback = function(value)
                getgenv().UseFOVSilentaim = value
            end
        })

        Tabs.aimbot_tab:AddSlider("FOVSizeSlider", {
            Title = "FOV Size",
            Default = getgenv().FOVSizeSilentaim,
            Min = 50,
            Max = 750,
            Rounding = 0,
            Callback = function(value)
                getgenv().FOVSizeSilentaim = value
            end
        })

        Tabs.aimbot_tab:AddColorpicker("FOVColorPicker", {
            Title = "FOV Color",
            Default = getgenv().FOVColorSilentaim,
            Callback = function(color)
                getgenv().FOVColorSilentaim = color
                fov_circle.Color = color
            end
        })

        Tabs.aimbot_tab:AddSlider("HitchanceSlider", {
            Title = "Hitchance (%)",
            Default = getgenv().Hitchance,
            Min = 0,
            Max = 100,
            Rounding = 0,
            Callback = function(value)
                getgenv().Hitchance = value
            end
        })




        Tabs.aimbot_tab:AddSection("Aimbot")


        -- aimbot tab
        local enable_aimbot_cb = Tabs.aimbot_tab:AddToggle("EnableAimbot", {Title = "Enable", Default = false})
        enable_aimbot_cb:OnChanged(
        function(value)
            aimbot_enabled = value
        end
        )

        Tabs.aimbot_tab:AddToggle("TeamCheckToggle", {
            Title = "Team Check",
            Default = teamcheck_enabled,
            Callback = function(value)
                teamcheck_enabled = value
            end
        })
        

        local smoothness_cb = Tabs.aimbot_tab:AddToggle("SmoothnessCheckbox", {Title = "Smoothness", Default = false})
        smoothness_cb:OnChanged(
            function(value)
                aimbot_smoothness_enabled = value
            end
        )


        local enable_prediction_cb =
            Tabs.aimbot_tab:AddToggle("EnablePrediction", {Title = "Enable Prediction", Default = false})
        enable_prediction_cb:OnChanged(
            function(value)
                aimbot_prediction_enabled = value
            end
        )

        local sticky_aim_cb = Tabs.aimbot_tab:AddToggle("StickyAimCheckbox", {Title = "Sticky Aim", Default = false})
        sticky_aim_cb:OnChanged(
            function(value)
                aimbot_sticky_aim_enabled = value
            end
        )

        local aimbot_kb = Tabs.aimbot_tab:AddKeybind("Keybind", {
            Title = "Keybind",
            Mode = "Toggle",
            Default = "MouseButton2",
        
            ChangedCallback = function(New)
                if New == Enum.KeyCode.Unknown then
                    aimbot_keybind = Enum.UserInputType.MouseButton2
                else
                    aimbot_keybind = New
                end
            end
        })

        local aim_at_dropdown =
            Tabs.aimbot_tab:AddDropdown(
            "AimPartDropDown",
            {
                Title = "Aim At",
                Values = {"Head", "HumanoidRootPart"},
                Multi = false,
                Default = 1,
                Callback = function(value)
                    aimbot_aim_part = value
                end
            }
        )

        local show_fov_cb = Tabs.aimbot_tab:AddToggle("ShowFovCheckbox", {Title = "Show FOV", Default = false})
        show_fov_cb:OnChanged(
            function(value)
                show_fov = value
            end
        )

        local fov_size_slider =
            Tabs.aimbot_tab:AddSlider(
            "FovSizeSlider",
            {
                Title = "FOV Size",
                Default = 250,
                Min = 0,
                Max = 1000,
                Rounding = 0,
                Callback = function(value)
                    aimbot_fov_size = value
                end
            }
        )

        local Colorpicker = Tabs.aimbot_tab:AddColorpicker("Colorpicker", {
            Title = "FOV Color",
            Default = Color3.fromRGB(19, 0, 255),
            Callback = function(color)
                fov_circle.Color = color
            end
        })


        local smoothness_slider =
            Tabs.aimbot_tab:AddSlider(
            "SmoothnessSlider",
            {
                Title = "Smoothness",
                Default = 0,
                Min = 0,
                Max = 10,
                Rounding = 1,
                Callback = function(value)
                    aimbot_smoothness = value
                end
            }
        )
        local prediction_strength_x_slider =
            Tabs.aimbot_tab:AddSlider(
            "PredictionStrengthXSlider",
            {
                Title = "Prediction Strength X",
                Default = 0,
                Min = 0,
                Max = 1,
                Rounding = 2,
                Callback = function(value)
                    aimbot_prediction_strength_x = value
                end
            }
        )

        local prediction_strength_y_slider =
            Tabs.aimbot_tab:AddSlider(
            "PredictionStrengthYSlider",
            {
                Title = "Prediction Strength Y",
                Default = 0,
                Min = 0,
                Max = 1,
                Rounding = 2,
                Callback = function(value)
                    aimbot_prediction_strength_y = value
                end
            }
        )


        --// Esp \\--
        local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/NervigeMuecke/Z3US-V2/refs/heads/main/Important/rivalsesp.lua"))()

        getgenv().global = getgenv()

        function global.declare(self, index, value, check)
            if self[index] == nil then
                self[index] = value
            elseif check then
                local methods = { "remove", "Disconnect" }

                for _, method in methods do
                    pcall(function()
                        value[method](value)
                    end)
                end
            end

            return self[index]
        end

        declare(global, "features", {})

        features.toggle = function(self, feature, boolean)
            if self[feature] then
                if boolean == nil then
                    self[feature].enabled = not self[feature].enabled
                else
                    self[feature].enabled = boolean
                end

                if self[feature].toggle then
                    task.spawn(function()
                        self[feature]:toggle()
                    end)
                end
            end
        end

        declare(features, "visuals", {
            ["enabled"] = false,
            ["teamCheck"] = false,
            ["teamColor"] = false,
            ["renderDistance"] = 250,
        
            ["boxes"] = {
                ["enabled"] = false,
                ["color"] = Color3.fromRGB(19, 0, 255),
                ["outline"] = {
                    ["enabled"] = false,
                    ["color"] = Color3.fromRGB(0, 0, 0),
                },
                ["filled"] = {
                    ["enabled"] = false,
                    ["color"] = Color3.fromRGB(19, 0, 255),
                    ["transparency"] = 0.25
                },
            },
            ["names"] = {
                ["enabled"] = false,
                ["color"] = Color3.fromRGB(19, 0, 255),
                ["outline"] = {
                    ["enabled"] = false,
                    ["color"] = Color3.fromRGB(0, 0, 0),
                },
            },
            ["health"] = {
                ["enabled"] = false,
                ["color"] = Color3.fromRGB(0, 255, 0),
                ["colorLow"] = Color3.fromRGB(255, 0, 0),
                ["outline"] = {
                    ["enabled"] = false,
                    ["color"] = Color3.fromRGB(0, 0, 0)
                },
                ["text"] = {
                    ["enabled"] = false,
                    ["outline"] = {
                        ["enabled"] = false,
                    },
                }
            },
            ["distance"] = {
                ["enabled"] = false,
                ["color"] = Color3.fromRGB(19, 0, 255),
                ["outline"] = {
                    ["enabled"] = false,
                    ["color"] = Color3.fromRGB(0, 0, 0),
                },
            },
            ["weapon"] = {
                ["enabled"] = false,
                ["color"] = Color3.fromRGB(19, 0, 255),
                ["outline"] = {
                    ["enabled"] = false,
                    ["color"] = Color3.fromRGB(0, 0, 0),
                },
            }
        })

        local visuals = features.visuals

        
        Tabs.visuals_tab:AddSection("ESP Settings")

        local enable_visuals_cb = Tabs.visuals_tab:AddToggle("EnableVisuals", {Title = "Enable ESP", Default = visuals.enabled})
        enable_visuals_cb:OnChanged(function(value)
            visuals.enabled = value
        end)

        local enable_teamcheck_cb = Tabs.visuals_tab:AddToggle("EnableTeamcheck", {Title = "Enable Teamcheck", Default = visuals.teamCheck})
        enable_teamcheck_cb:OnChanged(function(value)
            visuals.teamCheck = value
        end)


        
        local render_distance_slider = Tabs.visuals_tab:AddSlider("RenderDistance", {
            Title = "Render Distance",
            Default = visuals.renderDistance,
            Min = 0,
            Max = 2000,
            Rounding = 0
        })
        render_distance_slider:OnChanged(function(value)
            visuals.renderDistance = value
        end)


        
        Tabs.visuals_tab:AddSection("Boxes Settings")

        local enable_boxes_cb = Tabs.visuals_tab:AddToggle("EnableBoxes", {Title = "Boxes", Default = visuals.boxes.enabled})
        enable_boxes_cb:OnChanged(function(value)
            visuals.boxes.enabled = value
        end)

        local box_color_picker = Tabs.visuals_tab:AddColorpicker("BoxColorPicker", {
            Title = "Box Color",
            Default = visuals.boxes.color,
            Callback = function(color)
                visuals.boxes.color = color
            end
        })

        
        local enable_box_outline_cb = Tabs.visuals_tab:AddToggle("EnableBoxOutline", {Title = "Box Outline", Default = visuals.boxes.outline.enabled})
        enable_box_outline_cb:OnChanged(function(value)
            visuals.boxes.outline.enabled = value
        end)

        local box_outline_color_picker = Tabs.visuals_tab:AddColorpicker("BoxOutlineColorPicker", {
            Title = "Outline Color",
            Default = visuals.boxes.outline.color,
            Callback = function(color)
                visuals.boxes.outline.color = color
            end
        })

        local enable_box_filled_cb = Tabs.visuals_tab:AddToggle("EnableBoxFilled", {Title = "Box Filled", Default = visuals.boxes.filled.enabled})
        enable_box_filled_cb:OnChanged(function(value)
            visuals.boxes.filled.enabled = value
        end)

        local box_filled_color_picker = Tabs.visuals_tab:AddColorpicker("BoxFilledColorPicker", {
            Title = "Fill Color",
            Default = visuals.boxes.filled.color,
            Callback = function(color)
                visuals.boxes.filled.color = color
            end
        })

        local box_filled_transparency_slider = Tabs.visuals_tab:AddSlider("BoxFilledTransparency", {
            Title = "Fill Transparency",
            Default = visuals.boxes.filled.transparency,
            Min = 0,
            Max = 1,
            Rounding = 2
        })
        box_filled_transparency_slider:OnChanged(function(value)
            visuals.boxes.filled.transparency = value
        end)


        
        Tabs.visuals_tab:AddSection("Names Settings")

        local enable_names_cb = Tabs.visuals_tab:AddToggle("EnableNames", {Title = "Names", Default = visuals.names.enabled})
        enable_names_cb:OnChanged(function(value)
            visuals.names.enabled = value
        end)

        local name_color_picker = Tabs.visuals_tab:AddColorpicker("NameColorPicker", {
            Title = "Name Color",
            Default = visuals.names.color,
            Callback = function(color)
                visuals.names.color = color
            end
        })

        
        local enable_name_outline_cb = Tabs.visuals_tab:AddToggle("EnableNameOutline", {Title = "Name Outline", Default = visuals.names.outline.enabled})
        enable_name_outline_cb:OnChanged(function(value)
            visuals.names.outline.enabled = value
        end)

        local name_outline_color_picker = Tabs.visuals_tab:AddColorpicker("NameOutlineColorPicker", {
            Title = "Outline Color",
            Default = visuals.names.outline.color,
            Callback = function(color)
                visuals.names.outline.color = color
            end
        })


        
        Tabs.visuals_tab:AddSection("Health Settings")

        local enable_health_cb = Tabs.visuals_tab:AddToggle("EnableHealth", {Title = "Health", Default = visuals.health.enabled})
        enable_health_cb:OnChanged(function(value)
            visuals.health.enabled = value
        end)

        local health_color_picker = Tabs.visuals_tab:AddColorpicker("HealthColorPicker", {
            Title = "Health Color",
            Default = visuals.health.color,
            Callback = function(color)
                visuals.health.color = color
            end
        })

        local health_low_color_picker = Tabs.visuals_tab:AddColorpicker("HealthLowColorPicker", {
            Title = "Low Health Color",
            Default = visuals.health.colorLow,
            Callback = function(color)
                visuals.health.colorLow = color
            end
        })

        -- Health Outline Toggle and Color Picker
        local enable_health_outline_cb = Tabs.visuals_tab:AddToggle("EnableHealthOutline", {Title = "Health Outline", Default = visuals.health.outline.enabled})
        enable_health_outline_cb:OnChanged(function(value)
            visuals.health.outline.enabled = value
        end)

        local health_outline_color_picker = Tabs.visuals_tab:AddColorpicker("HealthOutlineColorPicker", {
            Title = "Outline Color",
            Default = visuals.health.outline.color,
            Callback = function(color)
                visuals.health.outline.color = color
            end
        })

       
        local enable_health_text_cb = Tabs.visuals_tab:AddToggle("EnableHealthText", {Title = "Health Text", Default = visuals.health.text.enabled})
        enable_health_text_cb:OnChanged(function(value)
            visuals.health.text.enabled = value
        end)

        
        local enable_health_text_outline_cb = Tabs.visuals_tab:AddToggle("EnableHealthTextOutline", {Title = "Health Text Outline", Default = visuals.health.text.outline.enabled})
        enable_health_text_outline_cb:OnChanged(function(value)
            visuals.health.text.outline.enabled = value
        end)
       
        --// Sky boxes \\--
        Tabs.visuals_tab:AddSection("Skyboxes | VERY BUGGY")


        local function setupSkybox()
            local lighting = game:GetService("Lighting")
            local players = game:GetService("Players")
            local Sky = lighting:FindFirstChild("Sky")
        
            if not Sky then
                Sky = Instance.new("Sky", lighting)
            end
        
            local skyboxAssetsUrl = "https://raw.githubusercontent.com/NervigeMuecke/Z3US-V2/refs/heads/main/Important/Skyboxes.lua"
            local skyboxAssets = loadstring(game:HttpGet(skyboxAssetsUrl))()
            local currentSkybox = 'Default'
        
            local function updatePlayerSkybox(path)
                local playerSkybox = players.LocalPlayer:FindFirstChild("PlayerScripts")
                                  and players.LocalPlayer.PlayerScripts:FindFirstChild("Assets")
                                  and players.LocalPlayer.PlayerScripts.Assets:FindFirstChild("MapLighting")
                                  and players.LocalPlayer.PlayerScripts.Assets.MapLighting:FindFirstChild(path)
                                  and players.LocalPlayer.PlayerScripts.Assets.MapLighting[path]:FindFirstChild("Sky")
                return playerSkybox
            end
        
            local function updateSkybox(skyboxName)
                if skyboxAssets[skyboxName] then
                    local skybox = skyboxAssets[skyboxName]
        
                    Sky.SkyboxBk = skybox.SkyboxBk
                    Sky.SkyboxDn = skybox.SkyboxDn
                    Sky.SkyboxFt = skybox.SkyboxFt
                    Sky.SkyboxLf = skybox.SkyboxLf
                    Sky.SkyboxRt = skybox.SkyboxRt
                    Sky.SkyboxUp = skybox.SkyboxUp
        
                    local defaultSkybox = updatePlayerSkybox("Default")
                    if defaultSkybox then
                        defaultSkybox.SkyboxBk = skybox.SkyboxBk
                        defaultSkybox.SkyboxDn = skybox.SkyboxDn
                        defaultSkybox.SkyboxFt = skybox.SkyboxFt
                        defaultSkybox.SkyboxLf = skybox.SkyboxLf
                        defaultSkybox.SkyboxRt = skybox.SkyboxRt
                        defaultSkybox.SkyboxUp = skybox.SkyboxUp
                    end
        
                    local stationSkybox = updatePlayerSkybox("Station")
                    if stationSkybox then
                        stationSkybox.SkyboxBk = skybox.SkyboxBk
                        stationSkybox.SkyboxDn = skybox.SkyboxDn
                        stationSkybox.SkyboxFt = skybox.SkyboxFt
                        stationSkybox.SkyboxLf = skybox.SkyboxLf
                        stationSkybox.SkyboxRt = skybox.SkyboxRt
                        stationSkybox.SkyboxUp = skybox.SkyboxUp
                    end
                else
                    updateSkybox('Default')
                end
            end
        
            local function persistSkybox()
                while true do
                    task.wait(0.01)
                    updateSkybox(currentSkybox)
                end
            end
        
            Tabs.visuals_tab:AddDropdown('World_Skybox', {
                Values = { 'Default', 'Neptune', 'Among Us', 'Nebula', 'Vaporwave', 'Clouds', 'Twilight', 'DaBaby', 'Minecraft', 'Chill', 'Redshift', 'Blue Stars', 'Blue Aurora' },
                Default = currentSkybox,
                Multi = false,
                Title = 'Custom Skybox:',
                Tooltip = 'Sky Changer',
            }):OnChanged(function(World_Skybox)
                currentSkybox = World_Skybox
                updateSkybox(currentSkybox)
            end)
        
            coroutine.wrap(persistSkybox)()
        end
        
        setupSkybox()

        Tabs.visuals_tab:AddSection("ViewModel")

        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local RunService = game:GetService("RunService")
        local TempViewModels = ReplicatedStorage.Assets.Temp.ViewModels
        local player = game.Players.LocalPlayer
        local selectedColor = Color3.fromRGB(19, 0, 255)
        local selectedMaterial = Enum.Material.SmoothPlastic
        local updateInterval = 0.1
        local lastUpdateTime = tick()
        local updateEnabled = false 

        local toggle = Tabs.visuals_tab:AddToggle("ViewModelToggle", {
            Title = "Enable Custom ViewModel",
            Default = false,
        })
        toggle:OnChanged(function(value)
            updateEnabled = value
        end)

        local Colorpicker = Tabs.visuals_tab:AddColorpicker("Colorpicker", {
            Title = "ViewModel Color",
            Default = selectedColor,
            Callback = function(color)
                selectedColor = color
            end
        })

        local MaterialPicker = Tabs.visuals_tab:AddDropdown("MaterialPicker", {
            Title = "Gun Material",
            Values = {
                "None",
                "ForceField",
                "Glass",
                "Ice",
                "Metal",
                "Neon",
                "Plastic",
                "SmoothPlastic"
            },
            Multi = false,
            Default = 1,
            Callback = function(selectedMaterialName)
                selectedMaterial = Enum.Material[selectedMaterialName]
            end
        })

        RunService.Heartbeat:Connect(function()
            if updateEnabled and tick() - lastUpdateTime >= updateInterval then
                lastUpdateTime = tick()
                
                for _, viewModel in ipairs(TempViewModels:GetChildren()) do
                    if viewModel:IsA("Model") then

                        viewModel.Name = player.Name
                        
                        for _, part in ipairs(viewModel:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.Color = selectedColor
                                part.Material = selectedMaterial
                            end
                        end
                    end
                end
            end
        end)

        
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local UserInputService = game:GetService("UserInputService")

        local MAX_DISTANCE = 1000
        local TELEPORT_DISTANCE = 5

        local function getNearestEnemy()
            local nearestEnemy = nil
            local shortestDistance = math.huge

            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and not is_teammate(player) then
                    local character = player.Character
                    if character and character:FindFirstChild("Humanoid") then
                        local humanoid = character:FindFirstChild("Humanoid")
                        if humanoid and humanoid.Health > 0 then
                            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                nearestEnemy = character
                            end
                        end
                    end
                end
            end

            return nearestEnemy
        end

        local function teleportBehindEnemy()
            local nearestEnemy = getNearestEnemy()
            if nearestEnemy and nearestEnemy:FindFirstChild("HumanoidRootPart") then
                local enemyPosition = nearestEnemy.HumanoidRootPart.Position
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - enemyPosition).Magnitude
                
                if distance <= MAX_DISTANCE then
                    local behindPosition = enemyPosition - (nearestEnemy.HumanoidRootPart.CFrame.lookVector * TELEPORT_DISTANCE)
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(behindPosition)
                    end
                end
            end
        end

        local function autoShot()
            mouse1press()
            wait(0)
            mouse1release()
        end

        local teleportToggle = Tabs.teleport_tab:AddToggle("TeleportBehindEnemyToggle", {
            Title = "Teleport Behind Enemy",
            Default = false,
            Callback = function(value)
                getgenv().TeleportEnabled = value

                while getgenv().TeleportEnabled do
                    teleportBehindEnemy()
                    wait(0)
                end
            end
        })

        Tabs.teleport_tab:AddSlider("SetTeleportDistance", {
            Title = "Teleport Distance",
            Default = TELEPORT_DISTANCE,
            Min = 1,
            Max = 10,
            Rounding = 1,
            Callback = function(value)
                TELEPORT_DISTANCE = value
            end
        })

    
        local autoShotToggle = Tabs.teleport_tab:AddToggle("AutoShotToggle", {
            Title = "Auto Shot",
            Default = false,
            Callback = function(value)
                getgenv().AutoShotEnabled = value
        
                while getgenv().AutoShotEnabled do
                    local screenGui = game:GetService("CoreGui"):FindFirstChild("HiddenUI")
                    if screenGui then
                        local child = screenGui:FindFirstChildOfClass("ScreenGui"):GetChildren()[2]
                        if child and not child.Visible then
                            pcall(autoShot)
                        end
                    end
                    task.wait(0.1)
                end
            end
        })
        
        


        --// Player Tab \\--

        Tabs.player_tab:AddToggle("Fly",{Title = "Enable Fly", default = ZYPHERION.Player.Fly,})
        :OnChanged(
            function(Value)
            ZYPHERION.Player.Fly = Value
            if Value then
                startFly()
            else
                stopFly()
            end
        end)
        
        Tabs.player_tab:AddSlider("FlySpeed",
        {Title = "Set FlySpeed", 
        Default = ZYPHERION.Player.FlySpeedValue,
        Min = 1, 
        Max = 100, 
        Rounding = 1,
        Callback = function(Value)
            ZYPHERION.Player.FlySpeedValue = Value
        end
        })

        Tabs.player_tab:AddToggle("WalkSpeed", {
            Title = "Enable WalkSpeed",
            Default = ZYPHERION.Player.WalkSpeed,
        }):OnChanged(function(Value)
            if Value then
                setWalkSpeed()
                walkSpeedConnection = game:GetService("RunService").RenderStepped:Connect(setWalkSpeed)
            else
                if walkSpeedConnection then
                    walkSpeedConnection:Disconnect()
                    walkSpeedConnection = nil
                end
                resetWalkSpeed()
            end
        end)


        Tabs.player_tab:AddSlider("SetWalkSpeed", {
            Title = "Set WalkSpeed",
            Default = ZYPHERION.Player.WalkSpeedValue,
            Min = 1,
            Max = 100,
            Rounding = 1,
            Callback = function(Value)
                ZYPHERION.Player.WalkSpeedValue = Value
            end
        })

        Tabs.player_tab:AddToggle("InfiniteJump", {
            Title = "Enable Infinite Jump",
            Default = ZYPHERION.Player.InfiniteJump,
        }):OnChanged(function(Value)
            ZYPHERION.Player.InfiniteJump = Value
        end)


        Tabs.player_tab:AddToggle("Noclip",{Title = "No clip", Default = ZYPHERION.Player.Noclip})
        :OnChanged(function(Value)
            ZYPHERION.Player.Noclip = Value
            if Value then
                noclipConnection = game:GetService("RunService").Stepped:Connect(function()
                    for _, v in pairs(PLAYER.Character:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                end)
            else
                if noclipConnection then
                    noclipConnection:Disconnect()
                    noclipConnection = nil
                end
                for _, v in pairs(PLAYER.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = true
                    end
                end
            end
        end)


        local runService=game:GetService("RunService")
        local camera=workspace.Camera
        local fov=camera.FieldOfView


        runService.RenderStepped:Connect(function()
            camera.FieldOfView=fov
            if fov>=120 then
                local dv=(1.7320508075688767*((camera.ViewportSize.Y/2)/math.tan(math.rad(fov/2))))/(camera.ViewportSize.Y/2)
                camera.CFrame*=CFrame.new(0,0,0,dv,0,0,0,dv,0,0,0,1)
            end
        end)

        Tabs.player_tab:AddSlider("FOVSlider", {
            Title = "Set Camera FOV",
            Default = camera.FieldOfView,
            Min = 10,
            Max = 175,
            Rounding = 0,
            Callback = function(value)
                fov = value
            end
        })

    
        --// Device Spoofer Tab \\--


        local MiscTab = Tabs.misc_tab:AddSection("No Flash & No Smoke")

        MiscTab:AddButton({
            Title = 'No Flash', 
            Callback = function()
            if game:GetService("Players").LocalPlayer.PlayerScripts.Assets.Misc:FindFirstChild("FlashbangEffect") then 
                game:GetService("Players").LocalPlayer.PlayerScripts.Assets.Misc.FlashbangEffect:Destroy()
            end
        end})
        
        MiscTab:AddButton({Title = 'No Smoke', Callback = function()
            if game:GetService("Players").LocalPlayer.PlayerScripts.Assets.Misc:FindFirstChild("SmokeClouds") then 
                game:GetService("Players").LocalPlayer.PlayerScripts.Assets.Misc.SmokeClouds:Destroy()
            end
        end})

        
        Tabs.misc_tab:AddSection("Device Spoofer")

        local Spoof = false
        local DeviceSpoofer = "Keyboard"


        Tabs.misc_tab:AddToggle("SpoofDevice", {
            Title = "Spoof Device",
            Default = Spoof,
        }):OnChanged(function(state)
            SpoofDevice = state
            if state then
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Replication"):WaitForChild("Fighter"):WaitForChild("SetControls"):FireServer(DeviceSpoofer)
            else
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Replication"):WaitForChild("Fighter"):WaitForChild("SetControls"):FireServer("MouseKeyboard")  
            end
        end)

        Tabs.misc_tab:AddDropdown('DeviceSpoofer', {
            Title = "Device Spoofer",
            Values = {"MouseKeyboard", "Touch", "Gamepad"},
            Multi = false,
            Default = DeviceSpoofer,
            Callback = function(v)
                DeviceSpoofer = v
                if SpoofDevice then
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Replication"):WaitForChild("Fighter"):WaitForChild("SetControls"):FireServer(DeviceSpoofer)
                end
            end
        })



        --// Hitsounds Sections \\ --

        Tabs.misc_tab:AddSection("Hit Sounds")
            local currentVolume = 5
            local currentPitch = 1

            local sounds = {
                ["Default Body"] = "rbxassetid://9114487369",
                Neverlose = "rbxassetid://8726881116",
                Gamesense = "rbxassetid://4817809188",
                One = "rbxassetid://7380502345",
                Bell = "rbxassetid://6534947240",
                Rust = "rbxassetid://1255040462",
                TF2 = "rbxassetid://2868331684",
                Slime = "rbxassetid://6916371803",
                ["Among Us"] = "rbxassetid://5700183626",
                Minecraft = "rbxassetid://4018616850",
                ["CS:GO"] = "rbxassetid://6937353691",
                Saber = "rbxassetid://8415678813",
                Baimware = "rbxassetid://3124331820",
                Osu = "rbxassetid://7149255551",
                ["TF2 Critical"] = "rbxassetid://296102734",
                Bat = "rbxassetid://3333907347",
                ["Call of Duty"] = "rbxassetid://5952120301",
                Bubble = "rbxassetid://6534947588",
                Pick = "rbxassetid://1347140027",
                Pop = "rbxassetid://198598793",
                Bruh = "rbxassetid://4275842574",
                Bamboo = "rbxassetid://3769434519",
                Crowbar = "rbxassetid://546410481",
                Weeb = "rbxassetid://6442965016",
                Beep = "rbxassetid://8177256015",
                Bambi = "rbxassetid://8437203821",
                Stone = "rbxassetid://3581383408",
                ["Old Fatality"] = "rbxassetid://6607142036",
                Click = "rbxassetid://8053704437",
                Ding = "rbxassetid://7149516994",
                Snow = "rbxassetid://6455527632",
                Laser = "rbxassetid://7837461331",
                Mario = "rbxassetid://2815207981",
                Steve = "rbxassetid://4965083997"
            }

            local CustomHitSounds = false
            local HitSound = "None"

            local function PlayHitSound(soundId)
                if not soundId then
                    return
                end
                
                local sound = Instance.new("Sound")
                sound.SoundId = soundId
                sound.Volume = currentVolume
                sound.Pitch = currentPitch
                sound.Parent = game:GetService("SoundService")
                sound:Play()
                sound.Ended:Connect(function()
                    sound:Destroy()
                end)
            end

            
            Tabs.misc_tab:AddToggle("Enabled", {Title = "Enable", default = CustomHitSounds}):OnChanged(
                function(state)
                CustomHitSounds = state
            end)


            Tabs.misc_tab:AddSlider('Volume',
            {Title = "Volume", 
            Default = currentVolume, 
            Min = 0, 
            Max = 10, 
            Rounding = 1, 
            Callback = function(vol)
                currentVolume = vol
            end})


            Tabs.misc_tab:AddDropdown('HitSound',
            {Title = "Hitsounds", 
            Values = {
                'None', 'Neverlose', 'Gamesense', 'One', 'Bell', 'Rust', 'TF2', 'Slime',
                'Among Us', 'Minecraft', 'CS:GO', 'Saber', 'Baimware', 'Osu', 'TF2 Critical', 'Bat',
                'Call of Duty', 'Bubble', 'Pick', 'Pop', 'Bruh', 'Bamboo', 'Crowbar', 'Weeb', 'Beep',
                'Bambi', 'Stone', 'Old Fatality', 'Click', 'Ding', 'Snow', 'Laser', 'Mario', 'Steve',
            }, 
            Multi = false, 
            Default = HitSound, 
            Callback = function(selected)
                HitSound = selected
                local soundId = sounds[HitSound]
                if CustomHitSounds then
                    PlayHitSound(soundId)
                end
            end})

            local function setupHitSound()
                local localPlayer = game:GetService("Players").LocalPlayer
            
                local sounds = {
                    ["Default Body"] = "rbxassetid://9114487369",
                    Neverlose = "rbxassetid://8726881116",
                    Gamesense = "rbxassetid://4817809188",
                    One = "rbxassetid://7380502345",
                    Bell = "rbxassetid://6534947240",
                    Rust = "rbxassetid://1255040462",
                    TF2 = "rbxassetid://2868331684",
                    Slime = "rbxassetid://6916371803",
                    ["Among Us"] = "rbxassetid://5700183626",
                    Minecraft = "rbxassetid://4018616850",
                    ["CS:GO"] = "rbxassetid://6937353691",
                    Saber = "rbxassetid://8415678813",
                    Baimware = "rbxassetid://3124331820",
                    Osu = "rbxassetid://7149255551",
                    ["TF2 Critical"] = "rbxassetid://296102734",
                    Bat = "rbxassetid://3333907347",
                    ["Call of Duty"] = "rbxassetid://5952120301",
                    Bubble = "rbxassetid://6534947588",
                    Pick = "rbxassetid://1347140027",
                    Pop = "rbxassetid://198598793",
                    Bruh = "rbxassetid://4275842574",
                    Bamboo = "rbxassetid://3769434519",
                    Crowbar = "rbxassetid://546410481",
                    Weeb = "rbxassetid://6442965016",
                    Beep = "rbxassetid://8177256015",
                    Bambi = "rbxassetid://8437203821",
                    Stone = "rbxassetid://3581383408",
                    ["Old Fatality"] = "rbxassetid://6607142036",
                    Click = "rbxassetid://8053704437",
                    Ding = "rbxassetid://7149516994",
                    Snow = "rbxassetid://6455527632",
                    Laser = "rbxassetid://7837461331",
                    Mario = "rbxassetid://2815207981",
                    Steve = "rbxassetid://4965083997"
                }
                
                local function playCustomHitSound()
                    local soundId = sounds[HitSound]
                    if not soundId then return end
            
                    local customSound = Instance.new("Sound")
                    customSound.SoundId = soundId
                    customSound.Volume = currentVolume
                    customSound.Pitch = currentPitch
                    customSound.Parent = localPlayer:WaitForChild("PlayerGui")
                    customSound:Play()
                    customSound.Ended:Connect(function()
                        customSound:Destroy()
                    end)
                end
            
                local function onSoundAdded(sound)
                    if CustomHitSounds and sound:IsA("Sound") then
                        sound:Stop()
                        playCustomHitSound()
                        sound:Destroy()
                    end
                end
            
                local function FindSoundToMakeHitsound()
                    local RunService = game:GetService("RunService")
                    RunService.Heartbeat:Connect(function()
                        local clientViewModel = localPlayer.PlayerScripts:FindFirstChild("Modules")
                            and localPlayer.PlayerScripts.Modules:FindFirstChild("ClientReplicatedClasses")
                            and localPlayer.PlayerScripts.Modules.ClientReplicatedClasses:FindFirstChild("ClientFighter")
                            and localPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter:FindFirstChild("ClientItem")
                            and localPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")
            
                        if clientViewModel then
                            for _, descendant in ipairs(clientViewModel:GetDescendants()) do
                                if descendant:IsA("Sound") and not descendant:GetAttribute("Processed") then
                                    onSoundAdded(descendant)
                                    descendant:SetAttribute("Processed", true)
                                end
                            end
                        else
                        end
                    end)
                end
            
                FindSoundToMakeHitsound()
            end

            setupHitSound()


            --// Skin Changer Sections\\--
            Tabs.misc_tab:AddSection("Skinchanger")


            local weaponSkins = {
                ["Assault Rifle"] = {"AK-47", "AKEY-47", "Boneclaw Rifle", "AUG", "Gingerbread AUG", "Keyper", "Hyper Sniper", "Pixel Sniper"},
                ["Battle Axe"] = {"The Shred", "Nordic Axe"},
                ["Burst Rifle"] = {"Aqua Burst", "Electro Rifle", "Pixel Burst", "Pine Burst"},
                ["Chainsaw"] = {"Blobsaw"},
                ["Daggers"] = {"Aces", "Cookies"},
                ["Energy Rifle"] = {"2025 Energy Rifle", "Apex Rifle"},
                ["Energy Pistols"] = {"2025 Energy Pistols", "Apex Pistols"},
                ["Exogun"] = {"Ray Gun", "Singularity", "Wondergun"},
                ["Fists"] = {"Boxing Gloves", "Brass Knuckles", "Pumpkin Claws", "Festive Fists"},
                ["Flamethrower"] = {"Lamethrower", "Pixel Flamethrower"},
                ["Flare Gun"] = {"Dynamite Gun", "Firework Gun"},
                ["Freeze Ray"] = {"Bubble Ray", "Temporal Ray", "Spider Ray"},
                ["Grenade"] = {"Water Balloon", "Whoopee Cushion", "Soul Grenade", "Jingle Grenade"},
                ["Grenade Launcher"] = {"Swashbuckler", "Uranium Launcher","Skull Launcher"},
                ["Handgun"] = {"Blaster", "Pixel Handgun", "Pumpkin Handgun", "Gingerbread Handgun"},
                ["Katana"] = {"Lightning Bolt", "Saber", "Pixel Katana", "Devil's Trident", "2025 Katana"},
                ["Knife"] = {"Chancla", "Karambit", "Machete"},
                ["Minigun"] = {"Lasergun 3000", "Pixel Minigun"},
                ["Molotov"] = {"Coffee", "Torch", "Hexxed Candle"},
                ["Paintball Gun"] = {"Boba Gun", "Slime Gun"},
                ["Revolver"] = {"Boneclaw Revolver"},
                ["RPG"] = {"Nuke Launcher"},
                ["Scythe"] = {"Anchor", "Keythe", "Scythe of Death", "Bat Scythe", "Cryo Scythe"},
                ["Shorty"] = {"Lovely Shorty", "Not So Shorty", "Too Shorty", "Demon Shorty"},
                ["Shotgun"] = {"Balloon Shotgun", "Hyper Shotgun"},
                ["Slingshot"] = {"Goalpost", "Stick"},
                ["Smoke Grenade"] = {"Balance", "Emoji Cloud", "Eyeball"},
                ["Sniper"] = {"Hyper Sniper", "Pixel Sniper", "Keyper", "Gingerbread Sniper", "Eyething Sniper"},
                ["Subspace Tripmine"] = {"Don't Press", "Spring"},
                ["Trowel"] = {"Garden Shovel", "Plastic Shovel"},
                ["Uzi"] = {"Electro Uzi", "Water Uzi"},
                ["Flashbang"] = {"Camera", "Disco Ball", "Pixel Flashbang", "Skullbang"},
                ["Medkit"] = {"Briefcase", "Laptop"}
            }
            
            

            local originalDescendants = {}
            local activeWeapons = {}
            local playerName = game:GetService("Players").LocalPlayer.Name
            local selectedSkins = {}
            local assetFolder = game:GetService("Players").LocalPlayer.PlayerScripts.Assets.ViewModels

            local Functions = {}

            function Functions:SaveOriginalGunsNeg(object)
                if object and not originalDescendants[object.Name] then
                    originalDescendants[object.Name] = {}
                    for _, child in pairs(object:GetChildren()) do
                        table.insert(originalDescendants[object.Name], child:Clone())
                    end
                end
            end

            function Functions:PutBackOriginal(object)
                if object and originalDescendants[object.Name] then
                    object:ClearAllChildren()
                    for _, originalChild in pairs(originalDescendants[object.Name]) do
                        originalChild.Parent = object
                    end
                    originalDescendants[object.Name] = nil
                end
            end

            function Functions:swapWeaponSkins(normalWeaponName, skinName, toggleState)
                if not normalWeaponName then return end
                
                local normalWeapon = assetFolder:FindFirstChild(normalWeaponName)
                if not normalWeapon then return end

                if toggleState then
                    if skinName then
                        local skin = assetFolder:FindFirstChild(skinName)
                        if not skin then return end

                        self:SaveOriginalGunsNeg(normalWeapon)
                        normalWeapon:ClearAllChildren()
                        for _, child in pairs(skin:GetChildren()) do
                            local newChild = child:Clone()
                            newChild.Parent = normalWeapon
                        end
                        activeWeapons[normalWeaponName] = true
                    end
                else
                    self:PutBackOriginal(normalWeapon)
                    activeWeapons[normalWeaponName] = nil
                end
            end

            local function applySavedSkins()
                for weapon, skin in pairs(selectedSkins) do
                    if weaponSkins[weapon] and table.find(weaponSkins[weapon], skin) then
                        Functions:swapWeaponSkins(weapon, skin, true)
                    end
                end
            end

            local skinDropdown
            local normalWeaponDropdown = Tabs.misc_tab:AddDropdown('NormalWeapons', {
                Title = 'Weapon',
                Values = {
                    "None","Assault Rifle", "Battle Axe", "Burst Rifle", "Chainsaw", "Daggers", "Energy Rifle", "Energy Pistols", "Exogun", "Fists", 
                    "Flamethrower", "Flare Gun", "Freeze Ray", "Grenade", "Grenade Launcher", 
                    "Handgun", "Katana", "Knife", "Minigun", "Molotov", "Paintball Gun", "Revolver",
                    "RPG", "Scythe", "Shorty", "Shotgun", "Slingshot", 
                    "Smoke Grenade", "Sniper", "Subspace Tripmine", "Trowel", "Uzi", "Flashbang", 
                    "Medkit"
                },   
                Multi = false,
                Default = 1,
                Callback = function(v)
                    NormalWeapon = v
                    local skins = weaponSkins[v] or {}

                    if skinDropdown then
                        skinDropdown:SetValues(skins)
                        Skin = selectedSkins[NormalWeapon] or skins[1]
                        skinDropdown:SetValue(Skin)

                        Functions:swapWeaponSkins(NormalWeapon, Skin, true)
                        Functions:saveSettings()
                    end
                end
            })

            skinDropdown = Tabs.misc_tab:AddDropdown('Skin', {
                Title = 'Skin',
                Values = {"PlaceHolder"},
                Multi = false,
                Default = 1,
                Callback = function(v)
                    selectedSkins[NormalWeapon] = v
                    Skin = v
                    Functions:swapWeaponSkins(NormalWeapon, Skin, true)
                    Functions:saveSettings()
                end
            })

            local HttpService = game:GetService("HttpService")
            local settingsFileName = "WeaponSkins.json"

            function Functions:saveSettings()
                writefile(settingsFileName, HttpService:JSONEncode({
                    selectedSkins = selectedSkins
                }))
            end

            function Functions:loadSettings()
                local success, data = pcall(function()
                    return HttpService:JSONDecode(readfile(settingsFileName))
                end)
                
                if success and data then
                    selectedSkins = data.selectedSkins or {}
                    applySavedSkins()
                end
            end

            Functions:loadSettings()


            --// Crosshair Sections \\ --


            Tabs.misc_tab:AddSection("Custom Crosshair")
            local RunService = game:GetService("RunService")

            local Camera = game.Workspace.CurrentCamera

            local crosshairVisible = false
            local showSwastika = false
            local crosshairColor = Color3.fromRGB(255, 0, 0)
            local swastikaColor = Color3.fromRGB(255, 0, 0)
            local rotationEnabled = false
            local rotationSpeed = 3
            local currentRotation = 0

            local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

            local crosshairLine1 = Drawing.new("Line")
            crosshairLine1.Thickness = 3
            crosshairLine1.Color = crosshairColor
            crosshairLine1.Visible = crosshairVisible

            local crosshairLine2 = Drawing.new("Line")
            crosshairLine2.Thickness = 3
            crosshairLine2.Color = crosshairColor
            crosshairLine2.Visible = crosshairVisible

            local swastika = Drawing.new("Text")
            swastika.Text = "卐"
            swastika.Font = Drawing.Fonts.UI
            swastika.Size = 50
            swastika.Color = swastikaColor
            swastika.Visible = false

            local function rotatePoint(point, angle)
                local offsetX = point.X - screenCenter.X
                local offsetY = point.Y - screenCenter.Y
                local cosTheta = math.cos(angle)
                local sinTheta = math.sin(angle)
                local rotatedX = cosTheta * offsetX - sinTheta * offsetY
                local rotatedY = sinTheta * offsetX + cosTheta * offsetY
                return Vector2.new(rotatedX + screenCenter.X, rotatedY + screenCenter.Y)
            end

            local function updateCrosshairPosition()
                crosshairLine1.Color = crosshairColor
                crosshairLine2.Color = crosshairColor
                
                local angle = math.rad(currentRotation)

                local from1 = Vector2.new(screenCenter.X - 15, screenCenter.Y)
                local to1 = Vector2.new(screenCenter.X + 15, screenCenter.Y)
                local from2 = Vector2.new(screenCenter.X, screenCenter.Y - 15)
                local to2 = Vector2.new(screenCenter.X, screenCenter.Y + 15)

                if rotationEnabled then
                    from1 = rotatePoint(from1, angle)
                    to1 = rotatePoint(to1, angle)
                    from2 = rotatePoint(from2, angle)
                    to2 = rotatePoint(to2, angle)
                end

                crosshairLine1.From = from1
                crosshairLine1.To = to1
                crosshairLine2.From = from2
                crosshairLine2.To = to2

                if showSwastika then
                    swastika.Color = swastikaColor
                    swastika.Position = Vector2.new(screenCenter.X - (swastika.TextBounds.X / 2), screenCenter.Y - (swastika.TextBounds.Y / 2))
                end
            end


            Tabs.misc_tab:AddToggle("enablecrosshair",{
                Title = "Enable Crosshair",
                Default = crosshairVisible})
                :OnChanged(function(cr)
                    crosshairVisible = cr
                    if crosshairVisible then
                        crosshairLine1.Visible = not showSwastika
                        crosshairLine2.Visible = not showSwastika
                        swastika.Visible = showSwastika
                    else
                        crosshairLine1.Visible = false
                        crosshairLine2.Visible = false
                        swastika.Visible = false
                    end
                end
            )

            Tabs.misc_tab:AddToggle("swastika",{
                Title = "Show Swastika Crosshair",
                Default = showSwastika,})
                :OnChanged(function(swastikaVisible)
                    showSwastika = swastikaVisible
                    if crosshairVisible then
                        crosshairLine1.Visible = not showSwastika
                        crosshairLine2.Visible = not showSwastika
                        swastika.Visible = showSwastika
                    end
                end
            )

            Tabs.misc_tab:AddToggle("rotation",{
                Title = "Enable Crosshair Rotation",
                Default = rotationEnabled,})
                :OnChanged(function(enabled)
                    rotationEnabled = enabled
                end
            )

            Tabs.misc_tab:AddSlider("rotationspeed1", {
                Title = "Rotation Speed",
                Default = rotationSpeed,
                Min = 1,
                Max = 10,
                Rounding = 1,
                Callback = function(speed)
                    rotationSpeed = speed
                end
            })

            Tabs.misc_tab:AddSlider("Thickness", {
                Title = "Crosshair Thickness",
                Default = 3,
                Min = 1,
                Max = 10,
                Rounding = 1,
                Callback = function(afd)
                    crosshairLine1.Thickness = afd
                    crosshairLine2.Thickness = afd
                end
            })

            Tabs.misc_tab:AddColorpicker("crosshairColor1", {
                Title = "Crosshair Color",
                Default = crosshairColor,
                Callback = function(newColor)
                    crosshairColor = newColor
                    swastikaColor = newColor
                end
            })
            
            local crosshairRainbowEnabled = false
            Tabs.misc_tab:AddToggle("crosshairRainbowToggle", {
                Title = "Rainbow Crosshair",
                Default = crosshairRainbowEnabled
            }):OnChanged(function(enabled)
                crosshairRainbowEnabled = enabled
                if enabled then
                    while crosshairRainbowEnabled do
                        crosshairColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                        swastikaColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                        wait(0.1)
                    end
                end
            end)
            RunService.RenderStepped:Connect(function(deltaTime)
                screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                if crosshairVisible or showSwastika then
                    if rotationEnabled then
                        currentRotation = (currentRotation + rotationSpeed * deltaTime * 60) % 360
                    end
                    updateCrosshairPosition()
                end
            end)




            
            local textChatService = game:GetService("TextChatService")
            local UserInputService = game:GetService("UserInputService")

            local ChatSection = Tabs.misc_tab:AddSection("Trash Talk")
            local ChatSpammer = {Enabled = false}
            local words = {
                "where are you aiming at?", "sonned", "bad", "even my grandma has faster reactions", ":clown:",
                "gg = get good", "im just better", "my gaming chair is just better", "clip me", "skill", ":Skull:",
                "go play adopt me", "go play brookhaven", "omg you are so good :screm:", "awesome", "you built like gru",
                "fridge", "do not bully pliisss :sobv:", "it was your lag ofc", "fly high", "*cough* *cough*", "son",
                "already mad?", "please don't report :sobv:", "sob harder", "sopt be neamn to me :sob :sob: sov:", 
                "alt + f4 for better aim", "bro can't even aim", "free kill", "thanks for the warm-up", "uninstall pls", 
                "bet you can't hit a barn", "you lagging or what?", "try harder", "oh no, you're so scary", 
                "you sure you're playing?", "that's it?", "must be your first time", "ez",
                "press Q to cry", "get a refund on your skills", "you're not that guy", "ouch, that was embarrassing", 
                "no scope, no skill", "you look lost", "need help aiming?", "hold this L", "get rekt",
                "game over", "try again, maybe?", "what was that?", "no challenge at all", "level up your game", 
                "delete system32", "I'm built different", "was that your best?", "you're softer than butter", 
                "get clapped", "did you try turning it off and on again?", "boop, headshot", "smoked", "GG no re", 
                "brain.exe stopped working", "better luck next time", "you tried, and that's cute", "are you serious right now?",
                "controller disconnected?", "your Wi-Fi playing for you?", "AFK or just bad?", "another one bites the dust", 
                "you blinked and missed", "rookie move", "outplayed", "so close, yet so far",
                "that was tragic", "need a map?", "pack it up", "somebody uninstall", "better switch games", "missed me!",
                "predictable", "wow, impressive... not", "time to retire", "aim better, talk less", "oops, you slipped",
                "just uninstall already", "cry more, try less", "game sense is missing", "outskilled", "thanks for the highlight",
                "was that your secret move?", "yawn, too easy", "is your screen on?",
                "is that all you've got?", "the bot is better than you", "next time, bring skill", "you good, bro?",
                "zero effort", "keep dreaming", "the floor is your enemy", "bot behavior", "too predictable",
                "time for a rematch?", "you're joking, right?", "skill issue", "didn't see that coming, huh?",
                "oops, your skill leaked", "aiming practice needed", "outclassed", "step up your game", "flatline",
                "you just got benched", "casual spotted", "still warming up?", "forever stuck in tutorial?", "the audacity!",
                "lag excuse incoming", "is this a speedrun to lose?", "back to the drawing board", "better luck never",
                "your ego is misplaced", "that's just embarrassing"
            }
            

            local function sendRandomMessage()
                local message = words[math.random(1, #words)]
                if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                    pcall(function()
                        textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(message)
                    end)
                else
                    pcall(function()
                        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
                    end)
                end
            end

            ChatSection:AddToggle("trashtalk", {
                Title = "Trash Talk | Press V for a random message",
                Default = false,
                Callback = function(callback)
                    ChatSpammer.Enabled = callback
                end
            })

            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if input.KeyCode == Enum.KeyCode.V and not gameProcessed and ChatSpammer.Enabled then
                    sendRandomMessage()
                end
            end)




            local textChatService = game:GetService("TextChatService")
            local ChatSection = Tabs.misc_tab:AddSection("Chat Spammer")
            local ChatSpammer = {Enabled = false}
            local ChatSpammerDelay = {Value = 10}
            local ChatSpammerHideWait = {Enabled = true}
            local ChatSpammerMessages = {ObjectList = {}}
            local chatspammerfirstexecute = true
            local chatspammerhook = false
            local oldchanneltab
            local oldchannelfunc
            local oldchanneltabs = {}
            local waitnum = 0
            
            -- Toggle for enabling chat spammer
            ChatSection:AddToggle("Enable Chat Spammer", {
                Title = "Enable Chat Spammer",
                Default = false,
                Callback = function(callback)
                    ChatSpammer.Enabled = callback
                    if callback then
                        if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                            task.spawn(function()
                                repeat
                                    if ChatSpammer.Enabled then
                                        pcall(function()
                                            textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(
                                                (#ChatSpammerMessages.ObjectList > 0 and ChatSpammerMessages.ObjectList[math.random(1, #ChatSpammerMessages.ObjectList)] or "ZYPHERION on top") .. " | " .. 
                                            (function()
                                                local length = math.random(1, 15)
                                                local result = ""
                                                for i = 1, length do
                                                    result = result .. string.char(math.random(32, 126))
                                                end
                                                return result
                                            end)()
                                            )
                                        end)
                                    end
                                    if waitnum ~= 0 then
                                        task.wait(waitnum)
                                        waitnum = 0
                                    else
                                        task.wait(ChatSpammerDelay.Value / 10)
                                    end
                                until not ChatSpammer.Enabled
                            end)
                        else
                            task.spawn(function()
                                if chatspammerfirstexecute then
                                    PLAYER.PlayerGui:WaitForChild("Chat", 10)
                                    chatspammerfirstexecute = false
                                end
                                if PLAYER.PlayerGui:FindFirstChild("Chat") and PLAYER.PlayerGui.Chat:FindFirstChild("Frame") and
                                PLAYER.PlayerGui.Chat.Frame:FindFirstChild("ChatChannelParentFrame") and 
                                ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") then
                                    if not chatspammerhook then
                                        task.spawn(function()
                                            chatspammerhook = true
                                            for i, v in pairs(getconnections(ReplicatedStorage.DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent)) do
                                                if v.Function and #debug.getupvalues(v.Function) > 0 and
                                                type(debug.getupvalues(v.Function)[1]) == "table" and 
                                                getmetatable(debug.getupvalues(v.Function)[1]) and 
                                                getmetatable(debug.getupvalues(v.Function)[1]).GetChannel then
                                                    oldchanneltab = getmetatable(debug.getupvalues(v.Function)[1])
                                                    oldchannelfunc = oldchanneltab.GetChannel
                                                    oldchanneltab.GetChannel = function(Self, Name)
                                                        local tab = oldchannelfunc(Self, Name)
                                                        if tab and tab.AddMessageToChannel then
                                                            local addmessage = tab.AddMessageToChannel
                                                            if oldchanneltabs[tab] == nil then
                                                                oldchanneltabs[tab] = addmessage
                                                            end
                                                            tab.AddMessageToChannel = function(Self2, MessageData)
                                                                if MessageData.MessageType == "System" then
                                                                    if MessageData.Message:find("You must wait") and ChatSpammer.Enabled then
                                                                        return nil
                                                                    end
                                                                end
                                                                return addmessage(Self2, MessageData)
                                                            end
                                                        end
                                                        return tab
                                                    end
                                                end
                                            end
                                        end)
                                    end
                                    task.spawn(function()
                                        repeat
                                            pcall(function()
                                                ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                                                    (#ChatSpammerMessages.ObjectList > 0 and ChatSpammerMessages.ObjectList[math.random(1, #ChatSpammerMessages.ObjectList)] or "vxpe on top") .. " | " .. string.char(math.random(65, 90)) .. string.char(math.random(65, 90)) .. string.char(math.random(65, 90)) .. string.char(math.random(65, 90)),
                                                    "All"
                                                )
                                            end)
                                            if waitnum ~= 0 then
                                                task.wait(waitnum)
                                                waitnum = 0
                                            else
                                                task.wait(ChatSpammerDelay.Value / 10)
                                            end
                                        until not ChatSpammer.Enabled
                                    end)
                                else
                                    if ChatSpammer.Enabled then ChatSpammer.ToggleButton(false) end
                                end
                            end)
                        end
                    else
                        waitnum = 0
                    end
                end
            })
            
        
            ChatSection:AddSlider("Delay", {
                Title = "Delay",
                Default = ChatSpammerDelay.Value,
                Min = 1,
                Max = 50,
                Rounding = 0,
                Callback = function(Value)
                    ChatSpammerDelay.Value = Value
                end
            })
            
            --[[
            ChatSection:AddToggle("Hide Wait Message", {
                Title = "Hide Wait Message",
                Default = true,
                Callback = function(callback)
                    ChatSpammerHideWait.Enabled = callback
                end
            })]]
            
            -- TextBox for custom messages
            ChatSection:AddInput("Messages", {
                Title = "Messages",
                Default = "ZYPHERION ON TOP",
                Numeric = false,
                Finished = true,
                Callback = function(Value)
                    table.insert(ChatSpammerMessages.ObjectList, Value)
                end
            })
            

            
            
            
            
            

    
            local TestTab = Tabs.misc_tab:AddSection("Other")
    

            TestTab:AddButton({
                Title = "Claim all rewards",
                Callback = function()
                    local ReplicatedStorage = game:GetService("ReplicatedStorage")
            
                    local function claimAllRewards()
                        ReplicatedStorage.Remotes.Data.ClaimLikeReward:FireServer()
                        
                        ReplicatedStorage.Remotes.Data.ClaimFavoriteReward:FireServer()
                        
                        ReplicatedStorage.Remotes.Data.ClaimNotificationsReward:FireServer()
                    end
            
                    claimAllRewards()
                end
            })

            TestTab:AddButton({
                Title = "Claim All Codes",
                Callback = function()
                    game:GetService("ReplicatedStorage").Remotes.Data.VerifyTwitter:FireServer()
                    wait(1)
            
                    local codes = {
                        "BONUS",
                        "roblox_rtc",
                        "COMMUNITY10",
                    }
            
                    for _, code in ipairs(codes) do
                        game:GetService("ReplicatedStorage").Remotes.Data.RedeemCode:InvokeServer(code)
                        wait(1)
                    end
                end
            })
        
            --[[
            TestTab:AddButton({
                Title = "Recover Win Streak (Free)",
                Callback = function()
                    local ReplicatedStorage = game:GetService("ReplicatedStorage")
                    local StatisticsLibrary = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("StatisticsLibrary")
                    local originalFunction

                    if StatisticsLibrary and StatisticsLibrary:IsA("ModuleScript") then
                        originalFunction = StatisticsLibrary:GetAttribute("GetRecoverWinStreakCost")
                        if originalFunction then
                            StatisticsLibrary.GetRecoverWinStreakCost = function(...)
                                return 0
                            end
                        end
                    end

                    ReplicatedStorage.Remotes.Data.RecoverWinStreak:FireServer()

                    if originalFunction then
                        StatisticsLibrary.GetRecoverWinStreakCost = originalFunction
                    end
                end
            })]]


            --// Ui Settings \\ --
            local UISection = Tabs.Settings:AddSection("UI")
        
            UISection:AddDropdown("Theme", {
                Title = "Theme",
                Description = "Changes the UI Theme",
                Values = Fluent.Themes,
                Default = Fluent.Theme,
                Callback = function(Value)
                    Fluent:SetTheme(Value)
                    UISettings.Theme = Value
                    InterfaceManager:ExportSettings()
                end
            })
        
            if Fluent.UseAcrylic then
                UISection:AddToggle("Acrylic", {
                    Title = "Acrylic",
                    Description = "Blurred Background requires Graphic Quality >= 8",
                    Default = Fluent.Acrylic,
                    Callback = function(Value)
                        if not Value or not UISettings.ShowWarnings then
                            Fluent:ToggleAcrylic(Value)
                        elseif UISettings.ShowWarnings then
                            Window:Dialog({
                                Title = "Warning",
                                Content = "This Option can be detected! Activate it anyway?",
                                Buttons = {
                                    {
                                        Title = "Confirm",
                                        Callback = function()
                                            Fluent:ToggleAcrylic(Value)
                                        end
                                    },
                                    {
                                        Title = "Cancel",
                                        Callback = function()
                                            Fluent.Options.Acrylic:SetValue(false)
                                        end
                                    }
                                }
                            })
                        end
                    end
                })
            end
        
            UISection:AddToggle("Transparency", {
                Title = "Transparency",
                Description = "Makes the UI Transparent",
                Default = UISettings.Transparency,
                Callback = function(Value)
                    Fluent:ToggleTransparency(Value)
                    UISettings.Transparency = Value
                    InterfaceManager:ExportSettings()
                end
            })

            -- Create watermark UI
            local ScreenGui = Instance.new("ScreenGui")
            local Watermark = Instance.new("TextLabel")

            ScreenGui.Parent = game.CoreGui

            Watermark.Parent = ScreenGui
            Watermark.Size = UDim2.new(0, 300, 0, 50)
            Watermark.Position = UDim2.new(0, 45, 0, 10)
            Watermark.BackgroundTransparency = 1
            Watermark.Font = Enum.Font.GothamSemibold
            Watermark.TextSize = 18
            Watermark.TextColor3 = Color3.fromRGB(19, 0, 255)
            Watermark.Text = "ZYPHERION Rivals | 0 FPS | Free User"

            local WatermarkVisible = true

            -- FPS counter
            local function UpdateFPS()
                local lastTick = tick()
                RunService.RenderStepped:Connect(function()
                    local currentTick = tick()
                    local fps = math.floor(1 / (currentTick - lastTick))
                    lastTick = currentTick
                    Watermark.Text = "ZYPHERION Rivals | " .. tostring(fps) .. " FPS | Free User"
                end)
            end

            UpdateFPS()

            local function ToggleWatermarkVisibility(value)
                WatermarkVisible = value
                Watermark.Visible = WatermarkVisible
            end

            local function UpdateWatermarkColor(color)
                Watermark.TextColor3 = color
            end

            UISection:AddToggle("Watermark", {
                Title = "Watermark",
                Description = "Toggle watermark visibility",
                Default = true,
                Callback = function(Value)
                    ToggleWatermarkVisibility(Value)
                end
            })

            UISection:AddColorpicker("Watermark Color", {
                Title = "Watermark Color",
                Default = Color3.fromRGB(19, 0, 255),
                Callback = function(color)
                    UpdateWatermarkColor(color)
                end
            })

            local DiscordWikiSection = Tabs.Settings:AddSection("Discord & Website")

            if getfenv().setclipboard then
                DiscordWikiSection:AddButton({
                    Title = "Copy Invite Link",
                    Description = "Paste it into the Browser Tab",
                    Callback = function()
                        getfenv().setclipboard("https://discord.gg/VaMhJXgr2M")
                        Window:Dialog({
                            Title = "ZYPHERION",
                            Content = "Invite Link has been copied to the Clipboard!",
                            Buttons = {
                                {
                                    Title = "Confirm"
                                }
                            }
                        })
                    end
                })
        
                DiscordWikiSection:AddButton({
                    Title = "Copy Website Link",
                    Description = "Paste it into the Browser Tab",
                    Callback = function()
                        getfenv().setclipboard("https://z3usprojects.rf.gd")
                        Window:Dialog({
                            Title = "ZYPHERION",
                            Content = "Website Link has been copied to the Clipboard!",
                            Buttons = {
                                {
                                    Title = "Confirm"
                                }
                            }
                        })
                    end
                })
            else
                DiscordWikiSection:AddParagraph({
                    Title = "https://discord.gg/VaMhJXgr2M",
                    Content = "Paste it into the Browser Tab"
                })
        
                DiscordWikiSection:AddParagraph({
                    Title = "https://z3usprojects.rf.gd",
                    Content = "Paste it into the Browser Tab"
                })
            end
        end
Window:SelectTab(1)
