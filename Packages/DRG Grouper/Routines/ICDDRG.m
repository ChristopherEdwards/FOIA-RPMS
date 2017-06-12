ICDDRG ;ALB/GRR/EG/ADL - Assigns DRG Codes ;04/21/2014
 ;;18.0;DRG Grouper;**2,7,10,14,20,31,37,57**;Oct 20, 2000;Build 7
 ;
 ; ADL - Updated for Code Set Versioning 03/10/2003
 ; KER - Updated for ICD-10              06/30/2012
 ;               
 ; Global Variables
 ;    None
 ;               
 ; External References
 ;    ^ICDDRG0            ICR  N/A
 ;    EN1^ICDDRG5         ICR  N/A
 ;    EN1^ICDDRG8         ICR  N/A
 ;    $$GETDRG^ICDEX      ICR  N/A
 ;    $$ICDDX^ICDEX       ICR  N/A
 ;    $$ICDOP^ICDEX       ICR  N/A
 ;    $$ISA^ICDEX         ICR  N/A
 ;    $$MDCD^ICDEX        ICR  N/A
 ;    $$MDCT^ICDEX        ICR  N/A
 ;    $$MOR^ICDEX         ICR  N/A
 ;    MDCG^ICDEX          ICR  N/A
 ;               
 ; Local Variables NEWed or KILLed in ICDDRGM
 ;     ICDDATE,ICDDMS,ICDDRG,ICDDX,ICDEXP,ICDMDC,ICDPRC,ICDRTC
 ;     ICDS24,ICDTMP,ICDTRS,SEX
 ;     
