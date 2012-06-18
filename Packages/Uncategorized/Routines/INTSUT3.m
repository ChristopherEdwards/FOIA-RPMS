INTSUT3 ; cmi/flag/maw - JD 13 Apr 96 21:09 INTERACTIVE TESTING II ; [ 05/22/2002  2:54 PM ]
 ;;3.01;BHL IHS Interfaces with GIS;**1**;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
MERGE(INREQLST) ;Merge tests into ^UTILITY GLOBAL
 ; Input:
 ;  INREQLST - Array of selected messages
 ;Get the next test run number
 N INL,INT,TESTNUM
 K ^UTILITY("INTHU",DUZ,$J)
 S INL="" F  S INL=$O(INREQLST(INL)) Q:INL=""  D
 .S INT=INREQLST(INL)
 .M ^UTILITY("INTHU",DUZ,$J,INL,INT,0)=^INTHU(INT,0)
 .M ^UTILITY("INTHU",DUZ,$J,INL,INT,3)=^INTHU(INT,3)
 .S TESTNUM=$G(^UTILITY("INTHU",DUZ,$J))+1,^UTILITY("INTHU",DUZ,$J)=TESTNUM
 Q
MERGE2(INARY) ;Merge tests into ^UTILITY GLOBAL
 ; Input:
 ;  INARY - Array of selected messages
 ;Get the next test run number
 N INL,INT,TESTNUM,INEXIST
 S INEXIST=0
 S:$G(INARY)="" INARY="^INTHU"
 S INL="" F  S INL=$O(INARY("A",INL)) Q:INL=""  D
 .S INT=INARY("A",INL)
 .S:$D(^UTILITY("INTHU",DUZ,$J,INL)) INEXIST=1
 .K ^UTILITY("INTHU",DUZ,$J,INL)
 .M ^UTILITY("INTHU",DUZ,$J,INL,INT,0)=@(INARY_"(INT,0)")
 .M ^UTILITY("INTHU",DUZ,$J,INL,INT,3)=@(INARY_"(INT,3)")
 .I 'INEXIST S TESTNUM=$G(^UTILITY("INTHU",DUZ,$J))+1,^UTILITY("INTHU",DUZ,$J)=TESTNUM
 Q
UPDAT2FL(INREQLST,INDA) ;Merge to 4001.1 multiple
 ; Input:
 ;  INREQLST - Array of selected messages
 ;  INDA - ien of 4001.1
 ;Get the next test run number
 N INL,INT,TESTNUM
 K ^DIZ(4001.1,INDA,19,0)
 S TESTNUM=""
 S INL="" F  S INL=$O(INREQLST(INL)) Q:INL=""  D
 .S INT=INREQLST(INL)
 .I $D(^INTHU(INT,0)) D
 ..S ^DIZ(4001.1,INDA,19,0)=INT_U_$P(^INTHU(INT,0),U,5)
 ..S TESTNUM=TESTNUM+1
 S ^DIZ(4001.1,INDA,19,0)="^4001.19PA^"_TESTNUM_U_TESTNUM
 Q
