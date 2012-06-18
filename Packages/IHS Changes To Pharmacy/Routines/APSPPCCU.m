APSPPCCU ;IHS/CIA/DKM/PLS - Utilities for PCC Hook for Pharmacy Package ;30-Aug-2005 13:07;SM
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1003**;DEC 11, 2003
 ; Search for bad PSRX-->VMED link
BADP2V ;EP
 N PSRX,REF,VMED,CNT,F1
 W "Searching for bad PSRX-->VMED links...",!!
 S F1=$$ASK^CIAU("Repair bad links")
 Q:'$L(F1)
 R "Starting PSRX: ",PSRX,!!
 Q:PSRX[U
 S:PSRX PSRX=PSRX-1
 S CNT=0
 F  S PSRX=$O(^PSRX(PSRX)) Q:'PSRX  D
 .S VMED=$G(^PSRX(PSRX,999999911)),REF=0
 .D BADP2VX
 .F  S REF=$O(^PSRX(PSRX,1,REF)) Q:'REF  D
 ..S VMED=$G(^PSRX(PSRX,1,REF,999999911))
 ..D BADP2VX
 .W:$X !
 W !!,"Bad links found: ",CNT,!!
 Q
 ; Check VMED
BADP2VX ;EP
 I VMED,'$D(^AUPNVMED(VMED)) D
 .W $S($X:",",1:PSRX_": "),REF
 .S CNT=CNT+1
 .I F1 D
 ..N X
 ..S X=$$PROCESS^APSPPCC(PSRX,REF)
 ..W:X "  ",$P(X,U,2),!
 Q
 ; Search for bad VMED-->PSRX link
BADV2P ;EP
 N VMED,CNT,F1
 W "Searching for bad VMED-->PSRX link...",!!
 S F1=$$ASK^CIAU("Remove orphaned VMED entries")
 Q:'$L(F1)
 R "Starting VMED: ",VMED,!!
 Q:VMED[U
 S:VMED VMED=VMED-1
 S CNT=0
 F  S VMED=$O(^AUPNVMED(VMED)) Q:'VMED  D:'$D(^PSRX("APCC",VMED))
 .S CNT=CNT+1
 .W VMED,!
 .I F1 D
 ..N DIK,DA
 ..S DIK="^AUPNVMED(",DA=VMED
 ..D ^DIK
 W !!,"Bad links found: ",CNT,!!
 Q
 ; Search for scripts without VMED links
NOVMED ;EP
 N PSRX,F1
 W "Searching for Rx's w/o PCC linkage...",!!
 S F1=$$ASK^CIAU("Create entries for unlinked Rx's")
 Q:'$L(F1)
 R "Starting PSRX: ",PSRX,!!
 Q:PSRX[U
 F  S PSRX=$O(^PSRX(PSRX)) Q:'PSRX  D
 .S $X=1
 .D CHECK(PSRX)
 .I '$X,F1 D
 ..N X
 ..S X=$$PROCESS^APSPPCC(PSRX)
 ..W:X ?5,$P(X,U,2),!
 Q
 ; Search message log for missing PCC links
MSG ;EP
 W "Searching message log for missing PCC links...",!!
 N I1,I2,I3,Z,F1,F2
 S F1=$$ASK^CIAU("Purge linked messages")
 S F2=$$ASK^CIAU("Reprocess unlinked Rx's")
 S I3=$O(^XTMP("APSPPCC",$C(1)),-1)
 F I1=0:0:I3 S I1=$O(^XTMP("APSPPCC",I1)) Q:'I1  D
 .W *13,I1,?10
 .F I2=0:0 S I2=$O(^XTMP("APSPPCC",I1,"MSG",I2)) Q:'I2  D  Q:I2<0
 ..S Z=^XTMP("APSPPCC",I1,"MSG",I2)
 ..Q:$E(Z,1,3)'="ORC"
 ..S Z=$P(Z,"|",4)
 ..Q:$P(Z,U,2)'="PS"
 ..S Z=$P(Z,U)
 ..D:Z=+Z CHECK(Z)
 ..S:'$X I2=-1
 .I F1,'I2 K ^XTMP("APSPPCC",I1)
 .I F2,I2 D REP(I1)
 W *13,?20,!!
 Q
 ; Check VMED link for a script
CHECK(PSRX) ;EP
 N REF,STA
 S STA=+$G(^PSRX(PSRX,"STA"))
 Q:STA=3!(STA=13)!(STA=16)
 S REF=$O(^PSRX(PSRX,1,$C(1)),-1)
 I REF D  Q
 .I $G(^PSRX(PSRX,1,REF,999999911)),$D(^AUPNVMED(^(999999911))) Q
 .W:$P(^PSRX(PSRX,1,REF,0),U,18) PSRX,":",REF,!
 I $G(^PSRX(PSRX,999999911)),$D(^AUPNVMED(^(999999911))) Q
 W:$P($G(^PSRX(PSRX,2)),U,2) PSRX,!
 Q
REPROC ;EP
 N MSG
 R "Message # to reprocess: ",MSG,!! Q:'MSG
 D REP(MSG)
 Q
REP(MSG) D EN^APSPPCC($NA(^XTMP("APSPPCC",MSG,"MSG")),MSG)
 Q
 ; Fix V PROVIDER entries of 0
BADPRV ;EP
 N VPRV,VIS,VMED,PSRX
 F VPRV=0:0 S VPRV=$O(^AUPNVPRV("B",0,VPRV)) Q:'VPRV  D
 .S VIS=$P(^AUPNVPRV(VPRV,0),U,3)
 .F VMED=0:0 S VMED=$O(^AUPNVMED("AD",VIS,VMED)) Q:'VMED  D
 ..S PSRX=$O(^PSRX("APCC",VMED,0))
 ..Q:'PSRX
 ..W VMED,!
 ..D PROCESS^APSPPCC(PSRX)
 .K DIE,DA,DR
 .S DIE="^AUPNVPRV(",DA=VPRV,DR=".01///@"
 .D ^DIE
 Q
 ; Purge message logs
MSGPRG K:$$ASK^CIAU("Really purge all message logs") ^XTMP("APSPPCC")
 Q
 ; Find all messages for a given script IEN
FNDMSG(IEN,REPROC) ;EP
 N MSG,X
 S IEN="|"_IEN_"^PS|",REPROC=+$G(REPROC)
 F MSG=0:0 S MSG=$O(^XTMP("APSPPCC",MSG)) Q:'MSG  D
 .F X=0:0 S X=$O(^XTMP("APSPPCC",MSG,X)) Q:'X  I ^(X)[IEN D  Q
 ..W MSG,!
 ..D:REPROC REP(MSG)
 Q
