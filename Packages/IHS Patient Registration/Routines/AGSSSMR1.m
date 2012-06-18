AGSSSMR1 ;IHS/ASDS/SDH - SSA/SSN Matching Report  ;  
 ;;7.1;PATIENT REGISTRATION;**4**;AUG 25,2005
 ;
 ;Changed all references to ^AGSSTEMP to ^AGSSTMP1
 ;
 ;This routine does NOT process records from SSA.  This report
 ;simply goes through file, sorting by verification code in the
 ;file and generates a report.  This routine does the first part,
 ;loading the global into a temp global.  See AGSSSMR2 for output.
 ;
S ;EP - START
 N AGACCTS
 N DIR
 S AGQUIT=""
 S DIC="^AUTTLOC("
 S DIC(0)="AEMQ"
 S DIC("A")="Process Site: "
 S DIC("B")=$P(^DIC(4,DUZ(2),0),"^",1)
 D ^DIC K DIC
 Q:Y<0
 I $D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT) K DTOUT,DUOUT,DIRUT,DIROUT,YQ
 S AGSSITE=+Y
SELECT ;
 W !?5,"V   Verified SSNs"
 W !?5,"1   SSNs not in file"
 W !?5,"2   Name and DOB match,sex code doesn't"
 W !?5,"3   Name and sex match, DOB doesn't"
 W !?5,"4   Name matches, sex and DOB don't"
 W !?5,"5   Name doesn't match,DOB and sex not checked"
 W !?5,"*   Not verified,SSA located different SSN based on name/DOB"
 W !?5,"A   Not verified,SSA found different SSN matching on name only"
 W !?5,"B   Not verified,SSA found different SSN matching on name/DOB"
 W !?5,"C   Not verified,Multiple SSNs found matching on name/DOB"
 W !?5,"D   Not verified,Multiple SSNs found matching on name only"
 W !?5,"E   Not verified,SSA found multiple matches for SSN"
 W !?5,"F   All error codes EXCEPT Verified"
 W !?5,"G   Complete report of ALL codes"
 W !!?5,"Enter the list of codes you desire to print"
 W !?5,"Example:  312*BD",!
 S DIR("A")="Enter all error codes you wish to see on report"
 S DIR(0)="FO^0:10"
 D ^DIR K DIR
 Q:Y=""
 I Y[","!(Y["-") W !,"Do not separate codes with commas or hyphens!" H 2 G SELECT
 Q:$D(DUOUT)!$D(DTOUT)!$D(DIRUT)!$D(DIROUT)
 S Y=$$UPPER^AGUTILS(Y)
 I $G(AGACCTS)'[Y S AGACCTS=$G(AGACCTS)_Y
 Q:$G(Y)=""&($G(AGACCTS)="")
 K Y
 Q:$D(DUOUT)
 ;write what options were selected
 W !!!,"Report will be written for the following codes:",!
 F A=1:1:$L(AGACCTS) D
 .S AGACCT=$E(AGACCTS,A)
 .I AGACCT="V" S AGTXT="Verified SSNs"
 .I AGACCT="1" S AGTXT="SSNs not in file"
 .I AGACCT="2" S AGTXT="Name and DOB match,sex code doesn't"
 .I AGACCT="3" S AGTXT="Name and sex match, DOB doesn't"
 .I AGACCT="4" S AGTXT="Name matches, sex and DOB don't"
 .I AGACCT="5" S AGTXT="Name doesn't match,DOB and sex not checked"
 .I AGACCT="*" S AGTXT="SSA located different SSN based on name/DOB"
 .I AGACCT="A" S AGTXT="SSA found different SSN matching on name only"
 .I AGACCT="B" S AGTXT="SSA found different SSN matching on name/DOB"
 .I AGACCT="C" S AGTXT="Multiple SSNs found matching on name/DOB"
 .I AGACCT="D" S AGTXT="Multiple SSNs found matching on name only"
 .I AGACCT="E" S AGTXT="SSA found multiple matches for SSN"
 .I AGACCT="F" S AGTXT="All error codes EXCEPT Verified"
 .I AGACCT="G" S AGTXT="Complete report of ALL codes"
 .I U_"V"_U_"1"_U_"2"_U_"3"_U_"4"_U_"5"_U_"*"_"A"_U_"B"_U_"C"_U_"D"_U_"E"_U_"F"_U_"G"'[(U_AGACCT_U) S AGTXT="Removing improper code..." S AGACCTS=$TR(AGACCTS,AGACCT,"")  ;IHS/SD/TPF 6/9/2008 IM29247
 .W !,?5,AGACCT,?10,AGTXT
 I AGACCTS="" H 3 G SELECT  ;IHS/SD/TPF 6/9/2008 IM29247
 ;I "FG"'[$G(AGACCTS) D
 I "FG"'[$G(AGACCTS) D  G:Y=1 SELECT  ;IHS/SD/TPF 6/9/2008 IM29247
 .S DIR("A")="Do you want to enter more error codes?"
 .S DIR(0)="Y"
 .D ^DIR K DIR
 .;I Y=1 K DTOUT D SELECT Q  ;IHS/SD/TPF 6/9/2008 AG*7.1*4 IM29247
 I $D(DUOUT) S AGQUIT=1 Q
 I $G(AGQUIT)=1 K AGQUIT Q
 I AGACCTS["F" S AGACCTS="12345*ABCDE"
 I AGACCTS["G" S AGACCTS="12345*ABCDEV"
 S AGQUIT=0
 K Y
 I $D(^AGSSTMP1(AGSSITE)) D  Q:'Y!(AGQUIT=1)
 .S DIR(0)="Y"
 .S DIR("A")="Scratch global ^AGSSTMP1 exists for this site. Kill"
 .S DIR("B")="N"
 .D ^DIR K DIR
 .I Y["^" S AGQUIT=1 Q
 .I Y=0 D ^AGSSSMR2 S AGQUIT=1 Q
 .K ^AGSSTMP1(AGSSITE)
 I 'AGQUIT D
 .S AGSSUFAC=$P(^AUTTLOC(AGSSITE,0),"^",10)
 .S AGSSHFL="ss"_AGSSUFAC_".ssn"
 .W !!,"Processing Host File: ",AGSSHFL,!
 .S DIR(0)="F"
 .S DIR("A")="Enter Directory Containing Above Host File"
 .S DIR("B")="/usr/spool/uucppublic"
 .D ^DIR K DIR S AGSSPATH=Y
 .Q:AGSSPATH["^"
 .I "\/"'[$E(AGSSPATH) D
 ..S:^%ZOSF("OS")["UNIX" AGSSPATH="/"_AGSSPATH Q
 ..S AGSSPATH="\"_AGSSPATH
 .I "\/"'[$E(AGSSPATH,$L(AGSSPATH)) D
 ..S:^%ZOSF("OS")["UNIX" AGSSPATH=AGSSPATH_"/" Q
 ..S AGSSPATH=AGSSPATH_"\"
 .D PROC
 D EXIT
 Q
PROC ;start processing
 K AGSSCNT
 U 0 W !,"READING INPUT FILE...."
BY ;bypass
 D OPEN^%ZISH("SSNFILE",AGSSPATH,AGSSHFL,"R")
 I POP D  Q
 .S ^AGSSTMP1(AGSSITE,0,"NOPEN")=1
 .I '$D(ZTQUEUED) W !!,*7,"Could not open file.",!
 S AGSSFIO=IO
PROCESS ;>PROCESS RECORDS
 K ^AGSSTMP1(AGSSITE,0,"STOP") ;external flag for stopping
HEADER ;initialize and retrieve number of records to process
 S AGSITE=$P(^AUTTSITE(1,0),"^")
 S ^AGSSTMP1(AGSSITE,0,"1ST-BEGIN-TIME")=$G(^AGSSTMP1(AGSSITE,0,"BEGIN-TIME"))
 S ^AGSSTMP1(AGSSITE,0,"1ST-LAST-RECORD")=$G(^AGSSTMP1(AGSSITE,0,"LAST-RECORD"))
 S AGSBGTM=$H,^AGSSTMP1(AGSSITE,0,"BEGIN-TIME")=$H
 S AGSSC=+$G(^AGSSTMP1(AGSSITE,0,"LAST-RECORD"))
 I $D(AGSS("NORUN")) G EXIT ;skip processing (SET MANUALLY) BEFORE STARTING
LOOP ;loop through host file
 S AGSSCNT("TOT")=1
 F  D  Q:$$STATUS^%ZISH!($D(^AGSSTMP1(AGSSITE,0,"STOP")))
 .U AGSSFIO R AGSCREC Q:$$STATUS^%ZISH
 .Q:AGSCREC=""
 .Q:$D(^AGSSTMP1(AGSSITE,0,"STOP"))
 .Q:AGSSC<$G(^AGSSTMP1(AGSSITE,0,"LAST-RECORD"))
 .S ^AGSSTMP1(AGSSITE,0,"LAST-RECORD")=AGSSC
 .S ^AGSSTMP1(AGSSITE,0,"CURRENT-TIME")=$H
 .Q:$D(ZTQUEUED)
 .S AGSSCVC=$P(AGSCREC,U,9)
 .S AGSSHRN=$P(AGSCREC,U,2)
 .S AGSSUFAC=$P(AGSCREC,U)
 .S ^AGSSTMP1(AGSSITE,"RECS",AGSSUFAC,AGSSCVC,AGSSHRN,AGSSCNT("TOT"))=AGSCREC
 .S AGSSCNT("TOT")=+$G(AGSSCNT("TOT"))+1
 .S AGSSCNT(AGSSCVC)=+$G(AGSSCNT(AGSSCVC))+1
 S ^AGSSTMP1(AGSSITE,0,"END-PROCESS")=$H
 S ^AGSSTMP1(AGSSITE,0,"END-DELTRAN")=$H
 S AGSSCVC=""
 F  S AGSSCVC=$O(AGSSCNT(AGSSCVC)) Q:AGSSCVC=""  D
 .I AGSSCVC["TOT" S AGSSCNT(AGSSCVC)=AGSSCNT(AGSSCVC)-1
 .S ^AGSSTMP1(AGSSITE,0,"COUNTS",AGSSCVC)=$G(AGSSCNT(AGSSCVC))
 S:$D(ZTQUEUED) XBFQ=1
 D ^%ZISC  ;IHS/SD/TPF 6/9/2008 AG*7.1*4  IM29060
 D ^AGSSSMR2
 D EXIT
 Q
EXIT ;
 D ^%ZISC
 K AGSSHFL,AGSSQ,AGSSREC,AGSSVC,AGSSHRN,AGSSDOB,AGSSSEX
 K AGHDDR,AGSBGTM,AGSCREC,AGSITE,AGSS1SSN,AGSS2SSN,AGSSBGT,AGSSC
 K AGSSCNT,AGSSCVC,AGSSDAY,AGSSFIO,AGSSFN,AGSSFNT,AGSSLN,AGSSMIN
 K AGSSMN,AGSSPATH,AGSSRTOT,AGSSSEC,AGSSUFAC,AGSSPICK
 K Y,DIRUT,DIROUT,DTOUT,DUOUT
 S AGK="AG" F  S AGK=$O(@AGK) Q:((AGK="")!($E(AGK,1,2)'="AG"))  I AGK'="AGK" K @AGK
 K AG,AGK
 Q
STOP ;EP - to stop background processing
 S ^AGSSTMP1(AGSSITE,0,"STOP")=1
 Q
