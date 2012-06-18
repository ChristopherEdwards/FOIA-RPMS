BAREDI01 ; IHS/SD/LSL - EDI TRANSPORT ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;;
 ; IHS/SD/LSL - 12/24/2002 - V1.7 - XJG-1202-160021
 ;       Allow user to pick new adjust categories 21 and 22
 ;
 ; *********************************************************************
 ;
SELTRAN() ;EP SELECT TRANSPORT
 N DIC,Y
 S DIC=90056.01
 S DIC(0)="AQEML"
 S DLAYGO=90056
 K DD,DO
 D ^DIC
 Q +Y
 ; *********************************************************************
 ;
SELSEG(X)          ;EP SELECT SEGMENT GIVEN TRANSPORT
 N DA,DIC,Y
 S DA(1)=X
 W @IOF,!,"Transport: ",$$VAL^XBDIQ1(90056.01,X,.01)
 S DIC=$$DIC^XBDIQ1(90056.0101)
 S DIC(0)="AEQM"
 S DLAYGO=90056
 K DD,DO
 D ^DIC
 Q +Y
 ; *********************************************************************
 ;
SELTAB(X)          ;EP SELECT TABLE GIVEN SEGMENT
 N DA,DIC,Y
 S DA(1)=X
 W @IOF,!,"Transport: ",$$VAL^XBDIQ1(90056.01,X,.01)
 S DIC=$$DIC^XBDIQ1(90056.0105)
 S DIC(0)="AEQM"
 S DLAYGO=90056
 K DD,DO
 D ^DIC
 Q +Y
 ; *********************************************************************
 ;
DEMOG ;EP EDIT DEMOGRAPHICS OF TRANSPORT
 N X1
 F  S X1=$$SELTRAN() Q:X1'>0  D
 . S DA=X1
 . S DIE=$$DIC^XBDIQ1(90056.01)
 . S DR=".01:.06"
 . D ^DIE
 Q
 ; *********************************************************************
 ;
PRTVARS ;EP PRINT VARIABLES LOCATED IN THE TRANPORT
 N X1
 F  S X1=$$SELTRAN() Q:X1'>0  D
 . S TRDA=X1
 . D VARPRT
 Q
 ; *********************************************************************
 ;
EDTELEM ;EP EDIT ELEMENTS
 N X1,X2
 F  S X1=$$SELTRAN() Q:X1'>0  D
 . F  S X2=$$SELSEG(X1) Q:X2'>0  D
 .. S DA=X2
 .. S DA(1)=X1
 .. S DR="[BAR ELEMENTS EDIT]"
 .. S DDSFILE=90056.01
 .. S DDSFILE(1)=90056.0101
 ..D ^DDS
 Q
 ; *********************************************************************
 ;
EDTTAB ;EP EDIT Entries of a Table
 N X1,X2
 F  S X1=$$SELTRAN() Q:X1'>0  D
 . F  S X2=$$SELTAB(X1) Q:X2'>0  D
 .. S DA=X2
 .. S DA(1)=X1
 .. S DR="[BAR EDI TABLE ID EDIT]"
 .. S DDSFILE=90056.01
 .. S DDSFILE(1)=90056.0105
 ..D ^DDS
 Q
 ; *********************************************************************
 ;
EDTCLAIM ;EP EDIT CLAIM LEVEL CODES
 N X1
 F  S X1=$$SELTRAN() Q:X1'>0  D
 . S DA=X1
 . S DDSFILE=90056.01
 . S DR="[BAR CLAIM LEVEL CODES EDIT]"
 . D ^DDS
 Q
 ; *********************************************************************
 ;
EDTLINE ;EP EDIT LINE LEVEL CODES
 N X1
 F  S X1=$$SELTRAN() Q:X1'>0  D
 . S DA=X1
 . S DDSFILE=90056.01
 . S DR="[BAR LINE LEVEL CODES EDIT]"
 . D ^DDS
 Q
 ; *********************************************************************
 ;
EDTPROV ;EP EDIT PROVIDER LEVEL CODES
 N X1
 F  S X1=$$SELTRAN() Q:X1'>0  D
 . S DA=X1
 . S DDSFILE=90056.01
 . S DR="[BAR PROVIDER LEVEL CODES EDIT]"
 . D ^DDS
 Q
 ; *********************************************************************
 ;
EDTVROU ;EP EDIT VARIABLE ROUTINES
 N X1
 F  S X1=$$SELTRAN() Q:X1'>0  D
 . S DA=X1
 . S DDSFILE=90056.01
 . S DR="[BAR PROCESS VARIABLE EDIT]"
 . D ^DDS
 Q
 ; *********************************************************************
 ;
EDTDATA ;EP EDIT  DATA TYPES & CONVERSIONS
 N X1
 F  S X1=$$SELTRAN() Q:X1'>0  D
 . S DA=X1,DDSFILE=90056.01,DR="[BAR EDIT DATA TYPES]" D ^DDS
 Q
 ; *********************************************************************
 ;
