BGP2HUTL ; IHS/CMI/LAB - ;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
 ;
 ;utility calls
 ;
STMP ;EP
 Q:BGPTIME'=1
 I BGPLIST="P",$P(^AUPNPAT(DFN,0),U,14)'=BGPLPRV Q
 X ^BGPHEIB(BGPIC,2) Q:'$T
 S BGPLIST(BGPIC)=$G(BGPLIST(BGPIC))+1
 S ^XTMP("BGP2D",BGPJ,BGPH,"LIST",BGPIC,$S($P($G(^AUPNPAT(DFN,11)),U,18)]"":$P(^AUPNPAT(DFN,11),U,18),1:"UNKNOWN"),$P(^DPT(DFN,0),U,2),BGPAGEB,DFN)=BGPVALUE
 Q
D(D) ;EP
 I D="" Q ""
 Q (1700+$E(D,1,3))_$E(D,4,5)_$E(D,6,7)_$S($P(D,".",2)]"":$P(D,".",2),1:"")
JRNL ;EP
 N (DT,U,ZTQUEUED) S %=$$NOJOURN^ZIBGCHAR("BGPHEDCB"),%=$$NOJOURN^ZIBGCHAR("BGPHEDPB"),%=$$NOJOURN^ZIBGCHAR("BGPHEDBB")
 Q
DATE(D) ;EP
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 ;
GS ;EP
 K ^TMP($J)
 ;I $P($G(^BGPSITE(DUZ(2),0)),U,3)="N" Q
 L +^BGPDATA:300 E  W:'$D(ZTQUEUED) "Unable to lock global" Q
 ;NOTE:  Kill of unscripted global.  Export to area.  Using standard name.
 K ^BGPDATA S X="",C=0 F  S X=$O(^BGPHEDCB(BGPRPT,X)) Q:X'=+X!(X>99998)  D
 .I $G(^BGPHEDCB(BGPRPT,X))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",8)=^BGPHEDCB(BGPRPT,X)
 .S X2="" F  S X2=$O(^BGPHEDCB(BGPRPT,X,X2)) Q:X2'=+X2  D
 ..I $G(^BGPHEDCB(BGPRPT,X,X2))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",8)=^BGPHEDCB(BGPRPT,X,X2)
 ..S X3="" F  S X3=$O(^BGPHEDCB(BGPRPT,X,X2,X3)) Q:X3'=+X3  D
 ...I $G(^BGPHEDCB(BGPRPT,X,X2,X3))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",8)=^BGPHEDCB(BGPRPT,X,X2,X3)
 ...S X4="" F  S X4=$O(^BGPHEDCB(BGPRPT,X,X2,X3,X4)) Q:X4'=+X4  D
 ....I $G(^BGPHEDCB(BGPRPT,X,X2,X3,X4))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",8)=^BGPHEDCB(BGPRPT,X,X2,X3,X4)
 ....S X5="" F  S X5=$O(^BGPHEDCB(BGPRPT,X,X2,X3,X4,X5)) Q:X5'=+X5  D
 .....I $G(^BGPHEDCB(BGPRPT,X,X2,X3,X4,X5))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3
 .....S $P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",5)=X5,$P(^BGPDATA(C),"|",8)=^BGPHEDCB(BGPRPT,X,X2,X3,X4,X5)
 S X=0 F  S X=$O(^BGPDATA(X)) Q:X'=+X  S ^BGPDATA(X)="BGPHEDCB"_"|"_^BGPDATA(X)
PRGS ;
 S S=C+1,X="" F  S X=$O(^BGPHEDPB(BGPRPT,X)) Q:X'=+X!(X>99998)  D
 .I $G(^BGPHEDPB(BGPRPT,X))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",8)=^BGPHEDPB(BGPRPT,X)
 .S X2="" F  S X2=$O(^BGPHEDPB(BGPRPT,X,X2)) Q:X2'=+X2  D
 ..I $G(^BGPHEDPB(BGPRPT,X,X2))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",8)=^BGPHEDPB(BGPRPT,X,X2)
 ..S X3="" F  S X3=$O(^BGPHEDPB(BGPRPT,X,X2,X3)) Q:X3'=+X3  D
 ...I $G(^BGPHEDPB(BGPRPT,X,X2,X3))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",8)=^BGPHEDPB(BGPRPT,X,X2,X3)
 ...S X4="" F  S X4=$O(^BGPHEDPB(BGPRPT,X,X2,X3,X4)) Q:X4'=+X4  D
 ....I $G(^BGPHEDPB(BGPRPT,X,X2,X3,X4))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",8)=^BGPHEDPB(BGPRPT,X,X2,X3,X4)
 ....S X5="" F  S X5=$O(^BGPHEDPB(BGPRPT,X,X2,X3,X4,X5)) Q:X5'=+X5  D
 .....I $G(^BGPHEDPB(BGPRPT,X,X2,X3,X4,X5))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3
 .....S $P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",5)=X5,$P(^BGPDATA(C),"|",8)=^BGPHEDPB(BGPRPT,X,X2,X3,X4,X5)
 S X=S-1 F  S X=$O(^BGPDATA(X)) Q:X'=+X  S ^BGPDATA(X)="BGPHEDPB"_"|"_^BGPDATA(X)
