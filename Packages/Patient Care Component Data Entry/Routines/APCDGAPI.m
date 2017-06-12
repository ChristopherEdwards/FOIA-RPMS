APCDGAPI ;IHS/CMI/LAB - PATIENT GOALS APIs;05-Dec-2011 14:28;DU
 ;;2.0;IHS PCC SUITE;**7,10,11**;MAY 14, 2009;Build 58
 ;
 ;
 ;
ADDGOAL(APCDPT,GDAT,RETVAL) ;PEP -- add Patient Goal
 ;This API is called to add a new entry to the PATIENT GOALS file
 ;Input:
 ;  - APCDPT = Patient DFN
 ;  - DAT = array of field data in the format DAT(field#,counter)=value
 ;               note the counter will always be 1 except for field 1000 which is
 ;               a multiple valued field so the counter will be 1,2 etc.
 ;    Details:
 ;    DAT(".01",1)=this is the goal set status, .01 field value
 ;       (".06",1)=facility where goal was added, optional, if not passed DUZ(2) is used
 ;       (".07",1)=goal number, must be a number 99.999 and must not already be used.  Use
 ;                 "AA" xref to determine allowable goal numbers for this facility:
 ;                  ^AUPNGOAL("AA",1090,5217," 001.00",3)=""
 ;                  ^AUPNGOAL("AA",1090,5217," 002.00",11)=""
 ;       (".08",1)=provider documenting, managing this goal, if not passed, DUZ is used
 ;       (".09",1)=goal start date, required, date only
 ;       (".1",1)=goal followup date, required, date only
 ;       (".12",1)=user last update, if not passed, DUZ will be used
 ;       ("1000",1)=goal type from file PATIENT GOAL TYPES - at least 1 is required, this is a multiple field
 ;       ("1000",2)=goal type 2, etc
 ;       ("1101",1)=goal name, required, free text 2-120 characters
 ;       ("1201",1)=reason for goal, free text 2-120 characters, optional
 ;       note:  field .11 is always stuffed with A (Active) on an add so no need to pass in that field value
 ;       note:  field .02  is always stuffed with the value of APCDPT
 ;       note:  fields .03 and .05 are stuffed with DT and $$NOW
 ;       note:  fields .04 and .12 area stuffed with DUZ
 ;
 ;  - RETVAL = string that returns value of call success/failure
 ;
 ;RETURN VALUE - RETVAL=ien of patient goal entry created OR 0^error message
 ;
 ;
 NEW APCDF,APCDC,APCDFDA,APCDIENS,APCDCNTR,APCDTY,APCDLOC,APCDE,APCDI,APCDLOC,APCDERR,APCDGDAT,APCDSTD,APCDGIEN,APCDEC
 NEW X,Y,%DT,Z,DIC,DIE,DR,DIK
 S RETVAL=""
E02 ;
 I '$G(APCDPT) S RETVAL="0^patient pointer (DFN) invalid" Q
 I '$D(^AUPNPAT(APCDPT)) S RETVAL="0^patient pointer (DFN) invalid" Q
REQ ;these field values are required to create an entry
 F APCDF=".07",".09",".01",".1","1000","1101" I $G(GDAT(APCDF,1))="" S RETVAL="0^"_APCDF_" field value missing, required to create a GOAL"
 I RETVAL]"" Q
 S APCDIENS="+1,"
 ;check all incoming data values and set fda array for call to Update^DIE
E01 ;.01 VALUE
 S APCDI=""
 K APCDE
 S X=GDAT(.01,1) I $L(X)=1 S X=$$EXTERNAL^DILFD(9000093,.01,"",$G(GDAT(".01",1)))
 D VAL^DIE(9000093,APCDIENS,.01,"EF",X,.APCDI,"APCDFDA","APCDE") I $D(APCDE("DIERR",1,"TEXT",1)) D E(APCDE("DIERR",1,"TEXT",1)) Q
E06 ;
 S X=$G(GDAT(.06,1))
 I X="" S X=DUZ(2)
 I X?1.N S X=$$EXTERNAL^DILFD(9000093,".06","",X)
 D VAL^DIE(9000093,APCDIENS,.06,"EF",X,.APCDI,"APCDFDA","APCDE")
 S APCDLOC=APCDI
 I $D(APCDE("DIERR",1,"TEXT",1)) D E(APCDE("DIERR",1,"TEXT",1)) Q
E07 ;
 S X=$G(GDAT(.07,1))
 I +X'=X!(X>999.99)!(X<1)!(X?.E1"."3N.N) S RETVAL="0^Goal number invalid, must be a number between 1-999.99" Q
 S Y=" "_$E("000",1,4-$L($P(X,".",1))-1)_$P(X,".",1)_"."_$P(X,".",2)_$E("00",1,3-$L($P(X,".",2))-1)
 I $D(^AUPNGOAL("AA",APCDPT,APCDLOC,Y)) S RETVAL="0^Goal number already in use - .07 value invalid" Q
 S APCDFDA(9000093,APCDIENS,.07)=X
