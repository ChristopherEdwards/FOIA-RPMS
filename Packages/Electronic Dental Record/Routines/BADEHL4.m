BADEHL4 ;IHS/MSC/MGH/VAC - Dentrix HL7 inbound interface  ;01-Oct-2010 14:42;MGH
 ;;1.0;DENTAL/EDR INTERFACE;**1**;AUG 22, 2011
 ;; Modified - IHS/MSC/AMF - 11/23/10 - More descriptive alert messages
 ;; Modified - IHS/MSC/AMF 10/2010 fix for hospital location FT1-16,2
UPD ;EP Update a V Dental entry
 N DIEN,MATCH,DA,APCDVSIT,CODEIEN,APCDSUR,APCDTEE
 N TYPE,TCODE,SCODE,PROV,X,Y,Y2,PIEN,POVIEN2,ADACODE,VTIME
 N NOOPSITE
 S APCDALVR("APCDPAT")=DFN    ;patient
 ;visit stored in V Dental file
 S APCDVSIT=$P($G(^AUPNVDEN(EXKEY,0)),U,3)
 ;Added patient name, DFN, and Visit date. can't add ASUFAC or HLBIEN
 I '$D(^AUPNVSIT(APCDVSIT)) D ACK^BADEHL3(HLMSGIEN,DFN,"Can't update visit "_APCDVSIT_". Not in RPMS:") Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 S APCDALVR("APCDVSIT")=APCDVSIT
 ;ADA code stored in V Dental file
 S APCDTSC=$P($G(^AUPNVDEN(EXKEY,0)),U,1)
 S ADACODE=$P($G(^AUTTADA(APCDTSC,0)),U,1)
 S NOOPSITE=$$GET1^DIQ(9999999.31,APCDTSC,.09,"I")="n"
 ;See if the provider was changed
 S PROV=$$GET^HLOPRS(.SEGFT1,20,1)
 I PROV="" D ACK^BADEHL3(HLMSGIEN,DFN,"Missing provider in FT1:") Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 D CHECKPRV(PROV)
 S APCDALVR("APCDACS")=""
 S TYPE=$$GET^HLOPRS(.SEGFT1,6)
 ;Check the date/time in the message
 S X=$$GET^HLOPRS(.SEGFT1,4)
 I X="" D ACK^BADEHL3(HLMSGIEN,DFN,"Missing visit date in FT1:") Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 I $L(X)=8 D
 .S VTIME=$$GET^XPAR("ALL","BADE EDR DEFAULT TIME")
 .I VTIME="" S VTIME=1138 ;IHS/MSC/AMF 10/2010 Change in default time
 .S X=X_VTIME
 S Y=$$FMDATE^HLFNC(X)
 S Y2=$P($G(^AUPNVDEN(EXKEY,12)),U,1)
 ;If the date and time of the visit is different, the old procedure
 ;and possibly the visit must be deleted and everything restarted
 I Y'=Y2 D DEL,NEW^BADEHL3 Q
 ;ADA code in the message
 S TCODE=$$GET^HLOPRS(.SEGFT1,7)
 I TCODE="" D ACK^BADEHL3(HLMSGIEN,DFN,"Missing ADA code in FT1:") Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 I $E(TCODE,1,1)="D" S SCODE=$E(TCODE,2,$L(TCODE))
 E  S SCODE=TCODE
 S CODEIEN=$O(^AUTTADA("B",SCODE,""))
 S APCDALVR("APCDTSC")="`"_CODEIEN
 ;Check to see if the code has changed. If the code was changed,
 ;the old code needs to be deleted and a new one stored
 I CODEIEN'=APCDTSC  D DELV,SETUP,ADD
 I SCODE=ADACODE D DELV,SETUP,ADD
 Q
