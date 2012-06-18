BDPLINKI ; IHS/CMI/TMJ - LINK ROUTINE ON PARM PASS FROM THE DESG PROV PKG ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
 ;
START ;Get Record Information
 ;
 ;
UPDATE(BDPFILE,BDPFIELD,BDPDA,BDPPROV,BDPPAT,BDPLINKI) ;PEP Update Record
 I '$G(BDPLINKI) Q  ;don't process if coming from non-bdp
 ;this entry point is called from xrefs on various
 ;files/fields to update the current designated
 ;provider package
 ;called from 90360.1
 ;
 ;I $G(BDPLNKO)=1 Q  ;Quit this routine - BDPKLINKO is running
 ;
 I $G(BDPFILE)=9002086,$$INSTALLD("BW.3.0") Q  ;not with version 3.0
 I $G(BDPFILE)="" Q
 I $G(BDPFIELD)="" Q
 I $G(BDPDA)="" Q
 I $G(BDPPROV)="" Q  ;bdpprov is the pointer to file 200
 I $G(BDPPAT)="" Q
 D EN^XBNEW("UPDATE1^BDPLINKI","BDPFILE;BDPFIELD;BDPDA;BDPPROV;BDPPAT;BDPLINKI")
 Q
 ;
UPDATE1 ;
 ;special code to take care of 9000001 file 6/200 issue
 I BDPFILE=9000001,$P(^DD(9000001,.14,0),U,2)[6 S BDPPROV=$P(^VA(200,BDPPROV,0),U,16) I BDPPROV="" Q  ;can't process if no file 200 ptr
 ;
 ;
CKLINK ;Check which File to Populate
 ;
 S BDPTYPE=$P($G(^BDPRECN(BDPDA,0)),U) ;Get Type
 Q:BDPTYPE=""
 I BDPTYPE=2 D MHLINK Q
 I BDPTYPE=3 D SSLINK Q
 I BDPTYPE=4 D CDLINK Q
 I BDPTYPE=8 D WHLINK Q
 I BDPTYPE=1 D DPLINK Q
 E  Q  ;Quit if no Link
 Q
 ;
MHLINK ;Update the Desg. Spec. Provider Record
 ;This Adds a new record if none exist
 ;Updates the existing Patient Record if different Provider
 S BDPMHIEN=$O(^AMHPATR("B",BDPPAT,"")) ;MHIEN RECORD
 Q:BDPMHIEN=""  ;Quit if no Record found for this patient
 S BDPPRVCK=$P($G(^AMHPATR(BDPMHIEN,0)),U,2) ;Existing MH Prov
 Q:BDPPRVCK=BDPPROV  ;Quit if same Provider
 S DIE="^AMHPATR(",DA=BDPMHIEN,DR=".02///"_"`"_BDPPROV D ^DIE K DIE,DR,DA,DINUM
 Q
 ;
SSLINK ;Social Services Update
 ;This Adds a new record if none exist
 ;Updates the existing Patient Record if different Provider
 S BDPSSIEN=$O(^AMHPATR("B",BDPPAT,"")) ;SSIEN RECORD
 Q:BDPSSIEN=""  ;Quit if no Record found for this patient
 S BDPPRVCK=$P($G(^AMHPATR(BDPSSIEN,0)),U,3) ;Existing SS Prov
 Q:BDPPRVCK=BDPPROV  ;Quit if same Provider
 S DIE="^AMHPATR(",DA=BDPSSIEN,DR=".03///"_"`"_BDPPROV D ^DIE K DIE,DR,DA,DINUM
 Q
 ;
 ;
CDLINK ;Chemical Dependency Link Update
 ;This Adds a new record if none exist
 ;Updates the existing Patient Record if different Provider
 S BDPCDIEN=$O(^AMHPATR("B",BDPPAT,"")) ;CDIEN RECORD
 Q:BDPCDIEN=""  ;Quit if no Record found for this patient
 S BDPPRVCK=$P($G(^AMHPATR(BDPCDIEN,0)),U,4) ;Existing CD Prov
 Q:BDPPRVCK=BDPPROV  ;Quit if same Provider
 S DIE="^AMHPATR(",DA=BDPCDIEN,DR=".04///"_"`"_BDPPROV D ^DIE K DIE,DR,DA,DINUM
 Q
 ;
WHLINK ;Womens Health Update
 ;This Adds a new record if none exist
 ;Updates the existing Patient Record if different Provider
 S BDPWHIEN=$O(^BWP("B",BDPPAT,"")) ;WHIEN RECORD
 Q:BDPWHIEN=""  ;Quit if no Record found for this patient
 S BDPPRVCK=$P($G(^BWP(BDPWHIEN,0)),U,10) ;Existing WH Prov
 Q:BDPPRVCK=BDPPROV  ;Quit if same Provider
 S DIE="^BWP(",DA=BDPWHIEN,DR=".1///"_"`"_BDPPROV D ^DIE K DIE,DR,DA,DINUM
 Q
 ;
DPLINK ;Patient Primary Care Provider Update
 ;This Adds a new record if none exist
 ;Updates the existing Patient Record if different Provider
 S BDPDPIEN=$O(^AUPNPAT("B",BDPPAT,"")) ;DPIEN RECORD
 Q:BDPDPIEN=""  ;Quit if no Record found for this patient
 S BDPPRVCK=$P($G(^AUPNPAT(BDPDPIEN,0)),U,14) ;Existing DPP Prov
 Q:BDPPRVCK=BDPPROV  ;Quit if same Provider
 S DIE="^AUPNPAT(",DA=BDPDPIEN,DR=".14///"_"`"_BDPPROV D ^DIE K DIE,DR,DA,DINUM
 Q
 ;
 ;
 ;
 ;
KILL(BDPFILE,BDPFIELD,BDPDA,BDPPROV,BDPPAT,BDPLINKI) ;PEP - called from kill side of xrefs
 I '$G(BDPLINKI) Q  ;don't process if coming from non-bdp
 I $G(BDPFILE)="" Q
 I $G(BDPFIELD)="" Q
 I $G(BDPDA)="" Q
 I $G(BDPPROV)="" Q  ;bdpprov is the pointer to file 200
 I $G(BDPPAT)="" Q
 D EN^XBNEW("KILL1^BDPLINKI","BDPFILE;BDPFIELD;BDPDA;BDPPROV;BDPPAT;BDPLINKI")
 Q
KILL1 ;EP - CALLED FROM XBNEW
 ;This Adds a new record if none exist
 ;Updates the existing Patient Record if different Provider
 ;
 S BDPTYPE=$P($G(^BDPRECN(BDPDA,0)),U) ;Get Type
 Q:BDPTYPE=""
 I BDPTYPE=2 D MHKILL Q
 I BDPTYPE=3 D SSKILL Q
 I BDPTYPE=4 D CDKILL Q
 I BDPTYPE=8 D WHKILL Q
 I BDPTYPE=1 D DPKILL Q
 E  Q  ;Quit if no Link
 Q
 ;
 ;
MHKILL ;Kill Mental Health Record
 S BDPMHIEN=$O(^AMHPATR("B",BDPPAT,"")) ;MHIEN RECORD
 Q:BDPMHIEN=""  ;Quit if no Record found for this patient
 S BDPPRVCK=$P($G(^AMHPATR(BDPMHIEN,0)),U,2) ;Existing MH Prov
 ;Q:BDPPRVCK=BDPPROV  ;Quit if same Provider
 ;Q:BDPTYIEN=""  ;Quit if this type is not linked
 ;Q:BDPRIEN=""  ;NO entry of this type for this patient
 ;now delete last current provider field
 S DIE="^AMHPATR(",DA=BDPMHIEN,DR=".02///@" D ^DIE
 D ^XBFMK
 Q
 ;
SSKILL ;Social Services Kill
 S BDPSSIEN=$O(^AMHPATR("B",BDPPAT,"")) ;SSIEN RECORD
 Q:BDPSSIEN=""  ;Quit if no Record found for this patient
 S BDPPRVCK=$P($G(^AMHPATR(BDPSSIEN,0)),U,3) ;Existing SS Prov
 ;Q:BDPPRVCK=BDPPROV  ;Quit if same Provider
 ;Q:BDPTYIEN=""  ;Quit if this type is not linked
 ;Q:BDPRIEN=""  ;NO entry of this type for this patient
 ;now delete last current provider field
 S DIE="^AMHPATR(",DA=BDPSSIEN,DR=".03///@" D ^DIE
 D ^XBFMK
 Q
 ;
CDKILL ;Chemical Dependency Kill
 S BDPCDIEN=$O(^AMHPATR("B",BDPPAT,"")) ;CDIEN RECORD
 Q:BDPCDIEN=""  ;Quit if no Record found for this patient
 S BDPPRVCK=$P($G(^AMHPATR(BDPCDIEN,0)),U,4) ;Existing MH Prov
 ;Q:BDPPRVCK=BDPPROV  ;Quit if same Provider
 ;Q:BDPTYIEN=""  ;Quit if this type is not linked
 ;Q:BDPRIEN=""  ;NO entry of this type for this patient
 ;now delete last current provider field
 S DIE="^AMHPATR(",DA=BDPCDIEN,DR=".04///@" D ^DIE
 D ^XBFMK
 Q
 ;
WHKILL ;Womens Health Kill
 S BDPWHIEN=$O(^BWP("B",BDPPAT,"")) ;WHIEN RECORD
 Q:BDPWHIEN=""  ;Quit if no Record found for this patient
 S BDPPRVCK=$P($G(^BWP(BDPWHIEN,0)),U,10) ;Existing MH Prov
 ;Q:BDPPRVCK=BDPPROV  ;Quit if same Provider
 ;Q:BDPTYIEN=""  ;Quit if this type is not linked
 ;Q:BDPRIEN=""  ;NO entry of this type for this patient
 ;now delete last current provider field
 S DIE="^BWP(",DA=BDPWHIEN,DR=".1///@" D ^DIE
 D ^XBFMK
 Q
 ;
DPKILL ;Patient Care Primary Provider Kill
 S BDPDPIEN=$O(^AUPNPAT("B",BDPPAT,"")) ;DPIEN RECORD
 Q:BDPDPIEN=""  ;Quit if no Record found for this patient
 S BDPPRVCK=$P($G(^AUPNPAT(BDPDPIEN,0)),U,14) ;Existing MH Prov
 ;Q:BDPPRVCK=BDPPROV  ;Quit if same Provider
 ;Q:BDPTYIEN=""  ;Quit if this type is not linked
 ;Q:BDPRIEN=""  ;NO entry of this type for this patient
 ;now delete last current provider field
 S DIE="^AUPNPAT(",DA=BDPDPIEN,DR=".14///@" D ^DIE
 D ^XBFMK
 Q
 ;
INSTALLD(BDPSTAL) ;EP - Determine if patch BDPSTAL was installed, where
 ; BDPSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW BDPY,DIC,X,Y
 S X=$P(BDPSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",22,",X=$P(BDPSTAL,"*",2)
 D ^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(BDPSTAL,"*",3)
 D ^DIC
 S BDPY=Y
 Q $S(BDPY<1:0,1:1)