E08 ;
 S X=$G(GDAT(".08",1))
 I X="" S X=DUZ
 I X?1.N S X=$$EXTERNAL^DILFD(9000093,".08","",X)
 D VAL^DIE(9000093,APCDIENS,.08,"EF",X,.APCDI,"APCDFDA","APCDE")
 I $D(APCDE("DIERR",1,"TEXT",1)) D E(APCDE("DIERR",1,"TEXT",1)) Q
E09 ;
 S X=$G(GDAT(".09",1))
 S %DT=""
 D ^%DT
 I Y=-1 S RETVAL="0^Goal start date invalid" Q
 S APCDFDA(9000093,APCDIENS,.09)=Y
 S APCDSTD=Y
E10 ;
 S X=$G(GDAT(".1",1))
 S %DT=""
 D ^%DT
 I Y=-1 S RETVAL="0^Goal start date invalid" Q
 I Y<APCDSTD S RETVAL="0^Follow up date cannot be prior to start date" Q
 S APCDFDA(9000093,APCDIENS,.1)=Y
E1000 ;
 ;now check goal type
 S C=0,APCDC=0 F  S C=$O(GDAT(1000,C)) Q:C'=+C  D
 .S Z=GDAT(1000,C)
 .I Z?1.N,'$D(^APCDTPGT(Z)) D E("invalid patient goal type") Q
 .I Z'?1.N S X=Z,DIC="^APCDTPGT(",DIC(0)="" D ^DIC D  Q:Y=-1
 ..I Y=-1 D E("invalid patient goal type") Q
 ;if RETVAL then quit with the error
 I RETVAL]"" Q
E1101 ;
 S X=$G(GDAT("1101",1))
 D VAL^DIE(9000093,APCDIENS,1101,"EF",X,.APCDI,"APCDFDA","APCDE")
 I $D(APCDE("DIERR",1,"TEXT",1)) D E(APCDE("DIERR",1,"TEXT",1)) Q
E1201 ;
 S X=$G(GDAT("1201",1))
 D VAL^DIE(9000093,APCDIENS,1201,"EF",X,.APCDI,"APCDFDA","APCDE")
 I $D(APCDE("DIERR",1,"TEXT",1)) D E(APCDE("DIERR",1,"TEXT",1)) Q
E03 ;set other data values into the FDA array
 S APCDFDA(9000093,APCDIENS,.02)=APCDPT
 S APCDFDA(9000093,APCDIENS,.03)=DT
 S APCDFDA(9000093,APCDIENS,.04)=DUZ
 S APCDFDA(9000093,APCDIENS,.05)=$$NOW^XLFDT
 S APCDFDA(9000093,APCDIENS,.11)="A"
 S APCDFDA(9000093,APCDIENS,.12)=DUZ
ADD1 D UPDATE^DIE("","APCDFDA","APCDIENS","APCDERR(1)")
 I $D(APCDERR(1)) S RETVAL="0^error adding entry to Patient Goals file "_APCDERR(1) Q
 S APCDGIEN=+$G(APCDIENS(1))
 K APCDFDA
 ;set in multiple goal type
 S APCDI="",APCDC=0
 F  S APCDC=$O(GDAT(1000,APCDC)) Q:APCDC'=+APCDC  D
 .S DIE="^AUPNGOAL(",DA=APCDGIEN,DR="1000////"_GDAT(1000,APCDC) D ^DIE K DIE,DA,DR
 .I $D(Y) S RETVAL="0^error adding goal type" S DA=APCDGIEN,DIK="^AUPNGOAL(" D ^DIK Q
 I RETVAL]"" Q
 S RETVAL=APCDGIEN
 Q
 ;
