BQIUTB6 ;GDIT/HCSD/ALA-Table Utility ; 13 Jul 2015  8:00 AM
 ;;2.5;ICARE MANAGEMENT SYSTEM;;May 24, 2016;Build 27
 ;
 ;
TIME(DATA,PARM) ;EP - BQI GET TIMEFRAMES
 NEW UID,II,X
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP(UID,"BQITABLE"))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 S PARM=$G(PARM,"") I PARM="" Q
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIUTB D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 NEW LN,BZ
 K BZ
 S II=0,LN=""
 S @DATA@(II)="T00010CODE^T00060DESC"_$C(30)
 S ORD=""
 F  S ORD=$O(^BQI(90506.9,"D",PARM,ORD)) Q:ORD=""  D
 . S LN=$O(^BQI(90506.9,"D",PARM,ORD,""))
 . S II=II+1,@DATA@(II)=$P(^BQI(90506.9,LN,0),U,3)_"^"_$P(^BQI(90506.9,LN,0),U,1)_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
MON(DATA) ;EP - Month
 NEW BI,TEXT
 K @DATA
 S II=0
 S @DATA@(II)="T00010CODE^T00030"_$C(30)
 F BI=1:1 S TEXT=$T(MLS+BI) Q:TEXT=" Q"  D
 . S TEXT=$P(TEXT,";;",2) I TEXT="" Q
 . S II=II+1,@DATA@(II)=$P(TEXT,U,1)_U_$P(TEXT,U,2)_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
MLS ;
 ;;01^January^Jan
 ;;02^February^Feb
 ;;03^March^Mar
 ;;04^April^Apr
 ;;05^May^May
 ;;06^June^Jun
 ;;07^July^Jul
 ;;08^August^Aug
 ;;09^September^Sep
 ;;10^October^Oct
 ;;11^November^Nov
 ;;12^December^Dec
 Q
