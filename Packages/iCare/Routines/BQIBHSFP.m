BQIBHSFP ;VNGT/HS/BEE - Behav Health Suicide Form Print ; 19 Jul 2006  10:35 AM
 ;;2.2;ICARE MANAGEMENT SYSTEM;;Jul 28, 2011;Build 37
 ;
 Q
 ;
EN(DATA,BQIHSF) ; EP - BQI BH PRINT SUICIDE FORM
 ;Description
 ;  Print a selected suicide form for a patient
 ;
 ;Input
 ;  BQIHSF - Internal IEN of the suicide form
 ;
 ;Output
 ;  DATA - Name of global in which data is stored(^TMP("BQIBHSFP"))
 ;
 NEW UID,II,APCDSF,APCDX,AM
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIBHSFP",UID))
 K @DATA
 ;
 S II=0
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIBHSFP D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 D HDR
 ;
 S APCDSF=BQIHSF
 ;
 ;Compile Form
 K ^TMP("APCDS",$J)
 D EP2^APCDLES1(APCDSF)
 ;
 S II=II+1,@DATA@(II)="********** CONFIDENTIAL PATIENT INFORMATION ["_$P(^VA(200,DUZ,0),U,2)_"]  "_$$FMTE^XLFDT(DT)_" **********"_$C(13)_$C(10)
 ;
 S APCDX=0 F  S APCDX=$O(^TMP("APCDS",$J,"DCS",APCDX)) Q:APCDX'=+APCDX  D
 .S AM=$G(^TMP("APCDS",$J,"DCS",APCDX))
 .S AM=$$STRIP^XLFSTR(AM,"^")
 .S II=II+1,@DATA@(II)=AM_$C(13)_$C(10)
 S @DATA@(II)=$G(@DATA@(II))_$C(30)
 ;
DONE ;
 ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
HDR ;
 S @DATA@(II)="T01024REPORT_TEXT"_$C(30)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
