DG53244T ;BPOIFO/KEITH - NAME STANDARDIZATION ; 27 Jan 2002 11:05 PM
 ;;5.3;Registration;**244**;Aug 13, 1993
 ;
PRINT ;Print name conversion report
 ;
 N DGFLAG,DGPDT,DGOUT,DTOUT,DUOUT
 N DIR,DGEND,DGFMT,DGFLD,DGEXC,DGI,DGT0
 D TITL^DG53244V("Patient Name Standardization Report") S (DGEND,DGOUT)=0
 S DGT0=$D(^XTMP("DPTNAME",0)),DGPDT=$G(^XTMP("DPTNAME",0,0))
 I 'DGT0 D
 .W !!,"The patient name conversion report global has not been created.  A report"
 .W !,"global will be generated which can be reprinted later."
 .S DGFLAG="K",DGFLAG("K")="Kill the global and regenerate"
 .Q
 I DGT0 D
 .I DGPDT D
 ..W !!,"Name conversion processing started on ",$$FMTE^XLFDT(+DGPDT) W:'$P(DGPDT,U,2) " but has not completed."
 ..W:$P(DGPDT,U,2) " and completed ",!,$$FMTE^XLFDT($P(DGPDT,U,2)),"."
 ..S DGFLAG="U",DGFLAG("U")="Use the existing report global"
 ..Q
 .I 'DGPDT D
 ..W !!,"Name conversion processing doesn't appear to have been performed."
 ..D SUBT^DG53244V("*** Report Generation Action ***")
 ..W !!,"A name conversion report global already exists, you may use it or regenerate",!,"the information.",!
 ..K DIR
 ..S DIR(0)="S^U:Use the existing report global;K:Kill the global and regenerate"
 ..S DIR("A")="Report generation action"
 ..D ^DIR I $D(DTOUT)!$D(DUOUT) S DGOUT=1 Q
 ..S DGFLAG=Y,DGFLAG(Y)=Y(0)
 ..Q
 .Q
 G:DGOUT Q
 D SUBT^DG53244V("*** Report Output Format ***")
 K DIR
 S DIR(0)="S^S:Statistics only;D:Detailed report",DIR("A")="Report format",DIR("?")="Specify if the report should return a list of name exceptions or statistics only."
 D ^DIR I $D(DTOUT)!$D(DUOUT) G Q
 S DGFMT=Y,DGFMT(DGFMT)=Y(0) G:DGFMT="S" QUEUE
 D SUBT^DG53244V("*** Conversion Fields to Include ***")
 W !!,"The name conversion ",$S(DGPDT:"has changed",1:"will change")," data in eleven different PATIENT file fields.",!,"Please specify which of these fields to return on the report."
FLDS ;Get fields to report
 K DIR
 S DIR(0)="SO^A:All fields;.01:Patient name;.211:K Name;.2191:K2 Name;.2401:Father's name;.2402:Mother's name;.2403:Mother's maiden name;.331:E Name;.3311:E2 Name;.341:D Name;2.01:Alias;2.101:Attorney's Name"
 S DIR("A")="Select field to include",DGFLD="",DIR("B")="All fields"
 F  D  Q:DGOUT!DGEND
 .D ^DIR I $D(DTOUT)!$D(DUOUT) S DGOUT=1 Q
 .I X="" S DGEND=1 Q
 .S DIR("A")="Select another field to include" K DIR("B")
 .I Y="A" K DGFLD S DGFLD="A",DGFLD(Y)=Y(0),DGEND=1 Q
 .S DGFLD(Y)=Y(0) N DGX
 .S DGX=";"_Y_":"_Y(0),DIR(0)=$P(DIR(0),DGX)_$P(DIR(0),DGX,2)
 .Q
 G:DGOUT Q
 I $D(DGFLD)<10 W !!,$C(7),"At least one selection is required!",! G FLDS
 D SUBT^DG53244V("*** Name Exceptions to Include ***")
 W !!,"This report groups name exceptions by the categories listed below.  Of these"
 W !,"types, the first three are considered important to review.  Names with no comma"
 W !,"may not be parsed correctly by Kernel name standardization utilities.  Names"
 W !,"with parenthetical text, e.g. ""(INELIGIBLE)"" may require clean up prior to"
 W !,"conversion.  Names that cannot be converted should be corrected or deleted."
 W !!,"The fourth category will apply to the majority of name changes.  These are"
 W !,"instances where characters such as periods, have been removed or changed"
 W !," and probably do not require review.  You may review all four categories but"
 W !,"limiting the report to the first three will produce a more relevant and"
 W !,"manageable list."
 K DIR
 S DIR(0)="SO^1:Name value contains no comma;2:Parenthetical text is removed from name;3:Name value cannot be converted;4:Characters are removed or changed"
 S DIR("A")="Select an exception to include",DGEND=0
