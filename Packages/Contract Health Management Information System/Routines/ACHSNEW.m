ACHSNEW ; IHS/ITSC/PMF - SET UP A NEW FISCAL YEAR FOR A FACILITY ;   [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 S ACHS("SETNEW")=""
 D ^ACHSVAR
 I $D(ACHSXQT) G K
 D FY^ACHSUF,C0SUB^ACHSUF
 I $D(ACHSERR),ACHSERR=1 G GLOBERR^ACHSUF
 S ACHS("FYX")=$O(ACHSFYWK(DUZ(2),9999),-1)
 S ACHS("ACWKX")=ACHSFYWK(DUZ(2),ACHS("FYX"))
 G GLOBERR^ACHSUF:'$D(^ACHS(9,DUZ(2),"FY",ACHS("FYX"),"W",ACHS("ACWKX")))
BD ;
 W !!,"Which fiscal year? ("
 S ACHS("YR")=1700+$E(DT,1,3)
 W ACHS("YR")-2," to ",ACHS("YR")+1,") "
 D READ^ACHSFU
 G K:$D(DTOUT)!$D(DUOUT)!(Y="")
 I $L(Y)'=4!(+Y>(ACHS("YR")+1))!(+Y<(ACHS("YR")-2)) W !!,"Enter a four-digit fiscal year - see listed examples." D SB1^ACHSFU G BD
 S ACHS("YR")=+Y
 I $D(^ACHS(9,DUZ(2),"FY",ACHS("YR"))) W *7,!!,"This fiscal year is already on file and cannot be reset.",!! G BD
 I $E($O(^ACHSF(DUZ(2),"D","B","1"_$E(ACHS("YR"),4)_"00000")),2)=$E(ACHS("YR"),4) D  G BD
 . W *7,!!,"P.O.s still exist for FY ",ACHS("YR")-10," that will interfere with ",ACHS("YR")," P.O. entry.",!,"Use the ^ACHSYFYD programmer utility to delete P.O.'s for FY ",ACHS("YR")-10,"."
 .Q
 D WAIT^DICD
AUTO ;EP - For automatic setup of new FY.
 I $D(ACHSFYWK(DUZ(2),ACHS("YR")-1)),ACHSFYWK(DUZ(2),ACHS("YR")-1),$P(^ACHS(9,DUZ(2),"FY",ACHS("YR")-1,"W",ACHSFYWK(DUZ(2),ACHS("YR")-1),0),U,2) W !!,"Registers Already Closed....",!! G AUTO1
 ; S ACHSACY=ACHS("YR")-1,ACHSASK=1,R=+ACHSFYWK(DUZ(2),ACHSACY),ACHS("DCR")="",ACHSNUM=1
 S ACHSACY=ACHS("YR")-1,ACHSASK=1,ACHS("DCR")="",ACHSNUM=1
 G DCR3^ACHSODQ
 ;
AUTO1 ;EP
 I $D(ACHSERR),ACHSERR=1 G K
 U IO(0)
 W !!,"Initializing New Registers.  Please Wait...",!
 D INIT^ACHSUF
AUTO2 ;
 K ^ACHS(9,DUZ(2),"FY",ACHS("YR"))
 S:'$D(^ACHS(9,DUZ(2),0)) ^ACHS(9,DUZ(2),0)=DUZ(2)_"^^"_DUZ(2)_"^1^1"
 S ^ACHS(9,DUZ(2),"FY",ACHS("YR"),0)=ACHS("YR")_"^0^0",^ACHS(9,DUZ(2),"FY",ACHS("YR"),1)="0^0^0^0^0^0^0",^ACHS(9,"B",DUZ(2),DUZ(2))=""
 S:'$D(^ACHS(9,DUZ(2),"FY",0)) ^ACHS(9,DUZ(2),"FY",0)=$$ZEROTH^ACHS(9002069,10)
 S X=$G(^ACHS(9,DUZ(2),"FY",0))
 S $P(^ACHS(9,DUZ(2),"FY",0),U,3)=ACHS("YR")
 S $P(^ACHS(9,DUZ(2),"FY",0),U,4)=+$P(X,U,4)+1
 S ^ACHS(9,DUZ(2),"FY",ACHS("YR"),"C")="0^0^0"
 S:'$D(^ACHS(9,DUZ(2),"FY",ACHS("YR"),"W",0)) ^ACHS(9,DUZ(2),"FY",ACHS("YR"),"W",0)="^9002069.02A^1^1",^(1,0)=1
 I '$D(ACHSAUTO) S DA=DUZ(2),DR="10///"_ACHS("YR"),DR(2,9002069.01)="1",DIE="^ACHS(9," D ^DIE
 I '$D(ACHSAUTO) K DR S DA=DUZ(2),DR="10///"_ACHS("YR"),DR(2,9002069.01)="2//1" D ^DIE
 I '$D(ACHSAUTO) S DIE="^ACHS(9,"_DUZ(2)_","_"""FY"""_",",DR="3//0",DA=ACHS("YR") D ^DIE
 I '$D(^ACHS(9,DUZ(2),"FY",ACHS("YR"),"W",$O(^ACHS(9,DUZ(2),"FY",ACHS("YR"),"W",0)),1)) S ^(1)="0^0^0^0^0^0^0"
 W !!,"FINISHED....",!!
 G K
 ;
CANNOT ;
 W *7,!!,"Cannot Add New Fiscal Year Until After ",$$FMTE^XLFDT(ACHSFYDT),".",!
 I $$DIR^XBDIR("E")
K ;
 K DA,DIC,DIE,DR
 I $D(ACHSAUTO) K ACHS,ACHSAUTO
 Q
 ;
