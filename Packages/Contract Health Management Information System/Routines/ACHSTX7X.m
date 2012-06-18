ACHSTX7X ; IHS/ITSC/PMF - CHS TRIBAL STATISTICAL EXPORT ERROR REPORT ;  [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ; Produces report for incomplete data items for Statisitcal (638)
 ; records to be sent to DDPS.
 ;
 ; Sites can use the "Enter/Edit Medical Data" to fill in any
 ; missing ICD9 or APC codes, and the Vendor edit option to
 ; fill in an EIN or Vendor Type.  Bad Admit/Discharge dates are
 ; rare and will have to be fixed w/FM.
 ;
 ;  THANKS TO FONDA JACKSON OF PORTLAND FOR THE ORIGINAL ROUTINE.
 ;
 I $$PARM^ACHS(0,8)'="Y" W !,"Your site is not a 638 facility." D RTRN^ACHS Q
 ;
DEV ;
 S %ZIS="MQP"
 D ^%ZIS
 G:POP CLOSE
 G:'$D(IO("Q")) START
 S ZTRTN="START^ACHSTX7X",ZTDESC=$$DESC
 D ^%ZTLOAD,HOME^%ZIS
 G CLOSE
 ;
START ;EP - From TaskMan.
 K ^TMP("ACHSTX7X",$J)
 N ACHSBDTS,ACHSEIN,ACHSFC,ACHSFYDT
 D SETUP
 D CALC
 D PRINT
 D CLOSE
 Q
 ;
SETUP ; -----  Set vars.  --------------------------------------------------
 D FY^ACHSUF,FC^ACHSUF
 S (ACHSDCR,ACHSBDT)=0,ACHSEDT=DT
 S X=$O(^ACHS(9,DUZ(2),"FY",ACHSCFY,"AR",0))
 I X?7N D
 . S ACHSDCR=$O(^ACHS(9,DUZ(2),"FY",ACHSCFY,"AR",X,ACHSDCR))
 . S ACHSEDT=$P(^ACHS(9,DUZ(2),"FY",ACHSCFY,"W",ACHSDCR,0),U,2)
 . S ACHSBDT=$P($G(^ACHS(9,DUZ(2),"FY",ACHSCFY,"W",ACHSDCR-1,0)),U,2)
 . I ACHSBDT'?7N S ACHSBDT=ACHSFYDT-10000
 .Q
 I ACHSDCR=0 S ACHSBDT=ACHSFYDT-10000
 S ACHSBDTS=ACHSBDT
 Q
 ;
CALC ; -----  Check for documents with incomplete data items.  ------------
 F  S ACHSBDT=$O(^ACHSF(DUZ(2),"TB",ACHSBDT)) Q:(ACHSBDT>ACHSEDT)!(ACHSBDT'?7N)  D
 . Q:'$D(^ACHSF(DUZ(2),"TB",ACHSBDT,"P"))
 . S ACHSDIEN=0
 . F  S ACHSDIEN=$O(^ACHSF(DUZ(2),"TB",ACHSBDT,"P",ACHSDIEN)) Q:ACHSDIEN'?1N.N  D
 .. Q:$P(^ACHSF(DUZ(2),"D",ACHSDIEN,0),U,3)
 .. S ACHSTIEN=$O(^ACHSF(DUZ(2),"TB",ACHSBDT,"P",ACHSDIEN,0))
 .. S ACHSDOCR=^ACHSF(DUZ(2),"D",ACHSDIEN,0),ACHSTOS=$P(ACHSDOCR,U,4)
 .. D CHK
 ..Q
 .Q
 Q
 ;
CHK ; --- Text at CHK_ labels are used in report.     
 F %=1:1:4 S ACHSERR(%)=0
 S ACHSTST=0
CHK1 ;ERROR IN ICD-9 CODE; Error 1.
 D DXPX^ACHSTX7A
 ;I ACHSTOS=1,+ACHSDX(1)<1 S ACHSERR(1)=1,ACHSTST=1 G CHK2
 I ACHSTOS=1,'(+ACHSDX(1)>0),"EV"'[$E(ACHSDX(1)) S ACHSERR(1)=1,ACHSTST=1 G CHK2
 I ACHSTOS=2 G CHK2
 I ACHSTOS=3,+ACHSAPC(1)<1 S ACHSERR(1)=1,ACHSTST=1
CHK2 ;INVALID EIN; Error 2.
 I '$P(ACHSDOCR,U,8) S ACHSERR(2)=1,ACHSTST=1,ACHSEIN="" G CHK4
 S (ACHSEIN,X)=$P($G(^AUTTVNDR($P(ACHSDOCR,U,8),11)),U)
 X $P(^DD(9999999.11,1101,0),U,5,99)
 I '$D(X) S ACHSERR(2)=1,ACHSTST=1 G CHK3
 I "12"'[$E(X) S ACHSERR(2)=1,ACHSTST=1
CHK3 ;INVALID PROVIDER TYPE; Error 3.
 S X=$P($G(^AUTTVNDR($P(ACHSDOCR,U,8),11)),U,3)
 I X<1 S ACHSERR(3)=1,ACHSTST=1
 I X,'$D(^AUTTVTYP(X,0)) S ACHSERR(3)=1,ACHSTST=1
CHK4 ;INVALID ADMISSION/DISCHARGE DATE; Error 4.
 I ACHSTOS=1 D
 . S X=$P($G(^ACHSF(DUZ(2),"D",ACHSDIEN,8)),U,2)
 . S Y=$P($G(^ACHSF(DUZ(2),"D",ACHSDIEN,8)),U,3)
 . S:(Y>ACHSBDT)!(Y>ACHSEDT)!(X>ACHSEDT)!(X'?7N)!(Y'?7N) ACHSERR(4)=1,ACHSTST=1
 .Q
CHKEND ; -----  Set TMP Global with document Errors.
 Q:ACHSTST=0
 S ^TMP("ACHSTX7X",$J,ACHSTOS,ACHSDIEN)=$P(ACHSDOCR,U,14)_"-"_ACHSFC_"-"_$P(ACHSDOCR,U)
 F %=1:1:4 S $P(^TMP("ACHSTX7X",$J,ACHSTOS,ACHSDIEN),U,%+1)=ACHSERR(%)
 S $P(^TMP("ACHSTX7X",$J,ACHSTOS,ACHSDIEN),U,6)=ACHSEIN
 Q
 ;
CLOSE ; -----  Close device, kill vars, quit.  -----------------------------
 D ^%ZISC
 K ACHSTOS,ACHSDX,ACHSAPC,ACHSERR,ACHSTST,ACHSDOCR,ACHSDIEN,ACHSTIEN,ACHSPX,ACHSCFY,ACHSX,ACHSY,ACHSPG,R,ACHSBDT,ACHSDCR,ACHS,ACHSEDT,^TMP("ACHSTX7X",$J)
 Q
 ;
PRINT ; -----  Print Errors.  ----------------------------------------------
 U IO
 S ACHSPG=0
 D PHDR
 S (ACHSTOS(1),ACHSTOS(2),ACHSTOS(3))=0
 I $D(^TMP("ACHSTX7X",$J)) D
 . F ACHSTOS=1,2,3 S ACHSDIEN=0 F  S ACHSDIEN=$O(^TMP("ACHSTX7X",$J,ACHSTOS,ACHSDIEN)) Q:ACHSDIEN'?1N.N  D  Q:$D(DUOUT)
 .. S ACHSTOS(ACHSTOS)=ACHSTOS(ACHSTOS)+1
 .. I $Y>(IOSL-5) D RTRN^ACHS Q:$D(DUOUT)  D PHDR
 .. W !?7,$P(^TMP("ACHSTX7X",$J,ACHSTOS,ACHSDIEN),U)
 .. F %=1:1:4  I $P(^TMP("ACHSTX7X",$J,ACHSTOS,ACHSDIEN),U,%+1)=1 W ?45,$P($T(@("CHK"_%)),";",2) W:%=2 " ",$P(^TMP("ACHSTX7X",$J,ACHSTOS,ACHSDIEN),U,6) W !
 ..Q
 .Q
 Q:$D(DUOUT)
 I $Y>(IOSL-8) D RTRN^ACHS Q:$D(DUOUT)  D PHDR
 W !!,"  TOTAL HOSPITAL DOCUMENTS WITH ERRORS = ",$J($FN(ACHSTOS(1),","),6)
 W !!,"    TOTAL DENTAL DOCUMENTS WITH ERRORS = ",$J($FN(ACHSTOS(2),","),6)
 W !!,"TOTAL OUTPATIENT DOCUMENTS WITH ERRORS = ",$J($FN(ACHSTOS(3),","),6),!
 D RTRN^ACHS
 Q
 ;
PHDR ; -----  Header for Report.
 S ACHSPG=ACHSPG+1
 W @IOF,!,$$LOC^ACHS,?70,"Page ",ACHSPG
 W !,$$REPEAT^XLFSTR("-",80),!,$$C^XBFUNC($$DESC,80)
 W !,$$C^XBFUNC("From Transaction Date "_$$FMTE^XLFDT(ACHSBDTS)_" to "_$$FMTE^XLFDT(ACHSEDT),80)
 W !,$$REPEAT^XLFSTR("-",80)
 W !!?5,"DOCUMENT NUMBER",?45,"TYPE OF ERROR",!?5,$$REPEAT^XLFSTR("-",15),?45,$$REPEAT^XLFSTR("-",13),!
 Q
 ;
DESC() ;
 Q $P($P($P($T(ACHSTX7X),";",2),"-",2)," ",2,7)
 ;
HELP ;EP - From DIR.
 W !,$$C^XBFUNC($$DESC),!
 F %=3:1 W !?5,$P($T(HELP+%),";",3) Q:$P($T(HELP+%+1),";",3)=""
 ;;This report will examine data in documents produced since your last
 ;;export, and produce a report listing any documents with missing or
 ;;invalid data, that is required by the Data center in Albuquerque.
 ;;  
 ;;Checks include checking for valid ICD-9 codes, EIN vendor number,
 ;;Provider Type, and valid Admit/Discharge dates.
 Q
 ;