BLGS ;save off baseline data
 S S=C+1,X="" F  S X=$O(^BGPHEDBB(BGPRPT,X)) Q:X'=+X!(X>99998)  D
 .I $G(^BGPHEDBB(BGPRPT,X))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",8)=^BGPHEDBB(BGPRPT,X)
 .S X2="" F  S X2=$O(^BGPHEDBB(BGPRPT,X,X2)) Q:X2'=+X2  D
 ..I $G(^BGPHEDBB(BGPRPT,X,X2))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",8)=^BGPHEDBB(BGPRPT,X,X2)
 ..S X3="" F  S X3=$O(^BGPHEDBB(BGPRPT,X,X2,X3)) Q:X3'=+X3  D
 ...I $G(^BGPHEDBB(BGPRPT,X,X2,X3))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",8)=^BGPHEDBB(BGPRPT,X,X2,X3)
 ...S X4="" F  S X4=$O(^BGPHEDBB(BGPRPT,X,X2,X3,X4)) Q:X4'=+X4  D
 ....I $G(^BGPHEDBB(BGPRPT,X,X2,X3,X4))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",8)=^BGPHEDBB(BGPRPT,X,X2,X3,X4)
 ....S X5="" F  S X5=$O(^BGPHEDBB(BGPRPT,X,X2,X3,X4,X5)) Q:X5'=+X5  D
 .....I $G(^BGPHEDBB(BGPRPT,X,X2,X3,X4,X5))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3
 .....S $P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",5)=X5,$P(^BGPDATA(C),"|",8)=^BGPHEDBB(BGPRPT,X,X2,X3,X4,X5)
 S X=S-1 F  S X=$O(^BGPDATA(X)) Q:X'=+X  S ^BGPDATA(X)="BGPHEDBB"_"|"_^BGPDATA(X)
 S XBGL="BGPDATA"
 S F="BG121"_$P(^AUTTLOC(DUZ(2),0),U,10)_".HE"_BGPRPT
 S XBMED="F",XBFN=F,XBTLE="SAVE OF GPRA DATA BY - "_$P(^VA(200,DUZ,0),U),XBF=0,XBFLT=1
 S XBUF=BGPUF D ^XBGSAVE
 L -^BGPDATA
 K ^TMP($J),^BGPDATA ;NOTE:  kill of unsubscripted global for use in export to area.
 Q
