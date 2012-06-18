APCD206F ; IHS/CMI/TUCSON - DATA ENTRY PATCH 6 [ 03/24/03  2:14 PM ]
 ;;2.0;IHS RPMS/PCC Data Entry;**6**;MAR 09, 1999
 ;
 W !,"checking V LAB for correct provider entries...Hold on..."
 I $P(^AUTTSITE(1,0),U,22)=1 Q
 I $P(^DD(9000010.06,.01,0),U,2)[200 Q
 I $P(^DD(9000010.09,1202,0),U,2)[6 Q  ;fix already ran or never installed patch 5
FIX ;
 D ^APC7INIT
 S APCDLAST=$P(^AUPNVLAB(0),U,3)
 ;loop through V LAB since date of patch 5 install and fix V LAB 1202
 S APCDII=$O(^XPD(9.7,"B","APCD*2.00*5",0))
 I 'APCDII W !!,"APCD patch 5 never installed.  No need to run post init." K APCDII Q
 S APCDID=$P($G(^XPD(9.7,APCDII,1)),U)
 S APCDID=$P(APCDID,".")
 F  S APCDID=$O(^AUPNVSIT("B",APCDID)) Q:APCDID'=+APCDID  D
 .S APCDV=0 F  S APCDV=$O(^AUPNVSIT("B",APCDID,APCDV)) Q:APCDV'=+APCDV  D
 ..Q:'$D(^AUPNVLAB("AD",APCDV))  ;no v labs
 ..S APCDL=0 F  S APCDL=$O(^AUPNVLAB("AD",APCDV,APCDL)) Q:APCDL'=+APCDL  D
 ...Q:APCDL>APCDLAST
 ...Q:$P($G(^AUPNVLAB(APCDL,12)),U,2)=""
 ...S APCDOLD=$P($G(^AUPNVLAB(APCDL,12)),U,2) ;is a file 200 ptr
 ...Q:'$D(^VA(200,APCDOLD,0))
 ...S APCDNEW=$P(^VA(200,APCDOLD,0),U,16) ;file 6 ptr
 ...Q:APCDNEW=""
 ...S Y=$$TXLGN($P(^AUPNVLAB(APCDL,0),U,6),APCDL)
 ...I Y]"",Y'=$P(^DIC(16,APCDNEW,0),U,1) Q
 ...S DA=APCDL,DIE="^AUPNVLAB(",DR="1202///`"_APCDNEW D ^DIE D ^XBFMK
 ...W ":",APCDL
 ...Q
 ..Q
 .Q
 D CHECK
 W !!,"all done"
 Q
 ;
TXLGN(ACC,VF) ;
 NEW A,B,C,G,P
 I $G(ACC)="" Q ""
 I $G(VF)="" Q ""
 S P="",G=0,A=0 F  S A=$O(^BLRTXLOG("D",ACC,A)) Q:A'=+A!(G)  D
 .S B=$P($G(^BLRTXLOG(A,1)),U,5)
 .I B=VF S G=1,P=$P($G(^BLRTXLOG(A,11)),U,4) I P S P=$P(^VA(200,P,0),U)
 .Q
 Q P
 ;
C ;
 S X=0 F  S X=$O(^VA(200,X)) Q:X'=+X  D
 .S Y=$P(^VA(200,X,0),U,16)
 .Q:Y=""
 .I $P(^DIC(16,Y,0),U)'=$P(^VA(200,X,0),U) W !,Y," ",X
 .Q
 Q
CHECK ;
 NEW VFP,TXP,NEW,DA,DIE,APCDX,VF
 W !,"hang on...checking..."
 S APCDX=0 F  S APCDX=$O(^BLRTXLOG(APCDX)) Q:APCDX'=+APCDX  D
 .I $P($G(^BLRTXLOG(APCDX,1)),U,3)<3021001 Q
 .Q:$P(^BLRTXLOG(APCDX,1),U,4)'=9000010.09
 .S VF=$P(^BLRTXLOG(APCDX,1),U,5)
 .Q:VF=""
 .Q:'$D(^AUPNVLAB(VF,12))
 .Q:'$D(^AUPNVLAB(VF,0))
 .S VFP=$$VAL^XBDIQ1(9000010.09,VF,1202)
 .S TXP=$$VAL^XBDIQ1(9009022,APCDX,1104)
 .I VFP=TXP Q  ;a match
 .I $P(VFP,",")=$P(TXP,",") Q
 .;I VFP'=TXP W !,"does not match: VF=",VF," TX=",APCDX," ",VFP," ",TXP
 .S NEW=$P(^BLRTXLOG(APCDX,11),U,4),NEW=$P(^VA(200,NEW,0),U,16)
 .Q:NEW=""
 .S DA=VF,DIE="^AUPNVLAB(",DR="1202///`"_NEW D ^DIE,^XBFMK
 .Q
 W !,"all done"
 Q
