BQIRREG ;PRXM/HC/DB - Register Reports ; 1 Nov 2007  10:35 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;**1**;Feb 07, 2011;Build 5
 ;
 Q
 ;
 ; Will need to address missing/unpopulated taxonomies
 ;
SSR(DATA,PLIST) ; EP -- BQI PATIENT STATE SURV
 ;Description
 ;  Generates a State Surveillance report for a list of DFNs
 ;
 ;Input
 ;  PLIST - Either set to a single Patient Internal ID or
 ;          in an array in the following format:
 ;          
 ;          PLIST(IX)=DFN_$C(28)
 ;
 ;Output
 ;  DATA - Name of global in which data is stored(^TMP("BQISSR"))
 ;
 NEW UID
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQISSR",UID))
 K @DATA
 D EN^BKMQSSR(DATA,.PLIST)
 Q
 ;
QOC(DATA,BKMRPOP,BKMEDT,OWNR,PLIEN,BKMTAG,DFN) ; EP -- BQI PATIENT QUALITY OF CARE
 ;
 ; Input:
 ;    BKMEDT - Ending date for report
 ;    OWNR   - Owner Internal Entry Number if running report by panel
 ;    PLIEN  - Panel Internal Entry Number if running report by panel
 ;    DFN    - Either set to a single Patient Internal ID or
 ;             in an array in the following format:
 ;          
 ;          DFN(IX)=DFN_$C(28)
 ;    BKMRPOP - Patient selection criteria:
 ;            - R = Active on HMS Register
 ;            - D = Active HIV/AIDS Diagnostic Tag
 ;            - P = By selected patients
 ;    BKMTAG  - If BKMRPOP is by Diagnostic Tag, identifies the status:
 ;            - Proposed
 ;            - Accepted
 ;            - Proposed or Accepted
 ;
 NEW UID
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIQOC",UID))
 K @DATA
 D RUN^BKMQQCR(.DATA,BKMRPOP,BKMEDT,$G(OWNR),$G(PLIEN),$G(BKMTAG),.DFN)
 Q
 ;
QOCTR(DATA,RPOP) ; EP - BQI QOC TRIGGER HMS
 ;
 ; Input
 ;   RPOP - Report Population - if the user selected anything other than
 ;          "D" for Active HIV/AIDS Diagnostic Tag, the Diagnostic Tag
 ;          Status prompt should be disabled
 ;
 NEW UID,II,ABLE
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIQOCTR",UID))
 K @DATA
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIRREG D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="T00008SOURCE^T00001ABLE_FLAG"_$C(30)
 S ABLE="N"
 I $G(RPOP)="D" S ABLE="Y"
 S II=II+1,@DATA@(II)="BKMTAG^"_ABLE_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
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
