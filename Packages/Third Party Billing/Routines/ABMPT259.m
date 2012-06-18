ABMPT259 ; IHS/ASDST/SDR - 3P BILLING 2.5 Patch 9 POST INIT ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ;
 Q
PREINST ;
 Q
EN ; EP
 D ERRCODES ; add new error codes
 D EXPMUDT  ;update export mode with new questions
 D XREF  ;index GROUP CONTROL NUMBER in 3P TX Status file
 D ECODES  ;add new 3P Codes
 D ZNODE  ;populate 0-node for 3P Cancelled Claims Data
 D TCODE  ;Change TRANCODE to TRANSCODE
 D QUES  ;add questions to 3P Page 3 Questions file
 D POSTF  ;populated export mode on past POS claims
 D NEWVT  ;new Visit Type for task 2
 D REINDEX  ;reindex Provider Taxonomy file
 D TPCODES  ;fix entries 1-9 to be 01-09 and re-index
 I $G(^DD(9002274.3021,.18,0))="" D ^ABMPRVCV  ;convert provider to multiple for claims and bills; only do once
 D NEWCRSN  ;new canceled claim reasons
 Q
ERRCODES ;
 ;215 - supervising provider missing ID#
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=215
 S X="SUPERVISING PROVIDER MISSING ID NUMBER"
 S DIC("DR")=".02///Edit Supervising Provider on page 3 and enter UPIN"
 S DIC("DR")=DIC("DR")_";.03///E"
 K DD,DO
 D FILE^DICN
 D SITE(215)
 ;198 - bill type must be ##5 if delayed reason code is other
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=198
 S X="BILL TYPE MUST BE ##5 IF DELAYED REASON CODE IS OTHER"
 S DIC("DR")=".02///Change bill type or delayed reason code"
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 D SITE(198)
 ;214 - delayed reason code with no remarks
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=214
 S X="DELAYED REASON CODE WITH NO REMARKS"
 S DIC("DR")=".02///Put remarks on page 9F"
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 D SITE(214)
 ;216 - provider on line item with no address
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=216
 S X="PROVIDER ON LINE ITEM WITH NO ADDRESS"
 S DIC("DR")=".02///Add address for provider"
 S DIC("DR")=DIC("DR")_";.03///E"
 K DD,DO
 D FILE^DICN
 D SITE(216)
 Q
SITE(ABMX) ;Add SITE multiple
 S DUZHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDCLM(DUZ(2))) Q:'+DUZ(2)  D
 .S DIC(0)="LX"
 .S DA(1)=ABMX
 .S DIC="^ABMDERR("_DA(1)_",31,"
 .S DIC("P")=$P(^DD(9002274.04,31,0),U,2)
 .S DINUM=DUZ(2)
 .S X=$P($G(^DIC(4,DUZ(2),0)),U)
 .S DIC("DR")=".03////E"
 .D ^DIC
 .K DA,DIC,DINUM
 S DUZ(2)=DUZHOLD
 K DUZHOLD,DLAYGO,ABMX
 Q
EXPMUDT F ABMEXPM=3,14,15,22 D
 .S ABMQUES=$P($G(^ABMDEXP(ABMEXPM,0)),U,8)
 .Q:ABMQUES["25"
 .S ABMQUES=ABMQUES_",25"
 .S DIE="^ABMDEXP("
 .S DA=ABMEXPM
 .S DR=".08////"_ABMQUES
 .D ^DIE
 ;
 F ABMEXPM=21,51 D
 .S ABMQUES=$P($G(^ABMDEXP(ABMEXPM,0)),U,8)
 .Q:ABMQUES["31"
 .S ABMQUES=ABMQUES_",31"
 .S DIE="^ABMDEXP("
 .S DA=ABMEXPM
 .S DR=".08////"_ABMQUES
 .D ^DIE
 Q
XREF ;
 K DIC,DIE,DR,DA,X,Y
 S DUZHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDTXST(DUZ(2))) Q:'+DUZ(2)  D
 .S DIK="^ABMDTXST(DUZ(2),"
 .S DIK(1)=".16^C"
 .D ENALL^DIK
 S DUZ(2)=DUZHOLD
 Q
ECODES ;
 ; IM14745
 K DIC,X
 S DIC="^ABMDCODE("
 S DIC(0)="ML"
 S X="07"
 S DIC("DR")=".02///H"
 S DIC("DR")=DIC("DR")_";.03///TRIBAL 638 FREE-STANDING FACILITY"
 K DD,DO
 D FILE^DICN
 Q
 K DIC,X
 S DIC="^ABMDCODE("
 S DIC(0)="ML"
 S X="08"
 S DIC("DR")=".02///H"
 S DIC("DR")=DIC("DR")_";.03///TRIBAL 638 PROVIDER-BASED FACILITY"
 K DD,DO
 D FILE^DICN
 Q
ZNODE ;
 S DUZHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDCLM(DUZ(2))) Q:'+DUZ(2)  D
 .S ABM("GL")="^ABMCCLMS(DUZ(2),0)"
 .S @ABM("GL")=^DIC(9002274.32,0)
 S DUZ(2)=DUZHOLD
 K DUZHOLD,ABM
 Q
