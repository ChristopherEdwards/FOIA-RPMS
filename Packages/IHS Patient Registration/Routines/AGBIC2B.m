AGBIC2B ; IHS/ASDS/EFG - ENTER CURRENT COMMUNITY ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
L1 ;
 K AG("HSDA"),AG("PRVCM"),AG("COMM")
 W !!,"Enter PRESENT COMMUNITY: "
 D DEF
 D READ^AG
 G:$D(DUOUT)!$D(DTOUT)!$D(DFOUT) END
 I $D(DLOUT)&($D(AG("EDIT")))&($D(AG("PRVCM"))) D  G L2
 . S Y=AG("PRVCM")
 I $D(DLOUT)!$D(DQOUT) S Y="?"
L2 ;
 S DIC="^AUTTCOM("
 S DIC(0)="QEM"
 S X=Y
 D ^DIC
 G L1:Y<0
 S AG("CPTR")=+Y
 S AG("CITY")=$P(Y,U,2)
 S:$P(^AUTTCTY($P(^AUTTCOM($P(Y,U),0),U,2),0),U,5)="Y" AG("HSDA")="Y"
L3 ;
 K AG("EDIT"),AG("BIRTH"),AG("PRVDT")
 W !!,"When did the patient move to this community?  "
 W "( ""B"" = ""at BIRTH"" ) ",!,"   DATE: "
 D DEF1
 D READ^AG
 Q:$D(DTOUT)!$D(DFOUT)
 G L1:$D(DUOUT)
 I $D(DLOUT)&($D(AG("EDIT")))&($D(AG("PRVDT"))) D  G L3A
 . S Y=AG("PRVDT")
 I $D(DLOUT)!$D(DQOUT) S Y="?"
L3A ;
 I Y="B" D
 . S AG("BIRTH")=""
 . S DIC=2
 . S DA=DFN
 . S DR=.03
 . D ^DIC
 . S:$D(AG("LKDATA")) Y=AG("LKDATA")
 . I $D(AG("LKERR"))!($D(AG("LKDATA"))&(+Y<99999)) D
 .. W !,*7,"There is no DATE-OF-BIRTH on file.",!
 .. S Y="?"
 .. K AG("BIRTH")
 S X=Y
 S %DT=""
 S %DT(0)="-NOW"
 D ^%DT
 K %DT(0)
 G L1:X="^"
 G END:$D(AG("EDIT"))&(X="")
 G L3:Y<0
 S AG("CDATE")=Y
L4 ;
 K ^AUPNPAT(DFN,51)
 S ^AUPNPAT(DFN,51,0)="^9000001.51D^"_AG("CDATE")_"^1"
 S ^AUPNPAT(DFN,51,AG("CDATE"),0)=AG("CDATE")_U_DT_U_AG("CPTR")
 S DIE="^AUPNPAT("
 S DA=DFN
 S DR="1118///"_AG("CITY")
 D ^DIE
