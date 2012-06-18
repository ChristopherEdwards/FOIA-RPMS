BHLU ; cmi/flag/maw - BHL Utilities ;  [ 04/19/2004  10:42 AM ]
 ;;3.01;BHL IHS Interfaces with GIS;**2,10,11,12,13,14,15,16**;OCT 15, 2002
 ;
 ;this routine will have callable utilites by the BHL Package
 ;
DIE ;-- generic DIE call from BHL package
 K DIE,DR
 I BHLVAL="""""" S BHLVAL="@"
 Q:BHLVAL=""  ;don't update data with a null value
 S DIE=BHLFL,DR=BHLFLD_"///"_BHLVAL,DA=BHLX
 D ^DIE
 I $D(Y) S BHLERCD="GEN" S BHLEFL=BHLFL X BHLERR
 K DIE,DR
 Q
 ;
DIE4 ;-- generic DIE call from BHL package
 K DIE,DR
 I BHLVAL="""""" S BHLVAL="@"
 Q:BHLVAL=""  ;don't update data with a null value
 S DIE=BHLFL,DR=BHLFLD_"////"_BHLVAL,DA=BHLX
 D ^DIE
 I $D(Y) S BHLERCD="GEN" S BHLEFL=BHLFL X BHLERR
 K DIE,DR
 Q
 ;
DIEM ;-- generic die call for multiples
 S DIE=BHLFL,DA(1)=BHLX,DA=BHLVAL,DR=BHLFLD_"///"_BHLVAL2
 D ^DIE
 I $D(Y) S BHLERCD="GEN",BHLEFL=BHLFL2,BHLFLD=BHLFLD X BHLERR
 K DIE,DR
 Q
 ;
DIC(BHLFL,BHLVAL) ;EP - generic dic call
 S DIC=BHLFL,DIC(0)="MXZ",X=BHLVAL D ^DIC
 S BHLY=+Y
 Q BHLY
 ;
FK ;EP - kill fileman variables
 K DD,DO,DIC,DIE,DR,Y,DIR
 Q
 ;
ST(ST) ;-- transform into state  
 I ST="" Q ST
 S NST=$$VAL^XBDIQ1(5,ST,1)
 Q NST
 ;
CHKPAT(BHLPT,BHLDUZ)         ;EP - lookup the patient
 I '$G(BHLDUZ) S BHLDUZ=DUZ(2)
 S BHLXDA=0 F  S BHLXDA=$O(^AUPNPAT("D",BHLPT,BHLXDA)) Q:'BHLXDA!($G(BHLPAT))  D
 . S BHLYDA=0 F  S BHLYDA=$O(^AUPNPAT("D",BHLPT,BHLXDA,BHLYDA)) Q:'BHLYDA!($G(BHLPAT))  I BHLYDA=BHLDUZ S BHLPAT=BHLXDA
 I $G(BHLPAT) Q BHLPAT
 Q ""
 ;
CHKDOB(BHLDOBC)    ;EP - check the date of birth and sex for identifier
 S BHLDOB2=$P($G(^DPT(BHLDOBC,0)),U,3)
 I BHLDOB2'=BHLDOB S BHLERCD="NODOBM" X BHLERR S BHLPAT="" Q BHLPAT
 S BHLSEX2=$P($G(^DPT(BHLDOBC,0)),U,2)
 I BHLSEX2'=BHLSEX S BHLERCD="NOSEXM" X BHLERR S BHLPAT="" Q BHLPAT
 S BHLPAT=BHLDOBC
 Q BHLPAT
 Q
 ;
CHAR ;-- set field sep and encoding characters for a message
 S DIC="^INTHL7M(",DIC(0)="AEMQZ"
 S DIC("A")="Set Characters for which message: "
 D ^DIC
 Q:Y<0
 S BHL("MSG")=+Y
 D CHARUP(BHL("MSG"))
 Q
 ;