SETUP ;Setup the variables needed to modifiy or add
 N SURGDES
 S APCDALVR("AUPNTALK")=""
 S APCDALVR("APCDANE")=""
 ;number of units
 S APCDALVR("APCDTNOU")=1
 ;Tooth surface
 S APCDTSUR=$$GET^HLOPRS(.SEGFT1,26,4)
 S APCDALVR("APCDTSUR")=APCDTSUR
 ;Fee for procedure
 S APCDTFEE=$$GET^HLOPRS(.SEGFT1,11)
 S APCDALVR("APCDTFEE")=APCDTFEE
 ;Date/Time
 S X=$$GET^HLOPRS(.SEGFT1,4)
 I X="" D ACK^BADEHL3(HLMSGIEN,DFN,"Missing visit date in FT1:") Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 I $L(X)=8 D
 .S VTIME=$$GET^XPAR("ALL","BADE EDR DEFAULT TIME")
 .I VTIME="" S VTIME=1138
 .S X=X_VTIME
 S Y=$$FMDATE^HLFNC(X)
 D DD^%DT S APCDTCDT=Y   ;External format
 S APCDALVR("APCDTCDT")=APCDTCDT
 S APCDALVR("APCDTCLN")="DENTAL"
 S APCDALVR("APCDTEXK")=APCDTEXK
 ;Provider
 S PNAME=$P($G(^VA(200,PROV,0)),U,1)
 S APCDALVR("APCDTEPR")=PNAME
 S APCDALVR("APCDTPRV")=PNAME
 S MOD=$$GET^HLOPRS(.SEGFT1,26,1)  ; Operative Site Code (may contain text)
 S SURGDES=$$GET^HLOPRS(.SEGFT1,26,2)  ;Operative Site Descriptive Text
 S APCDTOS=$S(NOOPSITE:"",1:$$GETTOS(MOD,SURGDES))
 I 'NOOPSITE,'APCDTOS D ACK^BADEHL3(HLMSGIEN,DFN,"No valid ADA code in FT1:") Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 S:APCDTOS APCDALVR("APCDTOS")="`"_APCDTOS
 ; ----- IHS/MSC/AMF 10/2010 fix for FT1-16,2
 ;Find the location and clinic location
 S ASUFAC2=$$GET^HLOPRS(.SEGFT1,16,1)
 S HOSLOC=$$GET^HLOPRS(.SEGFT1,16,2)
 I $L(ASUFAC2),'$L(HOSLOC) S ASUFAC=ASUFAC2
 ;
 S BADEWARN=""
 I $L(HOSLOC)  D
 .S PARLOC=+$O(^SC("B",HOSLOC,"")) I 'PARLOC S BADEWARN="Warning: Clinic "_HOSLOC_" is not valid ",HOSLOC="" Q
 .S LOC=+$P($G(^SC(PARLOC,0)),U,4) I 'LOC S BADEWARN="Warning: Location not found for Clinic "_HOSLOC_" ",HOSLOC=""
 I '$L(HOSLOC) D
 .S LOC=$O(^AUTTLOC("C",ASUFAC,"")) I '$L(LOC) S BADERR="No location associated ASUFAC "_ASUFAC_":" Q
 .S PARLOC=+$$GET^XPAR("DIV.`"_LOC_"^SYS","BADE EDR DEFAULT CLINIC") I 'PARLOC S BADERR=" There is no default clinic for this location " Q
 .S LOCA=+$P($G(^SC(PARLOC,0)),U,4) I LOCA'=LOC S BADERR=" The LOCATION associated with this ASUFAC and BADE EDR DEFAULT CLINIC is incorrect " Q
 I $L(BADERR) D ACK^BADEHL3(HLMSGIEN,DFN,BADERR) Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 I $L(BADEWARN) D ACK^BADEHL3(HLMSGIEN,DFN,BADEWARN) ;IHS/MSC/AMF 11/23/10 More descriptive alert
 ;location
 ;S ASUFAC=$$GET^HLOPRS(.SEGFT1,16,1)
 ;S HOSLOC=$$GET^HLOPRS(.SEGFT1,16,2)
 ;I ASUFAC="" D ACK^BADEHL3(HLMSGIEN,DFN,"Missing location in FT1:") Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 ;S (LOC,PARLOC)=""
 ;S LOC=$O(^AUTTLOC("C",ASUFAC,LOC))
 ;Get the clinic location
 ;I HOSLOC="" D
 .;S PARLOC=+$$GET^XPAR("DIV.`"_LOC_"^SYS","BADE EDR DEFAULT CLINIC")
 ;E  D
 .;S PARLOC=+$O(^SC("B",HOSLOC,PARLOC))
 ;I 'PARLOC S BADERR=" Clinic does not exist in RPMS in msg: "_$P($G(^DPT(DFN,0)),"^",1)_" "_DFN_" "_ASUFAC_" "_MIEN D ACK^BADEHL3(BADERR) Q  ;IHS/MSC/VAC 10/2010
 ;I LOC'=$P($G(^SC(PARLOC,0)),U,4) S BADERR=" Clinic "_HOSLOC_" isn't defined for ASUFAC location "_$P($G(^DPT(DFN,0)),"^",1)_" "_DFN_" "_ASUFAC D ACK^BADEHL3(BADERR) Q  ;IHS/MSC/VAC 10/2010
 ;
 ; ----- end IHS/MSC/AMF 10/2010 fix for FT1-16,2
 S APCDALVR("APCDLOC")="`"_LOC
 ;External key
 S APCDALVR("APCDTEXK")=APCDTEXK
 Q
