Rem
bbdoc: Represents an INI configuration file containing groups/sections and variables.
about:
<pre>
Example INI file content:

GlobalVar = Hello World
[Video]
ResolutionX = 1920
ResolutionY = 1080
[]
AnotherGlobalVar = true

Where [Video] and [] are groups and the other lines with an assignment are variables.
Variables below a group belong to this group. Variables at the beginning of the file belong to the global group.

The global group is just a group with an empty string as its name, containing all the variables that are in no other group.
You can switch back to the global group by adding a line like [] (group with empty string as its name).  

In the code you can retrieve the global group by using the GlobalGroup field.
Additionaly, you can use "" as the global group name for all methods that require a group name.
</pre>
End Rem
Type TIniFile
	Field Path:String
	Field Groups:TMap
	Field GlobalGroup:TIniGroup
   
	Method New()
		Groups = New TMap
		GlobalGroup = TIniGroup.Create("")
		Groups.Insert("", GlobalGroup)
	End Method
   
	Rem
	bbdoc: Creates a new INI file in memory.
	about: The path is optional and will only be used later, when you call Save() without arguments.
	End Rem
	Function Create:TIniFile(path:String = Null)
		Local f:TIniFile = New TIniFile
		f.Path = path
		Return f
	End Function

	Rem
	bbdoc: Loads an existing INI file from disk into memory.
	End Rem
	Function Load:TIniFile(path:String)
		Local stream:TStream = ReadFile(path)
		If stream = Null Then Return Null

		Local ini:TIniFile = LoadStream(stream)
		If ini <> Null
			ini.Path = path
		EndIf
                   
		CloseFile(stream)
		Return ini
	End Function

	Rem
	bbdoc: Loads an existing INI file from a stream.
	End Rem	
	Function LoadStream:TIniFile(stream:TStream)
		If stream = Null Then Return Null
		
		Local ini:TIniFile = TIniFile.Create()
		Local line:String
		Local variable:String[]
		Local group:TIniGroup = ini.GlobalGroup

		While Not Eof(stream)
			line = ReadLine(stream)
			line = line.Trim()
          	
			'Ignore comment lines
			If line[0] = "#" Then Continue

			If line[..1] = "[" And line[line.Length - 1..] = "]"
				'Groups/sections
				line = line[1..line.Length - 1]
				group = ini.GetOrAddGroup(line)
			Else If group <> Null
				'Variable
				variable = line.Split("=")
				If variable.Length > 1
					If variable.Length > 2
						variable[1] = "=".Join(variable[1..])
					End If
					group.SetValue(variable[0].Trim(), variable[1].Trim())
				EndIf
			EndIf
		Wend

		Return ini
	End Function

	Rem
	bbdoc: Loads an INI file by its string content.
	End Rem
	Function Parse:TIniFile(content:String)
		Local bank:TBank = CreateBank(content.Length)
		Local stream:TBankStream = CreateBankStream(bank)
		stream.WriteString(content)
		stream.Seek(0)
		
		Local ini:TIniFile = LoadStream(stream)
		
		stream.Close()
		Return ini
	End Function
	
	Rem
	bbdoc: Loads an existing INI file from disk into memory.
	about: If the file does not exist or can't be read a new INI will be created in memory.
	End Rem
	Function LoadOrCreate:TIniFile(path:String)
		Local ini:TIniFile = Load(path)
	
		If ini = Null
			ini = Create(path)
		EndIf
		
		Return ini
	End Function
	
	Rem
	bbdoc: Retrieves an existing group/section or creates a new one.
	End Rem
	Method GetOrAddGroup:TIniGroup(name:String)
		Local group:TIniGroup = GetGroup(name)
		If group <> Null Then Return group
	
		group = TIniGroup.Create(name)
		Groups.Insert(name, group)
		Return group
	End Method
    
	Rem
	bbdoc: Retrieves an existing group/section. Returns Null if there is no such group.
	End Rem
	Method GetGroup:TIniGroup(name:String)
		Local group:TIniGroup = TIniGroup(Groups.ValueForKey(name))
		Return group
	End Method
	
	Rem
	bbdoc: Removes a group (if it exists).
	End Rem
	Method RemoveGroup(name:String)
		Groups.Remove(name)
	End Method
    
	Rem
	bbdoc: Retrieves an existing variable. Returns Null if the group/section or the variable does not exist.
	End Rem
	Method GetVar:TIniVar(groupName:String, varName:String)
		Local group:TIniGroup = GetGroup(groupName)
		If group = Null Then Return Null
       
		Return group.GetVar(varName)
	End Method

	Rem
	bbdoc: Removes a variable from a group (if the group and variable exists).
	End Rem
	Method RemoveVar(groupName:String, varName:String)
		Local group:TIniGroup = GetGroup(groupName)
		If group <> Null
			group.RemoveVar(varName)
		End If
	End Method
		
	Rem
	bbdoc: Gets the value of a variable if the group and variable exists. Else, defaultValue will be returned.
	End Rem
	Method GetValue:String(groupName:String, varName:String, defaultValue:String = Null)
		Local group:TIniGroup = GetGroup(groupName)
		If group = Null Then Return defaultValue
		Return group.GetValue(varName, defaultValue)
	End Method

	Rem
	bbdoc: Gets the value of a variable as a byte if the group and variable exists. Else, defaultValue will be returned.
	End Rem
	Method GetByte:Byte(groupName:String, varName:String, defaultValue:Byte = 0)
		Local group:TIniGroup = GetGroup(groupName)
		If group = Null Then Return defaultValue
		Return group.GetByte(varName, defaultValue)
	End Method
	
	Rem
	bbdoc: Gets the value of a variable as a short if the group and variable exists. Else, defaultValue will be returned.
	End Rem
	Method GetShort:Short(groupName:String, varName:String, defaultValue:Short = 0)
		Local group:TIniGroup = GetGroup(groupName)
		If group = Null Then Return defaultValue
		Return group.GetShort(varName, defaultValue)
	End Method

	Rem
	bbdoc: Gets the value of a variable as an int if the group and variable exists. Else, defaultValue will be returned.
	End Rem
	Method GetInt:Int(groupName:String, varName:String, defaultValue:Int = 0)
		Local group:TIniGroup = GetGroup(groupName)
		If group = Null Then Return defaultValue
		Return group.GetInt(varName, defaultValue)
	End Method

	Rem
	bbdoc: Gets the value of a variable as a long if the group and variable exists. Else, defaultValue will be returned.
	End Rem
	Method GetLong:Long(groupName:String, varName:String, defaultValue:Long = 0)
		Local group:TIniGroup = GetGroup(groupName)
		If group = Null Then Return defaultValue
		Return group.GetLong(varName, defaultValue)
	End Method

	Rem
	bbdoc: Gets the value of a variable as a float if the group and variable exists. Else, defaultValue will be returned.
	End Rem
	Method GetFloat:Float(groupName:String, varName:String, defaultValue:Float = 0.0)
		Local group:TIniGroup = GetGroup(groupName)
		If group = Null Then Return defaultValue
		Return group.GetFloat(varName, defaultValue)
	End Method

	Rem
	bbdoc: Gets the value of a variable as a double if the group and variable exists. Else, defaultValue will be returned.
	End Rem
	Method GetDouble:Double(groupName:String, varName:String, defaultValue:Double = 0.0)
		Local group:TIniGroup = GetGroup(groupName)
		If group = Null Then Return defaultValue
		Return group.GetDouble(varName, defaultValue)
	End Method
					
	Rem
	bbdoc: Sets a variable to the specified value. The group and the variable will be created if they do not exist.
	End Rem
	Method SetValue:TIniVar(groupName:String, varName:String, value:String)
		Local group:TIniGroup = GetGroup(groupName)
		If group = Null
			group = TIniGroup.Create(groupName)
			Groups.Insert(groupName, group)
		End If
		
		Return group.SetValue(varName, value)
	End Method

	Rem
	bbdoc: Sets a variable in the global group to the specified value.
	End Rem
	Method SetValue:TIniVar(varName:String, value:String)
		Return SetValue("", varName, value)
	End Method

	Rem
	bbdoc: Saves the INI to a file on disk.
	about:
	If the filePath is omitted, the path from Create() will be used.
	After successfully saving, the Path field of the type will be set to the path where the file has been saved.
	This means, the next time you want to save, you can just call Save() without any arguments.
	End Rem           
	Method Save(filePath:String = Null)
		If filePath = Null
			If Path = Null Throw "No filePath specified."
			filePath = Path
		End If
	
		Local stream:TStream = WriteFile(filePath)
		If stream = Null Throw "Could not open " + filePath + " for writing."

		Save(stream)
       
		CloseFile(stream)
		Path = filePath
	End Method
	
	Rem
	bbdoc: Saves/Writes the INI to the specified stream.
	End Rem
	Method Save(stream:TStream)
		For Local g:TIniGroup = EachIn Groups.Values()
			g.Save(stream, False)
		Next
	End Method
End Type
