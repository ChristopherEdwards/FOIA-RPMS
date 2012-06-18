BDPAPI ; IHS/CMI/TMJ - ADD A NEW DESIGNATED PROVIDER ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
AEDWH(BDPPAT,BDPIEN,BDPRET) ;PEP - called to add, edit or delete a WOMEN's HEALTH CASE MANAGER
 ;
 ;BDPPAT - DFN of patient
 ;BDPIEN - ien of provider in file 200 to add as WHCM if one doesn't exist
 ;         or edit the existing provider if there is one
 ;         OR "@" to delete the existing WHCM and not replace it
 ;BDPRET - return value  1 if successful, 0^ERROR MESSAGE if not successful
 ;
 ;e.g to make provider with IEN 1234 as the WHCM for patient 3456
 ;     S X=$$AEDWH^BDPAPI(3456,1234)
 ;e.g to remove the current WHCM and not replace it (for example, if patient moves or dies)
 ;     S X=$$AEDWH^BDPAPI(3456,"@")
 ;
 I '$G(BDPPAT) S BDPRET="0^valid patient DFN passed" Q
 I '$D(^AUPNPAT(BDPPAT)) S BDPRET="0^patient not in patient file" Q
 NEW BDPCIEN,BDPRIEN,X
 S BDPCIEN=$O(^BDPTCAT("B","WOMEN'S HEALTH CASE MANAGER",0))
 I 'BDPCIEN S BDPRET="0^WOMEN'S HEALTH CASE MANAGER category not found" Q
 I '$G(BDPIEN),BDPIEN'="@" S BDPRET="0^PROVIDER IEN OR @ NOT PASSED" Q
 I BDPIEN,'$D(^VA(200,BDPIEN,0)) S BDPRET="0^INVALID PROVIDER IEN PASSED" Q
 ;
 I BDPIEN="@" S BDPRET=$$DEL1(BDPPAT,BDPCIEN) Q
 S BDPRIEN=$O(^BDPRECN("AA",BDPPAT,BDPCIEN,0))  ;get ien of this patient/category
 I 'BDPRIEN S BDPRIEN=$$ADD1(BDPPAT,BDPCIEN) I 'BDPRIEN S BDPRET=BDPRIEN Q
 I $P(^BDPRECN(BDPRIEN,0),U,3)=BDPIEN S BDPRET=1 Q  ;that already is the provider so don't bother
 ;
 S BDPRET=$$EDIT(BDPRIEN,BDPCIEN,BDPIEN)
 Q
 ;
AEDAP(BDPPAT,BDPIEN,BDPTYPE,BDPRET) ;PEP - called to add, edit or delete any designated provider by category
 ;this will add a new provider with the category BDPTYPE as the provider category
 ;
 ;BDPPAT - DFN of patient
 ;BDPIEN - ien of provider in file 200 to add a new provider or edit the existing provider to this one
 ;         OR "@" to delete the existing provider and not replace it
 ;BDPTYPE - name of category to add this provider for e.g. "DPCP" or "RENAL DISEASE"
 ;BDPRET - return value  1 if successful, 0^ERROR MESSAGE if not successful
 ;e.g to make provider with IEN 1234 as the WHCM for patient 3456
 ;     S X=$$AEDAP^BDPAPI(3456,1234,"RENAL DISEASE",.RETURN)
 ;e.g to remove the current WHCM and not replace it (for example, if patient moves or dies)
 ;     S X=$$AEDAP^BDPAPI(3456,"@","WOMEN'S HEALTH CASE MANAGER",.RETURN)
 ;
 I '$G(BDPPAT) S BDPRET="0^valid patient DFN passed" Q
 I '$D(^AUPNPAT(BDPPAT)) S BDPRET="0^patient not in patient file" Q
 NEW BDPCIEN,BDPRIEN,X
 S BDPCIEN=$O(^BDPTCAT("B",BDPTYPE,0))
 I 'BDPCIEN S BDPRET="0^Provider category not found" Q
 I '$G(BDPIEN),BDPIEN'="@" S BDPRET="0^PROVIDER IEN OR @ NOT PASSED" Q
 I BDPIEN,'$D(^VA(200,BDPIEN,0)) S BDPRET="0^INVALID PROVIDER IEN PASSED" Q
 ;
 I BDPIEN="@" S BDPRET=$$DEL1(BDPPAT,BDPCIEN) Q
 S BDPRIEN=$O(^BDPRECN("AA",BDPPAT,BDPCIEN,0))  ;get ien of this patient/category
 I 'BDPRIEN S BDPRIEN=$$ADD1(BDPPAT,BDPCIEN) I 'BDPRIEN S BDPRET=BDPRIEN Q
 I $P(^BDPRECN(BDPRIEN,0),U,3)=BDPIEN S BDPRET=1 Q  ;that already is the provider so don't bother
 ;
 S BDPRET=$$EDIT(BDPRIEN,BDPCIEN,BDPIEN)
 Q
 ;