EXC F  D  Q:DGOUT!DGEND
 .D ^DIR I $D(DTOUT)!$D(DUOUT) S DGOUT=1 Q
 .I X="" S DGEND=1 Q
 .S DGEXC(Y)=Y(0)
 .I $D(DGEXC(1)),$D(DGEXC(2)),$D(DGEXC(3)),$D(DGEXC(4)) D  Q
 ..S DGEND=1,DGEXC="ALL" Q
 .S DIR("A")="Select another exception to include" N DGX
 .S DGX=Y_":"_Y(0),DIR(0)=$P(DIR(0),DGX)_$P(DIR(0),DGX,2)
 .I DIR(0)[";;" S DIR(0)=$P(DIR(0),";;")_";"_$P(DIR(0),";;",2)
 .Q
 G:DGOUT Q
 I $D(DGEXC)<10 W !!,$C(7),"At least one selection is required!",! G EXC
 ;
 D SUBT^DG53244V("*** Selected Report Parameters ***")
 D PARAM^DG53244V
 K DIR S DIR(0)="Y",DIR("A")="Ok",DIR("B")="YES",DIR("?")="Indicate if the selected parameters are correct."
 D ^DIR G:'Y!$D(DTOUT)!$D(DUOUT) Q
QUEUE W !!,$C(7),"This report requires 132 column output!"
 F DGI="DGFLAG","DGFLAG(","DGFMT","DGFMT(","DGFLD","DGFLD(","DGEXC","DGEXC(" S ZTSAVE(DGI)=""
 D EN^XUTMDEVQ("PRT^DG53244V","Print Patient Name Standardization Report",.ZTSAVE)
Q D END^DG53244V Q
 ;
CONVERT ;Convert patient name fields
 N DGOUT,DGEND,DGPDT,DGRUN,DGT0,DGI,DIR,DTOUT,DUOUT,DGLIM,DGFLAG
 S DGOUT=0,DGFLAG="P",DGFLAG(DGFLAG)="Process patient name conversion"
 D TITL^DG53244V("*** Patient Name Field Conversion ***")
 S DGPDT=$G(^XTMP("DPTNAME",0,0)),DGT0=$G(^XTMP("DPTNAME",0))
 S DGRUN=($P(DGT0,U,5)="RUN")
 I DGPDT D
 .W !!,"Name conversion processing started on ",$$FMTE^XLFDT(+DGPDT) W:'$P(DGPDT,U,2) " but has not completed."
 .W:$P(DGPDT,U,2) " and completed ",!,$$FMTE^XLFDT($P(DGPDT,U,2)),"."
 .Q
 I $P(DGPDT,U,2) D  G Q
 .W !!,$C(7),"It appears that the conversion of patient name fields has completed.  No"
 .W !,"further action should be necessary.  To review the results of the conversion,"
 .W !,"a report may be printed with the PRINT^DG53244T entry point."
 .S DIR(0)="E",DIR("A")="Enter RETURN to exit"
 .W !! D ^DIR
 .Q
 I DGRUN D  G Q:DGOUT
 .W !!,"It appears that the conversion of patient name fields is running currently."
 .F DGI=1:1:10 Q:DGOUT  D
 ..I $P(^XTMP("DPTNAME",0),U,4)'=$P(DGT0,U,4) S DGOUT=1 Q
 ..H 1 W "." Q
 .I DGOUT D  Q
 ..W !!,"An additional processing task should not be started at this time.",!
 ..S DIR(0)="E",DIR("A")="Enter RETURN to exit"
 ..W !! D ^DIR
 ..Q
 .S $P(^XTMP("DPTNAME",0),U,5)="STOP"
 .W "that process has been flagged to stop."
 I 'DGPDT D
 .W !!,"Name conversion processing doesn't appear to have been performed."
 .Q
LIM D SUBT^DG53244V("*** Processing Limitation ***")
 S DGI="Processing will "_$S(DGPDT:"continue",1:"begin")_" with PATIENT file entry "_$S(DGPDT:$P(DGT0,U,4)+1,1:$O(^DPT(0)))_"."
 W !!?(80-$L(DGI)\2),DGI
 W !!,"The conversion can be tasked to run to completion or stop after a specified"
 W !,"record entry or date/time.  If stopped prior to completion it will need to be"
 W !,"re-tasked to run to completion at another time."
 S DIR(0)="S^R:Run to completion;SR:Stop after specified record;SD:Stop after date/time"
 S DIR("A")="Specify processing limitation"
 D ^DIR I $D(DTOUT)!$D(DUOUT) G Q
 S DGLIM=Y
SR I DGLIM="SR" D  G:DGOUT Q
 .D SUBT^DG53244V("*** Specify Ending Record ***")
 .W !!,"Name conversion processing will discontinue after the record number specified."
 .S DIR(0)="N^"_$S(DGPDT:(+$P(DGT0,U,4)+1),1:$O(^DPT(0)))_":"_$O(^DPT(999999999),-1)
 .S DIR("A")="Record number to end processing"
 .W ! D ^DIR I $D(DTOUT)!$D(DUOUT) S DGOUT=1 Q
 .S DGLIM(DGLIM)=Y
 .Q
SD I DGLIM="SD" D  G:DGOUT Q
 .D SUBT^DG53244V("*** Specify Ending Date/Time ***")
 .W !!,"The value specified must include both date and time.  It must be at least one"
 .W !,"hour in the future but not more than seven days in the future."
 .S DIR(0)=$$FMADD^XLFDT($P($$NOW^XLFDT(),":",1,2),,1)_":"_$$FMADD^XLFDT($P($$NOW^XLFDT(),":",1,2),7,1)_":ET"
 .S DGI="("_$$FMTE^XLFDT($P(DIR(0),":"))_" / "_$$FMTE^XLFDT($P(DIR(0),":",2))_")"
 .W !!?(80-$L(DGI)\2),DGI
 .S DIR("A")="Date/time to end processing: "
 .S DIR(0)="DA^"_DIR(0)
 .W ! D ^DIR I $D(DTOUT)!$D(DUOUT) S DGOUT=1 Q
 .S DGLIM(DGLIM)=Y
 .Q
 ;
PQUE ;Queue patient name conversion
 D SUBT^DG53244V("*** Queue Name Conversion Processing ***")
 N %DT,DGI,Y,ZTSK,ZTRTN,ZTDESC,ZTDTH,ZTIO,ZTSAVE
 S Y=DT_.22 X ^DD("DD") S %DT("B")=Y,%DT("A")="Queue to run: "
PQ S %DT="AEFXR" W ! D ^%DT
 I DGLIM="SD",Y>DGLIM(DGLIM) D  G PQ
 .W !,$C(7),"Task start time must be earlier than processing end time!"
 .Q
 I Y<1 G QQ
 S ZTDTH=Y,ZTRTN="RUN^DG53244U(.DGFLAG)",ZTIO=""
 F DGI="DGFLAG","DGFLAG(","DGLIM","DGLIM(" S ZTSAVE(DGI)=""
 S ZTDESC="Process patient name conversion"
 F DGI=1:1:20 D ^%ZTLOAD Q:$G(ZTSK)
QQ W:'$G(ZTSK) !!,"Extract not queued!!!",!
 W:$G(ZTSK) !!,"Task number: ",ZTSK,!
 S DIR(0)="E",DIR("A")="Enter RETURN to exit" K DIR("B")
 W !! D ^DIR
 G Q
 ;
STOP ;Request patient name conversion to stop
 N DIR,DTOUT,DUOUT,X,Y,DGRUN,DGOUT S DGOUT=0
 D TITL^DG53244V("*** Stop Patient Name Conversion Process ***")
 S DGRUN=($P($G(^XTMP("DPTNAME",0)),U,5)="RUN")
 I 'DGRUN D
 .W !!,"The patient name conversion process doesn't appear to be running currently."
 .Q
 I DGRUN D
 .S DIR(0)="Y",DIR("B")="NO"
 .S DIR("A")="Are you sure you wish to stop the patient name conversion process"
 .D ^DIR I $D(DTOUT)!$D(DUOUT) S DGOUT=1 Q
 .Q:'Y
 .S $P(^XTMP("DPTNAME",0),U,5)="STOP"
 .W !!,"The process has been flagged to stop."
 .Q
 G:DGOUT Q
 S DIR(0)="E",DIR("A")="Enter RETURN to exit" K DIR("B")
 W !! D ^DIR
 G Q
 ;
MGOUT(DGNCMG) ;Remove name change mail group
 ;Input: DGNCMG=variable to store existing group (pass by reference)
 ;
 N DGFDA,DGMSG
 S DGNCMG=$P($G(^DG(43,1,"NOT")),U,3)
 S:DGNCMG $P(^XTMP(DGNMSP,0),U,6)=DGNCMG
 S DGFDA(43,"1,",502)="@"
 D FILE^DIE("E","DGFDA","DGMSG")
 Q
 ;
MGIN(DGNCMG) ;Replace name change mail group
 ;Input: DGNCMG=mail group pointer
 ;
 I '$G(DGNCMG) S DGNCMG=$P(^XTMP(DGNMSP,0),U,6) Q:'DGNCMG
 N DGFDA,DGMSG
 S DGFDA(43,"1,",502)=DGNCMG
 D FILE^DIE("","DGFDA","DGMSG")
 Q
