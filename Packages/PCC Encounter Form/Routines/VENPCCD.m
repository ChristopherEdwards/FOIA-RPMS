VENPCCD ; IHS/OIT/GIS - UPDATE DEMOGRAPHICS AND INSURANCE INFO ;
 ;;2.6;PCC+;;NOV 12, 2007
 ;
 ;
 ;
PAT(DFN) ; EP-UPDATE DEMOGRAPHICS
 N VENA,VENPI,N,SEX,SSN,AGE,DOB,D0,IOEDEOP,IOINHI,IOINLOW,IOINORM,IORVOFF,IORVON,IOUOFF,IOUON,X,VEN,Y,I,IOBOFF,IOBON,%,VEND,DIPGM,AUPNDAYS,AUPNDOB,AUPNDOD,AUPNPAT,AUPNSEX,DA,DIC,DR,DIQ,D0,DLAYGO,VENPAT
 D ^XBKVAR
 S X="IOEDEOP;IORVON;IORVOFF;IOBOFF;IOBON;IOINHI;IOINORM;IOINLOW;IOUOFF;IOUON" D ENDR^%ZISS
 S VEND("EMPST")=$P(^DD(9000001,.21,0),"^",3)
START ;
 K VEN
 S DIC="^AUPNPAT(",DIC(0)="",X="`"_DFN,DLAYGO=9000001 D ^DIC K DIC
 I $D(DFN) D PROCESS
 I $D(DFN),$L($T(UPDATE1^AGED)),$P($G(^VEN(7.5,CFIGIEN,0)),U,20) D PAGE11(DFN)
 G END