EDTSEG ;EP EDIT SEGMENTS
 N X1
 F  S X1=$$SELTRAN() Q:X1'>0  D
 . S DA=X1
 . S DDSFILE=90056.01
 . S DR="[BAR EDIT SEGMENTS OF TRANSPORT]"
 . D ^DDS
 Q
 ; *********************************************************************
 ;
TABNM() ;EP RETURN A TABLE NAME FOR TABLE ELEMENT DATA TYPES
 ;MADE UP OF SEGMENT-ELEMENT
 N X
 S X=$$VAL^XBDIQ1(90056.0101,"D0,D1",.01)
 S X=X_$$VAL^XBDIQ1(90056.0102,"D0,D1,D2",.01)
 Q X
 ; *********************************************************************
 ;
GENTAB ;EP SCAN ELEMENTS AND GENERATE TABLE NAMES 
 S Y=$$SELTRAN
 Q:Y'>0
 S TRANDA=+Y
 S TABID=$$VAL^XBDIQ1(90056.01,TRANDA,.03)
 I '$L(TABID) D  Q
 . W !,"TABLE ID NOT SET - EXITING",!
 . H 2
 W @IOF
 W !,$$VAL^XBDIQ1(90056.01,TRANDA,01),!
 I '$D(^BAREDI("1T",TRANDA,10,0)) D  Q
 . W !,"NO SEGMENTS - EXITING",!
 . H 2
 I $D(^BAREDI("1T",TRANDA,30)) D  Q
 . W !,"TABLES ALREADY EXIST - EXITING",!
 . H 2
  W !,"HM .. CHECK FAILED"
  Q
 ; *********************************************************************
 ;
SETTAB ;EP  Set Table names of data types that are tables to SEG_"-"_ELEMENT
 ; ie field #1 of element & add forward & backward pointer values
 S ELEMDA=0
 F  S ELEMDA=$O(ELEM(ELEMDA)) Q:ELEMDA'>0  D
 . K DIC,DA,DR
 . S DIC=$$DIC^XBDIQ1(90056.0105)
 . S DIC(0)="XMLE"
 . S DLAYGO=90056
 . S DIC("P")="90056.0105A"
 . S DA(1)=TRANDA
 . S X=ELEM(ELEMDA,1)
 . W !,?10,X
 . K DD,DO
 . D ^DIC
 . S (DA,TABDA)=+Y
 . S VAL=TRANDA_","_SEGDA_","_ELEMDA
 . S DIE=DIC
 . S DR=".02///^S X=VAL"
 . D ^DIE
 . K DIC,DA,DIE,DR
 . S DIE=$$DIC^XBDIQ1(90056.0102)
 . S DA=ELEMDA
 . S DA(1)=SEGDA
 . S DA(2)=TRANDA
 . S DR=".07////"_TRANDA_","_TABDA
 . D ^DIE
 . K TABDA,DA,DIC,DIE,DR
 Q
 ; *********************************************************************
 ;
DICSTYP ;EP Set DIC("S") for selection of postable CATEGORY/TYPE  tables
 S DIC("S")="I (Y=3)!(Y=4)!(Y=13)!(Y=14)!(Y=15)!(Y=16)!(Y=20)!(Y=21)!(Y=22)"
 Q
 ; *********************************************************************
 ;
DICSREA ;EP Set DIC("S") for selection of reasons based on the Posting CATEGORY/TYPE selected
 S DIC("S")="N Z S Z=$P(^(0),U,2) I Z=+$G(^BAREDI(""1T"",DA(1),40,DA,2))"
 Q
 ; *********************************************************************
 ;
VARPRT ;EP XBLM CALL FOR VARPRT
 ;
PRT ;EP
 ; GET DEVICE (QUEUEING ALLOWED)
 S Y=$$DIR^XBDIR("S^P:PRINT Output;B:BROWSE Output on Screen","Do you wish to ","P","","","",1)
 K DA
 Q:$D(DIRUT)
 I Y="B" D  Q
 . S XBFLD("BROWSE")=1
 . S BARIOSL=IOSL
 . S IOSL=600
 . D VIEWR^XBLM("PRTVARS^BAREDIUT(TRDA)")
 . D FULL^VALM1
 . W $$EN^BARVDF("IOF")
 .D CLEAR^VALM1  ;clears out all list man stuff
 .K XQORNEST,VALMKEY,VALM,VALMAR,VALMBCK,VALMBG,VALMCAP,VALMCNT,VALMOFF
 .K VALMCON,VALMDN,VALMEVL,VALMIOXY,VALMLFT,VALMLST,VALMMENU,VALMSGR,VALMUP
 .K VALMY,XQORS,XQORSPEW,VALMCOFF
 .;
DEVE .;
 .S IOSL=BARIOSL
 .K BARIOSL
 .Q
 S XBRP="PRTVARS^BAREDIUT(TRDA)"
 S XBNS="TRDA"
 S XBRX="EXIT^BAREDP07"
 D ^XBDBQUE
 K DIR
 S DIR(0)="E"
 S DIR("A")="<CR> - Continue"
 D ^DIR
 K DIR
 ;
ENDJOB ;
 Q
