BDPIQ ; IHS/CMI/TMJ - Inquire to a Specific Patient Record ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
 ;
PATIENT2 ; ASK FOR PATIENT UNTIL USER SELECTS OR QUITS
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D DIC^BDPFMC K DIC
 I Y<1 D ^XBFMK,EN^XBVK("BDP") Q
 S BDPDFN=+Y,BDPREC("PAT NAME")=$P(^DPT(+Y,0),U)
 S BDPQ=0
 I $$DOD^AUPNPAT(BDPDFN) D  I 'Y K BDPDFN,BDPREC("PAT NAME") Q
 . W !!,"This patient is deceased."
 . S DIR(0)="YO",DIR("A")="Are you sure you want this patient",DIR("B")="NO" K DA D ^DIR K DIR
 . W !
 . Q
 ;
 D PPEP^BDPLMDSP(BDPDFN,$G(BDPDETL))
 D EN^XBVK("BDP")
 D ^XBFMK
 Q
 ;
 ;
 ;
PROVDISP ;Display if Patient has existing Designated Providers
 W ?10,"**CURRENT DESIGNATED PROVIDERS - BY PROVIDER CATEGORY TYPE**",!
 W !,?15,"Assigned to Patient: "
 W ?35,$P($G(^DPT(BDPDFN,0)),U)
 W !,?10,"**CATEGORY TYPE**",?46,"**CURRENT PROVIDER ASSIGNED**",!
 I '$D(^BDPRECN("AA",BDPDFN)) W !,?20,"**--NO EXISTING DESIGNATED PROVIDERS--**",! S BDPQ=1 Q
 S BDPQ=0
 S BDPTYPE=""
 S BDPCOUNT=0
 F  S BDPTYPE=$O(^BDPRECN("AA",BDPDFN,BDPTYPE)) Q:BDPTYPE=""  S BDPCOUNT=BDPCOUNT+1 D NEXT
 D PAUSE^BDP
 Q
NEXT ;2ND $O
 S BDPRIEN=""
 F  S BDPRIEN=$O(^BDPRECN("AA",BDPDFN,BDPTYPE,BDPRIEN)) Q:BDPRIEN'=+BDPRIEN  D
 . Q:BDPTYPE=""
 . Q:BDPRIEN=""
 . S BDPPTNAM=$P(^DPT(BDPDFN,0),U,1) ;Patient Print Name
 . S BDPTYPNM=$P(^BDPTCAT(BDPTYPE,0),U,1) ;Type Print
 . S BDPCPRV=$P($G(^BDPRECN(BDPRIEN,0)),U,3) ;Current Provider IEN
 . I BDPCPRV="" S BDPCPRVP="<None Currently Assigned>" ;If no current Provider
 . E  S BDPCPRVP=$P(^VA(200,BDPCPRV,0),U,1) ;Provider Print Name
 . W !,?5,BDPCOUNT,?10,$E(BDPTYPNM,1,30),?50,$E(BDPCPRVP,1,35)
 . S I=I+1 ; increment outer loop counter to limit display to 10 Designated Providers
 . Q
 ;D PAUSE^BDP
 Q
 ;
 ;
