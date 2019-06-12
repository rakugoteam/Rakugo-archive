extends Object

func invoke(var_name:String) -> RakugoVar:
	if  Rakugo.variables.has(var_name):
		var v = Rakugo.variables[var_name]
		var Type = Rakugo.Type

		match v.type:
			Type.TEXT:
				return v as RakugoText

			Type.DICT:
				return v as RakugoDict

			Type.LIST:
				return v as RakugoList

			Type.NODE:
				return v as NodeLink

			Type.QUEST:
				return v as Quest

			Type.SUBQUEST:
				return v as Subquest

			Type.CHARACTER:
				return v as CharacterObject

			Type.RANGED:
				return v as RakugoRangedVar

			Type.BOOL:
				return v as RakugoBool

			Type.VECT2:
				return v as RakugoVector2

			Type.VECT3:
				return v as RakugoVector3

			Type.COLOR:
				return v as RakugoColor

			_:
				return v as RakugoVar

	return null
