# Simple INI configuration module for BlitzMax

## Installation

1. Copy the folder mzehr.mod and all its content to \<BlitzMax installation directory\>/mod.
2. Go to the \<BlitzMax installation directory\>/bin folder.
3. Execute the bmk executable to build the module for your platform: "bmk makemods -a mzehr.net"

## INI format

* Supports groups/sections denoted as [Group name]
* Supports a global group that contains all the variables that do not belong to other groups.
* Allows to switch back from a named group to the global group by adding the line: []
* Group and variable names are treated case sensitive

For example:

GlobalVar = Hello World
[Video]
ResolutionX = 1920
ResoultionY = 1080
[]
AnotherGlobalVar = true

## Usage

Contains the following classes/types:

* TIniFile
* TIniGroup
* TIniVar

Just create an instance of TIniFile by using one of its static functions:

* TIniFile.Create([path])
* TIniFile.Load(path)
* TIniFile.LoadStream(stream)
* TIniFile.Parse(contentString)

Read from, modify and remove variables:

* ini.GetValue(groupName, varName, [fallBackValue])
* ini.SetValue(groupName, varName, value)
* ini.RemoveVar(groupName, varName)

Get, add or remove groups/sections:

* ini.GetGroup(groupName)
* ini.GetOrAddGroup(groupName)
* ini.RemoveGroup(groupName)

A group contains its own similar methods:

* group.GetValue(varName, [fallBackValue])
* group.SetValue(varName, value)
* group.RemoveVar(varName)