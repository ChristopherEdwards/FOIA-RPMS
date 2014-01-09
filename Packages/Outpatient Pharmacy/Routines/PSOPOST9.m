PSOPOST9 ;BIR/MR-Reminders Index Post-Install Routine ;22-Oct-2012 09:42;DU
 ;;7.0;OUTPATIENT PHARMACY;**118,1015**;DEC 1997;Build 62
 ;Reference to PXRMP12I supported by DBIA 3736
 ;Modified - IHS/MSC/MGH - 10/22/2012 - Line CPSRX+58
 ;IHS/MSC/MGH Added another cross-reference for e-prescribing
 ;
CPSRX ;Create cross-references for Prescription file.
 N IND,MSG,NAME,RESULT,XREF
 D MES^XPDUTL("Creating Prescription file cross-references...")
 S XREF("FILE")=52
 S XREF("WHOLE KILL")="Q"
 S XREF("TYPE")="MU"
 S XREF("SHORT DESCR")="Clinical Reminders index."
 S XREF("DESCR",1)="This cross-reference builds two indexes, one for finding"
 S XREF("DESCR",2)="all patients with a particular drug and one for"
 S XREF("DESCR",3)="finding all the drugs a patient has. The indexes are"
 S XREF("DESCR",4)="stored in the Clinical Reminders index global as:"
 S XREF("DESCR",5)=" ^PXRMINDX(52,""IP"",DRUG,DFN,START DATE,STOP DATE,DAS)"
 S XREF("DESCR",6)=" ^PXRMINDX(52,""PI"",DFN,DRUG,START DATE,STOP DATE,DAS)"
 S XREF("DESCR",8)="respectively. START DATE is the RELEASE DATE and STOP DATE is"
 S XREF("DESCR",9)="calculated by adding the DAYS SUPPLY to the RELEASE DATE."
 S XREF("DESCR",10)="For all the details, see the Clinical Reminders Index Technical Guide/Programmer's Manual."
 S XREF("USE")="ACTION"
 S XREF("EXECUTION")="F"
 S XREF("ACTIVITY")="IR"
 ;
 ;Original node
 S XREF("ROOT FILE")=52
 S XREF("NAME")="ACRO"
 S XREF("SET")="D SKIDX^PSOPXRMU(.X,.DA,""O"",""S"")"
 S XREF("KILL")="D SKIDX^PSOPXRMU(.X,.DA,""O"",""K"")"
 S XREF("VAL",1)=8
 S XREF("VAL",1,"SUBSCRIPT")=1
 S XREF("VAL",2)=31
 S XREF("VAL",2,"SUBSCRIPT")=2
 D CREIXN^DDMOD(.XREF,"k",.RESULT,"","MSG")
 I RESULT="" D DCERRMSG^PXRMP12I(.MSG,.XREF)
 ;
 ;Refill node
 S XREF("ROOT FILE")=52.1
 S XREF("NAME")="ACRR"
 S XREF("SET")="D SKIDX^PSOPXRMU(.X,.DA,""R"",""S"")"
 S XREF("KILL")="D SKIDX^PSOPXRMU(.X,.DA,""R"",""K"")"
 S XREF("VAL",1)=1.1
 S XREF("VAL",1,"SUBSCRIPT")=1
 S XREF("VAL",2)=17
 S XREF("VAL",2,"SUBSCRIPT")=2
 D CREIXN^DDMOD(.XREF,"k",.RESULT,"","MSG")
 I RESULT="" D DCERRMSG^PXRMP12I(.MSG,.XREF)
 ;
 ;Partial node
 S XREF("ROOT FILE")=52.2
 S XREF("NAME")="ACRP"
 S XREF("SET")="D SKIDX^PSOPXRMU(.X,.DA,""P"",""S"")"
 S XREF("KILL")="D SKIDX^PSOPXRMU(.X,.DA,""P"",""K"")"
 S XREF("VAL",1)=.041
 S XREF("VAL",1,"SUBSCRIPT")=1
 S XREF("VAL",2)=8
 S XREF("VAL",2,"SUBSCRIPT")=2
 D CREIXN^DDMOD(.XREF,"k",.RESULT,"","MSG")
 I RESULT="" D DCERRMSG^PXRMP12I(.MSG,.XREF)
 D MES^XPDUTL("OK!")
 ;
 ;IHS/MSC/MGH ERx cross-reference
 S XREF("ROOT FILE")=52
 S XREF("NAME")="ACRE"
 S XREF("SET")="D ERX^PSOPXRMU(.X,.DA,""O"",""S"")"
 S XREF("KILL")="D ERX^PSOPXRMU(.X,.DA,""O"",""K"")"
 S XREF("VAL",1)=8
 S XREF("VAL",1,"SUBSCRIPT")=1
 S XREF("VAL",2)=22
 S XREF("VAL",2,"SUBSCRIPT")=2
 D CREIXN^DDMOD(.XREF,"k",.RESULT,"","MSG")
 I RESULT="" D DCERRMSG^PXRMP12I(.MSG,.XREF)
 Q
 ;
