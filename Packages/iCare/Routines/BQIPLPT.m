BQIPLPT ;PRXM/HC/ALA-Get Patient List by Panel ; 27 Oct 2005  2:14 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN(DATA,OWNR,PLIEN) ; EP -- BQI GET PATIENT LIST BY PANEL
 ;
 ;Description
 ;  Gets a list of patients by owner and panel in the designated
 ;  display order
 ;Input
 ;  OWNR  - owner of the panel
 ;  PLIEN - panel internal entry number
 ;Output
 ;  DATA  - name of global (passed by reference) in which the data
 ;          is stored
 ;
 NEW UID,II,PDFN,X
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLPT",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLPT D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ;  if no patients in panel, get header and return empty values
 I $O(^BQICARE(OWNR,1,PLIEN,40,0))="" D HDR G DONE
 ;
 ;  for every patient in the panel, get the patient list data in display order
 S PDFN=0
 F  S PDFN=$O(^BQICARE(OWNR,1,PLIEN,40,PDFN)) Q:'PDFN  D
 . D EN^BQIPLVWP(.DATA,OWNR,PLIEN,PDFN)
 ;
DONE ;
 S II=II+1,@DATA@(II)=$C(31)
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
HDR ;EP - Get the header if no patients are in the file
 NEW LIEN,NIEN
 D EN^BQIPLVWP(.DATA,OWNR,PLIEN,"")
 S LIEN=""
 S LIEN=$O(@DATA@(LIEN),-1) Q:'LIEN
 I LIEN=1,$P(@DATA@(LIEN),$C(30),1)?1."^" K @DATA@(LIEN) S II=II-1
 Q
