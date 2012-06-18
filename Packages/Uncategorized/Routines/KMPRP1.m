KMPRP1 ;SFISC/RAK - RUM Data by Option ;4 Nov 1998
 ;;1.0;CAPACITY MANAGEMENT - RUM;;Dec 09, 1998
EN ;-- entry point.
 ;
 N %ZIS,CONT,DIC,IORVOFF,IORVON,KMPRDATE,KMPROPT,OUT,POP
 N X,Y,ZTDESC,ZTRTN,ZTSAVE,ZTSK
 ;
 D ZIS^KMPRUTL
 S OUT=0
 F  D  Q:OUT
 .W @IOF,!,?30,IORVON," RUM Data by Option ",IORVOFF,!
 .K DIC S DIC=19,DIC(0)="AEMQZ",DIC("A")="Select Option: "
 .W ! D ^DIC I Y<0 S OUT=1 Q
 .S KMPROPT=+Y_"^"_Y(0,0)
 .; determine start date from file 8971.1
 .D RUMDATES^KMPRUTL(.KMPRDATE)
 .Q:'KMPRDATE
 .; select output device.
 .S %ZIS="Q",%ZIS("A")="Device: ",%ZIS("B")="HOME"
 .W ! D ^%ZIS I POP W !,"No action taken." Q
 .; if queued.
 .I $D(IO("Q")) K IO("Q") D  Q
 ..S ZTDESC="RUM Data by Option for '"_$P(KMPROPT,U,2)_"'."
 ..S ZTRTN="EN1^KMPRP1"
 ..S ZTSAVE("KMPRDATE")="",ZTSAVE("KMPROPT")=""
 ..D ^%ZTLOAD W:$G(ZTSK) !,"Task #",ZTSK
 ..D EXIT
 .;
 .; if output to terminal display message.
 .W:$E(IOST,1,2)="C-" !?3,"...compiling data..."
 .D EN1
 Q
 ;
EN1 ;-- entry point from taskman.
 ;
 Q:'$G(KMPRDATE)
 Q:$G(KMPROPT)=""
 ;
 N ELEMENT,KMPRARRY,KMPRDAYS
 ;
 ; set elements data into ELEMENT() array.
 D ELEARRY^KMPRUTL("ELEMENT") Q:'$D(ELEMENT)
 S KMPRARRY=$NA(^TMP("KMPR OPT DATA",$J))
 K @KMPRARRY
 D DATA,PRINT,EXIT
 K @KMPRARRY
 ;
 Q
 ;
DATA ;-- set data into KMPRARRY
 Q:'$D(ELEMENT)
 Q:$G(KMPRARRY)=""
 Q:'$G(KMPRDATE)
 Q:$G(KMPROPT)=""
 ;
 N DATE,END,I,IEN,OPTION,START
 ;
 ; start and end dates.
 S START=$P(KMPRDATE,U),END=$P(KMPRDATE,U,2)
 S DATE=START-.1,KMPRDAYS=0
 F  S DATE=$O(^KMPR(8971.1,"B",DATE)) Q:'DATE!(DATE>END)  D 
 .S IEN=0,KMPRDAYS=KMPRDAYS+1
 .F  S IEN=$O(^KMPR(8971.1,"B",DATE,IEN)) Q:'IEN  D 
 ..Q:'$D(^KMPR(8971.1,IEN,0))  S DATA(0)=^(0),DATA(1)=$G(^(1)),DATA(2)=$G(^(2))
 ..S OPTION=$P(DATA(0),U,4)
 ..Q:OPTION'=$P(KMPROPT,U,2)
 ..F I=1:1:8 D 
 ...S $P(@KMPRARRY@(OPTION),U,I)=$P($G(@KMPRARRY@(OPTION)),U,I)+$P(DATA(1),U,I)
 ...S $P(@KMPRARRY@(OPTION),U,I)=$P($G(@KMPRARRY@(OPTION)),U,I)+$P(DATA(2),U,I)
 ;
 Q
 ;
EXIT ;
 S:$D(ZTQUEUED) ZTREQ="@"
 D ^%ZISC
 K KMPUDATE,KMPUNAM
 ;
 Q
 ;
PRINT ;-- print data from KMPRARRY.
 Q:'$D(ELEMENT)
 Q:$G(KMPRARRY)=""
 ;
 U IO
 ;
 N DATA,OCCUR,I,NUMBER,PIECE,SITE
 ;
 ; facility name.
 S SITE=$$SITE^VASITE
 S SITE=$P(SITE,U,2)_" ("_$P(SITE,U,3)_")"
 ;
 I '$D(@KMPRARRY) D  Q
 .D HDR
 .W !!!?28,"<<<No Data to Report>>>"
 .W !! D CONTINUE^KMPRUTL("Press RETURN to continue",.CONT)
 ;
 S OPTION=""
 F  S OPTION=$O(@KMPRARRY@(OPTION)) Q:OPTION=""  D 
 .D HDR S DATA=@KMPRARRY@(OPTION),I=0,OCCUR=$P(DATA,U,8)
 .F  S I=$O(ELEMENT(I)) Q:'I  D 
 ..W !,$P(ELEMENT(I),U) S PIECE=$P(ELEMENT(I),U,2)
 ..W $$REPEAT^XLFSTR(".",25-$X)
 ..S NUMBER=$P(DATA,U,PIECE)
 ..; per occurrence.
 ..W:PIECE'=8 ?28,$J($FN(NUMBER/OCCUR,",",$S(I<3:2,1:0)),$S(I<3:14,1:11))
 ..W ?50,$J($FN(NUMBER,",",$S(I<3:2,1:0)),$S(I<3:18,1:15))
 ;
 W !! D CONTINUE^KMPRUTL("Press RETURN to continue",.CONT)
 ;
 Q
 ;
HDR ;
 N TITLE
 W:$Y @IOF
 S TITLE="RUM Data for Option: "_$P(KMPROPT,U,2)
 W !?(80-$L(TITLE)\2),TITLE
 W !?(80-$L($G(SITE))\2),$G(SITE)
 W !?23,"For "_$P($G(KMPRDATE),U,3)_" to "_$P($G(KMPRDATE),U,4)
 W !
 W !?28,"per Occurrence",?50,"         Totals"
 W !
 ;
 Q