CHARUP(BHLMIEN) ;EP - update field sep and enc chars for hl7
 I $P($G(^INTHL7M(BHLMIEN,0)),U)["HL" D  Q
 . S ^INTHL7M(BHLMIEN,"FS")="|"
 . S ^INTHL7M(BHLMIEN,"EC")="^~\&"
 I $P($G(^INTHL7M(BHLMIEN,0)),U)="X1" S ^INTHL7M(BHLMIEN,"FS")="*"
 Q
 ;
COMPILE(MSG)       ;EP - compile a message
 S Y=MSG,INGALL=1 D EN^INHSGZ
 Q
 ;
COMPILEP(NS)       ;EP - compile msgs by namespace
 S BHLNDA=0 F  S BHLNDA=$O(^INTHL7M("B",BHLNDA)) Q:BHLNDA=""  D
 . Q:BHLNDA'[NS
 . S BHLNIEN=0 F  S BHLNIEN=$O(^INTHL7M("B",BHLNDA,BHLNIEN)) Q:'BHLNIEN  D
 .. S Y=BHLNIEN,INGALL=1
 .. D EN^INHSGZ
 Q
 ;
HFS(BHLHFSN,BHLUIEN)       ;EP - saves message to host file
 S Y=$$OPEN^%ZISH("D:\TEMP\",BHLHFSN_"."_BHLMSTD,"W")
 U IO
 I BHLMSTD="X12" D
 . S BHLUDA=0 F  S BHLUDA=$O(^INTHU(BHLUIEN,3,BHLUDA)) Q:'BHLUDA  D
 .. S BHLXR=$P($G(^INTHU(BHLUIEN,3,BHLUDA,0)),"|CR|")
 .. I $G(BHLXR)["~" W BHLXR Q
 .. W BHLXR_"~"
 I BHLMSTD'="X12" D
 . S BHLUDA=0 F  S BHLUDA=$O(^INTHU(BHLUIEN,3,BHLUDA)) Q:'BHLUDA  D
 .. W $P($G(^INTHU(BHLUIEN,3,BHLUDA,0)),"|CR|"),!
 D ^%ZISC
 Q
 ;
HFSA(DEST,BHLHDIR,BHLHFNM) ;EP - export from this destination
HFSDW ;-- callable from Data Warehouse   
 F BHLJOB="FORMAT CONTROLLER","OUTPUT CONTROLLER" D
 . S BHLY=$$CHK^BHLBCK(BHLJOB)
 Q:'$D(^INLHDEST(DEST))
 S Y=$$OPEN^%ZISH(BHLHDIR,BHLHFNM,"W")
 Q:Y
 S BHLH=0 F  S BHLH=$O(^INLHDEST(DEST,0,BHLH)) Q:'BHLH  D
 . S BHLU=0 F  S BHLU=$O(^INLHDEST(DEST,0,BHLH,BHLU)) Q:'BHLU  D
 .. D LPINTHU(BHLU)
 .. K ^INLHDEST(DEST,0,BHLH,BHLU)
 D ^%ZISC
 Q
 ;
HFSRL(DEST,BHLHDIR,BHLHFNM) ;EP - export from this destination
 F BHLJOB="FORMAT CONTROLLER","OUTPUT CONTROLLER" D
 . S BHLY=$$CHK^BHLBCK(BHLJOB)
 S Y=$$OPEN^%ZISH(BHLHDIR,BHLHFNM,"W")
 Q:Y
 S BHLH=0 F  S BHLH=$O(^INLHDEST(DEST,0,BHLH)) Q:'BHLH  D
 . S BHLU=0 F  S BHLU=$O(^INLHDEST(DEST,0,BHLH,BHLU)) Q:'BHLU  D
 .. D RLINTHU(BHLU)
 .. K ^INLHDEST(DEST,0,BHLH,BHLU)
 D ^%ZISC
 Q
 ;
LPINTHU(BHLUIEN)       ;EP - loop through UIF and set to file
 S BHLUDA=0 F  S BHLUDA=$O(^INTHU(BHLUIEN,3,BHLUDA)) Q:'BHLUDA  D
 . U IO W $P($G(^INTHU(BHLUIEN,3,BHLUDA,0)),"|CR|"),!
 Q
 ;
RLINTHU(BHLUIEN)       ;EP - loop through UIF and set to file for ref lab
 S BHLUDA=0 F  S BHLUDA=$O(^INTHU(BHLUIEN,3,BHLUDA)) Q:'BHLUDA  D
 . ;U IO W $P($G(^INTHU(BHLUIEN,3,BHLUDA,0)),"|CR|"),$C(13,10)
 . ;U IO W $P($G(^INTHU(BHLUIEN,3,BHLUDA,0)),"|CR|"),$C(10) quest old
 . U IO W $P($G(^INTHU(BHLUIEN,3,BHLUDA,0)),"|CR|"),!  ;quest new
 Q
 ;
SENDFILE(FNM,SDIR,IP,PASS) ;EP - this will trigger a send via the sendto command, sendto.pl must exist
 S BHLOPS=$P($G(^AUTTSITE(1,0)),U,21)
 I PASS["anonymous" D  Q
 . S BHLSEND="sendto -i"_$S(BHLOPS=1:" ",1:" -a ")_IP_" "_SDIR_FNM
 . S X=$$JOBWAIT^%HOSTCMD(BHLSEND)
 S BHLSEND="sendto -i -l "_PASS_$S(BHLOPS=1:" ",1:" -a ")_IP_" "_SDIR_FNM
 ;S BHLSEND="sendto1 -u -l "_PASS_$S(BHLOPS=1:" ",1:" -a ")_IP_" "_SDIR_FNM  ;for loinc project
 S X=$$JOBWAIT^%HOSTCMD(BHLSEND)
 Q
 ;
MPORT ;EP - run the import package utility
 I $O(^INXPORT(""))="" D  Q
 . W !,"Global ^INXPORT missing, please restore and run MPORT^BHLU"
 S BHLIT=$O(^INXPORT(""))
 S BHLIST=$O(^INXPORT(BHLIT,""))
 S BHLIPK=$O(^INXPORT(BHLIT,BHLIST,""))
 W !,"Importing GIS "_$G(BHLIT)_" Supplement "_$G(BHLIPK)
 W ", developing site "_$G(BHLIST)
 D ^INMPORT
 W !,"Finished Importing GIS Supplement "
 K BHLIT,BHLIST,BHLIPK
 Q
 ;
STUFFO(DEST,STOR)   ;--loop through stor and stuff into ^INTHU
 D NOW^%DTC S BHLXDTM=$G(%)
 S BHLXH=$H
 S BHLXDEST=$O(^INRHD("B","X1 IHS "_DEST,0))
 S BHLXSTAT="N"
 S BHLXIO="O"
 S BHLXPRIO=1
 K DD,DO
 S DIC="^INTHU(",DIC(0)="L",X=BHLXDTM
 S DIC("DR")=".02////"_BHLXDEST_";.03////"_BHLXSTAT_";.1////"_BHLXIO
 S DIC("DR")=DIC("DR")_";.16///"_BHLXPRIO
 D FILE^DICN
 S BHLXUIF=+Y
 S BHLXDA=0 F  S BHLXDA=$O(@STOR@(BHLXDA)) Q:'BHLXDA  D
 . K DIC,DD,DO
 . S DIC="^INTHU("_BHLXUIF_",3,",DIC(0)="L"
 . S DIC("P")=$P(^DD(4001,3,0),"",2)
 . S DA(1)=BHLXUIF,X=$G(@STOR@(BHLXDA))_"|CR|"
 . Q:X=""
 . D FILE^DICN
 K ^INTHU(BHLXUIF,3,"B")  ;don't need b index on msg multiple
 S ^INLHDEST(BHLXDEST,BHLXPRIO,BHLXH,BHLXUIF)=""
 Q
 ;
EOJ ;-- kill variables and quit
 Q
 ;
