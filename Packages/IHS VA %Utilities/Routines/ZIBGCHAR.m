ZIBGCHAR ; IHS/ADC/GTH - NONINTERACTIVE MODIFICATIONS OF GLOBAL CHARACTERISTICS ; [ 07/23/2002  10:35 AM ]
 ;;3.0;IHS/VA UTILITIES;**4,5,9**;FEB 07, 1997
 ; XB*3*4 IHS/ADC/GTH 05-22-97 Prevent <INDER> err.
 ; XB*3*5 IHS/ADC/GTH 10-31-97 Prevent errors in return from ^%GCH.
 ; XB*3*9 IHS/SET/GTH XB*3*9 07/23/2002 Cache' mods.
 ;
 ; Not all capabilities of the implementation-specific global
 ; characteristics routines are reflected in this routine.
 ;
 ; The argument for each entry point is the unsubscripted
 ; name of the global whose characteristics you want to
 ; change, with NO leading circumflex.  
 ;
 ; If the call is successful, 0 is returned.
 ;
 ; If the call is not successful, a positive integer is
 ; returned, and the cause can be retrieved at the ERR()
 ; entry point.
 ;
 ; E.g's: 
 ;          S %=$$NOJOURN^ZIBGCHAR("AUTTSITE")
 ;          I % W !,$$ERR^ZIBGCHAR(%)
 ;
 Q
 ;
 ;Begin New Code;IHS/SET/GTH XB*3*9 07/23/2002
