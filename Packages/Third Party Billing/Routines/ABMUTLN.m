ABMUTLN ; IHS/ASDST/DMJ - NAME UTILITIES ;    
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;DMJ;02/07/96 12:33 PM
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20000
 ;   Added code to look at Card Name for Policy Holder
 ;
LNM(X,Y) ;PEP - last name
 ;x=file
 ;y=internal entry number
 D SET
 D KILL
 I X="" Q X
 D FILE
 S X=$P(ABME("NM"),",",1)
 Q X
FNM(X,Y) ;PEP - first name
 ;x=file
 ;y=internal entry number
 D SET
 D KILL
 I X="" Q X
 D FILE
 S X=$P(ABME("NM"),",",2)
 S X=$$STRPL^ABMERUTL(X)
 I $L(X," ")>1 D
 .S X=$P(X," ",1,$L(X," ")-1)
 Q X
MI(X,Y) ;PEP - middle name/initial
 ;x=file
 ;y=internal entry number
 D SET
 D KILL
 I X="" Q X
 D FILE
 S X=$P(ABME("NM"),",",2)
 I $L(X," ")<2 S X="" Q X
 S X=$P(X," ",$L(X," "))
 S X=$TR(X,".,")
 Q X
SFX(X,Y) ;PEP - suffix (generation)  
 ;x=file
 ;y=internal entry number
 D SET
 D KILL
 I X="" Q X
 D FILE
 S X=$G(ABME("NSFX"))
 Q X
DOB(X,Y) ;PEP - date of birth
 ;x=file
 ;y=internal entry number
 D SET
 D KILL
 I X="" Q X
 D FILE
 S X=$G(ABME("DOB"))
 Q X
SEX(X,Y) ;PEP - sex
 ;x=file
 ;y=internal entry number
 D SET
 D KILL
 I X="" Q X
 D FILE
 S X=$G(ABME("SEX"))
 Q X
SET ;set abmpdfn
 S ABMFILE=X
 S ABMIEN=Y
 I X=3 S ABMFILE=9000003.1
 S ABMIEN=Y
 I ABMFILE=2 D
 .I '$D(^DPT(+ABMIEN,0)) S X="" Q
 .S ABMPDFN=ABMIEN
 I ABMFILE=200 D
 .S:'$D(^VA(200,+ABMIEN,0)) X=""
 I ABMFILE=9000003.1 D
 .S:'$D(^AUPN3PPH(+ABMIEN,0)) X=""
 Q
KILL ;kill off old abme
 K ABME("NM"),ABME("DOB"),ABME("SEX"),ABME("NSFX")
 Q
FILE ;retrieve from file
 I ABMFILE=2 D PAT
 I ABMFILE=200 D NP
 I ABMFILE=9000003.1 D PH
 D STRIP
 Q
PAT ; Patient name
 S ABMP("ITYPE")=$G(ABMP("ITYPE"))
 ; if insurer type is Medicare FI
 I ABMP("ITYPE")="R" D
 .; if insurer name contains "MEDICARE"
 .I $P(^AUTNINS(ABMP("INS"),0),U)["MEDICARE" D
 ..; Medicare Patient name from MEDICARE ELIGIBLE
 ..S ABME("NM")=$P($G(^AUPNMCR(ABMPDFN,21)),U)
 ..S ABME("DOB")=$P($G(^AUPNMCR(ABMPDFN,21)),"^",2) ; DOB
 .; If insurer name contains "RAILROAD"
 .I $P(^AUTNINS(ABMP("INS"),0),U)["RAILROAD" D
 ..; Railroad Patient name from RAILROAD ELIGIBLE
 ..S ABME("NM")=$P($G(^AUPNRRE(ABMPDFN,21)),U)
 ..S ABME("DOB")=$P($G(^AUPNRRE(ABMPDFN,21)),"^",2) ; DOB
 ;
 ; if insurer type is Medicaid FI
 I ABMP("ITYPE")="D"!(ABMP("ITYPE")="K") D
 .Q:'$G(ABMCDNUM)
 .S ABME("NM")=$P($G(^AUPNMCD(ABMCDNUM,21)),U) ; Pat name
 .S ABME("DOB")=$P($G(^AUPNMCD(ABMCDNUM,21)),"^",2) ; dob
 ;
 ; Else get from patient file
 S:$G(ABME("NM"))="" ABME("NM")=$P($G(^DPT(+ABMPDFN,0)),U)
 S:$G(ABME("DOB"))="" ABME("DOB")=$P(^DPT(ABMPDFN,0),"^",3)
 ; sex code & marital status
 S ABME("SEX")=$P(^DPT(ABMPDFN,0),"^",2),ABME("MS")=$P(^(0),"^",5)
 Q
NP ;new person file
 S ABME("NM")=$P($G(^VA(200,ABMIEN,0)),U)
 S ABME("SEX")=$P($G(^VA(200,ABMIEN,1)),"^",2)
 S ABME("DOB")=$P($G(^VA(200,ABMIEN,1)),"^",3)
 Q
PH ;policy holder file
 S ABME("NM")=$P($G(^AUPN3PPH(ABMIEN,1)),U)
 S:ABME("NM")="" ABME("NM")=$P($G(^AUPN3PPH(ABMIEN,0)),U)
 S ABME("SEX")=$P(^AUPN3PPH(ABMIEN,0),"^",8)
 S ABME("DOB")=$P(^AUPN3PPH(ABMIEN,0),"^",19)
 Q
STRIP ;strip suffix (generation)
 K ABME("NSFX")
 N I
 F I=" JR."," SR."," III."," IV." D STR1
 Q:$G(ABME("NSFX"))'=""
 F I=" JR"," SR"," III"," IV" D STR1
 Q
STR1 ;one name
 Q:ABME("NM")'[I
 S ABME("NSFX")=$TR(I," .")
 S ABME("NM")=$P(ABME("NM"),I,1)_$P(ABME("NM"),I,2)
 Q
