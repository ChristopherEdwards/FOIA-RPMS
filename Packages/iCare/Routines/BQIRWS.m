BQIRWS ;PRXM/HC/ALA - Patient Wellness Summary ; 19 Jul 2006  10:35 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN(DATA,DFN,TYPE) ; EP -- BQI PATIENT WELLNESS SUMMARY
 ;Description
 ;  Generates a Patient Wellness Summary for a given DFN
 ;
 ;Input
 ;  DFN - Patient Internal ID
 ;
 ;Output
 ;  DATA - Name of global in which data is stored(^TMP("BQIRWS"))
 ;
 NEW UID,X,BQII,HSTEXT,HSPATH,HSFN,Y,I,N,ENT,DATAR
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIRWS",UID))
 K @DATA
 ;
 S BQII=0
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIRWS D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ;  Check for patch
 I '$$PATCH^XPDUTL("APCH*2.0*15") S BMXSEC="Patch APCH*2.0*15 is not installed. Please contact your system manager." Q
 ;
 D HDR
 ;
 ; If BJPC v2.0 is loaded use new Patient Wellness Handout
 ; *** Note: TYPE must be passed - it corresponds to the HEALTH SUMMARY PWH TYPE ***
 ;
 I $$VERSION^XPDUTL("BJPC")'<2.0 D  G DONE
 . ; Data is returned from APCHPWH1 in ^TMP($J,"APCHPWH")
 . ; This cannot be run asynchronously since $J is used to subscript
 . ; temporary globals in APCHPWH1
 . ; 
 . S DATAR=$NA(^TMP($J,"APCHPWH"))
 . K @DATAR
 . ;
 . I $G(TYPE)="" S BMXSEC="RPC Call Failed: Missing Patient Wellness Handout type" Q
 . I TYPE'?.N S TYPE=$O(^APCHPWHT("B",TYPE,""))
 . I TYPE="" S BMXSEC="RPC Call Failed: Patient Wellness Handout type does not exist in RPMS" Q
 . D EP^APCHPWH1(DFN,TYPE)
 . I '$O(@DATAR@(0)) Q
 . S ENT=0 F  S ENT=$O(@DATAR@(ENT)) Q:ENT=""  D
 .. S BQII=BQII+1,@DATA@(BQII)=@DATAR@(ENT)_$C(13)_$C(10)
 . S BQII=BQII+1,@DATA@(BQII)=$C(30)
 ;
 I $$TMPFL^BQIUL1("W",UID,DFN) G DONE
 ;
 NEW IOSL,IOM,IOST
 S IOSL=999,IOM=80,IOST="P-OTHER80"
 U IO D PRINT^APCHPMH
 U IO W $C(9)
 ;
 I $$TMPFL^BQIUL1("C") G DONE
 I $$TMPFL^BQIUL1("R",UID,DFN) G DONE
 ;
 F  U IO R HSTEXT:.1 Q:HSTEXT[$C(9)  D
 . S HSTEXT=$$STRIP^XLFSTR(HSTEXT,"^")
 . I HSTEXT="" S HSTEXT=" "
 . S BQII=BQII+1,@DATA@(BQII)=HSTEXT_$C(13)_$C(10)
 S BQII=BQII+1,@DATA@(BQII)=$C(30)
 ;
 I $$TMPFL^BQIUL1("C") G DONE
 I $$TMPFL^BQIUL1("D",UID,DFN) G DONE
 ;
DONE ;
 ;
 S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
HDR ;
 S @DATA@(BQII)="T01024REPORT_TEXT"_$C(30)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(BQII),$D(DATA) S BQII=BQII+1,@DATA@(BQII)=$C(31)
 I $$TMPFL^BQIUL1("C")
 Q