ADD1(BDPDFN,BDPTYPE) ;EP - add to top level of file for this category
 NEW X S X=$O(^BDPRECN("AA",BDPDFN,BDPTYPE,0)) I X Q X
 S DIC="^BDPRECN(",DIC(0)="L",DLAYGO=90360.1,DIC("DR")=".02////"_BDPDFN,X=BDPTYPE
 D FILE^BDPFMC
 I Y<0 Q "0^UNABLE TO ADD - FILEMAN FAILED"
 Q +Y
 ;
EDIT(BDPRIEN,BDPTYPE,BDPPROV) ;EP - edit/add to multiple
 I '$G(BDPRIEN) Q "0^RECORD IEN INVALID"
 NEW X,BDPLIEN,C,BDPLNUM
 S:'$D(^BDPRECN(BDPRIEN,1,0)) $P(^(0),U,2)="90360.11P"
 S (X,BDPLIEN,BDPLNUM)=0
 F  S X=$O(^BDPRECN(BDPRIEN,1,X)) Q:X'=+X  S BDPLIEN=X,BDPLNUM=BDPLNUM+1  ;get last ien in multiple
 S BDPLIEN=BDPLIEN+1
 S BDPLNUM=BDPLNUM+1
 S $P(^BDPRECN(BDPRIEN,1,0),U,3)=BDPLIEN
 S $P(^BDPRECN(BDPRIEN,1,0),U,4)=BDPLNUM
 S BDPLINKI=1  ;tell fileman you are coming from bdp
 S DR=".01///"_"`"_BDPPROV
 L ^BDPRECN(BDPRIEN):10 I '$T Q "0^UNABLE TO LOCK GLOBAL"
 S DIE="^BDPRECN("_BDPRIEN_",1,",DA(1)=BDPRIEN,DA=BDPLIEN D ^DIE K DIE,DR,DA,DINUM
 L -^BDPRECN(BDPRIEN)
 I $D(Y) Q "0^ADDING PROVIDER TO LOG FAILED"
 Q 1
 ;
DEL1(BDPPAT,BDPTYPE) ;
 NEW BDPX
 S BDPX=$O(^BDPRECN("AA",BDPPAT,BDPTYPE,0))
 I 'BDPX Q 1  ;doesn't have one so can't delete it
 NEW DA,DIE,DR
 S DA=BDPX,DIE="^BDPRECN(",DR=".03///@" D ^DIE
 Q 1
 ;
WHPCP(BDPPAT,BDPRET) ;PEP - return WH case managers and DPCP
 ; input:  BDPPAT - DFN of patient
 ;         BDPRET - return array
 ; return array BDPRET:
 ;        BDPRET(category name)=name of provider^ien of provider^provider class of provider^date updated
 ;        BDPRET("WOMEN'S HEALTH CASE MANAGER")=name of provider^ien of provider^provider class of provider^date updated
 ;        BDPRET("DESIGNATED PRIMARY PROVIDER")=name of provider^ien of provider^provider class of provider^date updated
 ;        BDPRET("WOMEN'S HEALTH ALTERNATE")=name of provider^ien of provider^provider class of provider^date updated
 ;        
 ;        If the patient does not have a provider in any of the above categories the array will not
 ;        contain that category so if there is no dpcp then '$D(BDPRET("DESIGNATED PRIMARY CARE PROVIDER")
 ;        will be true
 ;
 K BDPRET
 I $G(BDPPAT)="" Q
 NEW BDPX,BDPY,BDPZ,BDPCIEN
 S BDPCIEN=$O(^BDPTCAT("B","DESIGNATED PRIMARY PROVIDER",0))
 S BDPX=$O(^BDPRECN("AA",BDPPAT,BDPCIEN,0))
 I BDPX,$P($G(^BDPRECN(BDPX,0)),U,3)]"" S BDPY="DESIGNATED PRIMARY PROVIDER" D SETV
 S BDPCIEN=0 F  S BDPCIEN=$O(^BDPTCAT(BDPCIEN)) Q:BDPCIEN'=+BDPCIEN  I $P(^BDPTCAT(BDPCIEN,0),U,6) D
 .S BDPX=$O(^BDPRECN("AA",BDPPAT,BDPCIEN,0))
 .Q:'BDPX
 .Q:$P(^BDPRECN(BDPX,0),U,3)=""
 .S BDPY=$P(^BDPTCAT(BDPCIEN,0),U,1) D SETV
 .Q
 Q
