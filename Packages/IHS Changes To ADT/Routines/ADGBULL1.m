ADGBULL1 ; IHS/ADC/PDW/ENM - POST ADT BULLETINS ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;AUTOMATIC POSTING OF ADT BULLETIN
 ;
GEN ; -- set general data
 S XMB(1)=$P(^DPT(DFN,0),U)                    ;patient name
 S XMB(2)=$P(^AUPNPAT(DFN,41,DUZ(2),0),U,2)    ;chart #
 S XMB(3)=$$VAL^XBDIQ1(405,DGPMCA,.01)         ;admit date/time
 S X="NOW",%DT="T" D ^%DT S XMDT=Y             ;send bulletin now
 Q
 ;
ICU ;EP; -- bulletin for ICU transfers
 S XMB="DG IHS B ICU TRANSFER"                   ;bulletin name
 S XMB(1)=$P(^DPT(DFN,0),U)                      ;patient name
 S XMB(2)=$P(^AUPNPAT(DFN,41,DUZ(2),0),U,2)      ;chart number
 S XMB(3)=$$VAL^XBDIQ1(405,+DGPMDA,.01)          ;transfer date/time
 S XMB(4)=$$VAL^XBDIQ1(405,+DGPMCA,.1)           ;admitting dx
 S XMB(5)=$$SRV(+DGPMDA)                         ;service
 S X="NOW",%DT="T" D ^%DT S XMDT=Y               ;send bulletin now
 D ^XMB Q
 ;
TI ;EP; -- bulletin for transfers in to facility
 S XMB="DG IHS B TRANSFER IN ADMIT"              ;bulletin name
 D GEN                                           ;set general variables
 S XMB(4)=$$VAL^XBDIQ1(405,+DGPMDA,.05)          ;transfer facility
 S XMB(5)=$$VAL^XBDIQ1(405,+DGPMCA,.1)           ;admitting dx
 S XMB(6)=$$SRV(+DGPMDA)                         ;service
 D ^XMB Q
 ;
TO ;EP; -- bulletin for transfers out to other facility
 S XMB="DG IHS B TRANSFER OUT DISCH"             ;bulletin name
 D GEN                                           ;set general variables
 S XMB(4)=$$VAL^XBDIQ1(405,+DGPMDA,.01)          ;dsch date
 S XMB(5)=$$VAL^XBDIQ1(405,+DGPMDA,.05)          ;transfer facility
 S XMB(6)=$$VAL^XBDIQ1(405,+DGPMCA,.1)           ;admitting dx
 S XMB(7)=$$SRV(+DGPMDA)                         ;service
 D ^XMB Q
 ;
AMA ;EP; -- bulletin for ama discharges
 S XMB="DG IHS B AMA DISCHARGE"                  ;bulletin name
 D GEN                                           ;set general variables
 S XMB(4)=$$VAL^XBDIQ1(405,+DGPMDA,.01)          ;dsch date
 S XMB(5)=$$VAL^XBDIQ1(405,+DGPMCA,.1)           ;admitting dx
 S XMB(6)=$$SRV(+DGPMDA)                         ;service
 D ^XMB Q
 ;
DEATH ;EP; -- bulletin for inpatient death
 S XMB="DG IHS B DEATH"                          ;bulletin name
 D GEN                                           ;set gen variables
 S XMB(4)=$$VAL^XBDIQ1(405,+DGPMDA,.01)          ;dsch date
 S XMB(5)=$$VAL^XBDIQ1(405,+DGPMDA,.04)          ;dsch type
 S XMB(6)=$$VAL^XBDIQ1(405,+DGPMCA,.1)           ;admitting dx
 S XMB(7)=$$SRV(+DGPMDA)                         ;service
 D ^XMB Q
 ;
READM ;EP; -- bulletin for readmissions
 S XMB="DG IHS B READMISSION"                    ;bulletin name
 D GEN                                           ;set gen variables
 S XMB(4)=$P($G(DGOPT("QA1")),U)                 ;time limit
 S XMB(5)=$$VAL^XBDIQ1(405,+DGPMCA,.1)           ;admitting dx
 S XMB(6)=$$LDSCH                                ;last discharge
 S XMB(7)=$$LDX                                  ;last adm dx
 S XMB(8)=$$SRV(+DGPMDA)                         ;service
 S XMB(9)=$$SRV($$LDSC)                          ;last service
 D ^XMB Q
 ;
ADMDS ;EP; -- bulletin for admit after day surgery
 S XMB="DG IHS B ADMIT AFTER DAY SURG"           ;bulletin name
 D GEN                                           ;set gen variables
 S XMB(4)=$P($G(DGOPT("QA1")),U,2)               ;time limit
 NEW ADG D ENP^XBDIQ1(405,+DGPMDA,".09;.1","ADG(")
 S XMB(5)=$$VAL^XBDIQ1(405,+DGPMCA,.1)           ;adm dx
 S XMB(9)=$$SRV(+DGPMDA)                         ;adm srv
 S Y=DGDS D DD^%DT S XMB(6)=Y                    ;day surg date/time
 S XMB(7)=$P(^ADGDS(DFN,"DS",DGDSA,0),U,2)       ;day surg procedure
 S XMB(8)=$S(DGRE["DS":"**ADMITTED DIRECTLY FROM DAY SURGERY**",1:"")
 D ^XMB Q
 ;
SRV(X) ; -- hospital srv name for movement
 NEW Y
 S Y=$O(^DGPM("APHY",X,0))
 I Y="" S Y=$$LSRV
 I Y]"" S Y=$$VAL^XBDIQ1(405,Y,.09)
 Q Y
 ;
LSRV() ; >> find last time srv was transferred
 N X,Y S Y=$$IDATE(+DGPMA)
 S X=$O(^DGPM("ATID6",DFN,+$O(^DGPM("ATID6",DFN,Y)),0))
 I X="" S X=DGPMCA
 Q X
 ;
LDSC() ; -- find last discharge
 N X,Y S Y=$$IDATE(+DGPMA)
 S X=$O(^DGPM("ATID3",DFN,+$O(^DGPM("ATID3",DFN,Y)),0))
 Q X
 ;
LDSCH() ; -- find last discharge date
 Q $$VAL^XBDIQ1(405,+$$LDSC,.01)
 ;
LDX() ; -- find last adm dx
 NEW Y S Y=$P(^DGPM($$LDSC,0),U,14) I Y="" Q ""
 Q $$VAL^XBDIQ1(405,Y,.1)
 ;
IDATE(X) ; >> inverse date
 Q (9999999.9999999-X)
