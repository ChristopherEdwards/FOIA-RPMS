AG2B ; IHS/ASDS/EFG - ENTER COMMUNITY OF RESIDENCE DATA ;  
 ;;7.1;PATIENT REGISTRATION;**8**;AUG 25, 2005
 ;
L1 ;
 W !!,"Enter PRESENT COMMUNITY:  "
 D DEF
 D READ^AG
 Q:$D(DUOUT)!$D(DTOUT)!$D(DFOUT)
 G L3:$D(DLOUT)&$D(AG("EDIT"))
 I $D(DLOUT)!$D(DQOUT) S Y="?"
L2 ;
 S DIC="^AUTTCOM("
 S DIC(0)="QEM"
 S X=Y
 D ^DIC
 G L1:Y<0
 S AG("CPTR")=+Y
 S AG("CITY")=$P(Y,U,2)
L3 ;
 K AG("EDIT")
 W !!,"When did the patient move to this community?  "
 W "( ""B"" = ""at BIRTH"" ) "
 W !,"   DATE: "
 D DEF1
 D READ^AG
 Q:$D(DTOUT)!$D(DFOUT)
 G L1:$D(DUOUT),END:$D(DLOUT)&($D(AG("EDIT")))
 I $D(DLOUT)!$D(DQOUT) S Y="?"
L3A ;
 I Y="B" D
 . S DIC=2
 . S DA=DFN
 . S DR=.03
 . D ^AGDICLK
 . S:$D(AG("LKDATA")) Y=AG("LKDATA")
 . I $G(AG("LKERR"))!($D(AG("LKDATA"))&(+Y<99999)) D
 .. W !,*7,"There is no DATE-OF-BIRTH on file.",!
 .. S Y="?"
 S X=Y
 S %DT=""
 S %DT(0)="-NOW"
 D ^%DT
 K %DT(0)
 G L1:X="^",END:$D(AG("EDIT"))&(X=""),L3:Y<0
 S AG("CDATE")=Y
L4 ;
 S DIC("P")=9000001.51,DIC="^AUPNPAT("_DFN_",51,",DIC(0)="QML",(DINUM,X)=AG("CDATE"),DA(1)=DFN,DIC("DR")=".02////"_DT_";.03////"_AG("CPTR") K DD,DO D FILE^DICN
END ;
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
 Q
DEF1 ;
 K AG("EDIT")
 I $D(^AUPNPAT(DFN,51,0)),AG("CDATE")]"" D
 . S Y=$P(^AUPNPAT(DFN,51,AG("CDATE"),0),U)
 . D DD^%DT
 . W !,Y,"// "
 . S AG("EDIT")=""
 Q
EDCOM ;EP - Edit Communities (string in AGED1 and AGBICEDZ).
 I AGOPT(14)'="N" D  Q
 . D EDCOM^AGBIC2B
 . D COMMVER^AGBIC2B
 . D CMMNR^AGBIC2
 ;
 ;Get before picture of community information
 D GETS^DIQ(9000001,DFN_",","5101*","I","OCOM")
 ;
E1 ;
 K DIC("S")
 S DIE="^AUPNPAT("
 S DA=DFN
 S DR=5101
 S DR(2,9000001.51)=".01;.03;S $P(^AUPNPAT(DFN,51,D1,0),U,2)=$P(^AUPNPAT(DFN,51,D1,0),U)"
 D ^DIE
 ;
 ;Verify that an entry is present - AG*7.1*8
 I $O(^AUPNPAT(DFN,51,0))="",'$D(Y) W "??  Required" G E1
 Q
