BQICMRUN ;VNGT/HS/BEE - Care Management - Calculate Last Run Date ; 7 Apr 2009  10:35 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN(DATA,DFN,SOURCE) ; EP - BQI GET LAST CARE MGT RUN
 ;
 ; Input
 ;  DFN - Patient Internal ID
 ;  SOURCE - Lookup (either NAME or IEN) to File #90506.5
 ;  
 ;  Get the Care Manager Last Run Information
 ;
 NEW UID,II,HDR,DA,NEDT,WEDT,LRDT,SEDT,SIEN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQICMRUN",UID))
 K @DATA
 ;
 S DFN=$G(DFN,""),SOURCE=$G(SOURCE,"")
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIGPRUN D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S HDR="D00030LAST_RUN_DATETIME"
 S @DATA@(II)=HDR_$C(30)
 ;
 S DA=$O(^BQI(90508,0)) I 'DA G DONE
 ;
 ;Pull Nightly/Weekly Run Completion Times - Determine most recent
 S NEDT=$$GET1^DIQ(90508,DA_",",3.23,"I")
 S WEDT=$$GET1^DIQ(90508,DA_",",4.02,"I")
 S LRDT=WEDT S:NEDT>LRDT LRDT=NEDT
 ;
 ;Handle Individual Patient/SOURCE, if provided
 I DFN]"",SOURCE]"" D
 .;
 .;Check for valid iCare Patient
 .I '$D(^BQIPAT(DFN)) Q
 .;
 .;Convert SOURCE to IEN if necessary
 .I SOURCE'?1N.N S SOURCE=$O(^BQI(90506.5,"B",SOURCE,"")) Q:SOURCE'?1N.N
 .;
 .;Look up entry
 .S SIEN=$O(^BQIPAT(DFN,60,"B",SOURCE,"")) Q:SIEN=""
 .S SEDT=$$GET1^DIQ(90507.56,SIEN_","_DFN_",",".02","I")
 .S:SEDT]"" LRDT=SEDT
 ;
 ;Convert to external date
 S:LRDT]"" LRDT=$$FMTE^BQIUL1(LRDT)
 ;
 S II=II+1,@DATA@(II)=LRDT_$C(30)
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
