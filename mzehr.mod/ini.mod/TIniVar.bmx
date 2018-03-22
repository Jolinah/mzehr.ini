Rem
bbdoc: Represents a variable in an INI configuration file.
End Rem
Type TIniVar
	Field Name:String
	Field Value:String
    
	Rem
	bbdoc: Creates a new variable with the given name and initial value.
	about: The variable won't be attached to a TIniGroup automatically. Just use TIniGroup or TIniFile directly to create variables.
	End Rem
	Function Create:TIniVar(name:String, value:String)
		Local v:TIniVar = New TIniVar
		v.Name = name
		v.Value = value
		Return v
	End Function

	Rem
	bbdoc: Returns the value of the variable as a byte.
	End Rem
	Method GetByte:Byte()
		Return Byte(Value)
	End Method

	Rem
	bbdoc: Returns the value of the variable as a short.
	End Rem
	Method GetShort:Short()
		Return Short(value)
	End Method
		
	Rem
	bbdoc: Returns the value of the variable as an int.
	End Rem
	Method GetInt:Int()
		Return Int(value)
	End Method
	
	Rem
	bbdoc: Returns the value of the variable as a long.
	End Rem
	Method GetLong:Long()
		Return Long(value)
	End Method
	
	Rem
	bbdoc: Returns the value of the variable as a float.
	End Rem
	Method GetFloat:Float()
		Return Float(value)
	End Method
	
	Rem
	bbdoc: Returns the value of the variable as a double.
	End Rem
	Method GetDouble:Double()
		Return Double(value)
	End Method
End Type
