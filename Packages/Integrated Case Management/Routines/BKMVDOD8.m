BKMVDOD8 ;PRXM/HC/BHS - DUE/OVERDUE REPORT PRINT ; 14 Aug 2005  11:18 AM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN(BKMSEL,BKMHDR) ; EP - Print report
 ; Input variables:  ^TMP("BKMVDOD",$J,"SORTED") - report data
 ;                   BKMSEL - array of report criteria, sort
 N PAGE,NWPG,SRT1,SRT2,CTR,BKMNODE,BKMDX,CTR2,BKMTST,BKMOVR,BKMDUEDT
 N BKMPDUDT,BKMLSTDT,BKMDUEDI,BKMSRT,BKMBDT
 ;
 S PAGE=0,NWPG=1,BKMSRT=BKMSEL("SORT"),BKMBDT=BKMSEL("BLDATE")
 ; Print report header and increment PAGE
 D HDR(.BKMSEL,.BKMHDR)
 ; Print report data
 S SRT1="" F  S SRT1=$O(^TMP("BKMVDOD",$J,"SORTED",SRT1)) Q:SRT1=""  D  Q:$G(BKMRTN)="^"
 .I BKMSRT'="P" D  Q:$G(BKMRTN)="^"
 ..; Header
 ..I $Y>(IOSL-6) D HDR(.BKMSEL,.BKMHDR) Q:$G(BKMRTN)="^"  S NWPG=1
 ..I 'NWPG W !
 ..W !,?1,$S(BKMSRT="PR":"HIV Provider: ",BKMSRT="DP":"DPC Provider: ",BKMSRT="CM":"HIV Case Manager: ",1:""),SRT1
 ..I NWPG S NWPG=0
 .S SRT2="" F  S SRT2=$O(^TMP("BKMVDOD",$J,"SORTED",SRT1,SRT2)) Q:SRT2=""  D  Q:$G(BKMRTN)="^"
 ..S CTR=0 F  S CTR=$O(^TMP("BKMVDOD",$J,"SORTED",SRT1,SRT2,CTR)) Q:'CTR  D  Q:$G(BKMRTN)="^"
 ...S BKMNODE=$G(^TMP("BKMVDOD",$J,"SORTED",SRT1,SRT2,CTR)),BKMDX=$P(BKMNODE,U,8)
 ...S BKMPDUDT=""
 ...I BKMSRT'="P",NWPG D  Q:$G(BKMRTN)="^"
 ....; Header
 ....I $Y>(IOSL-6) D HDR(.BKMSEL,.BKMHDR) Q:$G(BKMRTN)="^"  S NWPG=1
 ....W !,?1,$S(BKMSRT="PR":"HIV Provider: ",BKMSRT="DP":"DPC Provider: ",BKMSRT="CM":"HIV Case Manager: ",1:""),SRT1
 ....I NWPG S NWPG=0
 ...W !,?1,$E(SRT2,1,15),?17,$$HRN^BKMVA1($P(BKMNODE,U,2))
 ...W ?24,$P(BKMNODE,U,4),?28,$P(BKMNODE,U,5)
 ...;W ?33,$S(BKMDX="H":"HIV",BKMDX="A":"AIDS",BKMDX?1"E".E:"AT RISK-"_$S(BKMDX="EI":"IN",BKMDX="EO":"OCC",BKMDX="EN":"NON",BKMDX="EU":"UNK",1:BKMDX),1:BKMDX)
 ...W ?32,$S(BKMDX="H":"HIV",BKMDX="A":"AIDS",BKMDX?1"E".E:"AT RISK",1:BKMDX)
 ...S NWPG=0
 ...S CTR2=0 F  S CTR2=$O(^TMP("BKMVDOD",$J,"SORTED",SRT1,SRT2,CTR,CTR2)) Q:'CTR2  D  Q:$G(BKMRTN)="^"
 ....S BKMTST=$G(^TMP("BKMVDOD",$J,"SORTED",SRT1,SRT2,CTR,CTR2))
 ....I CTR2>1 D  Q:$G(BKMRTN)="^"
 .....I $Y>(IOSL-5) D HDR(.BKMSEL,.BKMHDR) Q:$G(BKMRTN)="^"  S NWPG=1
 .....W !
 .....I NWPG D
 ......I BKMSEL("SORT")'="P" D
 .......W ?1,$S(BKMSRT="PR":"HIV Provider: ",BKMSRT="DP":"DPC Provider: ",BKMSRT="CM":"HIV Case Manager: ",1:""),SRT1,!
 ......W ?1,$E(SRT2,1,15),?17,$$HRN^BKMVA1($P(BKMNODE,U,2))
 ......W ?24,$P(BKMNODE,U,4),?28,$P(BKMNODE,U,5)
 ......;W ?33,$S(BKMDX="H":"HIV",BKMDX="A":"AIDS",BKMDX?1"E".E:"AT RISK-"_$S(BKMDX="EI":"IN",BKMDX="EO":"OCC",BKMDX="EN":"NON",BKMDX="EU":"UNK",1:BKMDX),1:BKMDX)
 ......W ?32,$S(BKMDX="H":"HIV",BKMDX="A":"AIDS",BKMDX?1"E".E:"AT RISK",1:BKMDX)
 ......S NWPG=0
 ....W ?40,$E($P(BKMTST,U,1),1,15),?56,$S($P(BKMTST,U,2)="":"",1:$$FMTE^XLFDT($P(BKMTST,U,2)\1,"5Z"))
 ....S BKMLSTDT=$P(BKMTST,U,2)
 ....S BKMDUEDI=$P(BKMTST,U,3)
 ....I BKMDUEDI'="" D
 .....S BKMDUEDT=$$FMTE^XLFDT(BKMDUEDI\1,"5Z")
 .....I BKMDUEDI<BKMBDT S BKMDUEDT=" "_BKMDUEDT_"*" Q
 .....I BKMDUEDI=BKMBDT,BKMLSTDT="" S BKMDUEDT="("_BKMDUEDT_")" Q
 .....S BKMDUEDT=" "_BKMDUEDT
 ....; TBD - Do not display repeated dates within a patient
 ....;W ?67,$S(BKMDUEDT'=BKMPDUDT:BKMDUEDT,1:"")
 ....W ?67,BKMDUEDT
 ....S BKMPDUDT=BKMDUEDT
 ; No data found
 I '$D(^TMP("BKMVDOD",$J,"SORTED")) D
 .S BKMLINE="**** NO DATA FOUND ****"
 .W !!,?IOM-$L(BKMLINE)\2,BKMLINE
 Q
 ;
HDR(BKMSEL,BKMHDR) ; Print report header
 ; Input variables:  BKMSEL - report criteria array passed by ref
 ;                   BKMHDR - report header array passed by ref
 ; Output variables: PAGE - incremented
 ;                   BKMRTN - quit flag
 N BKMLINE,DA,IENS,SITE,INIT,BKMRDT,BKMDFLT,BKMI,BKMBDT,BKMPAT
 ; Press return to continue
 I IOST["C-",PAGE,$$PAUSE^BKMIXX3 S BKMRTN="^" Q
 S BKMBDT=BKMSEL("BLDATE"),BKMPAT=BKMSEL("PAT")
 W @IOF
 S PAGE=$G(PAGE)+1
 S INIT=$S($G(DUZ)'="":$$GET1^DIQ(200,DUZ_",","1","E"),1:"")
 S BKMRDT=$$FMTE^XLFDT(DT,1)
 W !?1,INIT,?IOM-$L(BKMRDT)\2,BKMRDT,?(73-$L(PAGE)),"Page: ",PAGE
 S DA=$G(DUZ(2)),IENS=$$IENS^DILF(.DA),SITE=$S(IENS'="":$$GET1^DIQ(4,IENS,.01,"E"),1:"")
 W !,?IOM-$L(SITE)\2,SITE
 S BKMLINE=$G(BKMHDR(1))
 W !,?IOM-$L(BKMLINE)\2,BKMLINE
 F BKMI=2:1 Q:$G(BKMHDR(BKMI))=""  S BKMLINE=$G(BKMHDR(BKMI)) W !?IOM-$L(BKMLINE)\2,BKMLINE
 S BKMLINE=$S(BKMPAT="ALL":"All ACTIVE HMS Register Patients",1:"Patient: "_$$GET1^DIQ(2,BKMPAT,".01","E"))
 S BKMLINE="*** CONFIDENTIAL PATIENT INFORMATION ***"
 W !,?IOM-$L(BKMLINE)\2,BKMLINE
 W !!?1,"PATIENT NAME",?17,"HRN",?24,"AGE",?28,"SEX",?32,"REG DX",?40,"TEST/PROC/VISIT",?56,"LAST DOC",?67,"DUE/OVERDUE*"
 W !?1 F BKMI=1:1:78 W "-"
 Q
 ;
END ; EP - Report footer
 N BKMI,BKMLINE
 I $Y>(IOSL-10) S BKMI=$$PAUSE^BKMIXX3 W @IOF
 W !!?1 F BKMI=1:1:78 W "*"
 W !?5,"Dates in parentheses, i.e. '(07/01/2005)', indicate the test/proc/visit"
 W !?5,"has never been done.  Dates with an '*', i.e. '07/01/2005*', indicate"
 W !?5,"the test/proc/visit is overdue."
 W !?1 F BKMI=1:1:78 W "*"
 S BKMLINE="**** END CONFIDENTIAL PATIENT INFORMATION ****"
 W !!,?IOM-$L(BKMLINE)\2,BKMLINE
 S BKMI=$$PAUSE^BKMIXX3
 Q
 ;
PRINT2 ;
 Q
