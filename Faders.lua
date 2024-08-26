_=[=[
__________________________________________________________________________
__  ___/__(_)__  /__   _______________  ____/__  ____/__  /__  __ \_  ___/
_____ \__  /__  /__ | / /  _ \_  ___/  /    ______ \ __  / _  / / /  __ \ 
____/ /_  / _  / __ |/ //  __/  /   / /___   ____/ / _  /__/ /_/ // /_/ / 
/____/ /_/  /_/  _____/ \___//_/    \____/  /_____/  /____/\____/ \____/  
					 _               ___        _            
Version  	4.0			| |  _  _ __ _  | __|_ _ __| |___ _ _ ___
Last Edited Aug 25, 2024		| |_| || / _` | | _/ _` / _` / -_) '_(_-<
Author 		SilverC5Z06		|____\_,_\__,_| |_|\__,_\__,_\___|_| /__/

									Licensed under Mozilla Public License Version 2.0
									
								
								
Documentation: 		github.com/SilverC5Z06/Lua-Faders/blob/main/README.md							
License: 			github.com/SilverC5Z06/Lua-Faders/blob/main/LICENSE	

Repository:			github.com/SilverC5Z06/Lua-Faders/tree/main
Source:				raw.githubusercontent.com/SilverC5Z06/Lua-Faders/main/Faders.lua


]=]



local TweenService = game:GetService("TweenService")

local Object = Instance 


local Faders = {}
local FaderCourotines = {}
local FaderCompletedBinds = {}
local Properties = {BackgroundTransparency = "Number", ImageTransparency = "Number", TextTransparency = "Number", TextStrokeTransparency = "Number", 
	Transparency = "Number", 
	PlaceholderColor3 = "Color3"
}



local OutValues = {Number = 1, Color3 = Color3.new(0, 0, 0)}

function ValidateProperty(Instance : Instance, Property)
	return pcall(function() 
		if Property=="Transparency" and (Instance:IsA("TextBox") or Instance:IsA("TextLabel") or Instance:IsA("TextButton")) then 
			error("")
		end
		return Instance[Property] 
	end)
end

function GetProperties(Instance)
	local ValidProperties = {}
	for Property, Type in Properties do 
		if not ValidateProperty(Instance, Property) then continue end

		table.insert(ValidProperties, Property)
	end

	return ValidProperties
end


function Faders:Create(Instance : Instance)

	local In,Out={},{}


	for _, Instance in {Instance, table.unpack(Instance:GetDescendants())} do
		for _, Property in GetProperties(Instance) do 

			In[Instance] = In[Instance] or {}
			Out[Instance] = Out[Instance] or {}
			
			
			
			
			warn(Property)
			warn(Instance[Property])
			In[Instance][Property] = Instance[Property]
			Out[Instance][Property] = OutValues[Properties[Property]]
			
			
			
		end
	end


	local FaderBase = {Instance = Instance, In = In, Out=Out}

	function FaderBase:Play(Direction, FadeInfo)
		Faders:Play(FaderBase, Direction, FadeInfo) 
	end; function FaderBase:Pause()
		Faders:Pause(FaderBase) 
	end; function FaderBase:Resume()
		Faders:Resume(FaderBase) 
	end; function FaderBase:Cancel()
		Faders:Cancel(FaderBase) 
	end; 

	local CompletedBind = Object.new("BindableEvent") -- Renamed from Instance.new earlier
	FaderBase.Completed = CompletedBind.Event
	
	FaderCompletedBinds[FaderBase] = CompletedBind


	return FaderBase
end


function Faders:Play(Fader : {Instance : Instance, In : {[Instance] : {[string] : any}}, Out : {[Instance] : {[string] : any}}}, Direction : "In" | "Out", FadeInfo : TweenInfo | number)
	task.wait()
	
	local FadeInfo : TweenInfo = (typeof(FadeInfo)=="number" and TweenInfo.new(FadeInfo)) or (typeof(FadeInfo)=="TweenInfo" and FadeInfo) or TweenInfo.new(0.1)
	

	
	if FaderCourotines[Fader.Instance] then 
		task.spawn(function()

			for _, Tween in FaderCourotines[Fader.Instance][2] do 
				Tween:Pause()
				Tween:Destroy()  
			end 
			
			coroutine.yield(FaderCourotines[Fader.Instance][1]) 
			coroutine.close(FaderCourotines[Fader.Instance][1]) 

		end)
	end
	
	
	

	task.wait(0.02)
	
	
	
	
	local thisTask = {[2] = {}}

	FaderCourotines[Fader.Instance] = thisTask
	
	
	thisTask[1] = coroutine.create(function()

		for Instance, Properties in Fader[Direction] do 
			
			print(Instance, FadeInfo, Properties)
			
			local InstanceTween = TweenService:Create(Instance, FadeInfo, Properties)

			table.insert(thisTask[2], InstanceTween)
			InstanceTween:Play()
		end



		task.wait(FadeInfo.Time)
		
		if FaderCourotines[Fader.Instance] then 
			coroutine.yield(FaderCourotines[Fader.Instance][1])
			coroutine.close(FaderCourotines[Fader.Instance][1])

			for _, Tween in FaderCourotines[Fader.Instance][2] do
				Tween:Pause(); Tween:Destroy()
			end
		end

		FaderCompletedBinds[Fader]:Fire(PS)
		FaderCourotines[Fader.Instance] = nil
	end)
	
	coroutine.resume(thisTask[1])
end



function Faders:Pause(Fader : {Instance : Instance, In : {[Instance] : {[string] : any}}, Out : {[Instance] : {[string] : any}}})

	if FaderCourotines[Fader.Instance] then 
		coroutine.yield(FaderCourotines[Fader.Instance][1]) 

		for _, Tween in FaderCourotines[Fader.Instance][2] do 
			Tween:Pause()
		end 
	end

end


function Faders:Resume(Fader : {Instance : Instance, In : {[Instance] : {[string] : any}}, Out : {[Instance] : {[string] : any}}})

	if FaderCourotines[Fader.Instance] then 
		coroutine.resume(FaderCourotines[Fader.Instance][1]) 

		for _, Tween in FaderCourotines[Fader.Instance][2] do 
			Tween:Play()
		end 
	end
end

function Faders:Cancel(Fader : {Instance : Instance, In : {[Instance] : {[string] : any}}, Out : {[Instance] : {[string] : any}}})

	if FaderCourotines[Fader.Instance] then 
		coroutine.yield(FaderCourotines[Fader.Instance][1])
		coroutine.close(FaderCourotines[Fader.Instance][1]) 

		for _, Tween in FaderCourotines[Fader.Instance][2] do 
			Tween:Pause();
			Tween:Cancel();
			Tween:Destroy()
		end 

		FaderCourotines[Fader.Instance] = nil
	end
end

function Faders:Destroy(Fader : {Instance : Instance, In : {[Instance] : {[string] : any}}, Out : {[Instance] : {[string] : any}}})

	if FaderCourotines[Fader.Instance] then 
		coroutine.yield(FaderCourotines[Fader.Instance][1])
		coroutine.close(FaderCourotines[Fader.Instance][1]) 

		for _, Tween in FaderCourotines[Fader.Instance][2] do 
			Tween:Pause();
			Tween:Destroy()
		end 

		FaderCourotines[Fader.Instance] = nil
	end
end




return Faders
