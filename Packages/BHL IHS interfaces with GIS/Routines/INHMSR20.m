INHMSR20 ;KN; 27 Nov 95 09:56; Statistical Report-Utility  
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; DESCRIPTION: 
 ; The processing of this routine is used to collect for 
 ; utility functions to support INHMSR2 Statistical Report 
 ; Display module.
 ;
 Q
GNDP(INFL,INFD) ; Get node and piece
 ;
 ; Description:  The function GNDP is used to get node and piece 
 ;               where data are at.
 ; Return: Node#^Piece#
 ; Parameters:
 ;    INFL = File ien (internal entry number)
 ;    INFD = Field ien
 ; Code begins:
 Q $P($P($G(^DD(INFL,INFD,0)),U,4),";",1,2)
 ;
GLN(INFL) ; Get global name
 ;
 ; Description:  The function GLN is used to get global name.
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
 ; No range selected, keep current field the same
 I $G(CF)="" S TMP=$G(CF) Q TMP
 ; For date, and number back up a litle bit (-.0000001)
 I (@AR["N")!(@AR["D") S TMP=CF-.0000001
 ; For pointer or free text keep the same
 I (@AR["P")!(@AR["F")!(@AR["S") S TMP=CF
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
 I $G(CF)="" S TMP=$G(CF) Q TMP
 ; For DATE, and Number jack it up a a little bit (+.0000001)
 I (@AR["D")!(@AR["N") S TMP=CF+.0000001
 ; For pointer or free text, use ~ for compare
 I (@AR["P")!(@AR["F")!(@AR["S") S TMP=CF_"~"
 Q TMP
 ;
CMP(S,IINA,TML,TMU) ; Compare 
 ;
 ;
 ; Description:  The function CMP is used to compare if S is
 ;               in the range from TML to TMU, and determine
 ;               any type of data date, numeric, or string in a 
 ;               specific range. 
 ; Return: 1 = True
 ;         0 = False
 ; Parameters:
 ;    S = Selected items to compare  
 ;    IINA = Contains type of field
 ;    TML =  Lower limit
 ;    TMU =  Upper limit
 ; Code begins:
 N INTMP
 S INTMP=0
 ; No FROM and TO, count this field
 I (TML="")&(TMU="")&(S]"") Q 1
 ; No TO, compare from TML and on
 I (TMU="")  D  Q INTMP
 .I ((IINA["N")!(IINA["D"))&(S'<TML) S INTMP=1 Q
 .I ((IINA["P")!(IINA["S")!(IINA["F"))&(TML']S) S INTMP=1 Q
 ; No FROM
 I (TML="")  D  Q INTMP
 .I ((IINA["N")!(IINA["D"))&(S'>TMU) S INTMP=1 Q
 .I ((IINA["P")!(IINA["S")!(IINA["F"))&(S']TMU) S INTMP=1 Q
 ; Both FROM and TO, compare to lower limit and upper limit
 I (TML'="")&(TMU'="")  D  Q INTMP
 .I ((IINA["N")!(IINA["D"))&(S'<TML)&(S'>TMU) S INTMP=1 Q
 .I ((IINA["P")!(IINA["S")!(IINA["F"))&(TML']S)&(S']TMU) S INTMP=1 Q
 ;nothing match, return 0
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
 ; Go through the current level of the array, LEV is the current subscript
 F  S LEV=$O(@REF@(LEV)) Q:LEV=""  D
 .; if the subscript is not a number, concat "" to make it a string
 . S ZLEV=LEV S:LEV'=(+LEV) ZLEV=""""_LEV_""""
 .; construct the indirect value for next level of the array TREF
 . S:REF[")" TREF=$E(REF,1,$L(REF)-1)_","_ZLEV_")"
 . S:REF'[")" TREF=REF_"("_ZLEV_")"
 .; Recursively calling this same routine
 . D FILL(.INC,TREF)
 .; Accumulating the count
 . S @REF=$G(@REF)+$G(@TREF)
 Q
 ;
FILL1(INC,REF) ; Display the output of the Statistical Report
 ;
 ; Description: The function FILL1 is used to perform the display
 ;  routine (using recursive).
 ;  
 ;  - upon entry set LEVEL=0
 ; - INSFLG flag to disable field type display in second line & on
 ; - INL is the length of field type, if > 20 then go to new line
 ;    ex. in case of the ORIGINAL TRANSACTION TYPE.
 ; Return: none
 ; Parameters:
 ;    INC = The counter array
 ;    REF = Name of INC array
 ; Code begins:
 N CSUB,TREF,ZSUB,DFLG S CSUB="",INSFLG=0
 Q:$G(DUOUT)
 F  S CSUB=$O(@REF@(CSUB)) Q:CSUB=""  D  Q:$G(DUOUT)
 . S ZSUB=CSUB S:CSUB'=(+CSUB) ZSUB=""""_CSUB_""""
 . S:REF[")" TREF=$E(REF,1,$L(REF)-1)_","_ZSUB_")"
 . S:REF'[")" TREF=REF_"("_ZSUB_")"
 .; Set level of the subscript
 . S LEVEL=$G(LEVEL)+1
 .; If only six lines left in the page, then go to the new page
 . I $Y+6>IOSL D HEAD^INHMSR21(INIEN,.INA,INTYPE)  Q:$G(DUOUT)
 .;display field type only on the first line of a new type
 .I '$G(INSFLG) W !?(LEVEL*3),$G(INDP(LEVEL))," : " D INLN^INHMSR21(CSUB,LEVEL*3) S INL(LEVEL)=$L($G(INDP(LEVEL)))
 .I ($G(INSFLG)&($G(INL(LEVEL))>20)) W !?(5+(LEVEL*3)),CSUB
 .I ($G(INSFLG)&($G(INL(LEVEL))'>20)) W !?($G(INL(LEVEL))+3+(LEVEL*3)),CSUB
 . D FILL1(.INC,TREF)  Q:$G(DUOUT)
 .; check if this is the last level, then this is the count
 . I $G(INSEL)=$G(LEVEL) D ADJ^INHMSR21($G(@TREF)) S INSFLG=1
 .; otherwise it must be the subtotal
 . I $Y+7>IOSL D HEAD^INHMSR21(INIEN,.INA,INTYPE)  Q:$G(DUOUT)
 . I $G(INSEL)=($G(LEVEL)+1) D INDASH^INHMSR21
 . I ($G(LEVEL)'=$G(INSEL)) W !?(LEVEL*3),$G(INDP(LEVEL))," SUBTOTAL : " D INLN^INHMSR21(CSUB,LEVEL*3+5) D ADJ^INHMSR21($G(@TREF)) S INSFLG=0 W !
 . S LEVEL=$G(LEVEL)-1
 Q
