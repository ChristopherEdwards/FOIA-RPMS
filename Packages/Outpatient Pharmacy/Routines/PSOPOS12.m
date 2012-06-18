PSOPOS12 ;VRN/MFR - Patient Merge Clean-up ;10/17/03
 ;;7.0;OUTPATIENT PHARMACY;**154**;DEC 1997
 ;
 ;External reference to ^OR(100 supported by DBIA 3582
 ;External reference to ^OR(100 supported by DBIA 3463
 ;External reference to ^PS(55 supported by DBIA 2228
 ;External reference to GET1^DIQ supported by DBIA 2056
 ;External reference to ^XMD supported by DBIA 10070
 ;
FIX(OLDDFN,NEWDFN) ; Fix problems caused by Patient Merge
 N DIE,DA,DR,EXPDT,RXIEN,ORIEN,RXST,ORST,RXSTN,ORSTN,COMM
 ;
 S EXPDT=0 F  S EXPDT=$O(^PS(55,NEWDFN,"P","A",EXPDT)) Q:'EXPDT  D
 . S RXIEN=0 F  S RXIEN=$O(^PS(55,NEWDFN,"P","A",EXPDT,RXIEN)) Q:'RXIEN  D
 . . I '$D(^PSRX(RXIEN,0)) Q
 . . I $P($G(^PSRX(RXIEN,0)),"^",2)=NEWDFN Q
 . . S DIE=52,DA=RXIEN,DR="2///"_NEWDFN D ^DIE
 . . S ORIEN=$P($G(^PSRX(RXIEN,"OR1")),"^",2) Q:'ORIEN
 . . S RXST=+$G(^PSRX(RXIEN,"STA"))
 . . S RXSTN=$$GET1^DIQ(52,RXIEN,100),ORSTN=$$GET1^DIQ(100,ORIEN,5)
 . . I $E(RXSTN,1,10)=$E(ORSTN,1,10) Q
 . . I RXST'=11,RXST'=12,RXST'=14,RXST'=15 Q
 . . S STCNT=$G(STCNT)+1
 . . I RXST=11 D EXP
 . . D DSC
 ;
 K OLDDFN,NEWDFN
 Q
 ;
EXP ; Sets CPRS order status to EXPIRED
 I $P(^PSRX(RXIEN,0),"^",19)=2 S $P(^PSRX(RXIEN,0),"^",19)=1
 S COMM="Prescription past expiration date"
 D EN^PSOHLSN1(RXIEN,"SC","ZE",COMM)
 I $D(^OR(100,ORIEN,3)) S $P(^OR(100,ORIEN,3),"^")=EXPDT
 Q
 ;
DSC ; Sets CPRS order status to DISCONTINUED
 N ACTLOG,LSTACT,PHARM,ACTDT,RSN,ACT0,ACTCOM,SAVEDUZ,NACT
 ;
 S (ACTLOG,LSTACT,PHARM,ACTDT)=0
 F  S ACTLOG=$O(^PSRX(RXIEN,"A",ACTLOG)) Q:'ACTLOG  D
 . S RSN=$P($G(^PSRX(RXIEN,"A",ACTLOG,0)),"^",2)
 . I RSN="C"!(RSN="L") S LSTACT=ACTLOG
 I 'LSTACT S COMM="Discontinued by Pharmacy",NACT=""
 I LSTACT S ACT0=$G(^PSRX(RXIEN,"A",LSTACT,0)) D
 . S PHARM=$P(ACT0,"^",3),ACTCOM=$P(ACT0,"^",5)
 . S ACTDT=$P(ACT0,"^"),(NACT,COMM)=""
 . I ACTCOM["Renewed" D
 . . S COMM="Renewed by Pharmacy"
 . I ACTCOM["Auto Discontinued" D
 . . S PHARM="",NACT="A",COMM=$E($P(ACTCOM,".",2),2,99)
 . . S:COMM="" COMM=ACTCOM
 . I ACTCOM["Discontinued During" D
 . . S COMM="Discontinued by Pharmacy"
 S SAVEDUZ=$G(DUZ) S:$G(PHARM) DUZ=PHARM
 D EN^PSOHLSN1(RXIEN,"OD",$S(RXST=15:"RP",1:""),COMM,NACT)
 S DUZ=SAVEDUZ W "."
 I '$G(ACTDT) S ACTDT=DT_".2200"
 I $D(^OR(100,ORIEN,3)) S $P(^OR(100,ORIEN,3),"^")=$E(ACTDT,1,12)
 I $D(^OR(100,ORIEN,6)) S $P(^OR(100,ORIEN,6),"^",3)=$E(ACTDT,1,12)
 ;
 Q
