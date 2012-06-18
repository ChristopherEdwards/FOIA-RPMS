AQAOPC83 ; IHS/ORDC/LJF - PRINT PROVIDER PROFILE ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn prints the single provider profile giving totals for the
 ;findings, actions, performance levels on occurrences.
 ;
INIT ; >>> initialize variables
 S (X,AQAOIOMX)=80 X:IOT'="HFS" ^%ZOSF("RM")
 D INIT^AQAOUTIL S AQAOHCON="Patient"
 S AQAOTY="OCCURRENCE PROVIDER PROFILE FOR"
 S AQAORG=$E(AQAOBD,4,5)_"/"_$E(AQAOBD,6,7)_"/"_$E(AQAOBD,2,3)_" to "
 S AQAORG=AQAORG_$E(AQAOED,4,5)_"/"_$E(AQAOED,6,7)_"/"_$E(AQAOED,2,3)
 ;
 I '$D(^TMP("AQAOPC8",$J)) D  G EXIT
 .D HEADING^AQAOUTIL,HDG2
 .W !,AQAOLINE,!!?30,">>> NO DATA FOUND <<<",!!
 ;
 ;
LOOP ; >>> loop thru med staff functions selected to check for data
 S AQAOM=0
 F  S AQAOM=$O(AQAOMP(AQAOM)) Q:AQAOM=""  Q:AQAOSTOP=U  D
 .I AQAOPAGE=0 D HEADING^AQAOUTIL,HDG2 I 1
 .E  D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG2
 .I '$D(^TMP("AQAOPC8",$J,AQAOM)) D  Q
 ..W !!?AQAOIOMX-20/2,">>> NO DATA FOUND <<<"
 .E  D LIST
 ;
 ;
EXIT ; >>> eoj
 I '$D(ZTQUEUED),IOST["C-" D PRTOPT^AQAOVAR
 K ^TMP("AQAOPC8",$J) K ^TMP("AQAOPC8A",$J) K ^TMP("AQAOPC8B",$J)
 D ^%ZISC D KILL^AQAOUTIL
 Q
 ;
 ; >>> END OF MAIN RTN <<<
 ;
 ;
LIST ; >> SUBRTN to loop thru ^tmp and print cases
 S AQAOIND=0
 F  S AQAOIND=$O(^TMP("AQAOPC8",$J,AQAOM,AQAOIND)) Q:AQAOIND=""  Q:AQAOSTOP=U  D
 .W !!,"Indicator:  ",$P(AQAOIND,U) ;print indicator #
 .W ?24,$P(^AQAO(2,$P(AQAOIND,U,2),0),U,2),! ;print indicator name
 .S AQAODT=0
 .F  S AQAODT=$O(^TMP("AQAOPC8",$J,AQAOM,AQAOIND,AQAODT)) Q:AQAODT=""  Q:AQAOSTOP=U  D
 ..S AQAOIFN=0
 ..F  S AQAOIFN=$O(^TMP("AQAOPC8",$J,AQAOM,AQAOIND,AQAODT,AQAOIFN)) Q:AQAOIFN=""  Q:AQAOSTOP=U  D
 ...S AQAOS=^TMP("AQAOPC8",$J,AQAOM,AQAOIND,AQAODT,AQAOIFN)
 ...I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG2
 ...W !,$P(AQAOS,U) S Y=AQAODT X ^DD("DD") W ?10,Y ;case id&occ dat
 ...W ?24,$P($P(AQAOS,U,2),"//") ;find/act/type/attr
 ...W ?53,$P($P(AQAOS,U,2),"//",2) ;poten/out/ult
 .D SUBTOTAL ;print subtotals at end of each ind
 Q
 ;
 ;
 ;
SUBTOTAL ; >> SUBRTN to print subtotals for an indicator in 2 columns
 S X="",$P(X,"_",50)="" W !,"Subtotals: ",?25,X
 S (AQAOX,AQAOY,AQAOCNT)=0
 F  S:AQAOX]"" AQAOX=$O(^TMP("AQAOPC8A",$J,AQAOIND,AQAOX)) S:AQAOY]"" AQAOY=$O(^TMP("AQAOPC8B",$J,AQAOIND,AQAOY)) Q:(AQAOX=AQAOY)  D
 .I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG2
 .W ! I AQAOX]"" S AQAOCNT=AQAOCNT+^TMP("AQAOPC8A",$J,AQAOIND,AQAOX)
 .I AQAOX]"" W ?24,AQAOX,?45,$J(^TMP("AQAOPC8A",$J,AQAOIND,AQAOX),4)
 .I AQAOY]"" W ?53,AQAOY,?70,$J(^TMP("AQAOPC8B",$J,AQAOIND,AQAOY),4)
 W !?45,"----",?70,"----"
 W !?45,$J(AQAOCNT,4),?70,$J(AQAOCNT,4)
 Q
 ;
 ;
HDG2 ; >> SUBRTN to print second half of heading
 W ?AQAOIOMX-$L(AQAOPRVN)/2,AQAOPRVN
 W !?AQAOIOMX-$L(AQAORG)/2,AQAORG,!,AQAOLIN2
 W !,"Case ID",?10,"Occ Date",?24,"Find/Actn/Type/Level"
 W ?53,"Risk/Occ/Ultimate Outcomes",!,AQAOLINE
 W:$D(AQAOM) !?AQAOIOMX-$L(AQAOMP(AQAOM))/2,AQAOMP(AQAOM)
 Q
