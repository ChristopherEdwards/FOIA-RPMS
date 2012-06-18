BLRMPC(REFLAB,DIR,FILE) ; cmi/anch/maw - BLR Import Reference Lab Order/Result Codes ;
 ;;5.2;LR;**1021**;Jul 27, 2006
 ;;1.0;BLR REFERENCE LAB;;MAR 14, 2005
 ;
 ;
 ;this routine will read in a ref lab database and attempt to
 ;match against file 60
 ;
 ;EP - This is the main routine driver
 S C=","
 D LOAD(REFLAB,DIR,FILE)
 Q:$G(BLRFLG)
 Q
 ;D EOJ
 Q
 ;
LOAD(RL,DIR,FL) ;-- load from the file and stuff in BLR REFERENCE LAB File
 S BLRLI=$$REF(RL)
 S BLRY=$$OPEN^%ZISH(DIR,FL,"R")
 I BLRY D  Q
 . S BLRFLG=1
 . W !,"Trouble Opening File, please fix and try again" Q
 F BLRI=1:1 U IO R BLRX:DTIME D  Q:BLRX=""
 . Q:BLRX=""
 . S ORDC=$P(BLRX,C)
 . S TNM=$P(BLRX,C,2)
 . S RESC=$P(BLRX,C,3)
 . S TNMA=$P(BLRX,C,4)
 . S BLRTI=$$ADD(BLRLI,ORDC,TNM,RESC,TNMA)
 . Q:'BLRTI
 . Q
 . ;S BLRLT=$$MTCH(BLRTI)
 Q
 ;
REF(RLNM)          ;-- check for existence of ref lab, add if not there
 I $O(^BLRRL("B",RLNM,0)) Q $O(^BLRRL("B",RLNM,0))
 K DD,DO
 S DIC="^BLRRL(",DIC(0)="L",X=RLNM
 D FILE^DICN
 Q +Y
 ;
ADD(LI,OCD,NM,RCD,NMA)          ;-- add the test code to the file
 K ORD,RES
 I $O(^BLRRL("BORD",OCD,LI,0)) S ORD=1
 I $O(^BLRRL("BRES",RCD,LI,0)) S RES=1
 I '$G(ORD) D
 . Q:NM=""
 . K BLROI
 . K DD,DO
 . S DA(1)=LI
 . S DIC("P")=$P(^DD(9009026,10,0),"^",2)
 . S DIC="^BLRRL("_LI_",1,",DIC(0)="L",X=NM
 . S DIC("DR")=".03///"_OCD
 . D FILE^DICN
 . S BLROI=+Y
 I '$G(RES) D
 . Q:NMA=""
 . K BLROI
 . K DD,DO
 . S DA(1)=LI
 . S DIC("P")=$P(^DD(9009026,10,0),"^",2)
 . S DIC="^BLRRL("_LI_",1,",DIC(0)="L",X=NMA
 . S DIC("DR")=".04///"_RCD
 . D FILE^DICN
 . S BLROI=+Y
 Q $G(BLROI)
 ;