DELGOAL(APCDGIEN,APCDGPRV,APCDGDTD,APCDGREA,APCDGOTH,RETVAL) ;PEP - called to delete a goal
 ;marks the goal status as "deleted", does not physically delete the goal
 ;INPUT - goal ien
 ;APCDGREA - REASON FOR DELETION, SET OF CODES, FIELD 2.03 -
 ;APCDGPRV - PROVIDER DELETING GOAL, IF NOT PASSED USES DUZ FIELD 2.01 PASS IEN PLEASE
 ;APCDGOTH - COMMENT IF OTHER IS REASON FIELD 2.04
 ;APCDGDTD - DATE/TIME DELETED 2.02 - USES $$NOW^XLFDT IF NOTHING PASSED, PASS INTERNAL VALUE PLEASE
 ;OUTPUT - return value is 1 if delete successful or 0^error message if not successful
 I '$G(APCDGIEN) S RETVAL="0^invalid ien" Q
 I '$D(^AUPNGOAL(APCDGIEN)) S RETVAL="0^invalid ien, not entry" Q
 S APCDGPRV=$G(APCDGPRV) I 'APCDGPRV S APCDGPRV=DUZ
 S APCDGDTD=$G(APCDGDTD) I 'APCDGDTD S APCDGDTD=$$NOW^XLFDT()
 S APCDGREA=$G(APCDGREA)
 S APCDGOTH=$G(APCDGOTH)
 NEW DIE,DA,DR,X,Y,DIC
 S DA=APCDGIEN,DR=".11///D;2.01////"_APCDGPRV_";2.02////"_APCDGDTD_";2.03///"_APCDGREA_";2.04///"_APCDGOTH,DIE="^AUPNGOAL(" D ^DIE K DIE,DA,DR
 I $D(Y) S RETVAL="0^error updating status field, goal not deleted" Q
 S RETVAL=1
 Q
EDITGOAL(APCDGIEN,APCDFUD,APCDSTAT,APCDREVD,APCDREVT,RETVAL) ;PEP- edit a goal entry
 ;only the following fields can be edited per requirements:  F/U DATE (.09), STATUS (.11)
 ;you can also add a review date and review/follow up text, to edit a review comment use EDITREV API
 ;INPUT : ien of goal, new followup date, new status, review date (optional), review comment (optional)
 ;        if adding a review both review date and comment are required, if both are not passed they
 ;        are ignored
 ;OUTPUT :  1 if edit successful, 0^error message if not successful
 ;
 I '$G(APCDGIEN) S RETVAL="0^invalid ien" Q
 I '$D(^AUPNGOAL(APCDGIEN)) S RETVAL="0^invalid ien, not entry" Q
 S APCDFUD=$G(APCDFUD)
 S APCDSTAT=$G(APCDSTAT)
 S APCDREVD=$G(APCDREVD)
 S APCDREVT=$G(APCDREVT)
 ;edit incoming values
 NEW DIE,DA,DR,X,Y,%DT,APCDFU,APCDI,APCDRD,APCDIENS,APCDFDA,APCDERR,DIC
 S X=$G(APCDFUD)
 I X="" G E1
 S %DT=""
 D ^%DT
 I Y=-1 S RETVAL="0^Goal followup date invalid" Q
 S APCDFU=Y
 S X=$P(^AUPNGOAL(APCDGIEN,0),U,9) I X>APCDFU S RETVAL="0^goal followup date cannot be less than start date" Q
E1 ;
 S X=$G(APCDSTAT),APCDI=""
 D CHK^DIE(9000093,.11,"",X,.APCDI)
 I APCDI="^" S RETVAL="0^invalid status value" Q
 ;if adding a review/fu edit those field values
 I APCDREVD=""!(APCDREVT="") G ED
 S X=$G(APCDREVD)
 S %DT=""
 D ^%DT
 I Y=-1 S RETVAL="0^review date invalid" Q
 S APCDRD=Y
 S Y=""
 D CHK^DIE(9000093.13,.02,"",APCDREVT,.Y)
 I Y="^" S RETVAL="0^invalid review note" Q
ED ;
 S DA=APCDGIEN,DR=".1////"_APCDFU_";.11///"_APCDI_";.05////"_$$NOW^XLFDT()_";.12////"_DUZ,DIE="^AUPNGOAL(" D ^DIE K DIE,DA,DR
 I $D(Y) S RETVAL="0^error updating status field, goal not deleted" Q
 I APCDREVT]"",APCDREVD]"" D
 .;add review to multiple
 .S APCDIENS=""
 .S APCDFDA(9000093.13,"+2,"_APCDGIEN_",",.01)=APCDRD
 .S APCDFDA(9000093.13,"+2,"_APCDGIEN_",",.02)=APCDREVT
 .D UPDATE^DIE("","APCDFDA","APCDIENS","APCDERR(1)")
 .I $D(APCDERR(1)) S RETVAL=APCDERR("DIERR",1,"TEXT",1)
 I RETVAL]"" Q
 S RETVAL=1
 Q
 ;
NEXTGN(P,F) ;PEP - return next available goal number for patient P, facility F
 I $G(P)="" Q ""
 I $G(F)="" Q ""
 I '$D(^AUPNPAT(P)) Q ""
 I '$D(^AUTTLOC(F)) Q ""
 Q $E($O(^AUPNGOAL("AA",P,F,""),-1),2,999)\1+1
 ;
E(V) ;
 S APCDEC=$G(APCDEC)+1,$P(RETVAL,"|",APCDEC)=V
 Q
