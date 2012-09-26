BTIUVFIX ;IHS/MSC/MGH - POSTINIT FOR PATCH 1009 FIX VISITS ;05-Jan-2012 14:48;DU
 ;;1.0;TEXT INTEGRATION UTILITIES;**1009**;NOV 04, 2004;Build 22
 ;
 ;Routine to fix visits created by Vista Imaging (MAG Windows)
 ;
EN ;EP
 NEW BTIUD,BTIUV,BTIU0,DA,DIE,DR,DITC,X,Y
 D MES^XPDUTL("Checking for Vista Imaging visits to fix...hold on, this may take a while")
 S BTIUD=3060101  ;START ARBITRARILY at 1/1/2006
 F  S BTIUD=$O(^AUPNVSIT("B",BTIUD)) Q:BTIUD=""  D
 .S BTIUV=0
 .F  S BTIUV=$O(^AUPNVSIT("B",BTIUD,BTIUV)) Q:BTIUV'=+BTIUV  D
 ..Q:'$D(^AUPNVSIT(BTIUV,0))  ;bad xref entry
 ..Q:$P(^AUPNVSIT(BTIUV,0),U,11)  ;delete flag set, don't bother
 ..Q:$$VAL^XBDIQ1(9000010,BTIUV,.24)'="MAG WINDOWS"  ;not a vista imaging visit
 ..;fix .01 by putting on .12 if there is no time.
 ..S BTIU0=^AUPNVSIT(BTIUV,0)
 ..S DR=""
 ..S X=$P(BTIU0,U,1)
 ..I X'["." S X=X_".12",DR=$S(DR]"":DR_";",1:""),DR=DR_".01////"_X
 ..;fix .02 by removing the time
 ..S X=$P(BTIU0,U,2)
 ..I X["." S X=$P(X,"."),DR=$S(DR]"":DR_";",1:""),DR=DR_".02////"_X
 ..;FIX .06 if blank
 ..I $P(BTIU0,U,6)="" S DR=$S(DR]"":DR_";",1:""),DR=DR_".06////"_DUZ(2)   ;SET TO DUZ(2) AS I CAN'T THINK OF ANYTHING ELSE TO SET IT TO
 ..;FIX .13
 ..S X=$P(BTIU0,U,13)
 ..I X["." S X=$P(X,"."),DR=$S(DR]"":DR_";",1:""),DR=DR_".13////"_X
 ..;CALL DIE TO FIX THIS VISIT
 ..I DR="" G NOTE  ;NOTHING TO FIX, MAYBE POST INIT ALREADY RAN ONCE
 ..S DIE="^AUPNVSIT(",DA=BTIUV,DITC=1   ;SET DITC TO OVERRIDE "UNEDITABLE" .02 FIELD
 ..D ^DIE
 ..I $D(Y) D MES^XPDUTL("Update to Visit IEN: "_BTIUV_" failed")
 ..K DIE,DA,DITC,DR
NOTE ..;NOW TRY TO CREATE A V NOTE
 ..D CNOTE(BTIUV)
 ..Q
 .Q
 Q
 ;
CNOTE(BTIUV) ;
 ;find tiu documents in "V" index for this visit and create V Notes
 NEW BTIUX,BTIUY,BTIUZ,A,B,G
 S BTIUX=0 F  S BTIUX=$O(^TIU(8925,"V",BTIUV,BTIUX)) Q:BTIUX'=+BTIUX  D
 .;lets check to see if V NOTE is already there in case this post init
 .;gets run more than once
 .S (A,G)=0 F  S A=$O(^AUPNVNOT("AD",BTIUV,A)) Q:A'=+A  D
 ..I $P($G(^AUPNVNOT(A,0)),U,1)=BTIUX S G=1 Q  ;this document already has a v note on this visit
 .Q:G  ;DON'T RECREATE V NOTE, IT IS ALREADY THERE
 .D VNOTE(BTIUX,BTIUV,$P(^TIU(8925,BTIUX,0),U,2),"ADD")
 .Q
 Q
VNOTE(NOTE,VISIT,DFN,MODE) ;EP; -- create v note entry
 ; -- COPIED FROM BTIUPCC
 NEW APCDALVR,APCDADFN,APCDAFLG,APCDLOOK
 I $$GET1^DIQ(9000010,+VISIT,.05,"I")'=DFN D MES^XPDUTL("Patient mismatch between visit and TIU doc: "_+VISIT_"  "_NOTE) Q  ;visit and TIU visit pointer mismatch on patient
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.28 ("_MODE_")]"
 S APCDALVR("APCDPAT")=DFN
 S APCDALVR("APCDVSIT")=+VISIT
 S APCDALVR("APCDTDOC")="`"_NOTE
 S APCDALVR("APCDTCDT")=$$GET1^DIQ(8925,NOTE,1201,"I")
 S X=$$GET1^DIQ(8925,NOTE,1202,"I") I X]"" S APCDALVR("APCDTPRV")="`"_X
 D EN^APCDALVR        ;calling PEP in PCC
 I $G(APCDAFLG) D MES^XPDUTL("Error creating V Note for TIU Document: "_NOTE_" error flag: "_APCDAFLG) Q
 Q
 ;
