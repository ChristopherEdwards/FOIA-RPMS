BDMPROB ; IHS/CMI/LAB - ;
 ;;2.0;IHS PCC SUITE;**4**;JUN 14, 2007
 ;
 ;
ADDPROB(APCDDX,APCDP,APCDDLM,APCDCLS,APCDN,APCDFAC,APCDDTE,APCDSTAT,APCDDOO,APCDCLAS,APCDEBU,APCDEC1,APCDEC2,APCDEC3) ;PEP called to non-interactively add a problem to the pcc problem list
 ;APCDDX is the dx - pass in "`"_ien format or pass code (required)
 ;APCDP is the patient dfn (required)
 ;APCDDLM is the date last modified, if null I will stuff DT, PASS IN EXTERNAL FORMAT PLEASE
 ;APCDCLS is the class (not required)
 ;APCDN - provider narrative pass either "`"_ien of prov narr or pass narrative text
 ;APCDFAC - facility ien, if null will use DUZ(2)
 ;APCDDTE - date entered, if null will use DT , PASS IN EXTERNAL FORMAT PLEASE
 ;APCDSTAT - status I or A WILL DEFAULT TO A IF NONE PASSED
 ;APCDDOO - date of onset (pass in EXTERNAL  format please) (not required)
 ;APCDCLAS= .15 field
 ;APCDEBU = ENTERED BY (field 1.03) if blank  is stuffed with DUZ
 ;APCDEC1, APCDEC2, APCDEC3 - E CODES pass in "`"_ien format or pass code (required)
 ;
 ;error codes will be past back
 ;    1 = invalid dx, either not a valid ien, inactive code, E code
 ;    2 = invalid patient dfn, either not a valid dfn or patient merged
 ;    3 = invalid class code
 ;    4 = error creating entry with FILE^DICN
 ;    5 = invalid date last modified
 ;    6 = invalid provider narrative
 ;    7 = invalid date entered
 ;    8 = invalid facility
 ;    9 = invalid status
 ;   10 = invalid date of onset
 ;   11 = invalid ecode 1
 ;   12 = invalid ecode 2
 ;   13 = invalid ecode 3
 ;
 NEW APCDERR
 S APCDERR=0
 D EN^XBNEW("AP^BDMPROB","APCDDX;APCDP;APCDDLM;APCDCLS;APCDN;APCDFAC;APCDDTE;APCDSTAT;APCDDOO;APCDCLAS;APCDEBU;APCDERR;APCDEC1;APCDEC2;APCDEC3")
 Q APCDERR
 ;
AP ;EP
 NEW IEN,%,F,%FDA
P I '$G(APCDP) S APCDERR=2 Q
 I '$D(^DPT(APCDP)) S APCDERR=2 Q
 I $P(^DPT(APCDP,0),U,19) S APCDERR=2 Q
 I '$D(^AUPNPAT(APCDP)) S APCDERR=2 Q
 S Y=APCDP D ^AUPNPAT
DX ;DX CHK
 I $G(APCDDX)="" S APCDERR=1 Q
 D CHK^DIE(9000011,.01,"",APCDDX,.%) I %="^" S APCDERR=1 Q
 S APCDDX=%
DLM ;
 I $G(APCDDLM)="" S APCDDLM=$$FMTE^XLFDT(DT,"1D")
 D CHK^DIE(9000011,.03,"",APCDDLM,.%) I %="^" S APCDERR=5 Q
CLS ;
 I $G(APCDCLS)="" S APCDCLS=""
 I APCDCLS]"" D  Q:APCDERR
 .D CHK^DIE(9000011,.04,"",APCDCLS,.%) I %="^" S APCDERR=3 Q
NARR ;
 I $G(APCDN)="" S APCDERR=6 Q
 I $$CHKNARR(APCDN) S APCDERR=6 Q
FAC ;
 I '$G(APCDFAC) S APCDFAC=DUZ(2)
 I '$D(^AUTTLOC(APCDFAC)) S APCDERR=8 Q
DTE ;
 I $G(APCDDTE)="" S APCDDTE=$$FMTE^XLFDT(DT,"1D")
 D CHK^DIE(9000011,.08,"",APCDDTE,.%) I %="^" S APCDERR=7 Q
