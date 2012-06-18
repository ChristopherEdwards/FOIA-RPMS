ABMDSPLB ; IHS/ASDST/DMJ - SPLIT CLAIM IN TWO medicare B;     
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p8 - task 6
 ;    Added code to not split claim if ambulance
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM19717/IM20374
 ;   Added to merge check primary provider and primary DX
 ;
 ; *********************************************************************
 ;
MAIN(ABMCF) ;EP - main section
 ;x=claim to clone
 D CHK I $G(ABMQUIT) K ABMQUIT Q
 D ADD Q:+Y<0
 D EDIT
 D DEL
 D XREF
 K ABMCF,ABMC2
 Q
CHK ;checks create claim or quit
 N ABMPAT,ABMDT,ABMVTYP,ABMINS,ABMCLIN
 S ABMQUIT=1
 Q:'$D(^ABMDCLM(DUZ(2),ABMCF,0))
 S ABMPAT=$P(^ABMDCLM(DUZ(2),ABMCF,0),U),ABMDT=$P(^(0),U,2),ABMVTYP=$P(^(0),U,7),ABMINS=$P(^(0),U,8),ABMCLIN=$P(^(0),U,6)
 Q:ABMDT<3010701
 Q:$P($G(^DIC(40.7,ABMCLIN,0)),U)="AMBULANCE"
 I '$$PARTB(ABMPAT,ABMDT) Q
 D DUP I $G(ABMDUP) Q
 K ABMQUIT
 Q
DUP ; EP - check for duplicate claim
 K ABMDUP
 N I
 S I=0 F  S I=$O(^ABMDCLM(DUZ(2),"B",ABMPAT,I)) Q:'I  D
 .Q:$P(^ABMDCLM(DUZ(2),I,0),"^",2)'=ABMDT
 .Q:$P(^ABMDCLM(DUZ(2),I,0),"^",7)'=999
 .Q:$P(^ABMDCLM(DUZ(2),I,0),"^",8)'=ABMINS
 .Q:$P(^ABMDCLM(DUZ(2),I,0),"^",6)'=ABMCLIN
 .D GETPPRV
 .D GETPPOV
 .Q:$G(ABMVPRV)'=ABMCPRV2
 .Q:$G(ABMVICD)'=ABMCICD2
 .S ABMDUP=1
 Q
ADD ; EP - add claim
 S X=$P($G(^ABMDCLM(DUZ(2),ABMCF,0)),U)
 Q:'X
 S DINUM=$$NXNM^ABMDUTL
 Q:DINUM=""
 S DIC="^ABMDCLM(DUZ(2),"
 S DIC(0)="L"
 K DD,DO
 D FILE^DICN
 Q:+Y<0
 S ABMC2=+Y
 M ^ABMDCLM(DUZ(2),ABMC2)=^ABMDCLM(DUZ(2),ABMCF)
 Q
EDIT ; EP - edit fields
 S DA=ABMC2
 S DIE="^ABMDCLM(DUZ(2),"
 S DR=".07///999;.1///"_DT_";.04///E;.14///20;.17///"_DT
 D ^DIE
 Q
DEL ; EP - delete sections
 N I F I=13,23,25,33,37,43,45 D
 .K ^ABMDCLM(DUZ(2),DA,I)
 Q
XREF ; EP - cross reference
 S DIK="^ABMDCLM(DUZ(2),"
 K ^ABMDCLM(DUZ(2),DA,"ASRC")
 D IX1^DIK
 Q
PARTB(X,Y) ;EP - check for part b
 ;x=patient dfn, y=date
 I 'X S Z=0 Q Z
 I 'Y S Z=0 Q Z
 S Z=0
 N I
 S I=0 F  S I=$O(^AUPNMCR(X,11,I)) Q:'I  D
 .S ABMZERO=^AUPNMCR(X,11,I,0)
 .D BSUB
 S I=0 F  S I=$O(^AUPNRRE(X,11,I)) Q:'I  D
 .S ABMZERO=^AUPNRRE(X,11,I,0)
 .D BSUB
 K ABMZERO
 Q Z
 ;
 ; *********************************************************************
BSUB ; EP
 ; check for B subroutine
 Q:$P(ABMZERO,"^",3)'="B"
 Q:$P(ABMZERO,U)>Y
 I $P(ABMZERO,"^",2),$P(ABMZERO,"^",2)<Y Q
 S Z=1
 Q
GETPPRV ;EP
 ;get attending/operating provider from claim
 S ABMCPRV2=+$O(^ABMDCLM(DUZ(2),I,41,"C","A",0))
 S:ABMCPRV2=0 ABMCPRV2=+$O(^ABMDCLM(DUZ(2),I,41,"C","O",0))
 I ABMCPRV2'=0 S ABMCPRV2=$P($G(^ABMDCLM(DUZ(2),I,41,ABMCPRV2,0)),U)
 Q
GETPPOV ;EP
 ;get Primary/first entry from claim
 S ABMCICD2=+$O(^ABMDCLM(DUZ(2),I,17,0))
 Q
