DGSSNRP2 ;ALB/SEK/PHH - DUPLICATE SPOUSE/DEPENDENT Report - Continued; Dec 15, 1999
 ;;5.3;Registration;**313,535**;Aug 13,1993
 ;
MAIN ;
 N X
 S X=$$DT^XLFDT
 S ^XTMP("DG-SSNRP2",0)=X+1_U_X_"^DG DUPLICATE SSN REPORT "
 ;
 D GETDATA
 I $D(ZTQUEUED) D
 .N ZTRTN,ZTDESC,ZTSK,ZTIO
 .S ZTRTN="PRINT^DGSSNRP2",ZTDESC="Print Duplicate Spouse/Dependent SSN Report",ZTIO="`"_DEV
 .S:$D(HFS) IO("HFSIO")=HFS
 .S:$D(PAR) IOPAR=PAR
 .D ^%ZTLOAD
 .S ZTREQ="@"
 E  S IOP="`"_IOS D ^%ZIS,PRINT,HOME^%ZIS
 Q
 ;
PRINT ;
 N STATS,CRT,QUIT,PAGE,PART1D,PART2D,PART1ST,SECTION,DGVETNM,DGVETSSN
 N VA,VADM,VAERR
 K DEV,HFS,PAR
 S QUIT=0
 S PAGE=0
 S CRT=$S($E(IOST,1,2)="C-":1,1:0)
 ;
 U IO
 I CRT,PAGE=0 W @IOF
 S PAGE=1
 S (PART1D,PART2D)=1
 S SECTION="PART1"
 D CHECKP1
 D HEADER
 I PART1D D PPART1
 I QUIT K ^XTMP("DG-SSNRP2") Q
 S SECTION="PART2"
 S:'$D(^XTMP("DG-SSNRP2","DGPART2")) PART2D=0
 D HEADER
 I PART2D D PPART2
 I CRT,'QUIT D PAUSE
 I $D(ZTQUEUED) S ZTREQ="@"
 D ^%ZISC
 K ^XTMP("DG-SSNRP2"),^UTILITY("VASD",$J)
 Q
