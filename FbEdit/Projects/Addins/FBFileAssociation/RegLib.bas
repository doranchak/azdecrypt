#include once "windows.bi"
#include once "win/winreg.bi"

'{ RegLib FBEdit Code Block
#Define REG_KEY_NOT_EXIST "REG_KEY_NOT_EXIST"
#Define REG_KEY_INVALID "REG_KEY_INVALID"

Type RegLib
	Declare Constructor(root as HKEY,key as String, create as Boolean=false)
	Declare Destructor()
	Declare Function createMe() as Boolean
	Declare Function deleteMe() as Boolean
	Declare Function getValue(v as String) as String
	Declare Function setValue(v as String, s as String) as Boolean
	Declare Property default() as String
	Declare Property default(s as String)
	exists As Boolean
Private:
	hroot  As HKEY	
	rkey   As HKEY
	key    As String  
End Type

Constructor RegLib(root as HKEY,key as String, create as Boolean=false)
	this.hroot=root
	this.key=key
	If RegOpenKeyEx(root, StrPtr(key), 0, KEY_ALL_ACCESS, @this.rkey) <> ERROR_SUCCESS Then	
		if create then
			createMe()
		else
			exists=false
		endif
	else
		exists=true
	endif
End Constructor

Destructor RegLib()
	RegCloseKey(rkey)
End Destructor

Function RegLib.createMe() As Boolean
	if RegCreateKeyEx(hroot,StrPtr(key),0,0,REG_OPTION_NON_VOLATILE,KEY_ALL_ACCESS,NULL,@rkey,0)=ERROR_SUCCESS then
		exists=true
	else
		exists=false
	endif
	return exists	
End Function

Function RegLib.deleteMe() As Boolean
	If RegDeleteKey(hroot,StrPtr(key)) = ERROR_SUCCESS Then
	  exists=false
	  return true
	Else
	  exists=true
	  return false
	End If	
End Function

Function RegLib.getValue(v as String) as String
	If exists=false then return REG_KEY_NOT_EXIST
	Dim out_ As Zstring * 1024
	Dim l As DWORD = 512
	Dim t As DWORD
	If RegQueryValueEx(rkey, StrPtr(v), NULL, @t, @out_, @l) <> ERROR_SUCCESS Or (t <> REG_SZ And t <> REG_EXPAND_SZ) Then 
		return REG_KEY_INVALID
	endif
	out_[512 - 1] = 0
	return out_
End Function

Function RegLib.setValue(v as String, s as String) as Boolean
	If exists=false then return false
	return RegSetValueEx(rkey,StrPtr(v),0,REG_SZ,StrPtr(s),Len(s)+1)= ERROR_SUCCESS	
End Function

Property RegLib.default() as String
	return getValue("")
End Property

Property RegLib.default(s as String)
	setValue("",s)
End Property

'}

/' Small test, File Association
Dim regAssocName as RegLib=RegLib(HKEY_CLASSES_ROOT,".bas",true)
regAssocName.default="FreeBasicFile"

Dim regClass as RegLib=RegLib(HKEY_CLASSES_ROOT,"FreeBasicFile",true)
regClass.default="FreeBasic Source" 

Dim regIcon as RegLib=RegLib(HKEY_CLASSES_ROOT,"FreeBasicFile\DefaultIcon",true)
regIcon.default="user32.dll,5"

Dim regCommand as RegLib=RegLib(HKEY_CLASSES_ROOT,"FreeBasicFile\shell\open\command",true)
regCommand.default=Chr(34)+"notepad"+Chr(34)+" "+Chr(34)+"%1"+Chr(34)

sleep
'/