ABMAUDRP ; IHS/SD/SDR - TM Audit report - 8/19/2005 1:28:34 PM
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ;This is to do a report based on fields being audited.
 ;They are listed below under FILES tag.  To add new fields
 ;to report just list them under FILES and turn the audit on
 ;using FM.
 ;
 K ABM,ABMY
 S ABM("RTYP")=1
 S ABM("RTYP","NM")="AUDIT LISTING"
 ;
SEL D LOOP Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABM("HD",0)="LISTING of Audited fields "
 S ABM("LVL")=0
 S ABMQ("RC")="COMPUTE^ABMAUDRP",ABMQ("RX")="POUT^ABMDRUTL",ABMQ("NS")="ABM"
 S ABMQ("RP")="OUTPUT^ABMAUDRP"
 D ^ABMDRDBQ
 Q
 ;
FILES ;
 ;;9002274.5;.26;3P Parameters-Printable Name of Payment Site
 ;;9002274.5;.23;3P Parameters-Facility to Receive Payment
 ;;9002274.09;2,.05;3P Insurer-Form Locator Override Data Value
 ;;9999999.06;.14;Location-Mailing address street
 ;;9999999.06;.15;Location-Mailing address city
 ;;9999999.06;.16;Location-Mailing address state
 ;;9999999.06;.17;Location-Mailing address zip
 ;;END
LOOP ;
 ; Display current exclusion parameters
 S ABMY("X")="W $$SDT^ABMDUTL(X)"
 G XIT:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 W !!?3,"EXCLUSION PARAMETERS Currently in Effect for RESTRICTING the EXPORT to:",!?3,"======================================================================="
 I $D(ABMY("LOC")) W !?3,"- Visit Location.....: ",$P(^DIC(4,ABMY("LOC"),0),"^",1)
 I $D(ABMY("DT")) W !?3,"- Edit Date Range....:"
 I  S X=ABMY("DT",1) X ABMY("X") W "  to: " S X=ABMY("DT",2) X ABMY("X")
PARM ;
 ; Choose additional exclusion parameters
 K DIR
 S DIR(0)="SO^1:LOCATION;2:DATE RANGE"
 S DIR("A")="Select ONE or MORE of the above EXCLUSION PARAMETERS"
 S DIR("?")="The report can be restricted to one or more of the listed parameters. A parameter can be removed by reselecting it and making a null entry."
 D ^DIR
 K DIR
 G XIT:$D(DIRUT)!$D(DIROUT)
 I Y=1!(Y=2) D @($S(Y=1:"LOC",1:"DT")_"^ABMAUDRP") G LOOP
 Q
 ;
COMPUTE ;
 S ABM("SUBR")="ABM-AUDR"
 K ^TMP($J,"ABM-AUDR")
 F ABMCNT=1:1 S ABMSEL=$P($T(FILES+ABMCNT),";;",2) Q:ABMSEL="END"  D
 .S ABMFILE=$P(ABMSEL,";")
 .S ABMFIELD=$P(ABMSEL,";",2)
 .I $G(ABMY("DT",1))'="" S ABMSDT=($G(ABMY("DT",1))-1),ABMEDT=$G(ABMY("DT",2))+1
 .E  S ABMSDT=0,ABMEDT=9999999
 .F  S ABMSDT=$O(^DIA(ABMFILE,"C",ABMSDT)) Q:+ABMSDT=0!(ABMSDT>ABMEDT)  D
 ..S ABMAIEN=0
 ..F  S ABMAIEN=$O(^DIA(ABMFILE,"C",ABMSDT,ABMAIEN)) Q:+ABMAIEN=0  D
 ...Q:$P($G(^DIA(ABMFILE,ABMAIEN,0)),U,3)'=ABMFIELD  ;quit if not Printable Name of Payment Site
 ...S ABMUSER=$P($G(^DIA(ABMFILE,ABMAIEN,0)),U,4)
 ...S ABMOLD=$P($G(^DIA(ABMFILE,ABMAIEN,2)),U)
 ...S ABMNEW=$P($G(^DIA(ABMFILE,ABMAIEN,3)),U)
 ...S ^TMP($J,"ABM-AUDR",ABMFILE,ABMFIELD,ABMSDT,ABMUSER)=ABMOLD_"^"_ABMNEW
 Q
