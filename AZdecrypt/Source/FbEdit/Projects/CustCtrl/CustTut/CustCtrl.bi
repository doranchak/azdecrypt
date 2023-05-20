dim SHARED hInstance as HINSTANCE

' Propery types
#define PROP_STYLETRUEFALSE		1
#define PROP_EXSTYLETRUEFALSE		2
#define PROP_STYLEMULTI				3

' Custom control styles
#define STYLE_0_DEG					&H0000
#define STYLE_90_DEG					&H0001
#define STYLE_180_DEG				&H0002
#define STYLE_270_DEG				&H0003
#define STYLE_RED						&H0000
#define STYLE_GREEN					&H0004
#define STYLE_BLUE					&H0008
#define STYLE_WHITE					&H000C
#define STYLE_LEFTTOP				&H0000
#define STYLE_CENTER					&H0010

' Default styles
#define DEFSTYLE						WS_CHILD or WS_VISIBLE or STYLE_CENTER
#define DEFEXSTYLE					&H200
#define IDB_BMP						100

#define EXSTYLE_NONE					0

' Controls class
CONST szClassName="FBCUSTOM_TUTORIAL"
' Controls tooltip
CONST szToolTip="Custom Control Tutorial"
' Controls default caption
CONST szCap="IDC_TUT"
' Controls default name
CONST szName="IDC_TUT"

' This is a typical multistyle property description with 4 choises.
type PROPERTYORIENTATION field=1
	txt as string*32					' The lenght must match the actual string
	and_style1 as integer
	or_style1 as integer
	and_exstyle1 as integer
	or_exstyle1 as integer
	and_style2 as integer
	or_style2 as integer
	and_exstyle2 as integer
	or_exstyle2 as integer
	and_style3 as integer
	or_style3 as integer
	and_exstyle3 as integer
	or_exstyle3 as integer
	and_style4 as integer
	or_style4 as integer
	and_exstyle4 as integer
	or_exstyle4 as integer
end type

' This is also a typical multistyle property description with 4 choises.
type PROPERTYBACKCOLOR field=1
	txt as string*20					' The lenght must match the actual string
	and_style1 as integer
	or_style1 as integer
	and_exstyle1 as integer
	or_exstyle1 as integer
	and_style2 as integer
	or_style2 as integer
	and_exstyle2 as integer
	or_exstyle2 as integer
	and_style3 as integer
	or_style3 as integer
	and_exstyle3 as integer
	or_exstyle3 as integer
	and_style4 as integer
	or_style4 as integer
	and_exstyle4 as integer
	or_exstyle4 as integer
end type

' This is a False/True style or exstyle description.
type PROPERTYFALSETRUE field=1
	and_false as integer
	or_false as integer
	and_true as integer
	or_true as integer
end type

' Description of the 3 properties
type PROPERTIES field=1
	type1 as integer
	property1 as PROPERTYORIENTATION ptr
	type2 as integer
	property2 as PROPERTYBACKCOLOR ptr
	type3 as integer
	property3 as PROPERTYFALSETRUE ptr
end type

type CCDEFEX field=1
	ID as integer						'Controls uniqe ID. ID's below 1000 are reserved.
	lptooltip as zstring ptr		'Pointer to FbEdit toolbox tooltip text
	hbmp as HBITMAP					'Handle of FbEdit toolbox bitmap
	lpcaption as zstring ptr		'Pointer to default caption text
	lpname as zstring ptr			'Pointer to default idname text
	lpclass as zstring ptr			'Pointer to class text
	style as integer					'Default style
	exstyle as integer				'Default ex-style
	flist1 as integer					'Property listbox bitflag1
	flist2 as integer					'Property listbox bitflag2
	flist3 as integer					'Property listbox bitflag3
	flist4 as integer					'Property listbox bitflag4
	lpszproperty as zstring ptr	'Pointer to properties text
	lpproprty as PROPERTIES ptr	'Pointer to properties descriptor
end type

' Property descriptions
dim SHARED PropertyOrientation as PROPERTYORIENTATION=("0 deg.,90 deg.,180 deg.,270 deg.",-1 xor &H0003,STYLE_0_DEG,-1,EXSTYLE_NONE,-1 xor &H0003,STYLE_90_DEG,-1,EXSTYLE_NONE,-1 xor &H0003,STYLE_180_DEG,-1,EXSTYLE_NONE,-1 xor &H0003,STYLE_270_DEG,-1,EXSTYLE_NONE)
dim SHARED PropertyBackColor as PROPERTYBACKCOLOR=("Red,Green,Blue,White",-1 xor &H000C,STYLE_RED,-1,EXSTYLE_NONE,-1 xor &H000C,STYLE_GREEN,-1,EXSTYLE_NONE,-1 xor &H000C,STYLE_BLUE,-1,EXSTYLE_NONE,-1 xor &H000C,STYLE_WHITE,-1,EXSTYLE_NONE)
dim SHARED PropertyCenter as PROPERTYFALSETRUE=(-1 xor &H0010,STYLE_LEFTTOP,-1 xor &H0010,STYLE_CENTER)

' Theese are the 3 properties for this control
CONST szProperties="Orientation,BackColor,Center"
' Properties descriptor
dim SHARED Properties as PROPERTIES=(PROP_STYLEMULTI,@PropertyOrientation,PROP_STYLEMULTI,@PropertyBackColor,PROP_STYLETRUEFALSE,@PropertyCenter)
' FbEdit uses this data when designing the control on a dialog. For a description of flist1 to flist4 bit values, see CustCtrl.txt file.
dim SHARED ccdefex as CCDEFEX=(123456,@szToolTip,0,@szCap,@szName,@szClassName,DEFSTYLE,DEFEXSTYLE,&B11111111000011000000000000000000,&B00010000000000011000000000000000,&B00001000000000000000000000000000,&B00000000000000000000000000000000,@szProperties,@Properties)
