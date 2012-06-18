SROARPT0 ;TAMPA/CFB - ANESTHETIST'S REPORT ; [ 05/13/99  12:36 PM ]
 ;;3.0; Surgery ;**48,86,88**;24 Jun 93
 ;
 ; Reference to ^PSDRUG supported by DBIA #221
 ;
 F X=0:.1:1.1 S SRTN(X)=$G(^SRF(SRTN,X))
 D UL Q:SRSOUT  W !,"Preop Status: " S Y=$P(SRTN(1.1),"^",3),C=$P(^DD(130,1.13,0),"^",2) D:Y'="" Y^DIQ W Y
 W ?40 S X=$P(SRTN(0),"^",2),X=$S(X="":X,$D(^SRS(X,0)):$P(^(0),"^",1),1:X),X=$S(X="":"",$D(^SC(X,0)):$P(^(0),"^",1),1:"") W "Operating Room: ",?56,X
 D UL Q:SRSOUT  W !,"Principal Operation:  " D PRIN
 I $O(^SRF(SRTN,13,0)) D OTHER
 D UL Q:SRSOUT  W !,"Anesthesia Technique(s): "
 I $O(^SRF(SRTN,6,0)) F V=0:0 S V=$O(^SRF(SRTN,6,V)) Q:'V  I $D(^(V,0)) S T=^(0),Y=$P(T,U),C=$P(^DD(130.06,.01,0),"^",2) D:Y'="" Y^DIQ W !,?5,Y W:$P(T,"^",3)="Y" "  (PRINCIPAL)" D DRUG,ANES
 D ^SROARPT1
 Q
DRUG Q:$P(^SRF(SRTN,6,V,0),"^")="N"
 W !,?8,"Agents: " S AGNT=0 F I=0:0 S AGNT=$O(^SRF(SRTN,6,V,1,AGNT)) Q:'AGNT  S T=^SRF(SRTN,6,V,1,AGNT,0) W ?16,$P(^PSDRUG($P(T,"^"),0),"^") W:$P(T,"^",2) "  "_$P(T,"^",2)_" mg" W !
 Q
ANES ; print anesthesia technique information
 S S(8)=$S($D(^SRF(SRTN,6,V,8)):^(8),1:"")
 W:$P(S(8),"^")="Y" !,"MONITORED ANESTHESIA CARE" W:$P(S(8),"^",2)'="" !,"Intubated: "_$S($P(S(8),"^",2)="Y":"YES",1:"NO")
 S S=^SRF(SRTN,6,V,0),(Y,APP)=$P(S,"^",5),C=$P(^DD(130.06,3,0),"^",2) D:Y'="" Y^DIQ W:Y'="" !,"Approach: "_Y I $P(S,"^",6)'="" S Y=$P(S,"^",6),C=$P(^DD(130.06,4,0),"^",2) D:Y'="" Y^DIQ W:APP'="" ?40,"Route: "_Y W:APP="" !,"Route: "_Y
 K APP S Y=$P(S,"^",7),C=$P(^DD(130.06,5,0),"^",2) D:Y'="" Y^DIQ W:Y'="" !,"Laryngoscope Type: "_Y I $P(S,"^",8)'="" S Y=$P(S,"^",8),C=$P(^DD(130.06,6,0),"^",2) D:Y'="" Y^DIQ W !,"Laryngoscope Size: "_Y
 K LTYPE S (Y,STY)=$P(S,"^",9),C=$P(^DD(130.06,7,0),"^",2) D:Y'="" Y^DIQ W:Y'="" !,"Stylet Used: "_Y
 I $P(S,"^",10) S Y=$P(S,"^",10),C=$P(^DD(130.06,8,0),"^",2) D:Y'="" Y^DIQ W:STY'="" ?40,"Lidocaine Topical: "_Y W:STY="" !,"Lidocaine Topical: "_Y
 K STY S Y=$P(S,"^",11),C=$P(^DD(130.06,9,0),"^",2) D:Y'="" Y^DIQ W:Y'="" !,"Lidocaine IV: "_Y
 S (Y,TT)=$P(S,"^",12),C=$P(^DD(130.06,10,0),"^",2) D:Y'="" Y^DIQ W:Y'="" !,"Tube Type: "_Y I $P(S,"^",13) W:TT'="" ?40,"Tube Size: "_$P(S,"^",13) W:TT="" !,"Tube Size: "_$P(S,"^",13)
 I $P(S,"^",14)'="" S Y=$P(S,"^",14),C=$P(^DD(130.06,12,0),"^",2) D:Y'="" Y^DIQ W !,"Trauma: "_Y
 S (Y,EXIN)=$P(S,"^",23),C=$P(^DD(130.06,21,0),"^",2) D:Y'="" Y^DIQ W:Y'="" !,"Extubated In: "_Y I $D(^SRF(SRTN,6,V,6)) S USER=+^(6) I USER'="" D N W:EXIN'="" ?40,"Extubated By: "_USER W:EXIN="" !,"Extubated By: "_USER
 K EXIN S REIN=$P(S,"^",24) I REIN="Y" W !,"Reintubated within 8 Hours: YES"
 I $P(S,"^",19)="Y" W !,"Heat, Moisture Exchanger Used: YES"
 I $P(S,"^",20)="Y" W !,"Bacteria Filter in Circuit: YES"
 S S(2)=$S($D(^SRF(SRTN,6,V,2)):^(2),1:""),S(3)=$S($D(^SRF(SRTN,6,V,3)):^(3),1:"")
 S CONT=$P(S(2),"^"),SRB=$P(S(2),"^",2) W:CONT'="" !,"Continuous: "_$S(CONT="Y":"YES",1:"NO") I SRB S SRB=$S(SRB=1:"HYPERBARIC",SRB=2:"HYPOBARIC",1:"ISOBARIC") W:CONT'="" ?40,"Baricity: "_SRB W:CONT="" !,"Baricity: "_SRB
 K CONT S (Y,PUN)=$P(S(2),"^",3),C=$P(^DD(130.06,27,0),"^",2) D:Y'="" Y^DIQ W:PUN'="" !,"Puncture Site: "_Y
 I $P(S(2),"^",5)'="" S Y=$P(S(2),"^",5),C=$P(^DD(130.06,29,0),"^",2) D:Y'="" Y^DIQ W:PUN'="" ?40,"Needle Size: "_Y W:PUN="" !,"Needle Size: "_Y
 K PUN I $D(^SRF(SRTN,6,V,8)) S S(8)=^(8),(Y,LEV)=$P(S(8),"^",3) I LEV'="" S C=$P(^DD(130.06,43,0),"^",2) D:Y'="" Y^DIQ W !,"Level: "_Y
 D ^SROARPT2
 Q