REPORT ;EP
 S BGPRPT=""
 W !!
 ;CREATE REPORT ENTRY IN FILEMAN FILE
 ;3 files must have the same ien
 L +^BGPHEDCB:30 I '$T W !!,"Unable to lock global, try later." G REPORTX
 L +^BGPHEDPB:30 I '$T W !!,"Unable to lock global, try later." G REPORTX
 L +^BGPHEDBB:30 I '$T W !!,"Unable to lock global, try later." G REPORTX
 D GETIEN
 I 'BGPIEN W !!,"Something wrong with control files, notify programmer!" S BGPRPT="" G REPORTX
 S DINUM=BGPIEN
 K DIC S X=BGPBD,DIC(0)="L",DIC="^BGPHEDCB(",DLAYGO=90546.03,DIADD=1,DIC("DR")=".02////"_BGPED_";.03////"_BGPPBD_";.04////"_BGPPED_";.05////"_BGPBBD_";.06////"_BGPBED_";.07////"_$G(BGPPER)_";.08////"_$G(BGPQTR)
 S DIC("DR")=DIC("DR")_";.09////"_$P(^AUTTLOC(DUZ(2),0),U,10)_";.11////"_$E($P(^AUTTLOC(DUZ(2),0),U,10),1,4)_";.12////"_BGPRTYPE_";.13////"_DT_";.14////"_BGPBEN_";.15////"_$P($G(^AUTTLOC(DUZ(2),1)),U,3)
 S DIC("DR")=DIC("DR")_";.17///"_$P(^BGPSITE(DUZ(2),0),U,6)_";.18///"_$S($G(BGPTAXI):$P(^ATXAX(BGPTAXI,0),U),1:"")
 D ^DIC K DIC,DA,DR,DIADD,DLAYGO I Y=-1 W !!,"UNABLE TO CREATE REPORT FILE ENTRY - NOTIFY SITE MANAGER!" S BGPQUIT=1 G REPORTX
 S BGPRPT=+Y
 K DIC S X=BGPBD,DIC(0)="L",DIC="^BGPHEDPB(",DLAYGO=90546.04,DIADD=1,DIC("DR")=".02////"_BGPED_";.03////"_BGPPBD_";.04////"_BGPPED_";.05////"_BGPBBD_";.06////"_BGPBED_";.07////"_$G(BGPPER)_";.08////"_$G(BGPQTR)
 S DIC("DR")=DIC("DR")_";.09////"_$P(^AUTTLOC(DUZ(2),0),U,10)_";.11////"_$E($P(^AUTTLOC(DUZ(2),0),U,10),1,4)_";.12////"_BGPRTYPE_";.13////"_DT_";.14////"_BGPBEN_";.15////"_$P($G(^AUTTLOC(DUZ(2),1)),U,3)
 S DIC("DR")=DIC("DR")_";.17///"_$P(^BGPSITE(DUZ(2),0),U,6)_";.18///"_$S($G(BGPTAXI):$P(^ATXAX(BGPTAXI,0),U),1:"")
 S DINUM=BGPRPT D ^DIC K DIC,DA,DR,DIADD,DLAYGO,DINUM I Y=-1 W !!,"UNABLE TO CREATE REPORT FILE ENTRY - NOTIFY SITE MANAGER!" S BGPQUIT=1 G REPORTX
 S BGPRPTP=+Y
 K DIC S X=BGPBD,DIC(0)="L",DIC="^BGPHEDBB(",DLAYGO=90546.05,DIADD=1,DIC("DR")=".02////"_BGPED_";.03////"_BGPPBD_";.04////"_BGPPED_";.05////"_BGPBBD_";.06////"_BGPBED_";.07////"_$G(BGPPER)_";.08////"_$G(BGPQTR)
 S DIC("DR")=DIC("DR")_";.09////"_$P(^AUTTLOC(DUZ(2),0),U,10)_";.11////"_$E($P(^AUTTLOC(DUZ(2),0),U,10),1,4)_";.12////"_BGPRTYPE_";.13////"_DT_";.14////"_BGPBEN_";.15////"_$P($G(^AUTTLOC(DUZ(2),1)),U,3)
 S DIC("DR")=DIC("DR")_";.17///"_$P(^BGPSITE(DUZ(2),0),U,6)_";.18///"_$S($G(BGPTAXI):$P(^ATXAX(BGPTAXI,0),U),1:"")
 S DINUM=BGPRPT D ^DIC K DIC,DA,DR,DIADD,DLAYGO I Y=-1 W !!,"UNABLE TO CREATE REPORT FILE ENTRY - NOTIFY SITE MANAGER!" S BGPQUIT=1 G REPORTX
 S BGPRPTB=+Y
 ;add communities to 28 multiple
 K ^BGPHEDCB(BGPRPT,9999)
 S C=0,X="" F  S X=$O(BGPTAX(X)) Q:X=""  S C=C+1 S ^BGPHEDCB(BGPRPT,9999,C,0)=X,^BGPHEDCB(BGPRPT,9999,"B",X,C)=""
 S ^BGPHEDCB(BGPRPT,9999,0)="^90546.12999A^"_C_"^"_C
 I $G(BGPMFITI) S C=0,X="" F  S X=$O(^ATXAX(BGPMFITI,21,"B",X)) Q:X=""  S C=C+1,Y=$P($G(^DIC(4,X,0)),U) S ^BGPHEDCB(BGPRPT,1111,C,0)=Y,^BGPHEDCB(BGPRPT,1111,"B",Y,C)=""
 S ^BGPHEDCB(BGPRPT,1111,0)="^90546.031111^"_C_"^"_C
 S ^BGPHEDCB(BGPRPT,99999,0)="^90546.129999A^0^0"
 S ^BGPHEDPB(BGPRPT,99999,0)="^90546.139999A^0^0"
 S ^BGPHEDBB(BGPRPT,99999,0)="^90546.149999A^0^0"
REPORTX ;
 D ^XBFMK
 K DIC,DIADD,DLAYGO,DR,DA,DD,X,Y,DINUM
 L -^BGPHEDCB
 L -^BGPHEDPB
 L -^BGPHEDBB
 Q
GETIEN ;EP -Get next ien available in all 3 files
 S BGPF=90546.03 D ENT
 S BGPF=90546.04 D ENT
 S BGPF=90546.05 D ENT
 S BGPIEN=$P(^BGPHEDCB(0),U,3)+1
S I $D(^BGPHEDPB(BGPIEN))!($D(^BGPHEDBB(BGPIEN))) S BGPIEN=BGPIEN+1 G S
 Q
 ;
ENT ;
 NEW GBL,NXT,CTR,XBHI,XBX,XBY,ANS
 S GBL=^DIC(BGPF,0,"GL")
 S GBL=GBL_"NXT)"
 S (XBHI,NXT,CTR)=0
 F L=0:0 S NXT=$O(@(GBL)) Q:NXT'=+NXT  S XBHI=NXT,CTR=CTR+1 ;W:'(CTR#50) "."
 S NXT="",XBX=$O(@(GBL)),XBX=^(0),XBY=$P(XBX,U,4),XBX=$P(XBX,U,3)
 S NXT=0,$P(@(GBL),U,3)=XBHI,$P(^(0),U,4)=CTR
 ;
EOJ ;
 KILL ANS,XBHI,XBX,XBY,CTR,DIC,FILE,GBL,L,NXT,BGPF
 Q
 ;
