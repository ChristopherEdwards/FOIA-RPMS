XBFDINFO(FILE,FIELD,ROOT) ; IHS/ADC/GTH - RETURN FIELD INFORMATION ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ;  ATTENTION PROGRAMMERS:  Use line label FLD() for entry.
 ;           Do not use the first line for entry.
 ;
 ; Given a file/subfile number, a field number, and an array
 ; root, this routine will return information about the
 ; specified field.  The information will be returned as
 ; subscripted variables from the root passed by the caller.
 ;
 ; The field information returned will be a subset of the
 ; following:
 ;
 ;  ROOT("NAME")   = name of field
 ;  ROOT("NODE")   = node in data global
 ;  ROOT("PIECE")  = piece in node
 ;  ROOT("TYPE")   = FileMan field type or "M" for multiple,
 ;                   or "C" for computed
 ;  ROOT("SFILE")  = subfile number if the field is a multiple
 ;  ROOT("PFILE")  = file number of pointed to file
 ;  ROOT("PGBL")   = gbl of pointed to file
 ;  ROOT("DINUM")  = existance indicates DINUM pointer
 ;
 ;  ROOT("VPFILE",file) = variable pointer prefix.  'file' is
 ;                        pointed to file
 ;  ROOT("VPGBL",file)  = variable pointer gbl of pointed to
 ;                        file.  'file' is pointed to file
 ;
 ; Formal list:
 ;
 ; 1)  FILE   = file/subfile number (call by value)
 ; 2)  FIELD  = field number (call by value)
 ; 3)  ROOT   = array root (call by reference)
 ;
START ;
 KILL ROOT
 NEW W,X,Y,Z
 Q:FILE'=+FILE
 Q:FIELD'=+FIELD
 Q:'$D(^DD(FILE,FIELD,0))  S X=^(0)
 S ROOT("NAME")=$P(X,"^",1)
 I $P(X,"^",2)["C" S ROOT("TYPE")="C" Q
 S ROOT("NODE")=$S(FIELD=.001:"",1:$P($P(X,"^",4),";",1))
 S ROOT("PIECE")=$S(FIELD=.001:"",1:$P($P(X,"^",4),";",2))
 S Y=$P(X,"^",2)
 S ROOT("TYPE")=$S(Y["F":"F",Y["C":"C",Y["D":"D",Y["K":"K",Y["N":"N",Y["P":"P",Y["S":"S",Y["V":"V",Y["K":"K",Y["W":"W",1:"?")
 I +$P(X,"^",2) S ROOT("SFILE")=+$P(X,"^",2),ROOT("TYPE")="M" I 1
 E  S:Y["P" ROOT("PFILE")=+$P(Y,"P",2),ROOT("PGBL")=$P(X,"^",3),@($S($P(X,"^",5,99)["DINUM"&(FIELD=.01):"ROOT(""DINUM"")",1:"Z"))=""
 I Y["V" F Z=0:0 S Z=$O(^DD(FILE,FIELD,"V","B",Z)) Q:Z'=+Z  S W=$O(^(Z,"")),ROOT("VPFILE",Z)=$P(^DD(FILE,FIELD,"V",W,0),"^",4),ROOT("VPGBL",Z)=^DIC(Z,0,"GL")
 Q
 ;
FLD(FILE,FIELD,ROOT) ;PEP - Return information about a field.
 G START
 ;
