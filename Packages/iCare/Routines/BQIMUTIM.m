BQIMUTIM ;GDIT/HS/ALA-MU CQ Timeframes and Periods ; 10 Nov 2011  8:17 AM
 ;;2.3;ICARE MANAGEMENT SYSTEM;;Apr 18, 2012;Build 59
 ;
 ;
GTM ; Get period based on timeframe and starting month
 ; Input Parameters
 ;    PERIOD  - Starting Month
 ;    TMFRAME - 30 = 1 Month, 90 = 90 Days, 12 = 1 Year
 ; Output Parameters
 ;    CPER   - Current Period
 ;    PPER   - Previous Period
 ;    BQCDAR - Array of current months
 ;    BQPDAR - Array of previous months
 ;  
 NEW CURN,BEGDT,ENDT,PEDT,PRVDT,PRMON,PRVN,PBGDT,PENDT,BQMON,BQDTE,CTMBG,EDAY,CTMEN
 NEW BM,TMDT,PTMBG,PTMEN,CYR,PYR,NYR
 S CURN=$O(^BQI(90508,1,19,"B",PERIOD,""))
 S BEGDT=$P(^BQI(90508,1,19,CURN,0),U,2),ENDT=$P(^BQI(90508,1,19,CURN,0),U,3)
 ;
 ;S CYR=$E(DT,1,3),PYR=CYR-1,NYR=CYR+1
 ;
 K BQCDAR,BQPDAR
 I TMFRAME=30 D
 . S CYR=$E(BEGDT,1,3),PYR=CYR-1,NYR=CYR+1
 . S CPER=$$FMTE^BQIUL1(BEGDT)_" - "_$$FMTE^BQIUL1(ENDT)
 . S CURDT=$E(BEGDT,1,5)_"00",BQCDAR(CURDT)=""
 . S PEDT=$$FMADD^XLFDT(BEGDT,-1),PRVDT=$E(PEDT,1,5)_"00",BQPDAR(PRVDT)=""
 . S PRMON=$$FMTE^BQIUL1(PRVDT)
 . S PRVN=$O(^BQI(90508,1,19,"B",PRMON,""))
 . I PRVN="" S PPER="No Previous Period" Q
 . S PBGDT=$P(^BQI(90508,1,19,PRVN,0),U,2),PENDT=$P(^BQI(90508,1,19,PRVN,0),U,3)
 . S PPER=$$FMTE^BQIUL1(PBGDT)_" - "_$$FMTE^BQIUL1(PENDT)
 ;
 I TMFRAME=90 D
 . S CYR=$E(BEGDT,1,3),PYR=CYR-1,NYR=CYR+1
 . S BQMON=$E(BEGDT,4,5)
 . S BQDTE=$P($T(BQM+BQMON),";;",2)
 . S CTMBG=@($P(BQDTE,U,2))_$P(BQDTE,U,1)_"01"
 . S CURN=$O(^BQI(90508,1,19,"B",PERIOD,""))
 . S EDAY="31^"_($$LEAP^XLFDT2(CYR)+28)_"^31^30^31^30^31^31^30^31^30^31"
 . S CTMEN=@($P(BQDTE,U,6))_$P(BQDTE,U,5)_$P(EDAY,U,+$P(BQDTE,U,5))
 . S BQCDAR($E(CTMBG,1,5)_"00")="",BQCDAR($E(CTMEN,1,5)_"00")=""
 . S BQCDAR(@($P(BQDTE,U,4))_$P(BQDTE,U,3)_"00")=""
 . S CPER=$$FMTE^BQIUL1(CTMBG)_" - "_$$FMTE^BQIUL1(CTMEN)
 . S PTMBG=@($P(BQDTE,U,8))_$P(BQDTE,U,7)_"01"
 . S PTMEN=@($P(BQDTE,U,12))_$P(BQDTE,U,11)_$P(EDAY,U,+$P(BQDTE,U,1))
 . S PRVN=$O(^BQI(90508,1,19,"B",$E(PTMBG,1,5)_"00",""))
 . S BQPDAR($E(PTMBG,1,5)_"00")="",BQPDAR($E(PTMEN,1,5)_"00")=""
 . S BQPDAR(@($P(BQDTE,U,10))_$P(BQDTE,U,9)_"00")=""
 . S PPER=$$FMTE^BQIUL1(PTMBG)_" - "_$$FMTE^BQIUL1(PTMEN)
 ;
 I TMFRAME=12 D
 . S CYR=$E(BEGDT,1,3),PYR=CYR-1,NYR=CYR+1
 . S EDAY="31^"_($$LEAP^XLFDT2(CYR)+28)_"^31^30^31^30^31^31^30^31^30^31"
 . S BQMON=$E(BEGDT,4,5)
 . S BQDTE=$P($T(BQM+BQMON),";;",2)
 . S CTMBG=BEGDT
 . S CTMEN=@($P(BQDTE,U,14))_$P(BQDTE,U,13)_$P(EDAY,U,+$P(BQDTE,U,13))
 . S PTMBG=@($P(BQDTE,U,15))_$P(BQDTE,U,1)_"01"
 . S PTMEN=@($P(BQDTE,U,16))_$P(BQDTE,U,13)_$P(EDAY,U,+$P(BQDTE,U,13))
 . S CPER=$$FMTE^BQIUL1(CTMBG)_" - "_$$FMTE^BQIUL1(CTMEN)
 . S PPER=$$FMTE^BQIUL1(PTMBG)_" - "_$$FMTE^BQIUL1(PTMEN)
 . ;
 . F BM=$P(BQDTE,U,1):1:12 S TMDT=@($P(BQDTE,U,2))_$S($L(BM)=1:"0"_BM,1:BM)_"00",BQCDAR(TMDT)=""
 . F BM=1:1:$P(BQDTE,U,13) S TMDT=@($P(BQDTE,U,14))_$S($L(BM)=1:"0"_BM,1:BM)_"00",BQCDAR(TMDT)=""
 . F BM=$P(BQDTE,U,1):1:12 S TMDT=@($P(BQDTE,U,15))_$S($L(BM)=1:"0"_BM,1:BM)_"00",BQPDAR(TMDT)=""
 . F BM=1:1:$P(BQDTE,U,13) S TMDT=@($P(BQDTE,U,16))_$S($L(BM)=1:"0"_BM,1:BM)_"00",BQPDAR(TMDT)=""
 Q
 ;
