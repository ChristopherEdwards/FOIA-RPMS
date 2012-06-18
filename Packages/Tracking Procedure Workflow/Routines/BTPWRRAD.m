BTPWRRAD ;VNGT/HS/ALA-Print Radiology Report ; 04 Feb 2009  9:22 AM
 ;;1.0;CARE MANAGEMENT EVENT TRACKING;;Feb 07, 2011
 ;
 ;
EN(DATA,DFN,RACASE) ; EP -- BTPW RAD REPORT DISPLAY
 ;Description
 ;  Generates a Display of a Radiology Record
 ;
 ;Input
 ;  DFN    - Patient IEN
 ;  RACASE - Radiology Case Number
 ;
 NEW UID,II,RAUTOE,RAXAM,RARPT,BN,QFL,RAY0,RAY1,RAY2,RAY3
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BTPWRRAD",UID))
 K @DATA
 ;
 S II=0
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BTPWRRAD D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 D HDR
 ;
 K ^TMP($J,"RA AUTOE")
 S RAXAM=$$FND(DFN,RACASE),RAUTOE=1
 S RARPT=+$P(RAXAM,"^",9),QFL=0
 I RARPT D  I QFL G DONE
 . NEW X
 . S X=$G(^RARPT(+$G(RARPT),0))
 . D INIT^RARTR
 . I RAY0<0 S II=II+1,@DATA@(II)="Missing zero node data from the Patient File (2)",QFL=1
 . I RAY1<0 S II=II+1,@DATA@(II)="Missing zero node data from the Rad/Nuc Med Patient File (70)",QFL=1
 . I RAY2<0 S II=II+1,@DATA@(II)="Missing Registered Exams data",QFL=1
 . I RAY3<0 S II=II+1,@DATA@(II)="Missing Examinations data",QFL=1
 . I QFL S II=II+1,@DATA@(II)=$C(30) Q
 . K ^TMP($J,"RA AUTOE")
 D:RARPT PRT^RARTR
 S BN=0
 F  S BN=$O(^TMP($J,"RA AUTOE",BN)) Q:'BN  D
 . S II=II+1,@DATA@(II)=^TMP($J,"RA AUTOE",BN)_$C(13)_$C(10)
 ;
 S II=II+1,@DATA@(II)=$C(30)
 ;
DONE ;
 ;
 K ^TMP($J,"RA AUTOE")
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
 S II=II+1,@DATA@(II)=$C(31)
 I $$TMPFL^BQIUL1("C")
 Q
 ;
FND(RADFN,RARPT) ;EP
 NEW RETURN,RCASE
 S RETURN=""
 S RARPN=$O(^RARPT("B",RARPT,"")) I RARPN="" Q RETURN
 S RDTM=0
 F  S RDTM=$O(^RADPT(RADFN,"DT",RDTM)) Q:RDTM="AP"  D
 . S RPRCN=0
 . F  S RPRCN=$O(^RADPT(RADFN,"DT",RDTM,"P",RPRCN)) Q:'RPRCN  D
 .. I $P(^RADPT(RADFN,"DT",RDTM,"P",RPRCN,0),U,17)'=RARPN Q
 .. S RCASE=^RADPT(RADFN,"DT",RDTM,"P",RPRCN,0)
 .. S RETURN=RADFN_U_RDTM_U_RPRCN_U_$P(^DPT(RADFN,0),U,1)_U_U_U_$P(RCASE,U,1)_U_U_RARPN_U_$P(RCASE,U,3)
 Q RETURN