TCODE ;
 Q:'$D(^ABMPSTAT("B","Trancode missing"))
 S ABMTCODE=$O(^ABMPSTAT("B","Trancode missing",0))
 Q:ABMTCODE=0
 S DIE="^ABMPSTAT("
 S DA=ABMTCODE
 S DR=".01////Transcode missing"
 D ^DIE
 Q
QUES ;
 K DIC,X,DINUM,DR,DLAYGO
 S DIC="^ABMQUES("
 S DIC(0)="LM"
 S DLAYGO=9002274
 S DINUM=31,X="DELAYED REASON CODE"
 S DIC("DR")=".02////W31;.03////ABMDE30;.04////31;1////ABMDE3C"
 K DD,DO
 D ^DIC
 Q
POSTF ;
 S ABMBDFN=0
 F  S ABMBDFN=$O(^ABMDBILL(DUZ(2),ABMBDFN)) Q:+ABMBDFN=0  D
 .Q:$P($G(^ABMDBILL(DUZ(2),ABMBDFN,0)),U,7)'=901  ;not POS claim
 .S DIE="ABMDBILL(DUZ(2),"
 .S DA=ABMBDFN
 .S DR=".06////24"
 .D ^DIE
 Q
NEWVT ;
 ;new visit type for Immunization for task 2
 K DIC,X,DINUM,DR,DLAYGO
 S DIC="^ABMDVTYP("
 S DIC(0)="LM"
 S X="IMMUNIZATION"
 S DINUM=140
 D ^DIC
 Q
REINDEX ;EP
 K DIK,DA,DR,DIE,DIC
 S DIK="^ABMPTAX("
 D IXALL^DIK
 Q
TPCODES ;
 S ABMCODE=""
 F  S ABMCODE=$O(^ABMDCODE("AC","O",ABMCODE)) Q:ABMCODE=""  D
 .Q:$L(ABMCODE)>1  ;only want 1-digit occurrence codes
 .S ABMCIEN=$O(^ABMDCODE("AC","O",ABMCODE,0))
 .Q:+ABMCIEN=0
 .S DIE="^ABMDCODE("
 .S DA=ABMCIEN
 .S DR=".01////0"_ABMCODE
 .D ^DIE
 S DIK="^ABMDCODE("
 S DIK(1)=".02^AC"
 D ENALL^DIK
 Q
NEWCRSN ;
 K DIC,X,DINUM,DR,DLAYGO
 S DIC="^ABMCCLMR("
 S DIC(0)="LM"
 S X="RETURN TO STOCK"
 D ^DIC
 K DIC,X,DINUM,DR,DLAYGO
 S DIC="^ABMCCLMR("
 S DIC(0)="LM"
 S X="OVER THE COUNTER MEDS"
 D ^DIC
 K DIC,X,DINUM,DR,DLAYGO
 S DIC="^ABMCCLMR("
 S DIC(0)="LM"
 S X="LEFT WITHOUT BEING SEEN"
 D ^DIC
 K DIC,X,DINUM,DR,DLAYGO
 S DIC="^ABMCCLMR("
 S DIC(0)="LM"
 S X="TELEPHONE CONSULT"
 D ^DIC
 Q