LINE(LINE) ;
 ;Description: prints a line. First prints header if at end of page.
 ;
 I CRT,($Y>(IOSL-4)) D  Q:QUIT
 .D PAUSE
 .Q:QUIT
 .W @IOF
 .D HEADER Q:QUIT
 .W:SECTION="PART1" !
 .W LINE
 ;
 E  I ('CRT),($Y>(IOSL-2)) D
 .W @IOF
 .D HEADER
 .W !,LINE
 ;
 E  W !,LINE
 Q
 ;
GETDATA ;
 ;Setup global with veterans and spouse/dependents included in the report
 ;
 ;Variables used
 ;DGCTR1 - counter part 1
 ;DGCTR2 - counter part 2
 ;DGVETSSN - vet's SSN
 ;DGVETNM  - vet's name
 ;DGDEPSSN - dep's SSN
 ;DGDEPNM  - dep's name
 ;DGDEPREL - dep's relationship
 ;
 D GETPART1
 D GETPART2
 Q
 ;
GETPART1 ;1st part of report
 ;S ^XTMP("DG-SSNRP2","DGPART1",DGVETSSN)=DGVETNM
 ;S ^XTMP("DG-SSNRP2","DGPART1",DGVETSSN,DGCTR1)=DGDEPNM^DGDEPSSN^DGDEPREL
 ;
 N DFN,DG40812,DGDEP,DGDEPIEN,DGIEN,DGSSNCTR
 S DFN=0
 F  S DFN=$O(^DGPR(408.12,"B",DFN)) Q:'DFN  D
 .S (DGIEN,DGSSNCTR)=0
 .K ^TMP("DGSSNAR",$J)
 .F  S DGIEN=$O(^DGPR(408.12,"B",DFN,DGIEN)) D  Q:'DGIEN
 ..I 'DGIEN D SETTMPA Q  ;add to ^TMP
 ..S DG40812=$G(^DGPR(408.12,DGIEN,0)) Q:'DG40812
 ..I DG40812["DPT" D  Q
 ...;if can't get veteran's SSN kill array and get next veteran
 ...D DEM^VADPT
 ...I '$P(VADM(2),"^") K ^TMP("DGSSNAR",$J) S DGIEN="" Q
 ...; if not OK to report then kill array and get next veteran
 ...I '$$OKRPT(DFN,.VADM) K ^TMP("DGSSNAR",$J) S DGIEN="" Q
 ...;^TMP("DGSSNAR",$J) for vet (subscript "V") = name^SSN (no P)^SSN (with P)
 ...;P for veterans with pseudo SSN
 ...S ^TMP("DGSSNAR",$J,"V")=VADM(1)_"^"_+VADM(2)_"^"_$P(VADM(2),"^")
 ...Q
 ..;^TMP("DGSSNAR",$J) for dependents = SSN or Not Available^name^relationship code
 ..I DG40812["DGPR" D  Q
 ...S DGDEPIEN=$P($P(DG40812,"^",3),";") Q:'DGDEPIEN
 ...S DGDEP=$G(^DGPR(408.13,DGDEPIEN,0)) Q:DGDEP']""
 ...S DGSSNCTR=DGSSNCTR+1
 ...S ^TMP("DGSSNAR",$J,DGSSNCTR)=$S($P(DGDEP,"^",9):$P(DGDEP,"^",9),1:"Not Available")_"^"_$P(DGDEP,"^")_"^"_$P(DG40812,"^",2)
 ...Q
 ..Q
 .Q
 Q
 ;
SETTMPA ;check if spouse/dep SSN is the same as the vet's SSN or if not available (missing)
 ;if true add to ^TMP
 N DGDEPSSN,DGSCTR,DGTMPN1,DGVETSNP
 I ('DGSSNCTR)!('$D(^TMP("DGSSNAR",$J,"V"))) K ^TMP("DGSSNAR",$J) Q
 S DGVETSNP=$P(^TMP("DGSSNAR",$J,"V"),"^",2)
 S DGTMPN1=0
 F DGSCTR=1:1:DGSSNCTR D
 .S DGDEPSSN=$P(^TMP("DGSSNAR",$J,DGSCTR),"^")
 .Q:((DGDEPSSN'=DGVETSNP)&(DGDEPSSN))
 .I 'DGTMPN1 S ^XTMP("DG-SSNRP2","DGPART1",("A"_$P(^TMP("DGSSNAR",$J,"V"),"^",3)))=$P(^TMP("DGSSNAR",$J,"V"),"^"),DGTMPN1=1
 .S ^XTMP("DG-SSNRP2","DGPART1",("A"_$P(^TMP("DGSSNAR",$J,"V"),"^",3)),DGSCTR)=$P(^TMP("DGSSNAR",$J,DGSCTR),"^",2)_"^"_DGDEPSSN_"^"_$P(^TMP("DGSSNAR",$J,DGSCTR),"^",3)
 .Q
 K ^TMP("DGSSNAR",$J)
 Q
 ;
GETPART2 ;2nd part of report
 ;S ^XTMP("DG-SSNRP2","DGPART2",DGDEPSSN,DGCTR2)=DGDEPNM^DGDEPREL^DGVETSSN
 ;
 N DGSSN,DGSSND,DGSSNDA,DGSSN1,DGSSNCTR
 S DGSSN=0
 F  S DGSSN=$O(^DGPR(408.13,"SSN",DGSSN)) D  Q:'DGSSN
 .K ^TMP("DGSSNAR",$J)
 .I 'DGSSN D SETTMP Q  ;add to ^TMP
 .S DGSSN1="A"_DGSSN
 .S (DGSSNDA,DGSSNCTR)=0
 .F  S DGSSNDA=$O(^DGPR(408.13,"SSN",DGSSN,DGSSNDA)) D  Q:'DGSSNDA
 ..I 'DGSSNDA D SETTMP Q
 ..S DGSSND=$G(^DGPR(408.13,DGSSNDA,0)) Q:DGSSND']""
 ..;
 ..;^TMP("DGSSNAR",$J) array = IEN of INCOME PERSON file (#408.13)^dependent name
 ..S DGSSNCTR=DGSSNCTR+1
 ..S ^TMP("DGSSNAR",$J,DGSSNCTR)=DGSSNDA_"^"_$P(DGSSND,"^")
 ..Q
 .Q
 Q
 ;
SETTMP ;check if >1 spouse/dependent with the same SSN
 ;if >1 add to ^TMP
 ;
 N DGDEPNM,DGDEPREL,DGPAT,DGPATRL,DGSCTR,DGSSNDA1,DGVETSN2
 I DGSSNCTR'>1 K ^TMP("DGSSNAR",$J) Q
 F DGSCTR=1:1:DGSSNCTR D
 .S DGSSNDA1=$P(^TMP("DGSSNAR",$J,DGSCTR),"^")
 .S DGDEPNM=$P(^TMP("DGSSNAR",$J,DGSCTR),"^",2)
 .S DGPAT=$O(^DGPR(408.12,"C",DGSSNDA1_";DGPR(408.13,",0))
 .S DGPATRL=$G(^DGPR(408.12,+DGPAT,0))
 .;missing "C" x-ref or 0 node of 408.12 record
 .I 'DGPATRL S DGDEPREL="U",DGVETSN2="UNKNOWN"
 .E  D  I +DGVETSN2 Q:'$$OKRPT(DGVETSN2)
 ..S DFN=+DGPATRL
 ..D DEM^VADPT
 ..S DGVETSN2=$P($G(VADM(2)),"^")
 ..S DGDEPREL=$P(DGPATRL,"^",2)
 ..Q
 .S ^XTMP("DG-SSNRP2","DGPART2",DGSSN1,DGSCTR)=DGDEPNM_"^"_DGDEPREL_"^"_DGVETSN2
 .Q
 K ^TMP("DGSSNAR",$J)
 S DGSSNCTR=0
 Q
 ;
CHECKP1 ;if there is no part1 data S PART1D=0
 ;if data S PART1ST=1 indicating 1st time thru header
 ;
 I '$D(^XTMP("DG-SSNRP2","DGPART1")) S PART1D=0 Q
 S PART1ST=1
 Q
 ;
HEADER ;
 ;Description: Prints the report header.
 ;
 Q:QUIT
 N LINE
 I $Y>1 W @IOF
 W !,?21,"Duplicate Spouse/Dependent SSN Report"
 W ?70,"Page ",PAGE
 W !,?26,"Date Generated: "_$$FMTE^XLFDT(DT)
 S PAGE=PAGE+1
 ;
 W !
 W $S(SECTION="PART1":"            Spouse/Dependent with no SSN or the same SSN as Veteran",1:"         Spouse/Dependent with the same SSN as another Spouse/Dependent")
 I SECTION="PART1" D
 .I 'PART1D W !!,?25,"No entries meet this criteria" Q
 .I 'PART1ST D PART1HD Q
 .S PART1ST=0
 .Q
 I SECTION="PART2" D
 .W !!
 .I 'PART2D W ?25,"No entries meet this criteria" Q
 .W "Spouse/Dependent Name",?33,"Spouse/Dependent SSN",?55,"Relationship",?69,"Veteran SSN"
 .Q
 Q
 ;
PAUSE ;
 ;Description: Screen pause.  Sets QUIT=1 if user decides to quit.
 ;
 N DIR,DIRUT,X,Y
 F  Q:$Y>(IOSL-3)  W !
 S DIR(0)="E"
 D ^DIR
 I ('(+Y))!$D(DIRUT) S QUIT=1
 Q
 ;
PPART1 ;
 ;Description: Prints Part 1 - Spouse/Dependent with no SSN or the same SSN as Veteran
 ;
 N DGPART1,DGSCTR,LINE
 S DGVETSSN=0
 F  S DGVETSSN=$O(^XTMP("DG-SSNRP2","DGPART1",DGVETSSN)) Q:DGVETSSN']""  D  Q:QUIT
 .S DGSCTR=0
 .S DGVETNM=$G(^XTMP("DG-SSNRP2","DGPART1",DGVETSSN))
 .Q:QUIT  D PART1HEA Q:QUIT
 .F  S DGSCTR=$O(^XTMP("DG-SSNRP2","DGPART1",DGVETSSN,DGSCTR)) Q:'DGSCTR  D  Q:QUIT
 ..S DGPART1=$G(^XTMP("DG-SSNRP2","DGPART1",DGVETSSN,DGSCTR))
 ..Q:DGPART1']""
 ..S LINE=$$LJ(" "_$P(DGPART1,"^"),25)_"     "_$$LJ($P(DGPART1,"^",2),22)
 ..S LINE=LINE_$$LJ($$RELCODE($P(DGPART1,"^",3)),12)
 ..D LINE(LINE) Q:QUIT
 ..Q:QUIT
 .Q:QUIT
 Q
 ;
PPART2 ;
 ;Description: Prints Part 2 -Spouse/Dependent with the same SSN as another Spouse/Dependent
 ;
 N DGDEPSSN,DGPART2,DGP2F,DGSCTR,LINE
 S DGP2F=1
 S DGDEPSSN=0
 F  S DGDEPSSN=$O(^XTMP("DG-SSNRP2","DGPART2",DGDEPSSN)) Q:DGDEPSSN']""  D  Q:QUIT
 .I 'DGP2F W !
 .E  S DGP2F=0
 .S DGSCTR=0
 .F  S DGSCTR=$O(^XTMP("DG-SSNRP2","DGPART2",DGDEPSSN,DGSCTR)) Q:'DGSCTR  D  Q:QUIT
 ..S DGPART2=$G(^XTMP("DG-SSNRP2","DGPART2",DGDEPSSN,DGSCTR))
 ..Q:DGPART2']""
 ..S LINE=$$LJ(" "_$P(DGPART2,"^"),29)_"     "_$$LJ($E(DGDEPSSN,2,10),21)
 ..S LINE=LINE_$$LJ($$RELCODE($P(DGPART2,"^",2)),13)
 ..S LINE=LINE_$$LJ(" "_$P(DGPART2,"^",3),10)
 ..D LINE(LINE) Q:QUIT
 ..Q:QUIT
 .Q:QUIT
 Q
 ;
 ;
LJ(STRING,LENGTH) ;
 Q $$LJ^XLFSTR($E(STRING,1,LENGTH),LENGTH)
 ;
RELCODE(DGCODE) ;returns relationship name from RELATIONSHIP file (#408.11)
 ;
 N DGNAME
 S DGNAME=$P($G(^DG(408.11,+DGCODE,0)),"^")
 I DGNAME']"" Q "UNKNOWN"
 Q DGNAME
 ;
PART1HEA ;heading for part1 (vet name & SSN and spouse/dep name & SSN)
 I ('CRT),($Y>(IOSL-6)) D  Q
 .D HEADER
 ;
 E  I CRT,($Y>(IOSL-8)) D  Q:QUIT
 .D PAUSE
 .Q:QUIT
 .D HEADER
 ;
 E  D PART1HD
 Q
 ;
PART1HD W !!,"Veteran: ",$$LJ(DGVETNM,30),"     Veteran SSN: ",$$LJ($E(DGVETSSN,2,11),10),!!,"  Spouse/Dependent Name       Spouse/Dependent SSN  Relationship"
 Q
OKRPT(DFN,VADM) ; Check if patient can be reported
 ;
 ; Input:
 ;   DFN   - Patient (#2) file IEN
 ;   VADM  - VADPT API demographic array for this patient (OPTIONAL)
 ; Ouput:
 ;   <function>  0: do not report
 ;               1: report patient
 ;
 N VAIP,X,X1,X2
 ;
 I '$D(VADM) D DEM^VADPT
 ; if veteran has a Date of Death
 I +VADM(6) Q 0
 ; has veteran been an Inpatient or Outpatient in the last 3 years
 S VAIP("D")="LAST" D IN5^VADPT
 I VAIP(3)'="" S X1=DT,X2=$P(VAIP(3),U)\1 D ^%DTC Q '(X>1095)
 ; if not an inpatient then check for appointment
 N VASD
 ; want appts kept in the last 3 years & ignore future appointments
 S VASD("W")=1,VASD("T")=DT
 S X1=DT,X2=1095 D C^%DTC S VASD("F")=X
 D SDA^VADPT
 Q ($D(^UTILITY("VASD",$J)))
