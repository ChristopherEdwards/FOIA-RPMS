BLSMAP ; IHS/CMI/LAB - MASTER LOINC MAPPER ; [ JUL 20, 2010  2:00 PM ]
 ;;5.2;IHS LABORATORY;**1015,1028**;NOV 01, 1997;Build 46
 ;
 ;This routine is a revised version of BLSMAP originally created for Patch 1015.  It has been modified extensively for Patch 1028.  
 ;
 ;Changes include:
 ;1. Translate UCUM pointer in File60 to its UCUM format prior to lookup in the Master File and report displayed after mapping.
 ;2. Map cosmic and non-CH subscripted tests to LOINC using newly created IHS LOINC field #999999902 in File 60. 
 ;3. Add OK flag for successful matches and mapping.
 ;4. Add ELOG tag to log failures in mapping and ILOG tag to log inactive tests NOT to map.
 ;5. Add LOINC check digit and C80 indicator(*) to post-mapping report.
 ;
EN ;EP
 ;[LR*5.2*1028;09/17/10;IHS/OIT/MPW]Added next 1 line to force UCUM conversion as prerequisite to mapping.
 I +$G(^XTMP("BLRUCUM","DONE"))=0 W !!,"UCUM CONVERSION MUST BE DONE FIRST!" H 2 Q
 ;go through all LAB 60 entries, site/specimen multiple and find 
 ;all tests without a loinc code and attempt to find it in BLSLMAST
 ;and set the LOINC Code into the LOINC field of the multiple
 W:$D(IOF) @IOF
 W !!,$$CTR($$LOC)
 W !!,$$CTR("AUTO-MAP LOINC CODES INTO THE LABORATORY TEST FILE")
 W !!,"This option is used to automatically map LOINC Codes from the IHS Master",!,"LOINC table to your Laboratory test file (file 60)."
 W !,"The test must match the master by Test name, Site/Specimen and Units.  If a ",!,"match is found in the master file, that loinc code is added to your test",!,"in the Laboratory test file"
 ;
LIST ;
 S BLSLIST=""
 W ! S DIR(0)="Y",DIR("A")="Would you like a report of all tests that were assigned a LOINC Code during this mapping process",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 S BLSLIST=Y
CONT ;
 W !!
 S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I 'Y D EXIT Q
 ;
ZIS ;
 S XBRP="PRINT^BLSMAP",XBRC="PROC^BLSMAP",XBRX="EXIT^BLSMAP",XBNS="BLS"
 D ^XBDBQUE
 D EXIT
 Q
EXIT ;
 D EN^XBVK("BLS")
 D ^XBFMK
 Q
 ;
