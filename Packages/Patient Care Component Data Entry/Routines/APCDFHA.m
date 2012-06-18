APCDFHA ;cmi/flag/maw - APCD Family History API 12/9/2009 11:30:27 AM
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
 ;
 ;
FH(APCDIE,APCDPT,APCDFIEN,APCDRIEN,APCDFDAT,APCDRDAT,RETVAL) ;-- add/edit family history
 ;APCDIE = "I" all values are internal, "E" all values are external
 ;APCDPT = Patient DFN
 ;APCDFIEN - IEN of entry in family history file to edit, null if adding
 ;APCDRIEN = IEN of entry in family history member to file in .09
 ;APCDRDAT = array of field data in the format RDAT(field#)=value
 ;APCDFDAT = array of field data in the format FDAT(field#)=value
 ;RETVAL = string that returns value of call success/failure
 S APCDC=0
 D EDTR(APCDIE,APCDPT,APCDRIEN,.APCDRDAT,.RETVAL)
 I '+$G(RETVAL) Q
 D EDTF(APCDIE,APCDPT,APCDFIEN,APCDRIEN,1,.APCDFDAT,.RETVAL)
 Q
 ;
EDTR(IE,PT,RIEN,RDAT,RETVAL) ;-- update entry in the family history member file
 ;IE = "I" all values are internal, "E" all values are external
 ;PT = Patient DFN
 ;RIEN = IEN of entry in family history member file to edit, null if adding
 ;RDAT = array of field data in the format RDAT(field#)=value
 I '$G(RIEN) D ADDR(.APCDRIEN,IE,PT,.RDAT)
 I $G(RIEN) S APCDRIEN=RIEN
 I '$G(APCDRIEN) S RETVAL="0^error adding entry to FAMILY HISTORY FAMILY MEMBERS file" Q
 I IE="E" D VAL(9000014.1,.RDAT,APCDRIEN)
 I '$G(RDAT(.09)) S RDAT(.09)=DT
 D FILE(9000014.1,.RDAT,APCDRIEN)
 Q
 ;
EDTF(IE,PT,FIEN,RIEN,COMB,FDAT,RETVAL) ;-- update entry in the family history file
 ;IE = "I" all values are internal, "E" all values are external
 ;PT = Patient DFN
 ;FIEN - IEN of entry in family history file to edit, null if adding
 ;RIEN = IEN of entry in family history member to file in .09
 ;COMB = flag indicating this is called from FH tag above
 ;FDAT = array of field data in the format FDAT(field#)=value
 I $G(RIEN)="",'$G(COMB) S RETVAL="0^cannot add entry, add entry to FAMILY HISTORY FAMILY MEMBERS file first" Q
 I '$G(FIEN) D ADDF(.APCDFIEN,IE,PT,.FDAT)
 I $G(FIEN) S APCDFIEN=FIEN
 I '$G(APCDFIEN) S RETVAL="0^error adding entry to FAMILY HISTORY file" Q
 I $G(RIEN),'$G(FDAT(.09)) S FDAT(.09)=RIEN
 S FDAT(.04)=$$FNDNARR(FDAT(.04))  ;file the provider narrative
 I IE="E" D VAL(9000014,.FDAT,APCDFIEN)
 I '$G(FDAT(.03)) S FDAT(.03)=DT
 D FILE(9000014,.FDAT,APCDFIEN)
 Q
 ;
ADDR(APCDRIEN,IE,P,FDAT) ;-- add a person to the Family History Member file
 N FDA,FIENS,FERR,REL
 S FIENS=""
 I $G(IE)="E" S REL=$O(^AUTTRLSH("B",RDAT(.01),0))
 I $G(IE)="I" S REL=$G(RDAT(.01))
 I '$G(REL) S RETVAL="0^invalid relationship passed in" Q
 S FDA(9000014.1,"+1,",.01)=REL
 S FDA(9000014.1,"+1,",.02)=P
 D UPDATE^DIE("","FDA","FIENS","FERR(1)")
 I '$D(FERR(1)) S APCDRIEN=+$G(FIENS(1)) Q
 S RETVAL="0^error adding entry to FAMILY HISTORY FAMILY MEMBERS file"
 Q
 ;
ADDF(APCDFIEN,IE,P,FDAT) ;-- add a person to the Family History Member file
 N FDA,FIENS,FERR,DX,DXI
 S FIENS=""
 I $G(IE)="E" D CHK^DIE(9000014,.01,"E",FDAT(.01),.DXI,"APCDERR(0)")
 I $G(IE)="I" S DXI=$G(FDAT(.01))
 I '+$G(DXI) S RETVAL="0^invalid DX passed in" Q
 S FDA(9000014,"+1,",.01)=DXI
 S FDA(9000014,"+1,",.02)=P
 D UPDATE^DIE("","FDA","FIENS","FERR(1)")
 I '$D(FERR(1)) S APCDFIEN=+$G(FIENS(1)) Q
 S RETVAL="0^error adding entry to FAMILY HISTORY file"
 Q
 ;
DELFM(VAL,RETVAL) ;-- delete the family member
 ;VAL=ien of entry in FAMILY HISTORY MEMBER file to delete
 I $O(^AUPNFH("AE",VAL,0)) S RETVAL="0^Cannot delete because entry is being pointed to by FAMILY HISTORY file IEN "_$O(^AUPNFH("AE",VAL,0)) Q
 S DIK="^AUPNFHR(",DA=VAL D ^DIK
 S RETVAL=VAL_"^entry deleted successfully"
 Q
 ;
DELFH(VAL,RETVAL) ;-- delete family history
 ;VAL=ien of entry in FAMILY HISTORY file to delete
 ;N FM
 ;S FM=$P($G(^AUPNFH(VAL,0)),U,9)
 ;I $G(FM),$D(^AUPNFHR(FM,0)) S RETVAL="0^Cannot delete because entry has a pointer to FAMILY HISTORY FAMILY MEMBERS file" Q
 S DIK="^AUPNFH(",DA=VAL D ^DIK
 S RETVAL=VAL_"^entry deleted successfully"
 Q
 ;
FNDNARR(NARR) ;EP -- find the provider narrative based on input
 S APCDOVRR=1
 S X=NARR
 S DIC="^AUTNPOV(",DIC(0)="L",DLAYGO=9999999.27 D ^DIC
 K DLAYGO
 Q $S($G(Y)>0:+Y,1:"")
 ;
FILE(FL,APCDDATA,APCDIN) ;-- file the data
 S APCDIENS=APCDIN_","
 K APCDFDA
 S APCDF="" F  S APCDF=$O(APCDDATA(APCDF)) Q:APCDF=""  D
 .S APCDFDA(FL,APCDIENS,APCDF)=APCDDATA(APCDF)
 ;CALL FILE^DIE
 K APCDE
 D FILE^DIE("K","APCDFDA","APCDE(0)")
 S APCDI=0 F  S APCDI=$O(APCDE(0,"DIERR",APCDI)) Q:APCDI'=+APCDI  D
 .Q:'$D(APCDE(0,"DIERR",APCDI,"TEXT"))
 .D E(APCDE(0,"DIERR",APCDI,"TEXT"))
 S RETVAL=APCDIN_"^"_$G(RETVAL)
 Q
 ;
VAL(FL,DAT,DIENS) ;-- validate data passed in
 S DIENS=DIENS_","
 S APCDF="" F  S APCDF=$O(DAT(APCDF)) Q:APCDF=""  D
 .I APCDF=".02" Q  ;you can't edit the .01, it's dinum'ed
 .I FL=9000014,APCDF=.04 Q  ;don't validate provider narrative, its done separately
 .I FL=9000014,APCDF=.09 Q  ;don't validate pointer to family member file
 .I '$D(^DD(FL,APCDF,0)) K DAT(APCDF) D E("field number not valid") Q
 .S APCDV=DAT(APCDF)
 .Q:APCDV=""
 .K APCDE,APCDI
 .S APCDI=""
 .D VAL^DIE(FL,DIENS,APCDF,"E",APCDV,.APCDI,,"APCDE")
 .I $D(APCDE("DIERR",1,"TEXT",1)) D E(APCDE("DIERR",1,"TEXT",1)) K DAT(APCDF) Q
 .S DAT(APCDF)=APCDI
 Q
 ;
E(V) ;
 S APCDC=APCDC+1,$P(RETVAL,"|",APCDC)=V
 Q
 ;
TESTALL ;
 S P=478
 S AREL(.01)=28
 S AREL(.02)=P
 S AREL(.03)="SECOND COUSIN"
 S AREL(.04)="L"
 S AREL(.07)="N"
 S AREL(.09)="3091208"
 S AREL(.11)="3091209"
 S AF(.01)="11377"
 S AF(.02)=P
 S AF(.03)="3091209"
 S AF(.04)="TEST NARRATIVE"
 S AF(.08)="240"
 S AF(.11)=5
 S AF(.12)="3091212"
 D FH("I",P,177,166,.AF,.AREL,.LORIERR)
 ;ZW LORIERR
 Q
 ;
TESTFH ;
 S P=478
 S AF(.01)="11377"
 S AF(.02)=P
 S AF(.03)="3091209"
 S AF(.04)="TEST NARRATIVE"
 S AF(.08)="240"
 S AF(.11)=5
 S AF(.12)="3091213"
 D EDTF("I",P,177,166,,.AF,.LORIERR)
 ;ZW LORIERR
 Q
 ;
TESTFM ;
 S P=478
 S AREL(.01)=28
 S AREL(.02)=P
 S AREL(.03)="SECOND COUSIN"
 S AREL(.04)="L"
 S AREL(.07)="N"
 S AREL(.09)="3091207"
 S AREL(.11)="3091207"
 D EDTR("I",P,166,.AREL,.LORIERR)
 ;ZW LORIERR
 Q
 ;
