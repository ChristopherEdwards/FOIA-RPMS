AGGRPAT ;VNGT/HS/ALA-Recent Patient save and retrieve ; 16 May 2010  1:07 PM
 ;;1.0;PATIENT REGISTRATION GUI;;Nov 15, 2010
 ;
 ;
GET(DATA,FAKE) ; EP - AGG RECENT PATIENT RETRIEVE
 ; Input
 ;  FAKE - extra 'blank' parameter required by BMXNET async 'feature'
 ;   
 ; Output:
 ;   DATA  = name of global (passed by reference) in which the data is stored
 ;
 ; or
 ;   BMXSEC - if M error encountered
 ;            
 NEW UID,II,DIEN,SDT,INFO,SGLOB,CNT,QFL
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("AGGRPAT",UID))
 K @DATA
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^AGGRPAT D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ; Create header record
 ; I00010RESULT^
 S II=0,@DATA@(II)="I00010DIEN^T00030SDT^T01024INFO"_$C(30)
 ;
 S SGLOB=$NA(^XTMP("AGGRPAT",DUZ)),SDT="A",CNT=10,QFL=0
 ;F  S JJ=$O(@SGLOB@(JJ)) Q:'JJ  S PLIST=PLIST_$S(PLIST]"":$C(29),1:"")_JJ
 ;
 F  S SDT=$O(@SGLOB@(SDT),-1) Q:'SDT  D  Q:QFL
 . S DIEN=0
 . F  S DIEN=$O(@SGLOB@(SDT,DIEN)) Q:'DIEN  D  Q:QFL
 .. S LOC=DUZ(2)
 .. S INFO=$G(@SGLOB@(SDT,DIEN,LOC)) I INFO="" Q
 .. S II=II+1,@DATA@(II)=DIEN_"^"_$$FMTE^XLFDT(SDT)_"^"_INFO_$C(30)
 .. I II+1>CNT S QFL=1
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
SAVE(DATA,NUM,DIEN,INFO) ; EP - AGG SAVE RECENT PATIENT LIST
 ; Input
 ;   NUM   - Max number of enties to keep
 ;   DIEN  - (DFN) Patient's IEN
 ;   INFO  - extra data to be stored
 ;   
 ; Output:
 ;   DATA  = name of global (passed by reference) in which the data is stored
 ;   RESULT = 1 (unlock will always succeed)
 ;   RESULT = -1 if invalid patient IEN (shouldn't happen)
 ; or
 ;   BMXSEC - if M error encountered
 ;            
 NEW UID,II
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("AGGRPAT",UID))
 K @DATA
 ;
 ;Set to a minimum number or keep at a low of five
 I +$G(NUM)<1 S NUM=1
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^AGGRPAT D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ; Create header record
 S II=0,@DATA@(II)="I00010RESULT"_$C(30)
 NEW RESULT,I,SDT,IEN,CNT
 S RESULT=0
 S SGLOB=$NA(^XTMP("AGGRPAT",DUZ))
 S @SGLOB@(0)=$$FMADD^XLFDT(DT,1825)_U_DT_U_"Recent Patient List"
 ; Check to see if patient is already in list, if so remove old entry
 S SDT=0
 F  S SDT=$O(@SGLOB@(SDT)) Q:'SDT  D
 . S IEN=0 F  S IEN=$O(@SGLOB@(SDT,IEN)) Q:'IEN  I IEN=DIEN K @SGLOB@(SDT,IEN,DUZ(2))
 ; Save new entry
 S SDT=$$NOW^XLFDT()
 S @SGLOB@(SDT,DIEN,DUZ(2))=INFO
 ; Count entries
 S SDT=0,CNT=0
 F  S SDT=$O(@SGLOB@(SDT)) Q:'SDT  D
 . S IEN=0 F  S IEN=$O(@SGLOB@(SDT,IEN)) Q:'IEN  D
 .. I $O(@SGLOB@(SDT,IEN,""))="" K @SGLOB@(SDT,IEN) Q  ;Clean out entries without locations
 .. I $G(@SGLOB@(SDT,IEN,DUZ(2)))="" Q
 .. S CNT=CNT+1
 ; If list contains too many enties remove the extra entries
 F I=1:1:(CNT-NUM) D
 . S SDT=$O(@SGLOB@(0))
 . S IEN=$O(@SGLOB@(SDT,0))
 . I $G(@SGLOB@(SDT,IEN,DUZ(2)))="" Q
 . K @SGLOB@(SDT,IEN)
 ;
 S RESULT=1
 S II=II+1,@DATA@(II)=RESULT_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