PROC ;
 K ^XTMP("BLSMAP")
 S BLSCNT=0,BLSQUIT=""
 S BLSJ=$J,BLSH=$H
 S ^XTMP("BLSLIST",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"LOINC MAPPER LIST"
 K ^XTMP("BLSLIST",BLSJ,BLSH)
 W:'$D(ZTQUEUED) ".... mapping codes..."
 ;[LR*5.2*1028;08/13/10;IHS/OIT/MPW]Rewrote loop to go through File 60 directly
 ;[LR*5.2*1028;08/13/10;IHS/OIT/MPW]S BLSNAME="" F  S BLSNAME=$O(^LAB(60,"B",BLSNAME)) Q:BLSNAME=""  D
 ;[LR*5.2*1028;08/13/10;IHS/OIT/MPW]S BLSIEN=0 F  S BLSIEN=$O(^LAB(60,"B",BLSNAME,BLSIEN)) Q:BLSIEN'=+BLSIEN  D
 S BLSIEN=0 F  S BLSIEN=$O(^LAB(60,BLSIEN)) Q:BLSIEN'=+BLSIEN  D
 .S OK=0
 .S BLSNAME=$P(^LAB(60,BLSIEN,0),U,1) Q:BLSNAME=""
 .S BLSTYP=$P(^LAB(60,BLSIEN,0),U,3)
  .; Skip inactive tests
 .I $E(BLSNAME,1,2)="ZZ"!($E(BLSNAME,1,2)="zz") D ILOG Q
 .I $E(BLSNAME,1)="x" S BLSNAME=$E(BLSNAME,2,$L(BLSNAME)) ;remove 'x' from ref lab test name
 .I BLSNAME[" (R)" S BLSNAME=$P(BLSNAME," (R)",1)
 .S BLSUNAME=$$TRIMN(BLSNAME) Q:BLSUNAME=""
 .;if no specimen node (cosmic test), check for IHS LOINC, if not found, set default specimen for lookup
 .I $O(^LAB(60,BLSIEN,1,0))="" D
 ..I $P($G(^LAB(60,BLSIEN,9999999)),U,2)'="" S OK=1 Q
 ..S BLSSS="SPECXXX",BLSUNITS="UNITXXX"
 ..;check once with these values
 ..I $O(^BLSLMAST("AA",BLSUNAME,BLSSS,BLSUNITS,0)) S OK=1,BLSUP=2 D UPDATE Q
 ..;if no match try trimming all leading chars not number,alpha or %
 ..S BLSUNAME=$$TRIMN(BLSUNAME)
 ..Q:BLSUNAME=""
 ..I $O(^BLSLMAST("AA",BLSUNAME,BLSSS,BLSUNITS,0)) S OK=1,BLSUP=2 D UPDATE Q
 ..Q
 .;if specimen node exists, check each for LOINC
 .I $O(^LAB(60,BLSIEN,1,0))'="" S BLSSSIEN=0 F  S BLSSSIEN=$O(^LAB(60,BLSIEN,1,BLSSSIEN)) Q:BLSSSIEN'=+BLSSSIEN  D
 ..;[LR*5.2*1028;09/27/10;IHS/OIT/MPW]I $P($G(^LAB(60,BLSIEN,1,BLSSSIEN,95.3)),U)]"" Q  ;already has Loinc
 ..I $P($G(^LAB(60,BLSIEN,1,BLSSSIEN,95.3)),U)]"" S OK=1 Q  ;already has Loinc
 ..S BLSSS=$P(^LAB(60,BLSIEN,1,BLSSSIEN,0),U),BLSSS=$P(^LAB(61,BLSSSIEN,0),U),BLSSS=$$CLEAN(BLSSS)
 ..S BLSUNITS=$P(^LAB(60,BLSIEN,1,BLSSSIEN,0),U,7) I BLSUNITS="" S BLSUNITS="UNITXXX"
 ..;check once with these values
 ..I $O(^BLSLMAST("AA",BLSUNAME,BLSSS,BLSUNITS,0)) S (OK,BLSUP)=1 D UPDATE Q
 ..;if no match try trimming all leading chars not number,alpha or %
 ..S BLSUNAME=$$TRIMN(BLSUNAME)
 ..Q:BLSUNAME=""
 ..I $O(^BLSLMAST("AA",BLSUNAME,BLSSS,BLSUNITS,0)) S (OK,BLSUP)=1 D UPDATE Q
 ..;check one last time for BLSUNAME,BLSSS combo for any units
 ..S BLSUNITS=$O(^BLSLMAST("AA",BLSUNAME,BLSSS,""))
 ..I BLSUNITS'="",$O(^BLSLMAST("AA",BLSUNAME,BLSSS,BLSUNITS,0)) S (OK,BLSUP)=1 D UPDATE Q
 ..I 'OK D ELOG
 ..Q
 .Q
 Q
 ;
UPDATE ;
 S BLSL=$O(^BLSLMAST("AA",BLSUNAME,BLSSS,BLSUNITS,0))
 S BLSLOI=$P(^BLSLMAST(BLSL,0),U,5)
 Q:BLSLOI=""  ;no loinc
 D ^XBFMK K DIADD,DLAYGO
 W !,"Mapping loinc code ",BLSLOI," - ",$G(^LAB(95.3,BLSLOI,80))," to lab test ",BLSUNAME
 ;[LR*5.2*1028;08/30/10;IHS/OIT/MPW] Begin changes
 ;S DA(1)=BLSIEN,DA=BLSSSIEN,DIE="^LAB(60,"_BLSIEN_",1,",DR="95.3///"_BLSLOI D ^DIE
 I BLSUP=1 S DA(1)=BLSIEN,DA=BLSSSIEN,DIE="^LAB(60,"_BLSIEN_",1,",DR="95.3///^S X=BLSLOI" D ^DIE
 I BLSUP=2 S DA=BLSIEN,DIE="^LAB(60,",DR="999999902///^S X=BLSLOI" D ^DIE
 ;[LR*5.2*1028;08/30/10;IHS/OIT/MPW] End changes
 I $D(Y) Q
 S BLSCNT=BLSCNT+1
 Q:'BLSLIST
 S ^XTMP("BLSLIST",BLSJ,BLSH,"MAPPED",BLSIEN,BLSSSIEN)=""
 Q
 ;
ILOG ; Inactive tests - don't map
 S ^XTMP("BLSMAP","INACT",BLSIEN)=""
 S ^XTMP("BLSMAP","INACT")=+$G(^XTMP("BLSMAP","INACT"))
 Q
 ;
ELOG ; Log error - tests that don't map
 S ^XTMP("BLSMAP","ERR",BLSIEN,BLSSSIEN)=BLSUNAME_U_BLSSS_U_BLSUNITS
 S ^XTMP("BLSMAP","ERR")=+$G(^XTMP("BLSMAP","ERR"))
 Q
 ;