MOD S APCDALVR("APCDATMP")="[APCDALVR 9000010.05 (ADD)]"
 D EN^APCDALVR
 Q
ADD S APCDALVR("APCDATMP")="[APCDALVR 9000010.05 (ADD)]"
 D EN^APCDALVR
 Q
DELV S FILE=9000010.05
 D VDEL(FILE,EXKEY,APCDVSIT)
 Q
DEL ;EP  Delete V file entry
 ;Find the entry in the V DENTAL file and the visit
 N MATCH,DIEN,VSIT,DIK,DA,POV,PRV,DCNT
 N APCDALVR
 S DIEN=EXKEY
 ;Delete the entry
 I '$D(^AUPNVDEN(DIEN)) D ACK^BADEHL3(HLMSGIEN,DFN,"Can't delete visit "_DIEN_". Not in RPMS:") Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 S VSIT=$P($G(^AUPNVDEN(+DIEN,0)),U,3)
 S PROV=$$GET^HLOPRS(.SEGFT1,20,1)
 I PROV="" D ACK^BADEHL3(HLMSGIEN,DFN,"Missing provider in FT1:") Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 ;Get the dependent count for this visit
 S DCNT=$P(^AUPNVSIT(VSIT,0),U,9)
 ;If the dependent count is greater than 3, there are other procedures on this visit
 ;Delete this one entry and quit
 I DCNT>3 D
 .S FILE=9000010.05
 .D VDEL(FILE,DIEN,VSIT)
 ;If its 3, delete the VPOV and VPRV entries then delete the visit
 I DCNT<4 D
 .S FILE=9000010.05
 .D VDEL(FILE,DIEN,VSIT)
 .D CHECK(VSIT,PROV)
 ;Delete visit if dependent count is 0
 I DCNT=0 D VSTDEL(VSIT)
 Q
VDEL(FILE,IEN,VSIT) ;Delete a V-file entry
 N X,DIK,DA
 S DIK=FILE,DA=IEN
 S X=$$DEL^APCDALVR(DIK,DA)
 I X>0 D ACK^BADEHL3(HLMSGIEN,DFN,"Can't delete V file entry:") Q  ;IHS/MSC/AMF 11/23/10 More descriptive alert
 Q
VSTDEL(VSIT) ;Delete the visit with zero dependents
 N APCDVDLT,U,APCDVFLE,AUPNVSIT,APCDVNM,APCDVDG,APCDVIGR,APCDVDFN
 N APCDVI,DIK,DA
 S APCDVDLT=VSIT
 D EN^APCDVDLT
 Q
CHECK(VSIT,PROV) ;Remove the POV and PRV if those are the 2 remaining dependent entries
 N POVIEN,MATCH,ICD,VPRV,PROVIEN,ICDIEN,PROV2,PROVIEN2
 S ICD="" S ICD=$O(^ICD9("AB","V72.2",ICD))
 S:'ICD ICD=$O(^ICD9("AB","V72.2 ",ICD))
 Q:ICD=""
 ;First the POV
 S MATCH=0
 S POVIEN="" F  S POVIEN=$O(^AUPNVPOV("AD",VSIT,POVIEN)) Q:POVIEN=""!(MATCH=1)  D
 .S POVIEN2=$P($G(^AUPNVPOV(POVIEN,0)),U,1)
 .I ICD=POVIEN2 S ICDIEN=POVIEN S MATCH=1
 Q:MATCH=0
 ;Found the POV for this visit so delete the dependent entry
 I MATCH=1 D
 .S FILE=9000010.07
 .D VDEL(FILE,ICDIEN,VSIT)
 ;Next the provider
 S (VPRV,MATCH)=0
 S PROVIEN="" F  S PROVIEN=$O(^AUPNVPRV("AD",VSIT,PROVIEN)) Q:PROVIEN=""!(MATCH=1)  D
 .S PROV2=$P($G(^AUPNVPRV(PROVIEN,0)),U,1)
 .I PROV=PROV2 S PROVIEN2=PROVIEN S MATCH=1
 Q:MATCH=0
 I MATCH=1 D
 .S FILE=9000010.06
 .D VDEL(FILE,PROVIEN2,VSIT)
 ;Recheck the dependent count
 S DCNT=$P(^AUPNVSIT(VSIT,0),U,9)
 Q