KILL(ZIBGLOB) ;PEP - Kill global or global referenced at the top level
 NEW QF,X
 I '$L($G(ZIBGLOB)) Q 1
 I ZIBGLOB'["," D  Q QF    ; just one global to kill
 . S QF=$$PROCESS("D","N")
 . I QF Q
 . KILL @("^"_ZIBGLOB)
 . I $$VERSION^%ZOSV(1)["Cache" S X=$ZU(68,28,1) ;disallow kill again
 .Q
 ;multiple globals to kill, comma delimited string like "gbl1,gbl2,gbl3"
 F X=1:1:$L(ZIBGLOB,",") S ZIBGLOB(X)=$P(ZIBGLOB,",",X)
 F X=1:1:$L(ZIBGLOB,",") D  Q:QF
 . S QF=$$KILLOK(ZIBGLOB(X))
 . I QF Q
 . KILL @("^"_ZIBGLOB(X)),ZIBGLOB(X)
 .Q
 I $$VERSION^%ZOSV(1)["Cache" S X=$ZU(68,28,1) ;disallow kill again
 Q QF
 ;
 ;End New Code;IHS/SET/GTH XB*3*9 07/23/2002
KILLOK(ZIBGLOB) ;PEP - Allow kill of global.
 Q $$PROCESS("D","N")
 ;
KILLNO(ZIBGLOB) ;PEP - Prevent kill'ing of global.
 Q $$PROCESS("D","Y")
 ;
JOURN(ZIBGLOB) ;PEP - Set Journaling to ALWAYS.
 Q $$PROCESS("J","A")
 ;
NOJOURN(ZIBGLOB) ;PEP - Set Journaling for global to NEVER.
 Q $$PROCESS("J","N")
 ;
UCIJOURN(ZIBGLOB) ;PEP - Journal when UCI is Journaled.
 Q $$PROCESS("J","U")
 ;
PROCESS(ZIBFLAG,ZIBVAL) ;
 I '$L($G(ZIBGLOB)) Q 1
 ;I '(ZIBGLOB?1.8U) Q 5;IHS/SET/GTH XB*3*9 07/23/2002
 I '(ZIBGLOB?1.8U!(ZIBGLOB?1"%"1.7U)) Q 5  ;Cache needs to SET % globals;IHS/SET/GTH XB*3*9 07/23/2002
 I '$D(@("^"_ZIBGLOB)) Q 2
 ; NEW O ; XB*3*4 IHS/ADC/GTH 05-22-97 Prevent <INDER> err.
 ; S O=$P(^%ZOSF("OS"),"-",1) ; XB*3*4 IHS/ADC/GTH 05-22-97 Prevent <INDER> err.
 ; I '$L($T(@O)) Q 3 ; XB*3*4 IHS/ADC/GTH 05-22-97 Prevent <INDER> err.
 ; G @O ; XB*3*4 IHS/ADC/GTH 05-22-97 Prevent <INDER> err.
 ; I $P(^%ZOSF("OS"),"^",1)["MSM" G MSM ; XB*3*4 IHS/ADC/GTH 05-22-97 Prevent <INDER> err.
 I $$VERSION^%ZOSV(1)["Cache" Q $$CACHE(ZIBFLAG,ZIBGLOB,ZIBVAL)  ;IHS/SET/GTH XB*3*9 07/23/2002
 I $P(^%ZOSF("OS"),"^",1)'["MSM" Q 3  ; XB*3*5 IHS/ADC/GTH 10-31-97 Prevent errors in return from ^%GCH.
 D MSM
 I '$D(ZTQUEUED) D HOME^%ZIS U IO(0) ; XB*3*5 IHS/ADC/GTH 10-31-97 Prevent errors in return from ^%GCH.
 Q 0  ; XB*3*5 IHS/ADC/GTH 10-31-97 Prevent errors in return from ^%GCH.
 ; Q 3  ; XB*3*4 IHS/ADC/GTH 05-22-97 Prevent <INDER> err. ; XB*3*5 IHS/ADC/GTH 10-31-97 Prevent errors in return from ^%GCH.
 ;
 ;Begin New Code;IHS/SET/GTH XB*3*9 07/23/2002
CACHE(ZIBFLAG,ZIBGLOB,ZIBVAL) ;PEP - allow/prevent kill or enable/disable journaling on Cache
 ;TASSC/MFD added subroutine to mimic portions of %GCH that Cache can do
 ; -Patterned after CALL subroutine of MSM's %GCH but an extrinsic
 ; -Less options than MSM- journaling is either on or off for a global
 ;  as there is no Journal entire UCI option
 ; -Allowing top-level kill is by process not by global specification
 ; -If the call is successful, 0 is returned.
 ;
 ; ZIBGLOB = global reference, no leading ^
 ; ZIBFLAG can be "J" or "D"- J is for journaling on or off, D is for
 ;   allowing top kill or not
 ; ZIBVAL = for Journaling- E, A or U for enable, D, N or null for disable
 ;       for Prev kill- Y to prevent kill, N to allow kill
 ;
 I '(ZIBGLOB?1.8U!(ZIBGLOB?1"%"1.7UL)) Q 5               ;TASSC/MFD added L to 1.7U for %zmu
 I '$D(@("^"_ZIBGLOB)) Q 2
 I ZIBFLAG="D",ZIBVAL="N" NEW X S X=$ZU(68,28,0) Q 0  ;don't prevent top-level kill for the process
 I ZIBFLAG="D",ZIBVAL="Y" NEW X S X=$ZU(68,28,1) Q 0  ;prevent top-level kill for the process
 I ZIBFLAG="J" NEW ZIBRC D
 .S ZIBVAL=$S(ZIBVAL="E":4,ZIBVAL="A":4,ZIBVAL="U":4,ZIBVAL="N":0,ZIBVAL="D":0,ZIBVAL="":0,1:1)
 .I ZIBVAL'=1 S ZIBRC=$$SetJournalType^%DM("",ZIBGLOB,ZIBVAL)
 .Q
 I ZIBRC=1 Q 0  ;Cache returns a 1 if successful
 Q 1  ; any other condition is bad so quit 1
 ;
 ;End New Code;IHS/SET/GTH XB*3*9 07/23/2002
MSM ; Micronetics Standard MUMPS.
 I '$L($T(CALL^%GCH)) Q 4
 S:$D(ZTQUEUED) CALL="" ; Tell ^%GCH not to talk if errors.
 KILL O
 NEW (ZIBFLAG,ZIBGLOB,ZIBVAL) ; XB*3*5 IHS/ADC/GTH 10-31-97 Prevent errors in return from ^%GCH.
 D CALL^%GCH(ZIBFLAG,ZIBGLOB,ZIBVAL)
 KILL CALL
 ; Q 0 ; XB*3*5 IHS/ADC/GTH 10-31-97 Prevent errors in return from ^%GCH.
 Q  ; XB*3*5 IHS/ADC/GTH 10-31-97 Prevent errors in return from ^%GCH.
 ;
ERR(Z) ;PEP - Return cause of error.
 Q $P($T(@Z),";;",2)
1 ;;NO GLOBAL SPECIFIED IN PARAMETER
2 ;;GLOBAL DOES NOT EXIST
3 ;;OPERATING SYSTEM NOT SUPPORTED
4 ;;WRONG VERSION OF MSM'S ^%GCH
5 ;;BAD GLOBAL NAME
 ;
 ;
TEST ;    
 NEW AZHB,AZHB1
 F AZHBCTR=1:1 S AZHB=$P($T(DATA+AZHBCTR),";",3) Q:AZHB="###"  D T1(AZHB),T2(AZHB)
 Q
 ;
T1(AZHB) ;
 W !,"No Journaling For '",AZHB,"'"
 S AZHB1=$$NOJOURN(AZHB)
 W ?28," : ",AZHB1
 I AZHB1 W " : ",$$ERR(AZHB1)
 E  W " : <kool>"
 Q
 ;
T2(AZHB) ;
 W !,"No Killing For '",AZHB,"'"
 S AZHB1=$$KILLNO(AZHB)
 W ?28," : ",AZHB1
 I AZHB1 W " : ",$$ERR(AZHB1)
 E  W " : <kool>"
 Q
 ;
DATA ;
 ;;
 ;;FREDDATA
 ;;ACHSDATA
 ;;AUTTSITE
 ;;^AUTTLOC
 ;;jen
 ;;44
 ;;DIC(4,
 ;;###