BQM ; Period formats
 ;;01^CYR^02^CYR^03^CYR^10^PYR^11^PYR^12^PYR^12^CYR^PYR^PYR
 ;;02^CYR^03^CYR^04^CYR^11^PYR^12^PYR^01^CYR^01^NYR^PYR^CYR
 ;;03^CYR^04^CYR^05^CYR^12^PYR^01^CYR^02^CYR^02^NYR^PYR^CYR
 ;;04^CYR^05^CYR^06^CYR^01^CYR^02^CYR^03^CYR^03^NYR^PYR^CYR
 ;;05^CYR^06^CYR^07^CYR^02^CYR^03^CYR^04^CYR^04^NYR^PYR^CYR
 ;;06^CYR^07^CYR^08^CYR^03^CYR^04^CYR^05^CYR^05^NYR^PYR^CYR
 ;;07^CYR^08^CYR^09^CYR^04^CYR^05^CYR^06^CYR^06^NYR^PYR^CYR
 ;;08^CYR^09^CYR^10^CYR^05^CYR^06^CYR^07^CYR^07^NYR^PYR^CYR
 ;;09^CYR^10^CYR^11^CYR^06^CYR^07^CYR^08^CYR^08^NYR^PYR^CYR
 ;;10^CYR^11^CYR^12^CYR^07^CYR^08^CYR^09^CYR^09^NYR^PYR^CYR
 ;;11^CYR^12^CYR^01^NYR^08^CYR^09^CYR^10^CYR^10^NYR^PYR^CYR
 ;;12^CYR^01^NYR^02^NYR^09^CYR^10^CYR^11^CYR^11^NYR^PYR^CYR