TOP ; Main Entry Point
 K ICDDRG,ICDMDC,ICDRTC S (ICDDRG,ICDMDC,ICDRTC)=""
 ; Check for Invalid Input Variables
 I +($G(ICDDX(1)))'>0 S ICDRTC=1 G ERR
 ;   Patient Expired?
 I ICDEXP'=0&(ICDEXP'=1)&(ICDEXP'="") S ICDRTC=5 G ERR
 ;   Patient Transferred
 I ICDTRS'=0&(ICDTRS'=1)&(ICDTRS'="") S ICDRTC=6 G ERR
 ;   Patient Discharged against Medical Advice
 I ICDDMS'=0&(ICDDMS'=1)&(ICDDMS'="") S ICDRTC=7 G ERR
 ;   Patient Sex
 I SEX'="M"&(SEX'="F")&(SEX'="") S ICDRTC=4 G ERR
 ;   Default is today's FileMan date
 I '$D(ICDDATE) S ICDDATE=DT
 ;
PRI ; Primary Diagnosis Related Variables
 D KILL S ICDSEX($S(SEX="M":1,SEX="F":2,1:0))=""
 S ICDTMP=$$ICDDX^ICDEX(+($G(ICDDX(1))),ICDDATE,,"I")
 ;   Error if not found
 I ICDTMP<0 S ICDRTC=1 G ERR
 S ICDY(0)=$P(ICDTMP,U,2,99)
 ;   Error if unacceptable or inactive
 I $P(ICDY(0),"^",4)=1!($P(ICDY(0),"^",9)=0) S ICDRTC=1 G ERR
 S ICDMDC=$P(ICDY(0),"^",5),ICDPD=$P(ICDY(0),"^",2),ICDRG=0
 I $T(+2)[",57**",$$CSI^ICDEX(80,+($G(ICDDX(1))))=1 S ICDPD=$TR(ICDPD,";")
 ;   Error if no MDC
 I 'ICDMDC S ICDRTC=1 G ERR
 D MDCG^ICDEX(+($G(ICDDX(1))),ICDDATE,.ICDMDC)
 S:$O(ICDMDC(0))>0 ICDMDC=$P(ICDY(0),"^",5)
 I $D(ICDMDC(12))!($D(ICDMDC(13))) S ICDMDC=$S(SEX="F":13,1:12) I SEX="" S ICDRTC=4 G ERR
 S ICDTMP=$$GETDRG^ICDEX(80,+($G(ICDDX(1))),ICDDATE) I ICDTMP>0 S ICDPDRG=$P(ICDTMP,";") D
 . F ICDI=1:1 Q:$P(ICDPDRG,"^",ICDI)']""  S ICDPDRG($P(ICDPDRG,"^",ICDI))="",ICDRG($P(ICDPDRG,"^",ICDI))=""
 S ICD104=0,ICDP24=$P(ICDY(0),"^",12),ICDP25=$P(ICDY(0),"^",13) D SEX
 ;   The following establishes Secondary Diagnosis Variables
 S (ICDCCT,ICDMCCT,ICDSD)="",ICDCC=0,ICDMCC=0,ICDI=1
 F ICDIZ=0:0 S ICDI=$O(ICDDX(ICDI)) Q:ICDI'>0  D  G:ICDRTC]"" ERR
 . S ICDTMP=$$ICDDX^ICDEX(+($G(ICDDX(ICDI))),ICDDATE,,"I")
 . I ICDTMP<0!'($P(ICDTMP,U,10)) S ICDRTC=8 Q
 . S ICDY(0)=$P(ICDTMP,U,2,99),ICDDXT($P(ICDY(0),"^",1))=""
 . S ICDP15($S($P(ICDY(0),"^",2)["J":1,1:0))=""
 . D SEC,SEX G:ICDRTC]"" ERR
 S:$D(ICDCCT(1)) ICDCC=1 K ICDCCT
 S:$D(ICDMCCT(1)) ICDMCC=1 S:$D(ICDMCCT(2)) ICDMCC=2 K ICDMCCT
 ;   The following establishes Operation/Prodedure Variables
 N ICDOTMP S (ICDMAJ,ICDORNI,ICDOP,ICDOR,ICDOTMP)="",(ICDOCNT,ICDONR,ICDORNR,ICDNOR,ICDOPCT,ICDOPNR)=0
 ;   Return ICD Operation/Procedure code info check if active
 I $D(ICDPRC) F ICDI=1:1 Q:'$D(ICDPRC(ICDI))  X "S ICDTMP=$$ICDOP^ICDEX(+($G(ICDPRC(ICDI))),ICDDATE,,""I"") I ICDTMP<0!'($P(ICDTMP,U,10)) S ICDRTC=2 Q" I ICDRTC="" D 
 . S ICDY(0)=$P(ICDTMP,U,2,99),ICDNOR=ICDNOR+1,ICDY=+($G(ICDPRC(ICDI))),ICDO24($S($P(ICDY(0),"^",3)'="":$P(ICDY(0),"^",3),1:"N"))="" D OPS,SEX
 K ICDO24("N") G:ICDRTC]"" ERR
 G ^ICDDRG0
 ;
SEC ; Secondary Diagnosis
 ;   Is Secondary NCC for Primary
 I ICDDATE>3070930.9 D
 . S ICDMCC=$S(+($$ISA^ICDEX(+($G(ICDDX(ICDI))),+($G(ICDDX(1))),1.11))>0:0,$P(ICDY(0),"^",18)=2:2,($P(ICDY(0),"^",18)=1)&(ICDMCC'=2):1,1:ICDMCC),ICDMCCT(ICDMCC)=""
 E  D
 . S ICDCC=$S(+($$ISA^ICDEX(+($G(ICDDX(ICDI))),+($G(ICDDX(1))),1.11))>0:0,$P(ICDY(0),"^",7)=1:1,1:ICDCC),ICDCCT(ICDCC)=""
 ;   Group ICD identifiers in one variable
 I $L($P(ICDY(0),"^",2)) S ICDSD=$$TM(ICDSD,";")_";"_$$TM($P(ICDY(0),"^",2),";"),ICDSD=";"_$$TM(ICDSD,";")_";"
 S ICDTMP=$$GETDRG^ICDEX(80,+($G(ICDDX(ICDI))),ICDDATE)
 ;   If any of the following conditions are met set ICDSDRG array
 I (($P(ICDY(0),"^",7)=1)!(ICDPD["h")!(ICDPD["J")!(ICDSD["h")),'$P(ICDTMP,";",3) D
 . S ICDSDRG=$P(ICDTMP,";") F ICDK=1:1 Q:$P(ICDSDRG,"^",ICDK)']""  S ICDSDRG($P(ICDSDRG,"^",ICDK))=""
 S ICDS24($S($P(ICDY(0),"^",12)'="":$P(ICDY(0),"^",12),1:"N"))="",ICDS25($S($P(ICDY(0),"^",13)'="":$P(ICDY(0),"^",13),1:0))=""
 K ICDS24("N"),ICDS25(0) Q
 ;
OPS ; Operation/Procedures
 I '$D(ICDOP(" "_$P(ICDY(0),"^",1))) S ICDOP(" "_$P(ICDY(0),"^",1))="",ICDOCNT=ICDOCNT+1
 I $S($D(ICDMDC(12))!($D(ICDMDC(13)))>0:'$$MDCT^ICDEX(ICDY,ICDDATE,.ICDMDC,0),1:'$$MDCD^ICDEX(ICDY,ICDMDC,ICDDATE)) D
 . S ICDONR=ICDONR+1,ICDORNI=ICDORNI_$P(ICDY(0),"^",2),ICDORNI($S($P(ICDY(0),"^",2)'="":$P(ICDY(0),"^",2),1:0))="" S:ICDORNR'=0 ICDORNR=1
 I $L($P(ICDY(0),"^",2)) S ICDOR=$$TM(ICDOR,";")_";"_$$TM($P(ICDY(0),"^",2),";"),ICDOR=";"_$$TM(ICDOR,";")_";"
 I +ICDY(0)>37.69,+ICDY(0)<37.84,ICDOR'["p" D
 . N ICDCC3 D EN1^ICDDRG5 I ICDCC3 S ICDOR=ICDOR_"p" S:ICDOR'["O" ICDOR=ICDOR_"O"
 I +ICDY(0)>80.999 I +ICDY(0)<81.40 N ICDCC3 D EN1^ICDDRG8 I ICDCC3 S ICDOR=ICDOR_"F"
 ;   Major OR Procedure
 S:$L($$MOR^ICDEX(ICDY)) ICDMAJ=ICDMAJ_$P($$MOR^ICDEX(ICDY),"^")_"^"
 ;   Set ICDOTMP with DRGs for doing checks
 S ICDOTMP=$P($$GETDRG^ICDEX(80.1,ICDY,ICDDATE,$G(ICDMDC)),";",1) S:+ICDOTMP'>0 ICDOTMP=""
 I $P(ICDY(0),"^",2)["O" D
 .S ICDOPCT=ICDOPCT+1
 .I ICDOPNR=0 D
 ..I $S($D(ICDMDC(12))!($D(ICDMDC(13)))>0:'$$MDCT^ICDEX(ICDY,ICDDATE,.ICDMDC,0),1:'$D(ICDOTMP)) S ICDOPNR=1
 I +ICDOTMP>0 S ICDF=ICDOTMP F ICDFX=1:1 Q:$P(ICDF,"^",ICDFX)']""  S ICDODRG($P(ICDF,"^",ICDFX))=$P(ICDF,"^",ICDFX)
 ;   Translate identifiers into common symbol, check for symbol
 S ICD104=$S($P(ICDY(0),"^",2)["P":1,1:0),ICDNMDC($S($TR($P(ICDY(0),"^",2),"lqtrB","\\\\")["\":1,1:0))="" Q
 ;
 ; Miscellaneous
ERR ;   Error Occured
 S ICDDRG=$S(ICDDATE>3070930.9:999,1:470)
 Q
SEX ;   Get sex for DX or Procedure
 S ICDSEX($S($P(ICDY(0),"^",10)="M":1,$P(ICDY(0),"^",10)="F":2,1:0))=""
 Q
TM(X,Y) ;   Trim Y
 S Y=$G(Y) S:'$L(Y) Y=" "
 F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
 Q X
KILL ;   Clean Environment
 K ICD104,ICDJ,ICDJJ,ICDOCNT,ICDOR,ICDNOR,ICDP15,ICDPDRG,ICDRG,ICDSEX
 K ICDSDRG,ICDODRG,ICDCC,ICDMCC,ICDOP,ICDORNR,ICDORNI,ICDP24,ICDP25,ICDPD
 K ICDSD,ICDI,ICDK,ICDF,ICDFX,ICDFK,ICDY,ICDDXT,ICDIZ,ICDONR,ICDOPCT
 K ICD,ICDCC2,ICDCC3,ICDGH,ICDL39,ICDMAJ,ICDNMDC,ICDNSD,ICDORNA,ICDREF
 K ICDS24,ICDS25,ICDOPNR,ICDO24,ICDO25
 Q
