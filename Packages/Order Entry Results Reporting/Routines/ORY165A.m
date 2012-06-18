ORY165A ;SLC/DAN Clean up non-canonic dates ;12/19/02  12:01
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**165**Dec 17, 1997
 ;DBIA Section
 ;10018 - DIE Call
 ;10063 - %ZTLOAD Call
 ;10141 - XPDUTL Call
 ;10070 - XMD Call
 ;This routine will find all order date/time entries that
 ;are non-canonical and enter them in canonic form.
 N ORI,DA,ORMSG
 S ORMSG(1)="A task is being queued in the background to identify"
 S ORMSG(2)="any orders whose START DATE/TIME or STOP DATE/TIME field is a non-canonic"
 S ORMSG(3)="number (having trailing zeros)."
 S ORMSG(4)=""
 S ORMSG(5)="These entries will be set to the correct canonic form"
 S ORMSG(6)="by the background job and a mail message will be sent"
 S ORMSG(7)="to the initiator of this patch at completion."
 S ORMSG(8)=""
 S ZTRTN="DQ^ORY165A",ZTIO="",ZTDESC="DATE/TIME ORDER field clean up - Patch 165",ZTDTH=$H,ZTSAVE("DUZ")="" D ^%ZTLOAD
 S ORMSG(9)="The task number is "_$G(ZTSK)
 D MES^XPDUTL(.ORMSG) I '$D(ZTQUEUED) N DIR,Y S DIR(0)="E",DIR("A")="Press return to continue installation" D ^DIR
 Q
DQ ;Start processing here
 N ORSR,ORVP,ORDG,ORI,DA
 F ORSR="AD","AE" S ORI="00" F  S ORI=$O(^OR(100,ORSR,ORI)) Q:ORI=""  I ORI'=+ORI D  ;if date/time is non-canonic then fix
 .S DA="" F  S DA=$O(^OR(100,ORSR,ORI,DA)) Q:DA=""  D:ORSR="AD" SK^ORDD100 D:ORSR="AE" EK^ORDD100A D UPDATE
 .Q
 ;Now check the AW xref, which has a different format
 S ORSR="AW"
 S ORVP="" F  S ORVP=$O(^OR(100,ORSR,ORVP)) Q:ORVP=""  S ORDG=0 F  S ORDG=$O(^OR(100,ORSR,ORVP,ORDG)) Q:'+ORDG  D
 .S ORI="00" F  S ORI=$O(^OR(100,ORSR,ORVP,ORDG,ORI)) Q:'+ORI  I ORI'=+ORI S DA=0 F  S DA=$O(^OR(100,ORSR,ORVP,ORDG,ORI,DA)) Q:'+DA  D WK^ORDD100,UPDATE
 .Q
 D MAIL ;send email notifying initiator that clean up is finished
 Q
UPDATE ;change date/time to canonic form and call DIE to reset cross references
 N DIE,DR
 S DIE="^OR(100,",DR=$S(ORSR="AD"!(ORSR="AW"):21,1:22)_"///"_+ORI
 D ^DIE
 D:ORSR="AW" WS^ORDD100 D:ORSR="AD" SS^ORDD100 D:ORSR="AE" ES^ORDD100A
 Q
MAIL ; -- Send completion message to user who initiated conversion
 N XMSUB,XMTEXT,XMDUZ,XMY,XMZ,XMMG,ORTXT
 S XMDUZ="PATCH OR*3*165 CLEAN-UP",XMY(.5)="" S:$G(DUZ) XMY(DUZ)=""
 S ORTXT(1)="The START DATE/TIME and STOP DATE/TIME field clean up for patch OR*3*165"
 S ORTXT(2)="completed at "_$$FMTE^XLFDT($$NOW^XLFDT)_"."
 S XMTEXT="ORTXT(",XMSUB="PATCH OR*3*165 Clean Up COMPLETED"
 D ^XMD
 Q
