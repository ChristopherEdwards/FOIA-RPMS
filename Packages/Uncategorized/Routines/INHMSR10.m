INHMSR10 ;KN; 11 Jul 96 11:52; Statistical Report-Def Screen Utilities 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; MODULE NAME: Statistical Report - Definition Screen Utilities
 ;              INHMSR10.
 ;
 ; PURPOSE:
 ; The purpose of this routine is used to contain utility functions
 ; and support for INHMSR1.
 ; 
 ; DESCRIPTION: 
 ; The processing of this routine is used to collect for utility 
 ; functions to support INHMSR1 Statistical Report Definintion 
 ; Screen modules.
 ;
 Q
GPC2(INFL,INFD) ; get piece #2 
 ; 
 ; Description: The function GPC2 is used to get piece #2 from 
 ;         data dictionary ^DD to determine the field type.
 ;
 ; Return: Field type (i.e. Number, Set of code, Date, Pointer)
 ; Parameters:
 ;    INFL = File ien (internal entry number)
 ;    INFD = Field ien
 Q $P($G(^DD(INFL,INFD,0)),U,2)
 ;
 ;
GPC3(INFL,INFD) ;get piece #3 to determine field type
 ;
 ; Description: The function GPC3 is used to get piece #3 from 
 ;         data dictionary ^DD, to get data for pointer
 ;              and set data type.
 ;
 ; Return: Field type 
 ; Parameters:
 ;    INFL = File ien (internal entry number)
 ;    INFD = Field ien
 Q $P($G(^DD(INFL,INFD,0)),U,3)
 ;
GVL(INFL,INFD) ;validation function, return mumps code for date, other default.
 ; 
 ; Description:  The function GVL is used to return Mumps code to 
 ;   validate user's input according to field type.
 ;
 ; Return: Mumps code for validation
 ; Parameters:
 ;    INFL = File ien (internal entry number)
 ;    INFD = Field ien
 ; Code begins:
 N INTMP,PC2,DIC,DIE
 S PC2=$$GPC2(INFL,INFD)
 ; Validation for date 
 I PC2["D" S INTMP="S %DT=""TX"" D ^%DT S Y1=Y D DD^%DT S X=Y K:Y1<1 X"
 E  S INTMP=$P($G(^DD(INFL,INFD,0)),U,5,99)
 ; for Interface error, press enter will ask for input and override 
 ; the input transform for location of error
 I INFL=4003,INFD=.05 S INTMP="S DIC(0)=""DQ"",(DIE,DIC)=$G(^DIC(4003.1,0,""GL"")),DIC(""S"")=""I $P(^(0),U)'=""""ALL"""""" D ^DIC K DIC S C=$P(^DD("_INFL_","_INFD_",0),U,2) D Y^DIQ S DIC=DIE,X=$P(Y,U,2) K:Y<0 X"
 Q INTMP
 ;
INHELP(INFL,INFD) ; Get help for range input.
 ;
 ; Description:  The function INHELP is used to provide help for
 ;               the range input. 
 ; Return: none
 ; Parameters:
 ;    INFL = File ien (internal entry number) 
 ;    INFD = Field ien
 ; Code begins:
 N DQ,DV,D,DP,DZ,INIOSL
 ; Save value only if exist
 S:$D(DIJC("IOSL")) INIOSL=$G(DIJC("IOSL"))
 ; Display the screen DWL for support help
 D POP^DWLR2(12,1)
 S DIJC("IOSL")=6
 ; Call function to get information for help
 D FMHELP^INHUT2(INFL,INFD)
 I $$CR^UTSRD
 ; Restore value only if saved before
 S:$D(INIOSL) DIJC("IOSL")=INIOSL
 Q
 ;
ISTHERE(INFL,INFD,INFLG) ;Check if the field is selectable
 ;
 ; Description:  The function ISTHERE is used to check if the 
 ;               field is selectable and return 1.  All the 
 ;    selectable fields are stored in global.
 ; Return: 1 = True
 ;   0 = False
 ; Parameters:
 ;    INFL = File ien(internal entry number)
 ;    INFD = Field ien
 ;    INFLG = flag 
 ;  = 1 indicates that this file has predefined selectable
 ;      fields stored in global.
 ;  = 0 indicates that there is no pre-defined selectable
 ;      and therefore ignores computed and multiple field.
 ; Code begins:
 N INTMP,X,PC2
 S INTMP=0
 I INFLG D
 .; Search ^UTILITY if a field is there
 .S INTMP=$D(^UTILITY($J,"INHSR",INFL,INFD))#10
 E  D
 .; Set function to determine of the field type
 .S PC2=$$GPC2(INFL,INFD)
 .; ignore it if a multiple field
 .S:'($E(PC2)?1N) INTMP=1
 Q INTMP
 ;
INACHK(INFL,INA) ;verify field .01 range
 ;
 ; Description:  The function INACHK is used to verify .01 field
 ;               range.   
 ; Return: 1 = Error detected
 ;   0 = No error
 ; Parameters:
 ;    INFL = File ien
 ;    INA  = Criteria array for statistical report
 ; Code begins:
 N TMP,IN,INB,INC
 ;int TMP, X, GLNN= Global name, GLN= global+cross ref B
 S TMP=0,X=$O(INA(0)),GLNN=$G(^DIC(INFL,0,"GL")),GLN=""_GLNN_"""B"""_")"
 ; IN=first field in global, INB=field ien of the first field in global 
 S IN=$O(@GLN@("")),INB=$O(@GLN@(IN,""))
 ; In=last field in global, INC=field ien of last field in global
 S IN=$O(@GLN@(""),-1),INC=$O(@GLN@(IN,"")),IN=$G(INC)-$G(INB)
 ; check if first field selected is .01
 I $G(INA(X,1))=.01 D
 .; Check doest it have range
 .I '$L(INA(X,3))&'$L(INA(X,4)) D
 ..; if no range then display
 ..D MESS^DWD(5,10) W !,"Approximate search size "_IN_" messages"
 ..I $$YN^UTSRD("Do you want to continue ?") S INA(0)=0
 ..E  S TMP=1
 .; INA(0)=0 field .01 has range
 .E  S INA(0)=1
 E  D
 .; field .01 is no selected
 .D MESS^DWD(5,10) W !,"Approximate search size "_IN_" messages"
 .I $$YN^UTSRD("Do you want to continue ?") S INA(0)=2
 .E  S TMP=1 Q
 .; X=first order selected
 .S X=$O(INA(0))
 .; Loop thru INA array and make sure field .01 is not selected
 .; in order different than 1
 .F  S X=$O(INA(X)) Q:X=""  D
 ..; If the .01 field is selected.  It is order must be "1"
 ..I $G(INA(X,1))=.01 D MESS^DWD(5,10) W !,$G(INA(X,2))," Field must be order 1" S TMP=1 I $$CR^UTSRD
 Q TMP
