BYIMIMM ;IHS/CIM/THL - IMMUNIZATION DATA INTERCHANGE;
 ;;2.0;BYIM IMMUNIZATION DATA EXCHANGE INTERFACE;**2**;MAY 01, 2011
 ;
 ;;PATCH 2
 ;;
 ;;  HFSA     - RE-DO EXPORT NUMBER COUNT
 ;;           - RE-DO CREATION OF EXPORT FILE
 ;;  DEX      - RE-DO EXPORT NUMBER COUNT
 ;
 ;----
ENV ;EP;
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 N BYIMDA
 S BYIMDA=+^AUTTSITE(1,0)
 I '$D(^BYIMPARA(+BYIMDA,0)) D
 .K DIE,DIC,DINUM,DR,DA,DD,DO,DIK,DLAYGO
 .S DIC="^BYIMPARA("
 .S DIC(0)="L"
 .S (X,DINUM)=+^AUTTSITE(1,0)
 .D FILE^DICN
 .K DIE,DIC,DINUM,DR,DA,DD,DO,DIK,DLAYGO
 .S BYIMDA=+Y
 I $D(^BYIMPARA(BYIMDA)),'$D(^BYIMPARA(BYIMDA,0)) D
 .S ^BYIMPARA(BYIMDA,0)=BYIMDA
 .S ^BYIMPARA("B",BYIMDA,BYIMDA)=""
 Q
 ;-----
DE ;EP;IMMUNIZATION EXPORT
 N BYIMJOB,BYIMY,BYIMRMSG,BYIMY,BYIMX,DA,DIC,DIE,DIK,DR,DIR,D19,DD19,DATE,DDATE,DATE19,DEST,ENC,EVDT,FACILITY,FILE,INA,MSG,NUM,OPATH,IPATH,ZTDESC,ZTDTC,ZTIO,ZTQUEUED,ZTRTN,ZTSAVE,VALMBCK,XPDDIQ,BYIMCNT,AGE,AGE19,MSGCNT,DFNCNT,IMMCNT,BYIMQUIT
 D PATH
 I OPATH="" D NOPATH Q
 K BYIMQUIT
 I '$D(ZTQUEUED) D  Q:$D(BYIMQUIT)
 .N WRITING,DE
 .S DE=""
 .D READY:$O(^BYIMPARA(DUZ(2),"LAST EXPORT",0))
 .I $D(WRITING) D  Q:$D(BYIMQUIT)
 ..D RESTART
DATE ;EP;SELECT EXPORT DATE
 K BYIMQUIT
 N DATE,X,Y,Z,BYIMDUZ
 S Y=2,BYIMDUZ(Y)=DUZ(2)
 I '$D(^BYIMPARA(DUZ(2),0)) D
 .S X=0
 .F  S X=$O(^BYIMPARA(X)) Q:'X  I $D(^BYIMPARA(X,0)) S Y=2,DUZ(Y)=X Q
 Q:'$D(^BYIMPARA(DUZ(2),0))
 D DATE19
 S (DATE,D19)=$O(^BYIMPARA(DUZ(2),"LAST EXPORT",9999999),-1)
 I DATE D D1 Q:$D(BYIMQUIT)
 I 'DATE D
 .S (DATE,D19)=$S(YEARS=19:DATE19,1:DATE99)
 .Q:$D(ZTQUEUED)
 .W !!,"The date of the last Immunization export is not on file."
 .W !,"The export will include all Children 0-18 years of age."
 I '$D(ZTQUEUED) D  Q:$D(BYIMQUIT)
 .W !!,"Evaluation of immunizations for export to the State Immunization"
 .W !,"registry may take several minutes."
 .S DIR(0)="YO"
 .S DIR("A")="Do you want to proceed"
 .S DIR("B")="NO"
 .W !
 .D ^DIR
 .K DIR
 .I Y'=1 S BYIMQUIT=""
 K ^BYIMTMP($J,"BYIM EXP")
 N X,Y,Z,ZZ,MSGCNT,DFN,BYIMQUIT,XX
 S XX=$P($H,",",2)
 I $D(^BYIMPARA(DUZ(2),"LAST EXPORT")) D LE Q
 I '$D(^BYIMPARA(DUZ(2),"LAST EXPORT")) D NLE Q
 Q
 ;-----
