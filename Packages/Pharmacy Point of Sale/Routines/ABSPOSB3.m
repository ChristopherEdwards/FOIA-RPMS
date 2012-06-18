ABSPOSB3 ; IHS/FCS/DRS - FSI/ILC A/R interface ;      
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
V681 ;EP - given VSTDFN
 ; - add a V68.1 diagnosis if it doesn't already have one
 N IEN
V681A ;
 Q:'$$V681IEN  ; V68.1 not on this system?! ; 03/26/2001
 Q:$$HASV681
 S IEN=$$ADDV681
 ;W !,"Testing - in V681^"_$T(+0)," return value is ",IEN,!
 I IEN<0 G V681A:$$IMPOSS^ABSPOSUE("FM","TRI","Failed to add diagnosis",,"V681",$T(+0))
 Q
HASV681() ; does VSTDFN already have a V68.1 among its diagnoses? ret true/false
 N RET S RET=0
 N A S A=0
 F  S A=$O(^AUPNVPOV("AD",VSTDFN,A)) Q:'A  I $$ISV681(A) S RET=1 Q
 Q RET
ISV681(VPOVDFN)    ; is this a V68.1?
 N X S X=$$V681IEN
 Q ($P(^AUPNVPOV(VPOVDFN,0),U)=X)
V681IEN()          Q $O(^ICD9("B","V68.1",0))
ADDV681() ; given VSTDFN ; add a V68.1 diagnosis to the visit 
 ; if you $$, it gives you back the IEN
A681A L +^AUPNVPOV:300 I '$T G A681A:$$IMPOSS^ABSPOSUE("L","RIT","LOCK ^AUPNVPOV",,"ADDV681",$T(+0))
 N DO,DD,DIC,DA,X,DINUM,Y,DTOUT,DUOUT,DLAYGO
 ; DO killed so that Fileman doesn't assume leftover stuff
 S DIC="^AUPNVPOV(",DIC(0)=""
 S X=$$V681IEN
 N DATA S DATA(.03)=VSTDFN
 S DATA(.02)=$P(^AUPNVSIT(VSTDFN,0),U,5)
 N I S DIC("DR")="" F I=.02,.03 D
 . S DIC("DR")=DIC("DR")_I_"////"_DATA(I)_";"
 S DIC("DR")=$E(DIC("DR"),1,$L(DIC("DR"))-1)
 K DO,DD D FILE^DICN
 L -^AUPNVPOV
 Q:$Q +Y Q
CLINIC ;EP - given VSTDFN - if it doesn't have one, give it one: pharmacy
 I $$HASCLIN Q
 N DIDEL,DTOUT,DIE,DA,DR
 S DIE="^AUPNVSIT(",DA=VSTDFN,DR=".08////"_$$PHARMCLI
 D ^DIE
 Q
HASCLIN() ; does VSTDFN already have a clinic?  return true or false 
 Q $P(^AUPNVSIT(VSTDFN,0),U,8)
PHARMCLI()         ; return IEN of PHARMACY clinic
 Q $O(^DIC(40.7,"B","PHARMACY",""))
PROVIDER() ;EP - given VSTDFN - and ^TMP($J,"VCPT",*)
 ; if it doesn't have a provider, give it one
 ; and make this the primary provider - he is the prescribing physician
 ; on the first prescription
P1 L +^AUPNVPRV:300 I '$T G P1:$$IMPOSS^ABSPOSUE("L","RIT","LOCK ^AUPNVPRV",,"PROVIDER",$T(+0))
 I $O(^AUPNVPRV("AD",VSTDFN,0)) Q  ; already has a provider
 N VCPT S VCPT=$O(^TMP($J,"VCPT",0)) ; take first VCPT
 N RXI S RXI=$P($G(^ABSVCPT(9002301,VCPT,"SPEC")),U) Q:'RXI
 ; PRESCRIPTION file points to file 200
 ; follow the links from file 200 -> file 16 -> file 6
 ; V PROVIDER file points to file 6
 N PROV200 S PROV200=$P(^PSRX(RXI,0),U,4) Q:'PROV200  ; impossible?
 N PROV16 S PROV16=$P($G(^VA(200,PROV200,0)),U,16) Q:'PROV16  ; imposs?
 N PROV6 S PROV6=$P($G(^DIC(16,PROV16,"A6")),U)  Q:'PROV6  ; imposs?
 N DO,DD,DIC,DA,X,DINUM,Y,DTOUT,DUOUT,DATA
 ; leave DO undef
 S DIC="^AUPNVPRV(",DIC(0)=""
 S X=PROV6
 S DATA(.02)=$P(^AUPNVSIT(VSTDFN,0),U,5)
 S DATA(.03)=VSTDFN
 S DATA(.04)="P"
 N I S DIC("DR")="" F I=.02,.03,.04 D
 . S DIC("DR")=DIC("DR")_I_"////"_DATA(I)
 . I I'=.04 S DIC("DR")=DIC("DR")_";"
 K DO,DD D FILE^DICN
 L -^AUPNVPRV
 Q:$Q +Y Q
