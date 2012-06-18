INHMR20 ;KN; 18 Jul 95 09:07; Statistical Report - Display Utilities
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; PURPOSE:  
 ; The purpose of the routine INHMR20 is used to contain
 ; the utility functions and support for INHMR2.
 ;
 ; DESCRIPTION: 
 ; The processing of this routine is used to collect for 
 ; utility functions to support INHMR2 Statistical Report 
 ; Display module.
 ;
GNDP(INFL,INFD) ; Get node and piece
 ;
 ; Description:  The function GNDP is used to get node and piece 
 ;               where data are at.
 ; Return: Node#^Piece#
 ; Parameters:
 ;    INFL = File ien (internal entry into ^INTHU)
 ;    INFD = Field ien
 ; CODE BEGINS:
 Q $P($P($G(^DD(INFL,INFD,0)),U,4),";",1,2)
 ;
GLN(INFL) ; Get global name
 ;
 ; Description:  The function GLN is used to get global name ^INTHU.
 ; Return: Global name (ex. ^INTHU)
 ; Parameters:
 ;    INFL = File ien ( internal entry number )
 ; Code begins:
 Q $G(^DIC(INFL,0,"GL"))
 ;
PRVF(CF,AR) ; Previous field
 ;
 ; Description:  The function PRVF is used to return previous 
 ;               field ien, given current field ien CF.
 ; Return: Field ien for previous field of CF
 ; Parameters:
 ;    CF = current field ien
 ;    AR = Name of array which contains an array of field ien
 ; Code begins:
 N TMP
 I $G(CF)="" S TMP=$G(CF) Q TMP
 I (@AR["S")!(@AR["P") S TMP=$O(@AR@(CF),-1)
 E  S TMP=CF-.1
 Q TMP
 ;
NXTF(CF,AR) ; Next field ien
 ; 
 ; Description:  The function NXTF is used to return next field 
 ;               ien, given current field ien CF
 ; Return: Field ien for next field of CF
 ; Parameters:
 ;    CF = current field ien
 ;    AR = Name of array which contains an array of field ien
 ; Code begins:
 N TMP
 I $G(CF)="" S TMP=$G(CF)
 E  D
 .I (@AR["S")!(@AR["P") S TMP=$O(@AR@(CF))
 .E  S TMP=CF+.1
 Q TMP
 ;
CMP(S,INF,IINA,TMP,TMN) ; Compare 
 ; 
 ; Description:  The function CMP is used to compare if S is
 ;               in the range from TMP to TMN, and determine
 ;               any type of data date, numeric, or string in a 
 ;               specific range. 
 ; Return: 1 = True
 ;         0 = False
 ; Parameters:
 ;    S = Selected items to compare 
 ;    INF = Order of items selected by user 
 ;    IINA = 
 ;    TMP =  Lower limit
 ;    TMN =  Uper limit
 ; Code begins:
 N INTMP
 S INTMP=0
 I IINA["P" S C=$P(^DD(INIEN,INA(INF,1),0),U,2),Y=S D Y^DIQ S S=Y
 I $L($G(INA(INF,3)))=0 S:(S]"") INTMP=1
 E  D
 .I (TMN'="") D
 ..I (IINA["N")!(IINA["D") S:(S>TMP)&(S<TMN) INTMP=1
 ..E  S:(S]TMP)&(TMN]S) INTMP=1
 .E  D
 ..I (IINA["N")!(IINA["D") S:(S>TMP) INTMP=1
 ..E  S:(S]TMP) INTMP=1
 Q INTMP
 ;
FILL(INC,REF) ; Fill up incount array
 ;
 ; Description:  The function FILL is used to fill an array with 
 ;               all the subtotals (count) and totals.  
 ; Return: none
 ; Parameters:
 ;    INC = The counter array
 ;    REF = Name of INC array
 ; Code begins:
 N LEV,TREF,ZLEV S LEV=""
 F  S LEV=$O(@REF@(LEV)) Q:LEV=""  D
 . S ZLEV=LEV S:LEV'=(0+LEV) ZLEV=""""_LEV_""""
 . S:REF[")" TREF=$E(REF,1,$L(REF)-1)_","_ZLEV_")"
 . S:REF'[")" TREF=REF_"("_ZLEV_")"
 . D FILL(.INC,TREF)
 . S @REF=$G(@REF)+$G(@TREF)
 Q