UPDTFRUT(INDA) ;Update ^UTILITY to 4001.1 multiple
 ; Input:
 ;  ^UTILITY("DIS",$J - selected messages
 ;   INDA - ien of 4001.1
 ; Output:
 ;   ^DIZ(4001.1,INDA,19, multiple
 ;
 N INL,INT,TESTNUM
 K ^DIZ(4001.1,INDA,19,0)
 S TESTNUM=""
 S INL="" F  S INL=$O(^UTILITY("INTHU",DUZ,$J,INL)) Q:INL=""  D
 .S INT=$O(^UTILITY("INTHU",DUZ,$J,INL,""))
 .I $D(^INTHU(INT,0)) D
 ..D UPSINGMS^INTSUT3(INDA,"LS",INT)
 Q
UPDATE(INDA) ;Update INREQLST with test messages
 ; Input/Output - INREQLST - Name of Utility with tests
 N INL,INT,IND
 K ^UTILITY("DIS",$J)
 S INL=0,INT="" F  S INT=$O(^DIZ(4001.1,INDA,19,INT)) Q:INT=""  D
 .S IND=+$G(^DIZ(4001.1,INDA,19,INT,0))
 .I IND D
 ..S INL=INL+1
 ..M ^UTILITY("DIS",$J,INL,IND,0)=^INTHU(IND,0)
 ..S ^UTILITY("DIS",$J)=INL
 Q
UPSINGMS(INDA,IN0,INENT) ;Update a single entry in test message multiple
 ; Input:
 ;   INDA - ien of Test Criteria
 ;   IN0 - DIC(0)
 ;   INENT - value to stuff
 N DLAYGO,DA,DIE,DIC,X,Y
 K DIC S DLAYGO="4001.1",DIC("P")=$P(^DD(4001.1,19,0),U,2)
 S DIC="^DIZ(4001.1,"_INDA_",19,",DIC(0)=IN0,DA(1)=INDA,DIE=DIC
 S X=INENT
 D ^DICN
 I Y<0 D DISPLAY^INTSUT1("Unable to update Test Message multiple - "_INENT) Q
 Q
UPDTSND(INDA) ;Update ^UTILITY("INTHU" with test messages
 ; Input - INDA - ien of Criteria
 ; Output - ^UTILITY - Name of Utility with tests
 N INL,INT,IND
 K ^UTILITY("INTHU",DUZ,$J)
 S INL=0,INT="" F  S INT=$O(^DIZ(4001.1,INDA,19,INT)) Q:INT=""  D
 .S IND=+$G(^DIZ(4001.1,INDA,19,INT,0))
 .I IND D
 ..S INL=INL+1
 ..M ^UTILITY("INTHU",DUZ,$J,INL,IND,0)=^INTHU(IND,0)
 ..M ^UTILITY("INTHU",DUZ,$J,INL,IND,3)=^INTHU(IND,3)
 ..S ^UTILITY("INTHU",$J)=INL
 ..;kill activity log from UIF
 ..K ^INTHU(IND,1)
 Q
FLATNAM(INAME,INTYP) ;Get VMS flat file name
 ;Input:
 ; INAME - default name
 ; INTYP - "S" - save file
 ; Returns: INAME - VMS Flat file name
 N DONE S DONE=0
 I $G(INTYP)="S" S INTYP="Save to"
 E  S INTYP="Restore from"
 F  D  Q:DONE
 .W @IOF,!!
 .S INAME=$$READ^%ZTF(1,30,"Enter the VMS flat file to "_INTYP_": ",INAME)
 .I INAME="^" S INAME=""
 .I INAME="" S DONE=1 Q
 .I INAME["?" D  Q
 ..N $ET
 ..S $ZE="",$ZT="ERR^INTSUT3"
 ..S INAME=""
 ..;I INTYP="Save to" W !,"Enter a flat file name to save Criteria to"
 ..;E  W $ZC(%SPAWN,"DIR")
 ..I $$CR^UTSRD
 .S DONE=1
 Q INAME
EXISTS(INODE0,INAME) ;Check to see if user defined record exists
 ;Input:
 ; INODE0 - 0 node of flat saved utility global or 4001.1 0 node
 ;Output:
 ; INAME - Name of criteria
 ;Returns: 0 if does not exist, or ien of existing criteria
 ;
 N INOPT2,INCTRL
 S INCTRL=$S('$L($G(INCTRL)):"U","SUBW"[INCTRL:INCTRL,1:"U")
 ; quit if not to be saved
 S INAME=$P(INODE0,U,4)
 Q:'$L(INAME) ""
 ; see if name exists already
 S INOPT2("DUZ")=DUZ,INOPT2("TYPE")=$P(INODE0,U,5),INOPT2("APP")=$P(INODE0,U,8),INOPT2("FUNC")=$P(INODE0,U,6),INOPT2("CONTROL")=INCTRL
 Q $$LOOKUP^INHUTC1(.INOPT2,INAME)
ERR Q
