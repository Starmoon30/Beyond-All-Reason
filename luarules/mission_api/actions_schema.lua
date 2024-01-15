--============================================================--

-- Action Types

--============================================================--

local actionTypes = {
	-- Triggers
	EnableTrigger               = 100, --
	DisableTrigger              = 101, --

	-- Orders
	IssueOrders                 = 200, --
	AllowCommands               = 201,
	RestrictCommands            = 202,

	-- Build Options
	AlterBuildlist              = 300,
	EnableBuildOption           = 301,
	DisableBuildOption          = 302,

	-- Units
	SpawnUnits                  = 400, --
	DespawnUnits                = 401, --
	SpawnWeapons                = 402,
	SpawnEffects                = 403,
	TransferUnits               = 404,

	-- SFX
	SpawnExplosion              = 500, --

	-- Map
	RevealLOS                   = 600,
	UnrevealLOS                 = 601,
	AlterMapZones               = 602,

	-- Media
	ControlCamera               = 700,
	Pause                       = 701,
	Unpause                     = 702,
	PlayMedia                   = 703,
	SendMessage                 = 704,

	-- Win Condition
	Victory                     = 800,
	Defeat                      = 801,
}

--============================================================--

-- Action Parameters

--============================================================--

local parameters = {
	-- Triggers
	[actionTypes.EnableTrigger] = {
		[1] = {
			name = 'triggerID',
			required = true,
			type = 'string',
		},
	 },

	[actionTypes.DisableTrigger] = {
		[1] = {
			name = 'triggerID',
			required = true,
			type = 'string',
		},
	 },

	 -- Orders
	[actionTypes.IssueOrders] = { 
		[1] = {
			name = 'unit',
			required = true,
			type = 'unit'
		},
		[2] = {
			name = 'orders',
			required = true,
			type = 'table'
		}
	 },
	[actionTypes.AllowCommands] = {  },
	[actionTypes.RestrictCommands] = {  },

	-- Build Options
	[actionTypes.AlterBuildlist] = {  },
	[actionTypes.EnableBuildOption] = {  },
	[actionTypes.DisableBuildOption] = {  },

	-- Units
	[actionTypes.SpawnUnits] = {
		[1] = {
			name = 'name',
			required = false,
			type = 'string',
		},
		[2] = {
			name = 'unitDef',
			required = true,
			type = 'unitDef',
		},
		[3] = {
			name = 'quantity',
			required = false,
			type = 'number',
		},
		[4] = {
			name = 'position',
			required = true,
			type = 'vec3'
		},
		[5] = {
			name = 'facing',
			required = false,
			type = 'direction'
		},
		[6] = {
			name = 'construction',
			required = false,
			type = 'bool'
		}
	},

	[actionTypes.DespawnUnits] = {
		[1] = {
			name = 'unit',
			required = true,
			type = 'unit',
		},
	 },
	[actionTypes.SpawnWeapons] = {  },
	[actionTypes.SpawnEffects] = {  },
	[actionTypes.TransferUnits] = { 
		[1] = {
			name = 'unit',
			required = true,
			type = 'unit'
		},
		[2] = {
			name = 'newTeam',
			required = true,
			type = 'number'
		},
		[3] = {
			name = 'given',
			required = false,
			type = 'bool'
		}
	 },

	-- SFX
	[actionTypes.SpawnExplosion] = { 
		[1] = {
			name = 'position',
			required = true,
			type = 'vec3'
		},
		[2] = {
			name = 'direction',
			required = true,
			type = 'vec3'
		},
		[3] = {
			name = 'params',
			required = true,
			type = 'table'
		}
	},

	-- Map
	[actionTypes.RevealLOS] = {  },
	[actionTypes.UnrevealLOS] = {  },
	[actionTypes.AlterMapZones] = {  },

	-- Media
	[actionTypes.ControlCamera] = {  },
	[actionTypes.Pause] = {  },
	[actionTypes.Unpause] = {  },
	[actionTypes.PlayMedia] = {  },

	[actionTypes.SendMessage] = {
		[1] = {
			name = 'message',
			required = true,
			type = 'string',
		}
	},

	-- Win Condition
	[actionTypes.Victory] = {  },
	[actionTypes.Defeat] = {  },
}

--============================================================--

return {
	Types = actionTypes,
	Parameters = parameters
}

--============================================================--