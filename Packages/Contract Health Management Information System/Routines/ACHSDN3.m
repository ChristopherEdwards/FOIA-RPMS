ACHSDN3 ; IHS/ITSC/PMF - DENIAL EDIT PROVIDERS ;  [ 02/12/2002  10:19 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**3**;JUN 11, 2001
 ;ACHS*3.1*3  remove the 'other providers' node correctly
 ;
A ;
 Q:$D(DUOUT)
 W @IOF,?33,"PROVIDER EDITS",!,$$REPEAT^XLFSTR("=",79),!,"PRIMARY PROVIDER....",!
 K ACHDSP
 S A=$G(^ACHSDEN(DUZ(2),"D",ACHSA,100))
 G:$P(A,U)="Y" A2
 S ACHD("PROV",1)="N"
 W !,"   1. ",$P(A,U,3)
 G B
 ;
A2 ;
 S ACHD("PROV",1)="O",ACHD("PTR")=$P(A,U,2)
 I ACHD("PTR")]"",$D(^AUTTVNDR(ACHD("PTR"),0)) W !,"   1. ",$P($G(^AUTTVNDR(ACHD("PTR"),0)),U)
B ;
 W !!!,"OTHER PROVIDERS....",!
 S ACHD("TVNDR")=1
 G C:'$D(^ACHSDEN(DUZ(2),"D",ACHSA,200))
 ;
 ;2/8/01  pmf  ACHS*3.1*3  remove the 'other providers' node correctly
 ;I $P($G(^ACHSDEN(DUZ(2),"D",ACHSA,200,0)),U,4)=0 K ^ACHSDEN(DUZ(2),"D",ACHSA,0) G C ; ACHS*3.1*3
 I $P($G(^ACHSDEN(DUZ(2),"D",ACHSA,200,0)),U,4)=0 K ^ACHSDEN(DUZ(2),"D",ACHSA,200) G C ; achs*3.1*3
 ;
 S ACHD=0
B1 ;
 S ACHD=$O(^ACHSDEN(DUZ(2),"D",ACHSA,200,ACHD))
 G C:+ACHD=0
 S ACHD("PTR")=$P($G(^ACHSDEN(DUZ(2),"D",ACHSA,200,ACHD,0)),U)
 ;
 I ACHD("PTR")]"",$D(^AUTTVNDR(ACHD("PTR"),0)) S ACHD("TVNDR")=ACHD("TVNDR")+1,ACHD("PROV",ACHD("TVNDR"))="O^"_ACHD W !,"  ",ACHD("TVNDR"),". ",$P($G(^AUTTVNDR(ACHD("PTR"),0)),U) G B1
 S DIE="^ACHSDEN("_DUZ(2)_",""D"","
 S DA(2)=DUZ(2),DA(1)=ACHSA,DA=ACHD,DR=200,DR(2,9002071.02)=".01///@"
 D ^DIE
 G B1
 ;
C ;
 G D:'$D(^ACHSDEN(DUZ(2),"D",ACHSA,210))
 ;02/11/02 pmf  ACHS*3.1*3  remove the 'other providers not on file'
 ; node correctly
 ;I $P($G(^ACHSDEN(DUZ(2),"D",ACHSA,210,0)),U,4)=0 K ^ACHSDEN(DUZ(2),"D",ACHSA,0) G D  ; ACHS*3.1*3
 I $P($G(^ACHSDEN(DUZ(2),"D",ACHSA,210,0)),U,4)=0 K ^ACHSDEN(DUZ(2),"D",ACHSA,210) G D  ; ACHS*3.1*3
 ;
 F ACHD=0:0 S ACHD=$O(^ACHSDEN(DUZ(2),"D",ACHSA,210,ACHD)) Q:+ACHD=0  D
 .S ACHD("TVNDR")=ACHD("TVNDR")+1
 .S ACHD("PROV",ACHD("TVNDR"))="N^"_ACHD
 .W !,"  ",ACHD("TVNDR"),". ",$P($G(^ACHSDEN(DUZ(2),"D",ACHSA,210,ACHD,0)),U)
 ;
D ;
 S Y=$$DIR^ACHS("FO","Edit which? (1"_$S(+ACHD("TVNDR")>1:" thru "_ACHD("TVNDR"),1:"")_", A=add a vendor, RETURN=none) ","","","^D QUES^ACHSDN3",2)
 Q:$D(DTOUT)!$D(DUOUT)!(Y="")
 G E:+Y>0&(+Y'>ACHD("TVNDR"))
 G PROV:$E(Y)="A"
 D QUES
 G D
 ;
E ;
 W !!
 I Y=1 S ACHDSP="" D PRMPRV^ACHSDN1 G A
 G E2:$P(ACHD("PROV",+Y),U)="N"
 G A:$P(ACHD("PROV",+Y),U)'="O"
 I '$$DIE(".01:99",$P(ACHD("PROV",+Y),U,2),200)
 G A
 ;
E2 ;
 I '$$DIE(".01:99",$P(ACHD("PROV",+Y),U,2),210)
 G A
 ;
PROV ;
 S Y=$$DIR^ACHS("Y","Is the new provider in the VENDOR file? ","YES","","",2)
 G A:$D(DUOUT)!$D(DTOUT),O1:Y,O2:'Y
O1 ;
 S:'$D(^ACHSDEN(DUZ(2),"D",ACHSA,200,0)) ^ACHSDEN(DUZ(2),"D",ACHSA,200,0)=$$ZEROTH^ACHS(9002071,1,200)
 S DIC="^ACHSDEN("_DUZ(2)_",""D"","_ACHSA_",200,",DA(2)=DUZ(2),DA(1)=ACHSA,DIC(0)="AELMNQ"
 D ^DIC
 G:Y<1 A
 I '$$DIE(".01:99",+Y,200)
 K DA,DIC,DIE,DR
 G A
 ;
O2 ;
 S:'$D(^ACHSDEN(DUZ(2),"D",ACHSA,210,0)) ^ACHSDEN(DUZ(2),"D",ACHSA,210,0)=$$ZEROTH^ACHS(9002071,1,210)
 S DIC="^ACHSDEN("_DUZ(2)_",""D"","_ACHSA_",210,",DA(1)=ACHSA,DIC(0)="QAZEML",DA(2)=DUZ(2)
 D ^DIC
 G A:+Y<1
 I '$$DIE(".01:99",+Y,210)
 G A
 ;
QUES ;EP - From DIR
 W *7,!,"Enter one of the numbers shown, or an 'A'."
 Q
 ;
DIE(DR,DA,N) ; N = Global node
 W !!
 S DA(1)=ACHSA,DA(2)=DUZ(2),DIE="^ACHSDEN("_DUZ(2)_",""D"","_ACHSA_","_N_","
 I '$$LOCK^ACHS("^ACHSDEN(DUZ(2),""D"",ACHSA)","+") S DUOUT="" Q 0
 D ^DIE
 I '$$LOCK^ACHS("^ACHSDEN(DUZ(2),""D"",ACHSA)","-") S DUOUT="" Q 0
 Q 1
 ;
