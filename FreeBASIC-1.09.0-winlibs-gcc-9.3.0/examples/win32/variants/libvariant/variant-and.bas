

#define VARIANT_NOASSIGNMENT
#include once "variant.bi"
#include once "intern.bi"

VAR_GEN_BOP( and, VarAnd, integer, I4 )
VAR_GEN_BOP( and, VarAnd, uinteger, UI4 )
VAR_GEN_BOP( and, VarAnd, longint, I8 )
VAR_GEN_BOP( and, VarAnd, ulongint, UI8 )

'':::::
operator and _
	( _
		byref lhs as VARIANT, _
		byref rhs as VARIANT _
	) as VARIANT
	
	dim as VARIANT_ res = any
	
	VarAnd( @lhs.var_, @rhs.var_, @res )
	
	return VARIANT( res, FALSE )
	
end operator

'':::::
operator and _
	( _
		byref lhs as VARIANT, _
		byref rhs as VARIANT_ _
	) as VARIANT
	
	dim as VARIANT_ res = any
	
	VarAnd( @lhs.var_, @rhs, @res )
	
	return VARIANT( res, FALSE )
	
end operator