CKHSDA ;
 S AG("COMM")="N"
 G STCOMVER:'$D(AG("HSDA"))
 D COMMVER
 G:$D(DUOUT) L3
 I (Y'["Y")&(Y'["N") D  G CKHSDA
 . D YN^AG
 S AG("COMM")=Y
STCOMVER ;
 D S1
 S DR="1121///"_AG("COMM")
 D ^DIE
 G END:AG("COMM")="Y"
CKPREV ;
 G END:$D(AG("BIRTH"))
 G END:AG("CDATE")>"2880915"
 W !!,"This patient's CURRENT COMMUNITY is "
 W $S('$D(AG("HSDA")):"not within a HSDA!",1:"within a HSDA but is not verified!")
MSG1 ;
 W !,"Enter any other COMMUNITY lived in since 09/16/88:  "
 S AG("COMM")="N"
 S AG("2BPREV")=""
 D READ^AG
 G:$D(DUOUT)!$D(DTOUT)!$D(DFOUT) END
 K AG("2BPREV")
 S DIC="^AUTTCOM("
 S DIC(0)="QEM"
 S X=Y
 D ^DIC
 G END:Y<0
 I $P(^AUTTCTY($P(^AUTTCOM($P(Y,U),0),U,2),0),U,5)'="Y" D  G MSG1
 . W !!,$P(^AUTTCOM($P(Y,U),0),U)," is not within a HSDA!"
CKPRVER ;
 D COMMVER
 G:$D(DUOUT)!(Y["N") CKPREV
 I Y'["Y" D  G CKPRVER
 . D YN^AG
 S AG("COMM")="Y"
SETPRV ;
 D S1
 S DR="1122///"_AG("COMM")
 D ^DIE
 G END
END ;
 K AG("COMMVER"),AG("BIRTH"),AG("HSDA"),AG("PRVDT"),AG("PRVCM")
 K AG("COMM"),DIC
 Q
DEF ;
 K AG("EDIT")
 Q:'$D(^AUPNPAT(DFN,51,0))
 S AG("CDATE")=$P(^AUPNPAT(DFN,51,0),U,3)
 Q:AG("CDATE")=""
 Q:'$D(^AUPNPAT(DFN,51,AG("CDATE")))
 S AG("CPTR")=$P(^AUPNPAT(DFN,51,AG("CDATE"),0),U,3)
 Q:+AG("CPTR")<1
 Q:'$D(^AUTTCOM(AG("CPTR")))
 W $P(^AUTTCOM(AG("CPTR"),0),U),"//"
 S AG("EDIT")=""
 S AG("PRVCM")=$P(^AUTTCOM(AG("CPTR"),0),U)
 Q
DEF1 ;
 K AG("EDIT")
 I $D(^AUPNPAT(DFN,51,0)),AG("CDATE")]"" D
 . S Y=$P(^AUPNPAT(DFN,51,AG("CDATE"),0),U)
 . D DD^%DT
 . W !,Y,"// "
 . S AG("EDIT")=""
 . S AG("PRVDT")=Y
 Q
EDCOM ;EP - Edit Communities.
E1 ;
 K DIC("S")
 S DIC=9000001.51
 S DR=.01
 S X=DFN
 D ^DIC
 S DA=+Y
 S DIE="^AUPNPAT("
 S DR=5101
 S DR(2,9000001.51)=".01;.03;S $P(^AUPNPAT(DFN,51,D1,0),U,2)=$P(^AUPNPAT(DFN,51,D1,0),U)"
 D ^DIE
E2 ;
 S AG("DRENT")=0
 S DR=.03
 S AG("CITY")=""
 S DIC=9000001.51
 S DA=DFN
 D ^DIC
 I $D(AG("LKDATA")),AG("LKDATA")]"",$D(^AUTTCOM(AG("LKDATA"))) D  Q:$D(AG("2BPREV"))
 .S (AG("CITY"),AG("2BPREV"))=$P(^AUTTCOM(AG("LKDATA"),0),U)
 .S AG("HSDA")=$P(^AUTTCOM(AG("LKDATA"),0),U,11)
 S DIE="^AUPNPAT("
 S DA=DFN
 S DR="1118///"_AG("CITY")
 D ^DIE
 Q
S1 ;
 K DFOUT,DTOUT,DUOUT,DLOUT,DQOUT
 Q
COMMVER ;EP
 S AG("COMMVER")=" "
 S:$D(^AUPNPAT(DFN,11)) AG("COMMVER")=$P(^AUPNPAT(DFN,11),U,21)
 W !!,"Has this COMMUNITY been VERIFIED? (Y/N): "
 W:(AG("COMMVER")["Y")!(AG("COMMVER")["N") AG("COMMVER")," // "
 D READ^AG
 S:$D(DLOUT)&(AG("COMMVER")'=" ") Y=AG("COMMVER")
 S AG("COMAGED1")=Y
 I "YC"[AGOPT(14),$D(AG("SEL")),AG("SEL")="6" D
 . S DIE="^AUPNPAT("
 . S DA=DFN
 . S DR="1121///"_AG("COMAGED1")
 . D ^DIE
 . D ^AGBIC2C
 Q