DEX D HEADER
 S (MSGCNT,DFN,DFNCNT,IMMCNT)=0
 F  S DFN=$O(^BYIMTMP($J,"BYIM EXP",DFN)) Q:'DFN  D
 .S DA=$O(^BYIMTMP($J,"BYIM EXP",DFN,0))
 .Q:'DA
 .W:'$D(ZTQUEUED) "/"
 .S MSG=$$V04(DA)
 .S MSGCNT=MSGCNT+1
 ;PATCH 2
 ;S ^BYIMTMP($J,"NUM")=MSGCNT_U_DFNCNT_U_IMMCNT
 S ^BYIMTMP("NUM")=MSGCNT_U_DFNCNT_U_IMMCNT
 S BYIMJOB=$J
 K ^BYIMTMP($J,"BYIM EXP")
 S XX=$P($H,",",2)-XX
ZIS S ZTRTN="HFSA^BYIMIMM"
 S ZTDESC="IMMUNIZATION DATA EXCHANGE"
 S ZTIO=""
 F X="BYIM*","DFN*","MSG*","IMM*" S ZTSAVE(X)=""
 S ZTDTC=$H
 D ^%ZTLOAD
 I $G(X)[U D  Q
 .W !!,"The export has been terminated."
 .D PAUSE
 .S BYIMQUIT=""
 .D RES1
OUT I '$D(ZTQUEUED) D
 .W !!?10,IMMCNT," immunizations for ",MSGCNT," ",CHILD," 0-",YEARS
 .W !?10,"were evaluated in "
 .N M,S
 .S M=XX\60
 .S S=XX#60
 .I M]"" W M," minutes"
 .I S]"" W ", ",S," seconds"
 .W "."
 .D PATH
 .I OPATH="" D NOPATH Q
 .S FILE="izdata"_(DT+17000000)_$S($G(BYIMTEST):"test",1:"")_"."_BYIMEXT
 .W !!?10,"The file '",FILE,"' will now be created in the"
 .W !?10,"'",OPATH,"' directory.  This may take several minutes."
 .W !!?10,"It can be retrieved from this directory for transfer"
 .W !?10,"to the State registry."
 .D PAUSE
 Q
 ;-----
HFSA ;EP;TO PROCESS EXPORT
 H 300
 S:'$G(BYIMTEST)&'$D(^BYIMPARA(DUZ(2),"LAST EXPORT",DT)) ^BYIMPARA(DUZ(2),"LAST EXPORT",DT)=$H
 N READY
 S READY=""
 D READY
 I $D(BYIMQUIT) K BYIMQUIT G HFSA
 S DEST=$O(^INRHD("B","HL IHS IZV04 FRAMEWORK",0))
 N PRI
 S PRI=+$O(^INLHDEST(DEST,""))
 ;PATCH 2
 ;S NUM=$G(^BYIMTMP(BYIMJOB,"NUM"))
 S NUM=$G(^BYIMTMP("NUM"))
 S DFNCNT=$P(NUM,U,2)
 S IMMCNT=$P(NUM,U,3)
 S NUM=+NUM
 N J,X,Y
 S J=0
 S X=""
 F  S X=$O(^INLHDEST(DEST,PRI,X)) Q:X=""  D
 .S Y=0
 .F  S Y=$O(^INLHDEST(DEST,PRI,X,Y)) Q:'Y  S J=J+1
 G:J<NUM HFSA
 D FOOTER
 H 30
 D PATH
 I OPATH="" D NOPATH Q
 S FILE="izdata"_(DT+17000000)_$S($G(BYIMTEST):"test",1:"")_"."_BYIMEXT
 ;PATCH 2
 ;D HFSA^BHLU(DEST,OPATH,FILE)
 D HFSA^BYIMIMM4(DEST,OPATH,FILE)
 S:'$G(BYIMTEST) $P(^BYIMPARA(DUZ(2),"LAST EXPORT",DT),U,2)=$H
 D LOG^BYIMIMM2(FILE,"E",DFNCNT,IMMCNT,,,,OPATH)
 ;PATCH 2
 ;K ^BYIMTMP(BYIMJOB,"NUM")
 K ^BYIMTMP("NUM")
 D ADDEX
 Q
 ;-----