STATUS ;
 I $G(APCDSTAT)="" S APCDSTAT="A" G DOO
 D CHK^DIE(9000011,.12,"",APCDSTAT,.%) I %="^" S APCDERR=9 Q
DOO ;
 S:$G(APCDDOO)="" APCDDOO="" G CLASS
 D CHK^DIE(9000011,.13,"",APCDDOO,.%) I %="^" S APCDERR=10 Q
CLASS ;
 S APCDCLAS=$G(APCDCLAS)
 S APCDEC1=$G(APCDEC1)
 I APCDEC1 D CHK^DIE(9000011,.16,"",APCDEC1,.%) I %="^" S APCDERR=11 Q
 S APCDEC2=$G(APCDEC2)
 I APCDEC2 D CHK^DIE(9000011,.17,"",APCDEC2,.%) I %="^" S APCDERR=12 Q
 S APCDEC3=$G(APCDEC3)
 I APCDEC3 D CHK^DIE(9000011,.18,"",APCDEC3,.%) I %="^" S APCDERR=13 Q
NMBR ;calculate new number
 NEW X,Y S X=0,Y="" F  S Y=$O(^AUPNPROB("AA",APCDP,APCDFAC,Y)) S:Y'="" X=$E(Y,2,4) I Y="" S X=X+1 K Y Q
 S APCDNMBR=X
FILE ;
 S APCDOVRR=1,APCDALVR=""
 S X=APCDDX,DIC(0)="L",DIC="^AUPNPROB(",DLAYGO=9000011,DIADD=1
 S DIC("DR")=".02////"_APCDP_";.03///"_APCDDLM_";.04///"_APCDCLS_";.05///"_APCDN_";.06////"_APCDFAC_";.08///"_APCDDTE_";.07///"_APCDNMBR_";.12///"_APCDSTAT_";.13///"_APCDDOO_";1.03////"_$S($G(APCDEBU):APCDEBU,1:DUZ)_";.15///"_APCDCLAS
 S DIC("DR")=DIC("DR")_";.16///"_APCDEC1_";.17///"_APCDEC2_";.18///"_APCDEC3
 K DD,DO D FILE^DICN K DD,DO,DR,DLAYGO,DIADD,DIC
 I Y=-1 S APCDERR=4 Q
 Q
CHKNARR(D) ;
 NEW %,F
 S F=0
 I $E(D)="`" S D=$P(D,"`",2) D  Q F
 .I '$D(^AUTNPOV(D)) S F=1
 .;S APCDN=D
 .Q
 S X=D X $P(^DD(9999999.27,.01,0),U,5,99)
 I '$D(X) S F=1
 Q F
DELPROB(P,REASON,OTHER) ;PEP called to delete a problem from the PCC Problem list
 ;non interactive -1 will be returned if a valid problem ien was not passed
 ;sets .12 field to D, sets 2.01 to DUZ, set 2.02 to $$NOW
 ;if passed sets 2.03 to REASON
 ;if passed, sets 2.04 to OTHER
 NEW DA,DIE,DR
 I '$G(P) Q -1
 I '$D(^AUPNPROB(P)) Q -1
 S REASON=$G(REASON)
 S OTHER=$G(OTHER)
 S DA=P  ;,DIK="^AUPNPROB(" D ^DIK
 S DIE="^AUPNPROB("
 S DR=".12////D;2.01////"_DUZ_";2.02///^S X=$$NOW^XLFDT;2.03///"_REASON_";2.04///"_OTHER
 D ^DIE K DA,DR,DIE
 I $D(Y) Q "-1^INVALID DATA"
 Q ""
TEST ;APCDDX,APCDP,APCDDLM,APCDCLS,APCDN,APCDFAC,APCDDTE,APCDSTAT,APCDDOO,APCDCLAS,APCDEBU,APCDEC1,APCDEC2,APCDEC3
 S X=$$ADDPROB(250.00,10,3101111,,"THIS IS MY NARRATIVE",5217,3101111,"A",,"P",,"E000.9","E800.1","E000.0")
 W !,X
 Q
TESTDEL ;
 S X=$$DELPROB(1200,"OTHER","PROBLEM IS RESOLVED")
 W !,X
 Q
