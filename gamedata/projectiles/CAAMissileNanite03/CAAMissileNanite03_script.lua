local CAAMissileNaniteProjectile = import("/lua/cybranprojectiles.lua").CAAMissileNaniteProjectile03

-- AA Missile for Cybrans
---@class CAAMissileNanite03: CAAMissileNaniteProjectile03
CAAMissileNanite03 = ClassProjectile(CAAMissileNaniteProjectile) {

    ---@param self CAAMissileNanite03
    OnCreate = function(self)
        CAAMissileNaniteProjectile.OnCreate(self)
        self.Trash:Add(ForkThread(self.UpdateThread, self))
    end,

    ---@param self CAAMissileNanite03
    UpdateThread = function(self)
        WaitTicks(16)
        self:SetMaxSpeed(80)
        self:SetAcceleration(10 + Random() * 8)
        self:ChangeMaxZigZag(0.5)
        self:ChangeZigZagFrequency(2)
    end,

    ---@param self CAAMissileNanite03
    ---@param TargetType string
    ---@param TargetEntity Prop|Unit
    OnImpact = function(self, TargetType, TargetEntity)
        CAAMissileNaniteProjectile.OnImpact(self, TargetType, TargetEntity)
    end,
}
TypeClass = CAAMissileNanite03