SETV ;
 NEW BDPI
 S BDPI=$$VALI^XBDIQ1(90360.1,BDPX,.03)
 S BDPRET(BDPY)=$$VAL^XBDIQ1(90360.1,BDPX,.03)_"^"_BDPI_"^"_$$VAL^XBDIQ1(200,BDPI,53.5)_"^"_$$VALI^XBDIQ1(90360.1,BDPX,.05)
 Q
ALLDP(BDPPAT,BDPTYPE,BDPRET) ;PEP - return array of designated providers in all categories or 1 category
 ; input:  BDPPAT - DFN of patient
 ;         BDPTYPE - null if want all designated providers, or NAME of category, (e.g. RENAL DISEASE)
 ;                   if just want 1 provider category
 ;         BDPRET - return array
 ; return array BDPRET:
 ;        BDPRET(category name)=name of provider^ien of provider^provider class of provider^date updated
 ;        example:
 ;        BDPRET("WOMEN'S HEALTH CASE MANAGER")=name of provider^ien of provider^provider class of provider^date updated
 ;        BDPRET("DESIGNATED PRIMARY PROVIDER")=name of provider^ien of provider^provider class of provider^date updated
 ;    
 K BDPRET
 I $G(BDPPAT)="" Q
 S BDPTYPE=$G(BDPTYPE)
 NEW BDPX,BDPY,BDPZ,BDPCIEN
 S BDPCIEN=0 F  S BDPCIEN=$O(^BDPRECN("AA",BDPPAT,BDPCIEN)) Q:BDPCIEN'=+BDPCIEN  D
 .I BDPTYPE]"",$P(^BDPTCAT(BDPCIEN,0),U)'=BDPTYPE Q  ;don't want this one
 .S BDPX=$O(^BDPRECN("AA",BDPPAT,BDPCIEN,0))
 .Q:'BDPX
 .Q:$P(^BDPRECN(BDPX,0),U,3)=""
 .S BDPY=$P(^BDPTCAT(BDPCIEN,0),U,1) D SETV
 .Q
 Q
PROVPANL(BDPPIEN) ;PEP - entry point to view/update one provider's panel
 I '$G(BDPPIEN) Q
 D EN^BDPDPEE
 Q
ALLDPVG(BDPPAT,BDPTYPE,BDPRET) ;PEP - return array of designated providers in all categories or 1 category
 ; input:  BDPPAT - DFN of patient
 ;         BDPTYPE - null if want all designated providers, or NAME of category, (e.g. RENAL DISEASE)
 ;                   if just want 1 provider category
 ;         BDPRET - return array
 ; return array BDPRET:
 ;        BDPRET(category IEN)=name of category^name of provider^ien of provider^provider class of provider^date updated^user last update
 ;        example:
 ;        BDPRET(12)=name of category^name of provider^ien of provider^provider class of provider^date updated
 ;    
 K BDPRET
 I $G(BDPPAT)="" Q
 S BDPTYPE=$G(BDPTYPE)
 NEW BDPX,BDPY,BDPZ,BDPCIEN
 S BDPCIEN=0 F  S BDPCIEN=$O(^BDPRECN("AA",BDPPAT,BDPCIEN)) Q:BDPCIEN'=+BDPCIEN  D
 .I BDPTYPE]"",$P(^BDPTCAT(BDPCIEN,0),U)'=BDPTYPE Q  ;don't want this one
 .S BDPX=$O(^BDPRECN("AA",BDPPAT,BDPCIEN,0))
 .Q:'BDPX
 .Q:$P(^BDPRECN(BDPX,0),U,3)=""
 .S BDPY=BDPCIEN D SETV1
 .Q
 Q
SETV1 ;
 NEW BDPI
 S BDPI=$$VALI^XBDIQ1(90360.1,BDPX,.03)
 S BDPRET(BDPY)=$P(^BDPTCAT(BDPCIEN,0),U,1)_"^"_$$VAL^XBDIQ1(90360.1,BDPX,.03)_"^"_BDPI_"^"_$$VAL^XBDIQ1(200,BDPI,53.5)_"^"_$$VALI^XBDIQ1(90360.1,BDPX,.05)_"^"_$$VALI^XBDIQ1(90360.1,BDPX,.04)
 Q