PROCESS ; EP - DRIVER
 L ^AUPNPAT(DFN,0):0 I '$T W !!,*7,"Patient is being edited by someone else!!" H 1 Q  ;G START
 S VEN(0)=^DPT(DFN,0)
 S DIC=2,DA=DFN,DR=.033,DIQ="VENA" D EN^DIQ1 S VEN("AGE")=VENA(2,DFN,.033)
 S VEN("SSN")=$P(VEN(0),"^",9)
 S VEN("HPHONE")=$P($G(^DPT(DFN,.13)),"^",1)
 S VEN("OPHONE")=$P($G(^DPT(DFN,.13)),"^",2)
 S VEN("N")=$P(VEN(0),"^",1)
 S VEN("HRN")=$P(^AUPNPAT(DFN,41,DUZ(2),0),"^",2)
 S %=$P($G(^DPT(DFN,0)),U,3) I %'?7N W !,"Missing/invalid DOB!!!" Q
 S AGE=(DT-%)\10000
 I (AGE>64)&('$D(^AUPNMCR(DFN))) S VEN("MRCK")="Y"
DISPLAY I '$G(CHECKIN) D ^XBCLS I 1
 E  W !!
 U 0 W ?5,IOUON,IOINHI,"Patient: ",IOUOFF,IOINLOW,VEN("N"),?69,IOUON,IOINHI,"HRN: ",IOUOFF,IOINLOW,VEN("HRN")
ADD ;
 S VEN(.11)=$G(^DPT(DFN,.11))
 F I=1:1:6 S VEN("A",I)=$P(VEN(.11),"^",I)
 I VEN("A",5)'="" S VEN("A",5)=$P(^DIC(5,VEN("A",5),0),"^",1)
 W !,?5,IOUON,IOINHI,"SSN: ",IOUOFF,IOINLOW,VEN("SSN")
 W !,?5,IOUON,IOINHI,"HOME PHONE: ",IOUOFF,IOINLOW,VEN("HPHONE")
 W !,?5,IOUON,IOINHI,"OFFICE PHONE: ",IOUOFF,IOINLOW,VEN("OPHONE")
 W !!,?5,IOUON,IOINHI,"Address: ",IOUOFF,IOINLOW,VEN("A",1) I VEN("A",2)'="" W !,?14,VEN("A",2)
 I VEN("A",3)'="" W !,?14,VEN("A",3)
 W !,?14,VEN("A",4),", ",VEN("A",5)," ",VEN("A",6)
 S DIR("A")="SSN, Phone or Address Change",DIR("B")="N",DIR(0)="Y"
 W IOINHI D ^DIR W IOINLOW
 I $D(DTOUT)!($D(DUOUT)) G END
 I Y=1 D ADDCHG G DISPLAY
 D INCHG G DISPLAY:VEN("ICHG")="Y"
 D EMPCHG
 D MDCDFL
 I (VEN("AGE")>64)&('$D(^AUPNMCR(DFN))) D MCRFL
 G END
ADDCHG ; call routine that changes address fields in pat reg
 ;makes sure change the date last edit,who edited and agpatch also
 N GBL,%,DIE,DA,DR,X,Y,DIC
 S GBL=$NA(^AGPATCH)
 S DIE="^DPT(",DA=DFN,DR=".09;.131;.132;.111;.112;.113;.114;.115;.116"
 L +^DPT(DA):0 I $T D ^DIE L -^DPT(DA)
 S DIE="^AUPNPAT(",DA=DFN,DR=".03////"_DT_";.16////"_DT_";.12////"_DUZ
 L +^AUPNPAT(DA):0 I $T D ^DIE L -^AUPNPAT(DA)
 D NOW^%DTC
 S @GBL@(%,DUZ(2),DFN)=""
 Q
INCHG ; changes in the insurance plan
 S VEN("ICHG")="N"
 W !
 I $D(^AUPNPRVT(DFN)) D PI^VENPCCD1
 I $$MOK(DFN) D MDCD^VENPCCD1
 D MCR^VENPCCD1
 S DIR("A")="Any 3rd Party Rescource Changes",DIR("B")="N",DIR(0)="Y"
 W IOINHI D ^DIR W IOINLOW
 I $D(DTOUT)!($D(DUOUT)) Q
 K DIR
 I Y=1 D ELIG^VENPCCD1 S VEN("ICHG")="Y"
 Q
MOK(DFN) ; IS PT MEDICAID ELIGIBLE?
 N MDIEN,START,END
 S MDIEN=$O(^AUPNMCD("B",+$G(DFN),0)) I 'MDIEN Q 0
 S START=$O(^AUPNMCD(MDIEN,11,9999999),-1) I 'START Q 0
 S END=$P($G(^AUPNMCD(MDIEN,11,START,0)),U,2)
 I END<DT Q 0
 Q 1
 ; 
EMPCHG ; changes in the employment, employment status, or spouse employment
 S VEN("$Y")=$Y
 S VEN(0)=^AUPNPAT(DFN,0)
 S VEN("E")=$P(VEN(0),"^",19) I VEN("E")'="" S VEN("E")=$P(^AUTNEMPL(VEN("E"),0),"^",1)
 S VEN("ES")=$P(VEN(0),"^",21) I VEN("ES")'="" S VEN("ES")=$P(VEND("EMPST"),(VEN("ES")_":"),2),VEN("ES")=$P(VEN("ES"),";",1)
 S VEN("SE")=$P(VEN(0),"^",22) I VEN("SE")'="" S VEN("SE")=$P(^AUTNEMPL(VEN("SE"),0),"^",1)
 W !!,?5,IOUON,IOINHI,"Employer: ",IOUOFF,IOINLOW,VEN("E"),"   ",IOUON,IOINHI,"Status: ",IOUOFF,IOINLOW,VEN("ES")
 I VEN("SE")'="" W !,?5,IOUON,IOINHI,"Spouse's Employer: ",IOUOFF,IOINLOW,VEN("SE")
 S DIR("A")="Any Changes in Employment",DIR("B")="N",DIR(0)="Y"
 W IOINHI D ^DIR W IOINLOW
 I $D(DTOUT)!($D(DUOUT)) Q
 I Y=1 D EMPL^VENPCCD1 S VEN("ECHG")="Y",$Y=VEN("$Y") W IOEDEOP S $Y=VEN("$Y")
 W !
 Q
MDCDFL ; medicaid alert for passport signature
 I $D(VEN("MDCD")) D
 .W IORVON,*7
 .S DIR("A",1)="Patient is currently on Medicaid and must sign Passport form."
 .S DIR("A")="Has this been COMPLETED"
 .S DIR(0)="Y"
 .S DIR("B")="Y"
 .D ^DIR
 .I Y=1 S VEN("COMP")="Y"
 .I Y=0 S VEN("COMP")="N"
 .I '$D(VENPAT("MDCD",DFN)) S VENPAT("MDCD",DFN)=DT_"^"_DUZ_"^"_VEN("COMP")
 .S VEN("M")=VENPAT("MDCD",DFN)
 .S $P(VEN("M"),"^",4)=DT
 .S $P(VEN("M"),"^",5)=DUZ
 .S $P(VEN("M"),"^",6)=VEN("COMP")
 .S VENPAT("MDCD",DFN)=VEN("M")
 K DIR
 W IORVOFF
 Q
MCRFL ; medicare alert--person over 65 and not on file with medicare
 U 0 W *7,IORVON,IOBON,!,?5,"PERSON OVER 65--NO MEDICARE ON FILE!!!",IORVOFF,IOBOFF
 I '$D(VENPAT("MCR",DFN)) S VENPAT("MCR",DFN)=DT_"^"_DUZ
 D NOW^%DTC
 S VENPAT("MCR",DFN,%)=DUZ
 ;THE VENPAT("MCR",DFN) node contains the initial time that the user
 ;was alerted to see person wasn't on file with Medicare & is over 64
 ;the next nodes with % is the times after that the user is alerted that
 ;the person is not on file with medicare
 Q
END ;
 Q
PAGE11(DFN) ; EP-EDIT PAGE 11
 N DA,DR,DIE
 W !!,"Want to enter additional registration information (Page 11)"
 S %=2 D YN^DICN I %'=1 Q
 S DIE=9000001,DR=1301,DA=DFN
 L +^AUPNPAT(DA):0 I $T D ^DIE L -^AUPNPAT(DA)
 D UPDATE1^AGED(DUZ(2),DFN,11,"")
 D ^XBFMK
 Q
 ; 
