BPXRMIDX ;IHS/MSC/MGH - Create cross-references. ;31-May-2013 11:01;DU
 ;;2.0;CLINICAL REMINDERS;**1001**;Feb 04, 2005;Build 21
 ;
 Q
 ;===============================================================
CVPRC ;Create cross-reference for V PROCEDURE.
 N MSG,RESULT,UITEM,XREF
 D BMES^XPDUTL("Creating V PROCEDURE cross-reference.")
 ;Set the XREF nodes
 S XREF("FILE")=9000010.08
 S XREF("ROOT FILE")=9000010.08
 S XREF("SET")="D SVFILEC^PXPXRM(9000010.08,.X,.DA)"
 S XREF("KILL")="D KVFILEC^PXPXRM(9000010.08,.X,.DA)"
 S XREF("WHOLE KILL")="K ^PXRMINDX(9000010.08)"
 D SXREFVF(.XREF,"ICD0 code")
 S UITEM="ICD0 CODE"
 S XREF("DESCR",5)=" ^PXRMINDX("_XREF("FILE")_",""IPP"","_UITEM_",PP,DFN,VISIT DATE,DAS) and"
 S XREF("DESCR",6)=" ^PXRMINDX("_XREF("FILE")_",""PPI"",DFN,PP,"_UITEM_",VISIT DATE,DAS)"
 S XREF("DESCR",7)="respectively. PP is the principal procedure code. Possible values are Y (yes), N (no) or U (undefined)."
 S XREF("DESCR",8)="For all the details, see the Clinical Reminders Index Technical Guide/Programmer's Manual."
 S XREF("VAL",4)=.07
 D CREIXN^DDMOD(.XREF,"k",.RESULT,"","MSG")
 Q
 ;
 ;===============================================================
CVFILE ;Create all the V file cross-references.
 D BMES^XPDUTL("Creating V file cross-references.")
 D CVPRC
 D CVMEA
 Q
 ;
 ;===============================================================
CVLAB ;Create cross-reference for V LAB.
 N MSG,RESULT,XREF
 D BMES^XPDUTL("Creating V LAB cross-reference.")
 ;Set the XREF nodes
 S XREF("FILE")=9000010.09
 S XREF("ROOT FILE")=9000010.09
 S XREF("SET")="D SVFILE^PXPXRM(9000010.09,.X,.DA)"
 S XREF("KILL")="D KVFILE^PXPXRM(9000010.09,.X,.DA)"
 S XREF("WHOLE KILL")="K ^PXRMINDX(9000010.09)"
 D SXREFVF(.XREF,"Lab test")
 D CREIXN^DDMOD(.XREF,"k",.RESULT,"","MSG")
 I RESULT="" W !,"ERROR"
 Q
 ;
 ;===============================================================
CVMEA ;Create cross-reference for V MEASUREMENT.
 N MSG,RESULT,XREF
 D BMES^XPDUTL("Creating V MEASUREMENT.")
 ;Set the XREF nodes
 S XREF("FILE")=9000010.01
 S XREF("ROOT FILE")=9000010.01
 S XREF("SET")="D EVFILE^PXPXRM(9000010.01,.X,.DA)"
 S XREF("KILL")="D KEFILE^PXPXRM(9000010.01,.X,.DA)"
 S XREF("WHOLE KILL")="K ^PXRMINDX(9000010.01)"
 D SXREFVF(.XREF,"measurement type")
 D CREIXN^DDMOD(.XREF,"k",.RESULT,"","MSG")
 I RESULT="" W !,"ERROR"
 Q
 ;
 ;===============================================================
DCERRMSG(MSG,XREF) ;Display creation error message.
 W !,"Cross-reference could not be created!"
 W !,"Error message:"
 D AWRITE^PXRMUTIL("MSG")
 W !!,"Cross-reference information:"
 D AWRITE^PXRMUTIL("XREF")
 Q
 ;
 ;===============================================================
SXREFVF(XREF,ITEM) ;Set XREF array nodes common for all V files.
 N UITEM
 S UITEM=$$UP^XLFSTR(ITEM)
 S XREF("TYPE")="MU"
 S XREF("NAME")="ACR"
 S XREF("SHORT DESCR")="Clinical Reminders index."
 S XREF("DESCR",1)="This cross-reference builds two indexes, one for finding"
 S XREF("DESCR",2)="all patients with a particular "_ITEM_" and one for finding all"
 S XREF("DESCR",3)="the "_ITEM_"s a patient has."
 S XREF("DESCR",4)="The indexes are stored in the Clinical Reminders index global as:"
 S XREF("DESCR",5)=" ^PXRMINDX("_XREF("FILE")_",""IP"","_UITEM_",DFN,VISIT DATE,DAS) and"
 S XREF("DESCR",6)=" ^PXRMINDX("_XREF("FILE")_",""PI"",DFN,"_UITEM_",VISIT DATE,DAS)"
 S XREF("DESCR",7)="respectively."
 S XREF("DESCR",8)="For all the details, see the Clinical Reminders Index Technical Guide/Programmer's Manual."
 S XREF("USE")="ACTION"
 S XREF("EXECUTION")="R"
 S XREF("ACTIVITY")="IR"
 S XREF("VAL",1)=.01
 S XREF("VAL",1,"SUBSCRIPT")=1
 S XREF("VAL",2)=.02
 S XREF("VAL",2,"SUBSCRIPT")=2
 S XREF("VAL",3)=1201
 S XREF("VAL",3,"SUBSCRIPT")=3
 Q
 ;
