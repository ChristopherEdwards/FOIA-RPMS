BQIPLDFN ;PRXM/HC/DB-Get list of DFNs for a Panel ; 1 Mar 2007  5:13 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
RET(DATA,OWNR,PLIEN) ; PEP -- BQI GET DFN LIST BY PANEL
 ;
 ;Description
 ;
 ;Input
 ;  OWNR  = User identifier if DUZ is a shared person
 ;  PLIEN = Panel IEN
 ;
 NEW UID,II,DFN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLDFN",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLDFN D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="I00010DFN"_$C(30)
 S DFN=0
 F  S DFN=$O(^BQICARE(OWNR,1,PLIEN,40,DFN)) Q:'DFN  D
 . S II=II+1
 . S @DATA@(II)=DFN_$C(30)
 ;
DONE ; Finish the RPC call
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