PRINT ;EP
 S BLSPG=0 D HEADER S BLSQUIT=""
 I '$D(^XTMP("BLSLIST",BLSJ,BLSH,"MAPPED")) W !!,"No Lab Tests were assigned LOINC Codes" D EOJ Q
 W !!,"Total number of tests assigned LOINC codes: ",BLSCNT,!
 S BLSIEN=0 F  S BLSIEN=$O(^XTMP("BLSLIST",BLSJ,BLSH,"MAPPED",BLSIEN)) Q:BLSIEN'=+BLSIEN!(BLSQUIT)  D
 .S BLSSSIEN=0 F  S BLSSSIEN=$O(^XTMP("BLSLIST",BLSJ,BLSH,"MAPPED",BLSIEN,BLSSSIEN)) Q:BLSSSIEN'=+BLSSSIEN!(BLSQUIT)  D
 ..I $Y>(IOSL-4) D HEADER Q:BLSQUIT
 ..;[LR*5.2*1028;08/30/10;IHS/OIT/MPW] Begin changes
 ..S BLSUNITS=$P(^LAB(60,BLSIEN,1,BLSSSIEN,0),U,7)
 ..S BLSL=$P($G(^LAB(60,BLSIEN,1,BLSSSIEN,95.3)),U),BLSLNC=BLSL_"-"_$P(^LAB(95.3,BLSL,0),U,15)
 ..;W !,$E($P(^LAB(60,BLSIEN,0),U),1,34),?35,$E($P(^LAB(61,BLSSSIEN,0),U),1,15),?52,$E($P(^LAB(60,BLSIEN,1,BLSSSIEN,0),U,7),1,15),?69,$P($G(^LAB(60,BLSIEN,1,BLSSSIEN,95.3)),U)
 ..W !,$E($P(^LAB(60,BLSIEN,0),U),1,34),?35,$E($P(^LAB(61,BLSSSIEN,0),U),1,15),?52,$E(BLSUNITS,1,15),?69,BLSLNC
 ..I $O(^BLSLMAST("C",BLSL,""))'="" S REC=$O(^BLSLMAST("C",BLSL,"")) W:$G(^BLSLMAST(REC,11))="C80" "*"
 ..Q:'BLSL
 ..W !?2,$P($G(^LAB(95.3,BLSL,80)),U)
 Q
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
HEADER I 'BLSPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BLSQUIT=1 Q
HEAD1 ;
 W:$D(IOF) @IOF S BLSPG=BLSPG+1
 W !
 W ?20,$$LOC,?72,"Page ",BLSPG,!
 W !,$$CTR("LOINC CODES ASSIGNED WITH AUTO MAPPER",80)
 W !,$$CTR("DATE: "_$$FMTE^XLFDT(DT),80)
 W !,$TR($J("",80)," ","-"),!
 Q
EOJ ;
 K ^XTMP("BLSLIST",BLSJ,BLSH)
 K BLSJ,BLSH
 D EOP
 Q
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR
 Q
 ;--------------------------------------------------------------------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;--------------------------------------------------------------------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;--------------------------------------------------------------------
 ;Trim Leading Spaces
TRIMLSPC(X) ;
 F  Q:$E(X,1)'=" "  S X=$E(X,2,$L(X))
 Q X
 ;--------------------------------------------------------------------
 ;Trim Trailing Spaces
TRIMTSPC(X) ;
 F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,$L(X)-1)
 Q X
 ;--------------------------------------------------------------------
 ;Trim Leading Slashes
TRIMLS(X) ;
 F  Q:$E(X,1)'="/"  S X=$E(X,2,$L(X))
 Q X
 ;--------------------------------------------------------------------
 ;Trim Trailing Colons
TRIMTC(X) ;
 F  Q:$E(X,$L(X))'=":"  S X=$E(X,1,$L(X)-1)
 Q X
 ;--------------------------------------------------------------------
 ;Trim All Leading Non-Alphanumeric Characters Except the "%" Sign
TRIMN(X) ;
 F  Q:$E(X,1)?1N!($E(X)?1U)!($E(X)?1"%")!($L(X)=0)  S X=$E(X,2,$L(X))
 Q X
 ;--------------------------------------------------------------------
 ;Trim All Leading and Trailing Spaces
TRIMALL(X) ;
 Q $$TRIMLSPC($$TRIMTSPC(X))
 ;--------------------------------------------------------------------
 ;Convert lowercase to uppercase
UCASE(X) ;
 Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 ;--------------------------------------------------------------------
 ;Trim All Leading and Trailing Spaces and Convert from Lowercase to Uppercase
CLEAN(X) ;
 Q $$UCASE($$TRIMALL(X))
 ;--------------------------------------------------------------------
