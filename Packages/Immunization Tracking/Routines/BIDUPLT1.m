BIDUPLT1 ;IHS/CMI/MWR - BI PRINT LETTERS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  PRINT LETTERS FROM ^TMP LIST OF PATIENTS.
 ;
 ;
 ;----------
PRINT(BILET,BIDLOC,BIIOP,BIFDT) ;EP
 ;---> Print Due Letters for patients stored in ^TMP("BIDUL".
 ;---> Called by PRINTALL above; error checking done above.
 ;---> Parameters:
 ;     1 - BILET  (req) Due Letter IEN.
 ;     2 - BIDLOC (req) Date-Location Line of letter.
 ;     3 - BIIOP  (req) Output Device Name (Should be equal to ION.)
 ;     4 - BIFDT  (req) Forecast date.
 ;
 D FULL^VALM1
 I '$G(BILET) D ERROR(609) Q
 I '$D(^BILET(BILET,0)) D ERROR(610) Q
 S:'$D(BIIOP) BIIOP="HOME"
 I '$G(BIFDT) D ERROR(616) Q
 S BICRT=$S(($E(IOST)="C")!(IOST["BROWSER"):1,1:0)
 ;
 ;---> Quit if no patients retrieved. (Next line was v8.0 patch 1.)
 I $O(^TMP("BIDUL",$J,0))="" D  Q
 .U IO
 .W !!?3,"NOTE: Based on the criteria you selected, no Immunization Due"
 .W !?9,"letters were printed."
 .D:BICRT DIRZ^BIUTL3() W:'BICRT @IOF
 ;
 ;---> Loop through ^TMP("BIDUL",$J,...,BIDFN) printing Due Letters.
 N BIDFN,BILCNT,BIPOP,N,M,P
 S BILCNT=0,BIPOP=0
 ;
 S N=0
 F  S N=$O(^TMP("BIDUL",$J,N)) Q:N=""  D  Q:BIPOP
 .S M=0
 .F  S M=$O(^TMP("BIDUL",$J,N,M)) Q:M=""  D  Q:BIPOP
 ..S P=0
 ..F  S P=$O(^TMP("BIDUL",$J,N,M,P)) Q:P=""  D  Q:BIPOP
 ...S BIDFN=0
 ...F  S BIDFN=$O(^TMP("BIDUL",$J,N,M,P,BIDFN)) Q:'BIDFN  D  Q:BIPOP
 ....N N,M,P
 ....S IOP=BIIOP D ^%ZIS
 ....D PRINT^BILETPR(BIDFN,BILET,BIDLOC,BIIOP,BIFDT,.BIPOP)
 ....S BILCNT=BILCNT+1
 ;
 S IOP=BIIOP D ^%ZIS
 U IO
 W !!?10,"Immunization Due Letters printed: ",BILCNT
 W !?10,$$NOW^BIUTL5()
 D:BICRT DIRZ^BIUTL3() W:'BICRT @IOF
 D ^%ZISC
 Q
 ;
 ;
 ;----------
ERROR(BIERR) ;EP
 ;---> Report error, either to screen or print.
 ;---> Parameters:
 ;     1 - BIERR  (ret) Text of Error Code if any, otherwise null.
 ;
 S:'$G(BIERR) BIERR=999
 D ERRCD^BIUTL2(BIERR,,1)
 S BIPOP=1
 Q
