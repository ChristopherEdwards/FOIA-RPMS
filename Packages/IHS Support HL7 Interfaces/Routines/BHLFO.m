BHLFO ; cmi/flag/maw - BHL Get Inbound Filing Order ;
 ;;3.01;BHL IHS Interfaces with GIS;**12**;JUL 01, 2001
 ;
 ;
 ;this routine will look at the message and get the inbound filing
 ;order
 ;
MAIN ;-- this is the main routine driver
 D FO,PRS
 Q
 ;
FO ;-- get the inbound filing order
 S BHLCNT=0
 S BHLMDA=0 F  S BHLMDA=$O(^INTHL7M(BHLMIEN,1,"AS",BHLMDA)) Q:'BHLMDA  D
 . S BHLMFN=$O(^INTHL7M(BHLMIEN,1,"AS",BHLMDA,0))
 . S BHLSEG=$P($G(^INTHL7S(+$P($G(^INTHL7M(BHLMIEN,1,BHLMFN,0)),U),0)),U,2)
 . S BHLCNT=BHLCNT+1
 . S BHLFO(BHLCNT)=BHLSEG
 Q
 ;
PRS ;-- reparse INV for filer
 S BHLINV=0 F  S BHLINV=$O(INV(BHLINV)) Q:BHLINV=""  D
 . S BHLSEG=$E(BHLINV,1,3)
 . S BHLSEQ=+$E(BHLINV,4,6)
 . S BHLML=$O(INV(BHLINV,0))
 . I BHLML="" S BHL(BHLSEG,1,BHLSEQ)=$G(INV(BHLINV)) Q
 . S BHLML=0 F  S BHLML=$O(INV(BHLINV,BHLML)) Q:'BHLML  D
 .. I $O(INV(BHLINV,BHLML,0)) D PAR Q
 .. S BHL(BHLSEG,BHLML,BHLSEQ)=$G(INV(BHLINV,BHLML)) Q
 Q
 ;
PAR ;-- break down array into lower level
 S BHLPR=0 F  S BHLPR=$O(INV(BHLINV,BHLML,BHLPR)) Q:'BHLPR  D
 . I $O(INV(BHLINV,BHLML,BHLPR,0)) D SUBPAR Q
 . S BHL(BHLSEG,BHLML,BHLPR,BHLSEQ)=$G(INV(BHLINV,BHLML,BHLPR))
 Q
 ;
SUBPAR ;-- break down the relationship to the next level
 S BHLSPR=0 F  S BHLSPR=$O(INV(BHLINV,BHLML,BHLPR,BHLSPR)) Q:'BHLSPR  D
 . S BHL(BHLSEG,BHLML,BHLPR,BHLSPR,BHLSEQ)=$G(INV(BHLINV,BHLML,BHLPR,BHLSPR))
 Q
 ;