OUTPUT ;
 D HDB
 S (ABMADT,ABMUSER,ABMFILE,ABMFIELD,ABMOLD,ABMNEW)=0
 F  S ABMFILE=$O(^TMP($J,"ABM-AUDR",ABMFILE)) Q:+ABMFILE=0  D   Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .S ABMFIELD=0,ABMSFLD=0
 .F  S ABMFIELD=$O(^TMP($J,"ABM-AUDR",ABMFILE,ABMFIELD)) Q:+ABMFIELD=0  D   Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ..S ABMSDT=0
 ..I ABMFIELD'=ABMSFLD D
 ...W !!?5,$P($G(^DIC(ABMFILE,0)),U)_"  Fld: "_$P($G(^DD(ABMFILE,+ABMFIELD,0)),U)
 ..S ABMSFLD=ABMFIELD
 ..F  S ABMSDT=$O(^TMP($J,"ABM-AUDR",ABMFILE,ABMFIELD,ABMSDT)) Q:+ABMSDT=0  D   Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ...S ABMUSER=0
 ...F  S ABMUSER=$O(^TMP($J,"ABM-AUDR",ABMFILE,ABMFIELD,ABMSDT,ABMUSER)) Q:+ABMUSER=0  D   Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ....I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W " (cont)"
 ....W !,$$CDT^ABMDUTL(ABMSDT)  ;date/time
 ....W ?17,$E($P($G(^VA(200,ABMUSER,0)),U),1,17)  ;user
 ....W ?35,$E($P($G(^TMP($J,"ABM-AUDR",ABMFILE,ABMFIELD,ABMSDT,ABMUSER)),U),1,22) ;old value
 ....W ?58,$E($P($G(^TMP($J,"ABM-AUDR",ABMFILE,ABMFIELD,ABMSDT,ABMUSER)),U,2),1,22)  ;new value
 K ^TMP($J,"ABM-AUDR")
 Q
LOC ;EP
 W ! K DIC,ABMY("LOC")
 S DIC="^BAR(90052.05,DUZ(2),"
 S DIC(0)="AEMQ"
 S DIC("A")="Select LOCATION: "
 D ^DIC K DIC
 Q:+Y<1
 S ABMY("LOC")=+Y
 Q
DT ;EP
 K DIR,ABMY("DT")
 Q:$D(DIRUT)
 S ABMY("DT")="E"
 S Y="EDIT DATE"
 W !!," ============ Entry of ",Y," Range =============",!
 S DIR("A")="Enter STARTING "_Y_" for the Report"
 S DIR(0)="DO^::EP"
 D ^DIR
 G DT:$D(DIRUT)
 S ABMY("DT",1)=Y
 W !
 S DIR("A")="Enter ENDING DATE for the Report"
 D ^DIR
 K DIR
 G DT:$D(DIRUT)
 S ABMY("DT",2)=Y
 I ABMY("DT",1)>ABMY("DT",2) W !!,*7,"INPUT ERROR: Start Date is Greater than than the End Date, TRY AGAIN!",!! G DT
 Q
XIT ;
 K ABMY("I"),ABMY("X"),DIR
 Q
HDR ;
 I $D(ABMY("LOC")) S ABM("TXT")=$P(^DIC(4,ABMY("LOC"),0),U),ABM("CONJ")="at " D CHK
 Q:$G(ABMY("DT",1))=""  ;no dates
 S ABM("CONJ")="with "
 S ABM("TXT")="Edit Date" D CHK
 S ABM("CONJ")="from ",ABM("TXT")=$$SDT^ABMDUTL(ABMY("DT",1)) D CHK
 S ABM("CONJ")="to ",ABM("TXT")=$$SDT^ABMDUTL(ABMY("DT",2)) D CHK
 Q
WHD ;EP for writing Report Header
 W $$EN^ABMVDF("IOF"),!
 I $D(ABM("PRIVACY")) W ?($S($D(ABM(132)):34,1:8)),"WARNING: Confidential Patient Information, Privacy Act Applies",!
 K ABM("LINE") S $P(ABM("LINE"),"=",$S($D(ABM(132)):132,1:80))="" W ABM("LINE"),!
 W ABM("HD",0),?$S($D(ABM(132)):108,1:57) S Y=DT X ^DD("DD") W Y,"   Page ",ABM("PG")
 W:$G(ABM("HD",1))]"" !,ABM("HD",1)
 W:$G(ABM("HD",2))]"" !,ABM("HD",2)
 W !,ABM("LINE") K ABM("LINE")
 Q
CHK I ($L(ABM("HD",ABM("LVL")))+1+$L(ABM("CONJ"))+$L(ABM("TXT")))<($S($D(ABM(132)):104,1:52)+$S(ABM("LVL")>0:28,1:0)) S ABM("HD",ABM("LVL"))=ABM("HD",ABM("LVL"))_" "_ABM("CONJ")_ABM("TXT")
 E  S ABM("LVL")=ABM("LVL")+1,ABM("HD",ABM("LVL"))=ABM("CONJ")_ABM("TXT")
 Q
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HDB S ABM("PG")=+$G(ABM("PG"))+1 D WHD
 W !,"Date/Time",?17,"User",?35,"Old Value",?58,"New Value"
 S $P(ABM("LINE"),"-",80)="" W !,ABM("LINE") K ABM("LINE")
 Q
