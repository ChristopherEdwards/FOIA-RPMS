AGGFTVAL ;VNGT/HS/BEE-AGG Family/Tribal/NOK RPC Calls ; 07 Apr 2010  7:05 PM
 ;;1.0;PATIENT REGISTRATION GUI;;Nov 15, 2010
 ;
QNT(DATA,TTRI,TTRQ,AGGPTTRI,AGGPTTRQ,AGGPTBLQ,AGGPTCLB,OTHTRIB) ;EP -- AGG QUANTUM VALIDATION
 ;
 ;Input
 ;  TTRI - New Other Tribe Tribe
 ;  TTRQ - New Other Tribe Quantum
 ;  AGGPTTRI - Tribe of Membership
 ;  AGGPTTRQ - Tribe of Membership Blood Quantum
 ;  AGGPTBLQ - Indian Blood Quantum
 ;  AGGPTCLB - Classification/Beneficiary
 ;  OTHTRIB - Other Tribe Multiple Field Information
 ;
 NEW UID,II,LIST,BN,BQ,RESULT,OTHTOT,CLBEN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("AGGFTVAL",UID))
 K @DATA
 S II=0,MSG=""
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^AGGFTVAL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="I00010RESULT^T00100ERROR"_$C(30)
 ;
 ;Skip check if classification/beneficiary is not Indian/Alaskan Native
 S CLBEN=$O(^AUTTBEN("B","INDIAN/ALASKA NATIVE",""))  ;Get Classification IEN
 I AGGPTCLB]"",AGGPTCLB'=CLBEN G DONE
 ;
 ;Skip check if we are not recording tribal quantums
 I $P($G(^AGFAC(DUZ(2),0)),U,2)'="Y" G DONE
 ;
 ; Get list of current Other Tribe entries
 S OTHTRIB=$G(OTHTRIB,"")
 I OTHTRIB="" D
 . S LIST="",BN=""
 . F  S BN=$O(OTHTRIB(BN)) Q:BN=""  S LIST=LIST_OTHTRIB(BN)
 . K OTHTRIB
 . S OTHTRIB=LIST
 . K LIST
 ;
 ;Parse Parameters to get total Other Tribe Quantum (excluding new value)
 S OTHTOT=0
 F BQ=1:1:$L(OTHTRIB,$C(28)) D
 . N PDATA,NAME,VALUE,BP,BV
 . S PDATA=$P(OTHTRIB,$C(28),BQ) Q:PDATA=""
 . S NAME=$P(PDATA,"=",1) Q:NAME'="AGGOTTRQ"
 . S VALUE=$P(PDATA,"=",2,99) Q:VALUE=""
 . F BP=1:1:$L(VALUE,$C(29)) S BV=$P(VALUE,$C(29),BP) D
 .. I BV="FULL"!(BV="F") S BV=1
 .. I BV="NONE"!(BV="UNKNOWN")!(BV="UNSPECIFIED") S BV=0
 .. I BV["/" D
 ... N BV1,BV2
 ... S BV1=$P(BV,"/")
 ... S BV2=$P(BV,"/",2) I +BV2=0 S BV=0 Q
 ... S BV=BV1/BV2
 .. S OTHTOT=OTHTOT+(BV)
 ;
 ;Add in new Other Tribe Quantum
 I TTRQ="FULL"!(TTRQ="F") S TTRQ=1
 I TTRQ="NONE"!(TTRQ="UNKNOWN")!(TTRQ="UNSPECIFIED") S TTRQ=0
 I TTRQ["/" D
 . N T1,T2
 . S T1=$P(TTRQ,"/")
 . S T2=$P(TTRQ,"/",2) I +T2=0 S TTRQ=0 Q
 . S TTRQ=T1/T2
 S OTHTOT=OTHTOT+TTRQ
 ;
 ;Perform Quantum checks
 S RESULT=$$QUANT^AGGUL2(AGGPTBLQ,AGGPTTRQ,OTHTOT)
 ;
 S II=II+1,@DATA@(II)=RESULT_$C(30)
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
