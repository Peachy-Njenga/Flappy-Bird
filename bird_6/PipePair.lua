PipePair = Class{}

--gap between the pipes
local GAP_HEIGHT = 100

function PipePair:init(y)
    --initialize pipes past right edg eof the screen 
    self.x = VIRTUAL_HEIGHT + 32

    --y value is for top pipes
    self.y = y

    --instantiate 2 pipes in each pair
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    self.remove = false

end

function PipePair:update(dt)
    --scroll pipes
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
    
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end  