CHECKPRV(PROV) ;See if the provider in the message is new
 N VPRV,DPRV,MATCH,PRVIEN,IEN,PPRV,PRIM ;IHS/MSC/MGH 7/2010 new var PRIM for patch 1
 S MATCH=0,PRIM="P" ;IHS/MSC/MGH 7/2010 new var PRIM for patch 1
 ;Find the provider in the existing V dental file
 S DPRV=$P($G(^AUPNVDEN(EXKEY,12)),U,2)
 ;If its the same provider quit
 Q:DPRV=PROV
 ;If its not the same provider, check the visit to see if the new provider
 ;is already on this visit
 S VPRV="" F  S VPRV=$O(^AUPNVPRV("AD",APCDVSIT,VPRV)) Q:VPRV=""  D
 .;IHS/MSC/MGH patch 1 check for primary
 .I $P($G(^AUPNVPRV(VPRV,0)),U,4)="P" S PRIM="S"
 .S PRVIEN=$P($G(^AUPNVPRV(VPRV,0)),U,1)
 .I PROV=PRVIEN S MATCH=1
 ;If this new provider is already attached to this visit we are OK
 Q:MATCH=1
 ;If the new provider is not on this visit,add this provider
 I MATCH=0 D PRV^BADEHL3(PRIM)   ;patch 1 IHS/MSC/MGH
 ;Now we need to see if we need to delete the old provider.
 ;If this provider does not have any procedures attached we will delete
 S MATCH=0
 S IEN="" F  S IEN=$O(^AUPNVDEN("AD",APCDVSIT,IEN)) Q:IEN=""!(MATCH=1)  D
 .S PPRV=$P($G(^AUPNVDEN(IEN,12)),U,2)
 .I PPRV=DPRV&(IEN'=EXKEY) S MATCH=1
 ;This provider is on other procedures
 Q:MATCH=1
 I MATCH=0 D
 .N PP,FDA ;IHS/MSC/MGH patch 1 check for primary
 .S PP=0 ;IHS/MSC/MGH patch 1 check for primary
 .S PIEN="" F  S PIEN=$O(^AUPNVPRV("AD",APCDVSIT,PIEN)) Q:PIEN=""  D
 ..S PROVIEN=$P($G(^AUPNVPRV(PIEN,0)),U,1)
 ..;IHS/MSC/MGH patch 1 check for primary
 ..I $P($G(^AUPNVPRV(PIEN,0)),U,4)="P" S PP=1   ; IHS/MSC/MGH patch 1 We are deleting the primary provider
 ..I PROVIEN=DPRV D
 ...S FILE=9000010.06
 ...D VDEL(FILE,PIEN,APCDVSIT)
 ...;ISH/MSC/MGH PATCH 1  If primary provider was deleted, make the new provider primary
 ...I PP=1 D
 ....S PIEN="" F  S IEN=$O(^AUPNVPRV("AD",APCDVSIT,PIEN)) Q:PIEN=""  D
 .....S PROVIEN=$P($G(^AUPNVPRV(PIEN,0)),U,1)
 .....I PROVIEN=PROV D
 ......S FDA=9000010.06
 ......S FDA=$NA(FDA(FNUM,PIEN_","))
 ......S @FDA@(.04)="P"
 ......K FDA
 ; ----- end ISH/MSC/MGH PATCH 1  If primary provider was deleted
 Q
 ; Returns Dental Operative Code IEN
GETTOS(CODE,DESC) ;EP
 Q:'$L(DESC) 0
 N RET,LP
 S RET=0
 I $L(DESC)>30 D  ;"B" only contains first 30 characters
 .S LP=0 F  S LP=$O(^ADEOPS(LP)) Q:'LP  D  Q:RET
 ..S:$P(^ADEOPS(LP,0),U)=DESC RET=LP
 E  D
 .S RET=+$O(^ADEOPS("B",DESC,0))
 Q RET
