ABMDF3 ; IHS/ASDST/DMJ - Set HCFA-1500 Print Array ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
 ; IHS/DSD/LSL 03/21/98  - Modified logic in 
 ;             tab ABMU to kill ABMU array if no more
 ;             numeric subscipts.  solve problem of 
 ;             HCFA print same page w/no procedures
 ;             continuous   (Nois: HQW-0398-100121)
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM16876
 ;    (cont) removed from block 28/30 if payment
 ;
 ; IHS/SD/SDR - v2.5 p12 - IM24880
 ;    Correction to number of line items printing on
 ;    each page (wasn't printing 6 on each)
 ;
 K ABMP,ABMF
 S ABMP("EXP")=3
 D TXST^ABMDFUTL
 ;
BDFN ;
 S ABMY("N")=0
 F  S ABMY("N")=$O(ABMY(ABMY("N"))) Q:'ABMY("N")  D
 .S ABMP("BDFN")=""
 .F  S ABMP("BDFN")=$O(ABMY(ABMY("N"),ABMP("BDFN"))) Q:'ABMP("BDFN")  D
 ..Q:'$D(^ABMDBILL(DUZ(2),ABMP("BDFN"),0))
 ..D ENT
 ..S DIE="^ABMDBILL(DUZ(2),"
 ..S DA=ABMP("BDFN")
 ..S DR=".04////B;.16////A;.17////"_ABMP("XMIT")
 ..D ^ABMDDIE
 ..Q:$D(ABM("DIE-FAIL"))
 ..K ^ABMDBILL(DUZ(2),"AS",+^ABMDBILL(DUZ(2),ABMP("BDFN"),0),"A",ABMP("BDFN")),^ABMDBILL(DUZ(2),"AC","A",ABMP("BDFN"))
 D TXUPDT^ABMDFUTL
 ;
XIT ;
 K ABM,ABMV,ABMF,ABMS,ABMR
 Q
 ;
HCFA ;
 D EMG^ABMDF3E
 F ABMS("I")=36:1:47 K ABMF(ABMS("I"))
 F ABMS("I")=37:2:47 D  Q:$G(ABM("QUIT"))
 .I $D(ABMR) D
 ..S ABMS=0
 ..F  S ABMS=$O(ABMS(ABMS)) Q:+ABMS=0  D
 ...S ABMLN=2
 ...D PROC^ABMDF3E
 ...S ABMLN=ABMLN+1
 ..S ABMLN=0,ABMPRT=0
 .F ABMS("I")=37:1:47 D  Q:$G(ABM("QUIT"))
 ..S ABMLN=$O(ABMR(ABMLN))
 ..I 'ABMLN S ABM("QUIT")=1 Q
 ..S ABMPRT=0
 ..I (($O(ABMR(ABMLN,9),-1))+(ABMS("I")))>49 Q
 ..S ABMLCNT=0
 ..F  S ABMPRT=$O(ABMR(ABMLN,ABMPRT)) Q:+ABMPRT=0  D
 ...I +$O(ABMR(ABMLN,ABMPRT))'=0,($G(ABMF(ABMS("I")-1))=""),(ABMS("I")#2=1),ABMS("I")=37 S ABMS("I")=ABMS("I")-1
 ...M ABMF(ABMS("I"))=ABMR(ABMLN,ABMPRT)
 ...S ABMLCNT=ABMLCNT+1
 ...S ABMS("I")=ABMS("I")+1
 ...K ABMR(ABMLN,ABMPRT)
 ..K ABMR(ABMLN)
 I (ABMS("I")>=47),(+$O(ABMR(ABMS))'=0)!(ABMS("I")>=47),($O(ABMR(ABMS))="MORE") D ^ABMDF3X G HCFA
 S $P(ABMF(49),U,7)=$P(ABMR("TOT"),U)
 S $P(ABMF(49),U,8)=$P(ABMR("TOT"),U,2)
 S $P(ABMF(49),U,9)=$P(ABMR("TOT"),U,3)
 K ABMR("MORE")
 D ^ABMDF3X
 Q
 ;
ENT ;EP for setting up export array
 K ABMP("INS"),ABMP("CDFN")
 D ^ABMDF3A,^ABMDF3B,^ABMDF3C,^ABMDF3D
 I +$O(ABMR("")) S ABMR("MORE")="",ABMP("MORE")=""
 ;payment so flag to write (cont.)
 K ABMTEST,ABMTEST1
 S ABMTEST=$P($G(ABMP("B0")),U)
 S ABMTEST1=$O(^ABMDBILL(DUZ(2),"B",ABMTEST),-1)
 I ($E(ABMTEST,1,$L(ABMTEST)-1))=($E(ABMTEST1,1,$L(ABMTEST1)-1)) D
 .I $D(^ABMDBILL(DUZ(2),$O(^ABMDBILL(DUZ(2),"B",ABMTEST1,"")),3,0)) S ABMP("PTOT")=1
 K ABM("LTOT")
 I $$MPP^ABMUTLP(ABMP("BDFN")) D
 .S $P(ABMF(11),"^",2)="NONE"
 .S $P(ABMF(13),"^",4,6)=""
 .S $P(ABMF(15),"^",7)=""
 .S $P(ABMF(17),"^",4)=""
 D ^ABMDF3X
 I +$O(ABMR("")) S ABMS=0 D HCFA
 Q
 ;
ABMU ; EP
 ; Long Description
 N I,J
 S I=0
 F J=1,2 S I=$O(ABMU(I)) Q:'+I  D
 .S:J=1 ABMF(ABMS("I")-1)=ABMU(I)
 .S:J=2 $P(ABMF(ABMS("I")),"^",5)=ABMU(I)
 .K ABMU(I)
 S I=$O(ABMU(I)) I '+I K ABMU
 Q