UL I SRT="UL" D UL1
Q I $Y>(IOSL-10) W ! D FOOT^SROARPT Q:SRSOUT  D HDR^SROARPT
 Q
UL1 I IO(0)=IO,'$D(ZTQUEUED) W !
 W $C(13) F X=1:1:79 W "_"
 Q
N S:'$D(USER) USER="" I USER'="" S USER=$P($G(^VA(200,USER,0)),"^")
 Q
LOOP ; break procedure if greater than 50 characters
 S SROPS(M)="" F LOOP=1:1 S MM=$P(SROPER," "),MMM=$P(SROPER," ",2,200) Q:MMM=""  Q:$L(SROPS(M))+$L(MM)'<50  S SROPS(M)=SROPS(M)_MM_" ",SROPER=MMM
 Q
PRIN ; print principal procedure information
 S SROPER=$P(^SRF(SRTN,"OP"),"^"),X=$P(^("OP"),"^",2),Z=$S(X:$$CPT^ICPTCOD(X),1:"^NOT ENTERED"),SRCPT=$P(Z,"^",2)_"  "_$P(Z,"^",3)
 I $P($G(^SRF(SRTN,30)),"^")&$P($G(^SRF(SRTN,.2)),"^",10) S SROPER="** ABORTED ** "_SROPER
 K SROPS,MM,MMM S:$L(SROPER)<50 SROPS(1)=SROPER I $L(SROPER)>49 S SROPER=SROPER_"  " F M=1:1 D LOOP Q:MMM=""
 W SROPS(1) I $D(SROPS(2)) W !,?22,SROPS(2) I $D(SROPS(3)) W !,?22,SROPS(3)
 W !,?4,"CPT Code: "_SRCPT K SRCPT
 S SRI=0,SRX="Modifiers: -" F  S SRI=$O(^SRF(SRTN,"OPMOD",SRI)) Q:'SRI  D
 .S SRZ=$P(^SRF(SRTN,"OPMOD",SRI,0),"^"),SRY=$$MOD^ICPTMOD(SRZ,"I")
 .W !,?5,SRX_$P(SRY,"^",2)_" "_$E($P(SRY,"^",3),1,59)
 .S SRX="           -"
 Q
OTHER ; other procedures
 W ! S (OTH,CNT)=0 F  S OTH=$O(^SRF(SRTN,13,OTH)) Q:'OTH  S CNT=CNT+1 D OTH
 Q
OTH S OTHER=$P(^SRF(SRTN,13,OTH,0),"^"),X=$P($G(^SRF(SRTN,13,OTH,2)),"^"),Z=$S(X:$$CPT^ICPTCOD(X),1:"^NOT ENTERED"),SRCPT=$P(Z,"^",2)_"  "_$P(Z,"^",3)
 D:$Y>(IOSL-10) UL W !,"Other:  "_OTHER,!,?4,"CPT Code: "_SRCPT K SRCPT
 S SRI=0,SRX="Modifiers: -" F  S SRI=$O(^SRF(SRTN,13,OTH,"MOD",SRI)) Q:'SRI  D
 .S SRZ=$P(^SRF(SRTN,13,OTH,"MOD",SRI,0),"^"),SRY=$$MOD^ICPTMOD(SRZ,"I")
 .W !,?5,SRX_$P(SRY,"^",2)_" "_$E($P(SRY,"^",3),1,59)
 .S SRX="           -"
 Q
