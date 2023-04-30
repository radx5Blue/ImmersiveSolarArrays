local util = {}

util.maxBatteryCapacity = {
    ["DeepCycleBattery"] = 200,
    ["SuperBattery"] = 400,
    ["WiredCarBattery"] = 50, --ModData
    ["DIYBattery"] = 200,
}

util.patchClassMetaMethod = function(class, methodName, createPatch)
    local metatable = __classmetatables[class]
    if not metatable then
        error("Unable to find metatable for class "..tostring(class))
    end
    local metatable__index = metatable.__index
    if not metatable__index then
        error("Unable to find __index in metatable for class "..tostring(class))
    end
    local originalMethod = metatable__index[methodName]
    metatable__index[methodName] = createPatch(originalMethod)
end

function util.queueFunction(eventName,fn)
    local event = Events[eventName]
    if not event then return print("Tried to queue to invalid event") end
    local function queueFn(...)
        event.Remove(queueFn)
        return fn(...)
    end
    event.Add(queueFn)
end

do
    local delayedProcess = ISBaseObject:derive("ISA delayedProcess")
    local meta = {__index=delayedProcess}

    function delayedProcess:new(obj)
        obj = obj or {}
        obj.event = obj.event or Events.OnTick
        setmetatable(obj,meta)
        return obj
    end

    function delayedProcess:start()
        self.event.Add(self.process)
    end

    function delayedProcess:stop()
        self.data = nil
        return self.event.Remove(self.process)
    end

    function delayedProcess.process() end

    util.delayedProcess = delayedProcess
end

ImmersiveSolarArrays = util
return util