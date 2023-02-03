Rem
bbdoc: Represents a group/section in an INI configuration file.
End Rem
Type TIniGroup
	Field Name:String
	Field Vars:TMap
    
	Method New()
		Vars = New TMap
	End Method
	
	Rem
	bbdoc: Creates a new INI group/section.
	about:
	The group won't be attached to a TIniFile automatically.
	Just use TIniFile directly for creating groups.
	End Rem
	Function Create:TIniGroup(name:String)
		Local g:TIniGroup = New TIniGroup
		g.Name = name
		Return g
	End Function
    
	Rem
	bbdoc: Retrieves an existing variable within the group or Null if the variable does not exist.
	End Rem
	Method GetVar:TIniVar(name:String)
		Local v:TIniVar = TIniVar(Vars.ValueForKey(name))
		Return v
	End Method
	
	Rem
	bbdoc: Removes a variable from the group (if it does exist).
	End Rem
	Method RemoveVar(name:String)
		Vars.Remove(name)
	End Method
		
	Rem
	bbdoc: Gets the value of a variable within the group. Returns defaultValue if the variable does not exist.
	End Rem
	Method GetValue:String(name:String, defaultValue:String = Null)
		Local v:TIniVar = GetVar(name)
		If v = Null Then Return defaultValue
		Return v.Value
	End Method

	Rem
	bbdoc: Gets the value of a variable within the group as a byte. Returns defaultValue if the variable does not exist.
	End Rem
	Method GetByte:Byte(name:String, defaultValue:Byte = 0)
		Local v:TIniVar = GetVar(name)
		If v = Null Then Return defaultValue
		Return v.GetByte()
	End Method

	Rem
	bbdoc: Gets the value of a variable within the group as a short. Returns defaultValue if the variable does not exist.
	End Rem
	Method GetShort:Short(name:String, defaultValue:Short = 0)
		Local v:TIniVar = GetVar(name)
		If v = Null Then Return defaultValue
		Return v.GetShort()
	End Method

	Rem
	bbdoc: Gets the value of a variable within the group as an int. Returns defaultValue if the variable does not exist.
	End Rem
	Method GetInt:Int(name:String, defaultValue:Int = 0)
		Local v:TIniVar = GetVar(name)
		If v = Null Then Return defaultValue
		Return v.GetInt()
	End Method

	Rem
	bbdoc: Gets the value of a variable within the group as a long. Returns defaultValue if the variable does not exist.
	End Rem
	Method GetLong:Long(name:String, defaultValue:Long = 0)
		Local v:TIniVar = GetVar(name)
		If v = Null Then Return defaultValue
		Return v.GetLong()
	End Method

	Rem
	bbdoc: Gets the value of a variable within the group as a float. Returns defaultValue if the variable does not exist.
	End Rem
	Method GetFloat:Float(name:String, defaultValue:Float = 0.0)
		Local v:TIniVar = GetVar(name)
		If v = Null Then Return defaultValue
		Return v.GetFloat()
	End Method
	
	Rem
	bbdoc: Gets the value of a variable within the group as a double. Returns defaultValue if the variable does not exist.
	End Rem
	Method GetDouble:Double(name:String, defaultValue:Double = 0.0)
		Local v:TIniVar = GetVar(name)
		If v = Null Then Return defaultValue
		Return v.GetDouble()
	End Method
	
	Rem
	bbdoc: Sets the value of a variable within the group to the specified value. The variable will be created if it does not exist.
	End Rem
	Method SetValue:TIniVar(name:String, value:String)
		Local v:TIniVar = GetVar(name)

		If v = Null
			v = TIniVar.Create(name, value)
			Vars.Insert(name, v)
		Else
			v.Value = value
		End If
		
		Return v
	End Method

	Rem
	bbdoc: Saves/Writes the group to the specified stream.
	about:
	outputGlobalGroup - Whether the brackets [] will be output for the global group or not. Default is True. Save() from TIniFile uses False, however.
	End Rem
	Method Save(stream:TStream, outputGlobalGroup:Int = True)
	
		If outputGlobalGroup Or Name <> "" Then
			WriteLine(stream, "[" + Name + "]")
		End If
		For Local v:TIniVar = EachIn Vars.Values()
			v.Save(stream)
		Next
		WriteLine(stream, "")
	End Method
End Type
