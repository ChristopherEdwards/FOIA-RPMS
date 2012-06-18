BQIPTLNK ;VNGT/HS/ALA-Get patient record via Link ; 24 Apr 2009  10:42 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 ;
EN(DATA,LINK) ; EP -- BQI GET LINK RECORD
 ;
 ;Description
 ;  Returns a record for a patient's visit or problem or whatever type of data record
 ;Input
 ;   LINK - File Number:Record Internal Entry Number
 ;
 NEW UID,II,FILE,RECIEN,TEXT
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQILINK",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPTLNK D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 I $G(LINK)="" D HDR G DONE
 S FILE=$P(LINK,":",1),RECIEN=$P(LINK,":",2)
 I FILE=9000010 D GET^BQIPTVST(.DATA,RECIEN) Q
 D OTH
 ;I FILE=9000011 D EN^BQIRPL(.DATA,"","",RECIEN)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
OTH ;
 D HDR
 ;
 I $$TMPFL^BQIUL1("W",UID,RECIEN) G DONE
 ;
 S IOSL=999,IOM=80,IOST="P-OTHER80"
 ;
 U IO
 S DIC=$$ROOT^DILFD(FILE),DA=RECIEN
 D EN^DIQ
 U IO W $C(9)
 ;
 I $$TMPFL^BQIUL1("C") G DONE
 ;
 I $$TMPFL^BQIUL1("R",UID,RECIEN) G DONE
 ;
 F  U IO R HSTEXT:.1 Q:HSTEXT[$C(9)  D
 . S HSTEXT=$$STRIP^XLFSTR(HSTEXT,"^")
 . I HSTEXT="" S HSTEXT=" "
 . S II=II+1,@DATA@(II)=HSTEXT_$C(13)_$C(10)
 S II=II+1,@DATA@(II)=$C(30)
 ;
 I $$TMPFL^BQIUL1("C") G DONE
 ;
 I $$TMPFL^BQIUL1("D",UID,RECIEN) G DONE
 ;
DONE ;
 ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
HDR ;
 S @DATA@(II)="T01024REPORT_TEXT"_$C(30)
 I $G(FILE)'="" D
 . S TEXT="Record Data from "_$P(^DIC(FILE,0),U,1)_" file"
 . S II=II+1,@DATA@(II)=$$C^XBFUNC(TEXT,80)
 Q