READY ;EP;
 N X,Y,Z
 S X=""
 F  S X=$O(^INLHSCH(0,X)) Q:X=""!$D(BYIMQUIT)  D
 .S Y=0
 .F  S Y=$O(^INLHSCH(0,X,Y)) Q:'Y!$D(BYIMQUIT)  D
 ..S:$G(^INTHU(Y,3,1,0))["V04" BYIMQUIT=""
 I '$D(BYIMQUIT) D  Q
 .S DEST=$O(^INRHD("B","HL IHS IZV04 FRAMEWORK",0))
 .I '$D(READY),$D(^INLHDEST(+DEST)) D  Q
 ..W:'$D(ZTQUEUED) !!,"Immunization data file creation still in process."
 ..S WRITING=""
 ..H 4
 .Q:$D(ZTQUEUED)!$D(DE)
 .H 2
 .W !!,"The Immunization data export file is ready for transmission"
 .W !,"to the state immunization registry."
 .H 4
 Q:$D(ZTQUEUED)
 W !!,"Immunization data export still in process."
 S J=0
 S X=""
 F  S X=$O(^INLHSCH(0,X)) Q:X=""  D
 .S Y=0
 .F  S Y=$O(^INLHSCH(0,X,Y)) Q:'Y  D
 ..S:$G(^INTHU(Y,3,1,0))["V04" J=J+1
 W " (",J,")"
 H 2
 Q
 ;-----
PATH ;EP;SET PATH
 S OPATH=$P($G(^BYIMPARA(DUZ(2),0)),U,2)
 S IPATH=$P($G(^BYIMPARA(DUZ(2),0)),U,3)
 S BYIMEXT=$P($G(^BYIMPARA(DUZ(2),0)),U,8)
 S:BYIMEXT="" BYIMEXT="dat"
 Q
 ;-----
NOPATH ;EP;NO PATH MESSAGE
 I $D(ZTQUEUED) S BYIMQUIT="" Q
 W @IOF
 W !!,"You are logged into site: ",$P(^AUTTLOC(DUZ(2),0),U,2)
 W !!,"Directory path information was missing for the Immunization Data Exchange."
 W !,"Please contact your Site Manager.  There must be entries in the"
 W !!?10,"PATH FOR OUTNBOUND MESSAGES field and the"
 W !?10,"PATH FOR INBOUND MESSAGES field of the"
 W !?10,"IZ PARAMETERS file for ",$P(^AUTTLOC(DUZ(2),0),U,2)
 D PAUSE
 Q
 ;-----
V04(BYIMVST)        ;this is the unsolicited Imm record
 I 'BYIMVST Q $$MSG("VST")
 S BYIMPAT=$P($G(^AUPNVSIT(BYIMVST,0)),U,5)
 S INDA=BYIMPAT
 S INDA(9000010,1)=BYIMVST
 S INDA(2,1)=BYIMPAT
 D ^INHF("HL IHS IZV04 OUT PARENT",.INDA)
 D LOG(BYIMPAT)
 D EOJ
 Q $$MSG("INHF")
 ;-----
HEADER ;this is the header record
 S DEST=$O(^INRHD("B","HL IHS IZV04 FRAMEWORK",0))
 K ^INLHDEST(+DEST)
 D NOW^%DTC
 S INA("EVDT")=%
 S EVDT="INA(""EVDT"")"
 S INA("ENC")="^~\&"
 S ENC="INA(""ENC"")"
 S INA("FACILITY")=$P($G(^DIC(4,+$G(DUZ(2)),0)),U)
 S FACILITY="INA(""FACILITY"")"
 L +^INTHU(0):DTIME
 S INDA=$P(^INTHU(0),U,3)
 D ^INHF("HL IHS IZV04 OUT HEADER PARENT",.INDA,.INA)
 L -^INTHU(0)
 D EOJ
 Q
 ;-----
FOOTER ;this is the header record
 S INDA=$P(^INTHU(0),U,3)+1
 D ^INHF("HL IHS IZV04 OUT FOOTER PARENT",.INDA,.INA)
 D EOJ
 Q
 ;-----
EOJ ;kills variables
 K INDA,BYIMPAT,BYIMVST,BYIMVAIN,BYIMADT
 Q
 ;-----
MSG(BYIMMVAR)        ;-- return message defining status
 I BYIMMVAR="PAT" S BYIMRMSG="Patient Not Passed In, Message Not Created"
 I BYIMMVAR="VST" S BYIMRMSG="Visit Not Passed In, Message Not Created"
 I BYIMMVAR="VLAB" S BYIMRMSG="VLAB Not Passed In, Message Not Created"
 I BYIMMVAR="MFL" S BYIMRMSG="Mstr File Not Passed In, Message Not Created"
 I BYIMMVAR=0 S BYIMRMSG="Message Not Created, problem with GIS call"
 I BYIMMVAR S BYIMRMSG=BYIMMVAR_U_"Message Created Successfully"
 Q $G(BYIMRMSG)
 ;-----
IMZIS S ZTRTN="HFSA^BYIMIMM"
 S ZTDESC="IMMUNIZATION DATA EXCHANGE"
 S ZTIO=""
 S ZTSAVE("BYIMJOB")=""
 S ZTSAVE("BYIMTEST")=""
 S ZTDTC=$H
 D ^%ZTLOAD
 Q
 ;-----
STRIP(Z) ;REMOVE CONTROLL CHARACTERS
 N I
 F I=1:1:$L(Z) I (32>$A($E(Z,I))) S Z=$E(Z,1,I-1)_" "_$E(Z,I+1,999)
 Q Z
 ;-----
BACK S VALMBCK="R"
 Q
 ;-----
MPORT ;EP - run the import package utility
 I $O(^INXPORT(""))="" D  Q
 . W !,"Global ^INXPORT missing, please restore and the global."
 S BYIMIT=$O(^INXPORT(""))
 S BYIMIST=$O(^INXPORT(BYIMIT,""))
 S BYIMIPK=$O(^INXPORT(BYIMIT,BYIMIST,""))
 W !,"Importing GIS "_$G(BYIMIT)_" Supplement "_$G(BYIMIPK)
 W ", developing site "_$G(BYIMIST)
 D ^BYIMPORT
 W !,"Finished Importing GIS Supplement "
 K BYIMIT,BYIMIST,BYIMIPK
 Q
 ;-----
MENU ;EP;MENU DISPLAY
 W @IOF,!!
 N X
 S X="Immunization Data Exchange"
 W !?(80-$L(X))\2,X
 W !
 S X="VERSION "
 S X=X_$P($G(^DIC(9.4,+$O(^DIC(9.4,"C","BYIM",0)),"VERSION")),U)
 W !?(80-$L(X))\2,X
 Q
 ;-----
RESTART ;EP;
 S DIR(0)="YO"
 W !!,"Do you want to restart the export?"
 S DIR("B")="NO"
 D ^DIR
 K DIR
 I Y'=1 S BYIMQUIT="" Q
 D RES1
 D PATH
 I OPATH="" D NOPATH Q
 S FILE="izdata"_(DT+17000000)_$S($G(BYIMTEST):"test",1:"")_"."_BYIMEXT
 S Y=$$DEL^%ZISH(OPATH,FILE)
 Q
 ;-----
RES1 ;CLEAR OUT CURRENT EXPORT QUEUE
 S DEST=$O(^INRHD("B","HL IHS IZV04 FRAMEWORK",0))
 K ^INLHDEST(DEST)
 N X,Y,Z,BYIMQUIT
 S X=""
 F  S X=$O(^INLHSCH(0,X)) Q:X=""!$D(BYIMQUIT)  D
 .S Y=0
 .F  S Y=$O(^INLHSCH(0,X,Y)) Q:'Y!$D(BYIMQUIT)  D
 ..I $G(^INTHU(Y,3,1,0))["V04" K ^INLHSCH(0,X,Y)
 Q
 ;-----
LOG(DFN,TYPE) ;EP;LOG EACH IMMUNIZATION EXPORTED OR IMPORTED
 N IMM,X,Y,Z
 S:$G(TYPE)="" TYPE="E"
 S DFNCNT=$G(DFNCNT)+1
 S IMM=0
 F  S IMM=$O(^AUPNVIMM("AC",DFN,IMM)) Q:'IMM  D
 .K DIE,DIC,DINUM,DR,DA,DD,DO,DIK,DLAYGO
 .S DIC="^BYIMEXP("
 .S DIC(0)="L"
 .S DIC("DR")=".02////"_DT_";.03////"_IMM_";.04////"_TYPE
 .S X=DFN
 .D FILE^DICN
 .K DIE,DIC,DINUM,DR,DA,DD,DO,DIK,DLAYGO
 .S IMMCNT=$G(IMMCNT)+1
 Q
 ;-----
DATE19 ;SET AGE FOR EXPORT
 N Y
 S Y=$P($G(^BYIMPARA(DUZ(2),0)),U,6)
 S YEARS=$S('Y:19,Y=1:65,1:99)
 S CHILD=$S('Y:"Children",1:"Patients")
 S (AGE,AGE19)=19*10000
 S DATE19=DT-(19*10000)
 S AGE65=65*10000
 S DATE65=DT-(65*10000)
 S AGE99=99*10000
 S DATE99=DT-(99*10000)
 S D19=$S(YEARS=19:DATE19,YEARS=65:DATE65,1:DATE99)
 Q
 ;-----
ADDEX ;EP;TO PROCESS ADDITIONAL EXPORT SITES
 S BYIMDA=DUZ(2)
 S BYIMAS=0
 F  S BYIMAS=$O(^BYIMPARA(BYIMDA,3,BYIMAS)) Q:'BYIMAS  D
 .S X=^BYIMPARA(BYIMDA,3,BYIMAS,0)
 .S BYIMOUT=$P(X,U,2)
 .S Y=$$MV^%ZISH(OPATH,FILE,BYIMOUT,FILE)
 .D LOG^BYIMIMM2(FILE,"E",DFNCNT,IMMCNT,,,,BYIMOUT)
 Q
 ;-----
LE ;PROCESS SEQUENTIAL EXPORT
 S X1=D19
 S X2=-1
 D C^%DTC
 S D19=X-.99
 F  S D19=$O(^AUPNVSIT("APCIS",D19)) Q:'D19  D
 .S DA=0
 .F  S DA=$O(^AUPNVSIT("APCIS",D19,DA)) Q:'DA  D
 ..S X=$G(^AUPNVSIT(DA,0))
 ..Q:X=""
 ..S DFN=$P(X,U,5)
 ..Q:'DFN
 ..Q:$D(^BYIMTMP($J,"BYIM EXP",DFN))
 ..Q:$G(^DPT(DFN,.35))!'$O(^AUPNPAT(DFN,41,0))!'$G(^AUPNPAT(DFN,0))
 ..S X=$G(^DPT(DFN,0))
 ..Q:X=""
 ..Q:X["PATIENT,ERROR"!(X["ERROR,PATIENT")!(X["DEMO,PAT")
 ..Q:$P($G(^BIP(DFN,0)),U,24)=0
 ..I YEARS=19 Q:$P(X,U,3)<DATE19
 ..I YEARS=65 Q:$P(X,U,3)<DATE19&($P(X,U,3)>DATE65)
 ..S ^BYIMTMP($J,"BYIM EXP",DFN,DA)=""
 ..S ^TMPBYIM(DFN,DA)=""
 ..W:'$D(ZTQUEUED) "."
 D DEX
 S Y=2,DUZ(Y)=BYIMDUZ(2)
 Q
 ;-----
NLE ;PROCESS FIRST EXPORT
 F  S D19=$O(^DPT("ADOB",D19)) Q:'D19  D
 .S DFN=0
 .F  S DFN=$O(^DPT("ADOB",D19,DFN)) Q:'DFN  D
 ..Q:$G(^DPT(DFN,.35))!'$D(^AUPNPAT(DFN,41,+$G(^AUTTSITE(1,0)),0))!'$G(^AUPNPAT(DFN,0))
 ..S X=$G(^DPT(DFN,0))
 ..Q:X["PATIENT,ERROR"!(X["ERROR,PATIENT")!(X["DEMO,PAT")!($E(X,1,2)="ZZ")!$P(X,U,19)
 ..S X=$O(^AUPNVSIT("AC",DFN,9999999999),-1)
 ..Q:'X
 ..Q:'$G(^AUPNVSIT(X,0))
 ..Q:+^AUPNVSIT(X,0)<DATE
 ..Q:$O(^BYIMTMP($J,"BYIM EXP",DFN,0))
 ..S ^BYIMTMP($J,"BYIM EXP",DFN,X)=""
 ..W:'$D(ZTQUEUED) "."
 D DEX
 S Y=2,DUZ(Y)=BYIMDUZ(2)
 Q
 ;-----
D1 ;PROCESS WHEN DATE IDENTIFIED
 S Y=DATE
 X ^DD("DD")
 S DDATE=Y
 S Y=DT-AGE
 X ^DD("DD")
 S DD19=Y
 Q:$D(ZTQUEUED)
 W @IOF
 W !!,"The last Immunization export ran on: ",DDATE
 I YEARS=19 D
 .W !,"Children 18 and under were born after: ",DD19
 W !!,"This export will include: ",!
 I YEARS=19 D
 .W !?5,"Children 18 and under"
 I YEARS=65 D
 .W !?5,"Children 18 and under and"
 .W !?5,"Adults.. 65 and over"
 I YEARS=99 D
 .W !?5,"All patients"
 W !!,"who have had a visit since the last export."
 W !,"You can enter another date for the export."
 S DIR(0)="DO"
 S DIR("A")="Export Immunizations given since "_DDATE
 S DIR("B")=DDATE
 W !
 D ^DIR
 K DIR
 I 'Y S BYIMQUIT="" Q
 S (DATE,D19)=Y
 Q
 ;-----
PAUSE ;EP;FOR PAUSE READ
 W !
 K DIR
 S DIR(0)="E"
 S DIR("A")="Press <ENTER> to continue..."
 D ^DIR
 K DIR
 Q
