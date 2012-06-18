AGSSSMR2 ;IHS/ASDS/SDH - SSA/SSN Matching Report  ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 ;Changed all references of ^AGSSTEMP to ^AGSSTMP1
 ;
 ;This routine does NOT process records from SSA.  This report
 ;simply goes through file, sorting by verification code in the
 ;file and generates a report.  This routine does the output.  See
 ;AGSSSMR1 for loading of data in global.
 ;
S ;EP - START
 N AGSSPICK
 S AGSSFLAG=0
 N AGCOUNT,AGSSPG
 S AGSSPG=1
 D HOME^%ZIS
 S AGSSUFAC=$P(^AUTTLOC(AGSSITE,0),"^",10)
 S DIR("A")="Output to printer or file? "
 S DIR("B")="printer"
 S DIR("?")="File will be delimited for Excel or Access; Printer will be to screen/device"
 S DIR(0)="S^P:PRINTER;F:FILE"
 D ^DIR S AGSSPICK=Y
 I AGSSPICK["^" S AGQUIT=1
 I AGSSPICK["F" D OUTFILE
 I AGSSPICK["P" D OUTFILE2
 D EXIT
 Q
QUE ;que to taskman
 S ZTRTN="PROC^AZHTAGSS"
 S ZTDESC="SSN Matching Report"
 S ZTIO=ION_";"_IOST_";"_IOM_";"_IOSL
 S ZTSAVE("AGSS*")=""
 G OUTFILE2
 Q
OUTFILE ;setup for printing to file
 S AGEXT=+$G(^AGSSTMP1("REPORT#"))
 I AGEXT=0 S ^AGSSTMP1("REPORT#")=1,AGEXT=1
 E  S ^AGSSTMP1("REPORT#")=AGEXT+1
 S AGSSHFL2="ss"_AGSSUFAC_"_"_$G(AGEXT)_".txt"
 W !!,"Output File: ",AGSSHFL2,!
 S DIR(0)="F"
 S DIR("A")="Enter directory for file:  "
 S DIR("B")="/usr/spool/uucppublic/"
 D ^DIR S AGSSP2=Y
 Q:AGSSP2["^"
 I "\/"'[$E(AGSSP2) D
 .S:^%ZOSF("OS")["UNIX" AGSSP2="/"_AGSSP2 Q
 .S AGSSP2="\"_AGSSP2
 I "\/"'[$E(AGSSP2,$L(AGSSP2)) D
 .S:^%ZOSF("OS")["UNIX" AGSSP2=AGSSP2_"/" Q
 .S AGSSP2=AGSSP2_"\"
 U 0 W !,"WRITING FILE...."
 D OPEN^%ZISH("SSNFILE",AGSSP2,AGSSHFL2,"W")
 U IO
 D PRINT
 D CLOSE^%ZISH("SSNFILE")
 Q
OUTFILE2 ;setup for output to device
 N IO
 S ZTRTN="PRINT2^AGSSSMR2"
 S ZTDESC="SSN Matching Report"
 S ZTSAVE("AGSS*")=""
 S %ZIS="Q"
 D ^%ZIS
 Q:POP
 I $D(IO("Q")) D  Q
 .K IO("Q")
 .S ZTIO=ION_";"_IOST_";"_IOM_";"_IOSL
 .D ^%ZTLOAD
 .W !,"TASK #",$G(ZTSK)," QUEUED"
 E  D @ZTRTN
 Q
PROC ;start processing
 K AGSSCNT
PRINT ;prints to comma-delimited file
 S AGSSHDR="Report for SSA SSN Matching Application" D AGSSHDR
 I $D(AGSS("NORUN")) W !,"NO RUN SET SO ... NO REPORT",! Q
 W !,"Total Records in file from NPIRS/SSA",?40,$G(^AGSSTMP1(AGSSITE,0,"COUNTS","TOT")),?55,"for "_$S($P($G(^AUTTLOC(AGSSITE,0)),U,2)'="":$P(^AUTTLOC(AGSSITE,0),U,2),1:"ASUFAC#"_AGSSITE)
 S (AGSSBGT,%H)=$G(^AGSSTMP1(AGSSITE,0,"BEGIN-TIME")) D YX^%DTC
 W !,"Starting Time",?40,Y
 S (AGSSFNT,%H)=$G(^AGSSTMP1(AGSSITE,0,"END-DELTRAN")) D YX^%DTC
 W !,"Ending Time",?40,Y
 S AGSSDAY=(AGSSFNT/1)-(AGSSBGT/1)*24*60*60,AGSSSEC=AGSSDAY+($P(AGSSFNT,",",2))-($P(AGSSBGT,",",2)),AGSSMIN=AGSSSEC\60
 I AGSSMIN<1 S AGSSMIN=1
 W !,"Processing Time",?50,AGSSMIN,"  minutes"
 S T="^"
 S AGSSC=""
 S (AGSSUFAC,AGSSCVC,AGSSHRN)=""
 F  S AGSSUFAC=$O(^AGSSTMP1(AGSSITE,"RECS",AGSSUFAC)) Q:AGSSUFAC=""  D
 .F  S AGSSCVC=$O(^AGSSTMP1(AGSSITE,"RECS",AGSSUFAC,AGSSCVC)) Q:AGSSCVC=""  D
 ..Q:AGSSCVC="TOT"
 ..Q:($G(AGACCTS))'[AGSSCVC
 ..D VCHDR
 ..F  S AGSSHRN=$O(^AGSSTMP1(AGSSITE,"RECS",AGSSUFAC,AGSSCVC,AGSSHRN)) Q:AGSSHRN=""  D
 ...F  S AGSSC=$O(^AGSSTMP1(AGSSITE,"RECS",AGSSUFAC,AGSSCVC,AGSSHRN,AGSSC)) Q:AGSSC=""  D
 ....S AGSSREC=$G(^AGSSTMP1(AGSSITE,"RECS",AGSSUFAC,AGSSCVC,AGSSHRN,AGSSC))
 ....S AGSS1SSN=$P(AGSSREC,U,3)
 ....S AGSSLN=$P(AGSSREC,U,4)
 ....S AGSSFN=$P(AGSSREC,U,5)
 ....S AGSSMN=$P(AGSSREC,U,6)
 ....S AGSSDOB=$P(AGSSREC,U,7)
 ....S AGSSDOB=$E(AGSSDOB,5,6)_"/"_$E(AGSSDOB,7,8)_"/"_$E(AGSSDOB,1,4)
 ....S AGSSSEX=$P(AGSSREC,U,8)
 ....U IO W !,AGSS1SSN_T_AGSSLN_T_AGSSFN_T_AGSSMN_T_AGSSDOB_T_AGSSSEX_T_AGSSCVC_T_AGSSHRN
 Q
PRINT2 ;prints to device
 S (AGSSUFAC,AGSSCVC,AGSSHRN)=""
 S AGSSC=""
 S AGSSHDR="Report for SSA SSN Matching Application" D AGSSHDR
 I $D(AGSS("NORUN")) W !,"NO RUN SET SO ... NO REPORT",! Q
 U IO W !,"Total Records in file from NPIRS/SSA",?40,$G(^AGSSTMP1(AGSSITE,0,"COUNTS","TOT")),?55,"for "_$S($P($G(^AUTTLOC(AGSSITE,0)),U,2)'="":$P(^AUTTLOC(AGSSITE,0),U,2),1:"ASUFAC#"_AGSSITE)
 S (AGSSBGT,%H)=$G(^AGSSTMP1(AGSSITE,0,"BEGIN-TIME")) D YX^%DTC
 W !,"Starting Time",?40,Y
 S (AGSSFNT,%H)=$G(^AGSSTMP1(AGSSITE,0,"END-DELTRAN")) D YX^%DTC
 U IO W !,"Ending Time",?40,Y
 S AGSSDAY=(AGSSFNT/1)-(AGSSBGT/1)*24*60*60,AGSSSEC=AGSSDAY+($P(AGSSFNT,",",2))-($P(AGSSBGT,",",2)),AGSSMIN=AGSSSEC\60
 I AGSSMIN<1 S AGSSMIN=1
 U IO W !,"Processing Time",?50,AGSSMIN,"  minutes"
 S AGCOUNT=AGCOUNT+4
 S AGSSFLAG=1
 F  S AGSSUFAC=$O(^AGSSTMP1(AGSSITE,"RECS",AGSSUFAC)) Q:AGSSUFAC=""  D  Q:X["^"
 .F  S AGSSCVC=$O(^AGSSTMP1(AGSSITE,"RECS",AGSSUFAC,AGSSCVC)) Q:AGSSCVC=""  D  Q:X["^"
 ..Q:AGSSCVC="TOT"
 ..Q:($G(AGACCTS))'[AGSSCVC
 ..D VCHDR
 ..F  S AGSSHRN=$O(^AGSSTMP1(AGSSITE,"RECS",AGSSUFAC,AGSSCVC,AGSSHRN)) Q:AGSSHRN=""  D  Q:X["^"
 ...F  S AGSSC=$O(^AGSSTMP1(AGSSITE,"RECS",AGSSUFAC,AGSSCVC,AGSSHRN,AGSSC)) Q:AGSSC=""  D  Q:X["^"
 ....S AGSSREC=$G(^AGSSTMP1(AGSSITE,"RECS",AGSSUFAC,AGSSCVC,AGSSHRN,AGSSC))
 ....S AGSS1SSN=$P(AGSSREC,U,3)
 ....S AGSSLN=$P(AGSSREC,U,4)
 ....S AGSSFN=$P(AGSSREC,U,5)
 ....S AGSSMN=$P(AGSSREC,U,6)
 ....S AGSSDOB=$P(AGSSREC,U,7)
 ....S AGSSDOB=$E(AGSSDOB,5,6)_"/"_$E(AGSSDOB,7,8)_"/"_$E(AGSSDOB,1,4)
 ....S AGSSSEX=$P(AGSSREC,U,8)
 ....U IO W !,?2,AGSS1SSN,?13,AGSSLN,?28,AGSSFN,?39,AGSSMN,?51,AGSSDOB,?64,AGSSSEX,?68,AGSSCVC,?71,AGSSHRN
 ....S AGCOUNT=$G(AGCOUNT)+1
 ....I $G(IOST)["C",(AGCOUNT>IOSL) D
 .....I '$D(ZTQUEUED) U 0 K DIR S DIR(0)="E" D ^DIR K DIR
 .....Q:X["^"
 .....D AGSSHDR,COLHDR
 ....E  D
 .....I AGCOUNT>IOSL D AGSSHDR,COLHDR
 I '$D(ZTQUEUED),(X'["^") U 0 K DIR S DIR(0)="E" D ^DIR K DIR
 W !!!,"*** END OF REPORT ***"
 S DIR(0)="E"
 S DIR("A")="ENTER RETURN TO CONTINUE"
 D ^DIR K DIR
 I $G(IOST)'["C" D CLOSE^%ZISH("SSNFILE")
 Q
VCHDR ;header for each error code
 U IO W !,"          ============================================================"
 I AGSSCVC="V" D
 .U IO W !!,?3,"VC=V:  VERIFIED SSNs - ",^AGSSTMP1(AGSSITE,0,"COUNTS",AGSSCVC)," Records",!
 I AGSSCVC="1" D
 .U IO W !!,?3,"VC=1:  SSNs not in file",!,?5,"(impossible number/never issued to anyone/no SSN) - "_^AGSSTMP1(AGSSITE,0,"COUNTS",AGSSCVC)_" Records"
 I AGSSCVC="2" D
 .U IO W !!,?3,"VC=2:  Name and DOB match, sex code doesn't - "_^AGSSTMP1(AGSSITE,0,"COUNTS",AGSSCVC)_" Records",!
 I AGSSCVC="3" D
 .U IO W !!,?3,"VC=3:  Name and sex match, DOB doesn't - "_^AGSSTMP1(AGSSITE,0,"COUNTS",AGSSCVC)_" Records",!
 I AGSSCVC="4" D
 .U IO W !!,?3,"VC=4:  Name matches, sex and DOB don't - "_^AGSSTMP1(AGSSITE,0,"COUNTS",AGSSCVC)_" Records",!
 I AGSSCVC="5" D
 .U IO W !!,?3,"VC=5:  Name doesn't match, DOB and sex not checked - "_^AGSSTMP1(AGSSITE,0,"COUNTS",AGSSCVC)_" Records",!
 I AGSSCVC="*" D
 .U IO W !!,?3,"VC=*:  SSN not verified;",!,?5,"SSA located different SSN based on name/DOB- "_^AGSSTMP1(AGSSITE,0,"COUNTS",AGSSCVC)_" Records"
 I AGSSCVC="A" D
 .U IO W !!,?3,"VC=A:  SSN not verified;",!,?5,"SSA found different SSN matched on Name/DOB - "_^AGSSTMP1(AGSSITE,0,"COUNTS",AGSSCVC)_" Records"
 I AGSSCVC="B" D
 .U IO W !!,?3,"VC=B:  SSN not verified",!,?35,"SSA found different SSN matching on name only - "_^AGSSTMP1(AGSSITE,0,"COUNTS",AGSSCVC)_" Records"
 I AGSSCVC="C" D
 .U IO W !!,?3,"VC=C:  SSN not verified;",!,?5,"Multiple SSNs found matching on name/DOB - "_^AGSSTMP1(AGSSITE,0,"COUNTS",AGSSCVC)_" Records"
 I AGSSCVC="D" D
 .U IO W !!,?3,"VC=D:  SSN not verified;",!,?5,"Multiple SSNs found matching on name only - "_^AGSSTMP1(AGSSITE,0,"COUNTS",AGSSCVC)_" Records"
 I AGSSCVC="E" D
 .U IO W !!,?3,"VC=E:  SSN not verified;",!,?5,"SSA found multiple matches for SSN - "_^AGSSTMP1(AGSSITE,0,"COUNTS",AGSSCVC)_" Records"
 D COLHDR
 S AGCOUNT=AGCOUNT+4
 Q
COLHDR ;
 I AGSSPICK["F" U IO W !!,"SSN"_T_"Last Name"_T_"First Name"_T_"Middle Name"_T_"DOB"_T_"Sex"_T_"VC"_T_"HRN"
 I AGSSPICK["P" U IO W !!,?2,"SSN",?13,"Last Name",?28,"First Name",?39,"Middle Name",?51,"DOB",?64,"Sex",?68,"VC",?71,"HRN"
 S AGCOUNT=$G(AGCOUNT)+2
 Q
EXIT D ^%ZISC
 K AGSSHFL,AGSSQ,AGSSREC,AGSSVC,AGSSHRN,AGSSDOB,AGSSSEX
 K AGHDDR,AGSBGTM,AGSCREC,AGSITE,AGSS1SSN,AGSS2SSN,AGSSBGT,AGSSC
 K AGSSCNT,AGSSCVC,AGSSDAY,AGSSFIO,AGSSFN,AGSSFNT,AGSSLN,AGSSMIN
 K AGSSMN,AGSSPATH,AGSSRTOT,AGSSSEC,AGSSUFAC,AGSSPICK
 K AG,AGK
 Q
AGSSPG ;EP - PAGE HANDLER
 Q:($Y<(IOSL-4))!($G(DOUT)!$G(DFOUT))  S:'$D(AGSSPG) AGSSPG=0 S AGSSPG=AGSSPG+1 I $E(IOST)="C" R !,"^ to quit ",X:DTIME I $E(X)="^" S DOUT=1,DFOUT=1,AGCOUNT=AGCOUNT+1 Q
AGSSHDR ;EP - PAGE HEADER HANDLER
 I AGSSPG'=1 U IO W !!
 U IO W ! Q:'$D(AGSSHDR)  S:'$D(AGSSLINE) $P(AGSSLINE,"-",IOM-2)="" S:'$D(AGSSPG) AGSSPG=1 I '$D(AGSSDT) D DT^DICRW S Y=DT D DD^%DT S AGSSDT=Y
 W ?(IOM-20-$L(AGSSHDR)/2),AGSSHDR,?(IOM-25),AGSSDT,?(IOM-10),"PAGE: ",AGSSPG,!,AGSSLINE
 I AGSSPG'=1 S AGCOUNT=3    ;5
 E  S AGCOUNT=3
 S AGSSPG=AGSSPG+1
EAGSSPG Q
STOP ;EP - to stop background processing
 S ^AGSSTMP1(AGSSITE,0,"STOP")=1
 Q
