BLRLDFIS ; IHS/MSC/MKK - Add data to "IHS" Lab Data file ; 22-Oct-2013 09:22 ; MKK
 ;;5.2;IHS LABORATORY;**1033,1034**;NOV 01, 1997;Build 88
 ;
EEP ; Ersatz EP
 D EEP^BLRGMENU
 Q
 ;
EP ; EP
PEP ; EP
 NEW (APCDALVR,BLRLOGDA,DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,REFLABF,U,XPARSYS,XQXFLG)
 ;
 Q:$$INITVARS()<1
 ;
 D STORDATA
 Q
 ;
INITVARS() ; EP - Initialization of variables
 S (ICD,LOCDN,LOINC,NOTE,RESULTDT,SNOMED)=""
 ;
 Q:+$G(APCDALVR("APCDTRES"))<1 0    ; If no RESULT data, skip
 ;
 S LRAS=$$GET1^DIQ(9009022,BLRLOGDA,"ACCESSION NUMBER")
 Q:$L(LRAS)<1 0                     ; If no Accession number, skip
 ;
 S X=$$GETACCCP^BLRUTIL3(LRAS,.LRAA,.LRAD,.LRAN)
 Q:X<1 0                            ; If cannot "break apart" accession number, skip
 ;
 S LRDFN=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,0)),UID=$G(^(.3)),LRIDT=+$P($G(^(3)),"^",5)
 Q:LRDFN<1!(LRIDT<1) 0              ; If no Lab Data file pointers, skip
 ;
 S RESULTDT=+$$GET1^DIQ(9009022,BLRLOGDA,"ENTRY DATE/TIME","I")
 Q:RESULTDT<1 0                     ; If no date, skip
 ;
 S F60IEN=+$$GET1^DIQ(9009022,BLRLOGDA,"PANEL/TEST POINTER","I")
 Q:F60IEN<1 0                       ; If no Test, skip
 ;
 S LOCDN=+$P($$GET1^DIQ(60,F60IEN,"LOCATION (DATA NAME)"),";",2)
 Q:LOCDN<1 0                        ; If no DataName, skip
 ;
 S LOINC=$TR($G(APCDALVR("APCDTLNC")),"`")
 S ICD=$TR($G(APCDALVR("APCDTLPV")),"`")
 S:$L(ICD)&(+ICD<1) ICD=""          ; If ICD not a number, set to null
 ;
 D:REFLABF ICOMDATA
 ;
 Q 1
 ;
ICOMDATA ; EP - Retreive necessary data from the Incoming HL7 message in the UNIVERSAL INTERFACE (#4001) file.
 ; Note that BLRLINKU routine stores the data in the ^TMP global when called earlier in the BLRLINK3 routine,
 ; which means no need to re-examine 4001.
 S STR=$G(^TMP("BLR",$J,UID,F60IEN))
 S RESULTDT=$P(STR,"^",6)
 S LOINC=$P(STR,"^",7)
 Q
 ;
STORDATA ; EP - Store the Data
 K FDA  S FDA(90479.5,"?+1,",.01)=LRDFN
 K ERRS  D UPDATE^DIE("S","FDA",,"ERRS")
 Q:$$CHKERRS("ERRS","Error Adding LRDFN")
 ;
 S IEN0=+$$FIND1^DIC(90479.5,,,LRDFN)
 I IEN0<1 D NOTFOUND("LRDFN "_LRDFN)  Q
 ;
 K FDA
 S FDA(90479.51,"?+1,"_IEN0_",",.01)=LRIDT
 S FDA(90479.51,"?+1,"_IEN0_",",1)=LRAS
 S FDA(90479.51,"?+1,"_IEN0_",",2)=UID
 ;
 K ERRS  D UPDATE^DIE("S","FDA",,"ERRS")
 Q:$$CHKERRS("ERRS","LRIDT, LRAS, & UID")
 ;
 S IEN1=+$$FIND1^DIC(90479.51,","_IEN0_",",,LRIDT)
 I IEN1<1 D NOTFOUND("LRIDT "_LRIDT)  Q
 ;
 K FDA
 S FDA(90479.513,"?+1,"_IEN1_","_IEN0_",",.01)=LOCDN
 ;
 K ERRS  D UPDATE^DIE("S","FDA",,"ERRS")
 Q:$$CHKERRS("ERRS","LOCATION (DATA NAME)")
 ;
 S IEN2=+$$FIND1^DIC(90479.513,","_IEN1_","_IEN0_",",,LOCDN)
 I IEN1<1 D NOTFOUND("LOCATION (DATA NAME) "_LOCDN)  Q
 ;
 K FDA
 S FDA(90479.5131,"?+1,"_IEN2_","_IEN1_","_IEN0_",",.01)=RESULTDT
 S:$L($G(LOINC)) FDA(90479.5131,"?+1,"_IEN2_","_IEN1_","_IEN0_",",1)=LOINC
 S:$L($G(ICD)) FDA(90479.5131,"?+1,"_IEN2_","_IEN1_","_IEN0_",",2)=ICD
 S:$L($G(SNOMED)) FDA(90479.5131,"?+1,"_IEN2_","_IEN1_","_IEN0_",",3)=SNOMED
 ;
 K ERRS  D UPDATE^DIE("S","FDA",,"ERRS")
 Q:$$CHKERRS("ERRS","RESULT DATE")
 ;
 D OTHRSEGS(IEN0,IEN1,IEN2)
 Q
 ;
OTHRSEGS(IEN0,IEN1,IEN2) ; EP - Store Other Data
 Q
 ;
CHKERRS(ERRS,SUBJECT) ; EP - If ERRS array is empty, just return zero, otherwise send MailMan message and return 1
 Q:$D(ERRS)<1 0
 ;
 NEW LN,MSGARRAY,STR1
 ;
 S MSGARRAY(1)="BLRLDFIS Routine ERROR"
 S $E(MSGARRAY(2),5)="Accession:"_LRAS
 S $E(MSGARRAY(3),5)="UID:"_UID
 S LN=3
 ;
 ; "Dump" ERRS array into the MailMan Message array
 S STR1=$Q(@ERRS@(""))
 S $E(MSGARRAY(4),10)=@STR1
 S LN=4
 F  S STR1=$Q(@STR1)  Q:STR1=""  D
 . S LN=LN+1
 . S $E(MSGARRAY(LN),10)=@STR1
 ;
 S SUBJECT="Error Adding "_SUBJECT_" to 90475.7"
 D MAILALMI^BLRUTIL3(SUBJECT,.MSGARRAY,"BLRLDFIS")
 ;
 Q 1
 ;
NOTFOUND(SUBJECT) ; EP - If could not retrieve IEN, send Message
 NEW LN,MSGARRAY,STR1
 ;
 S MSGARRAY(1)="BLRLDFIS Routine ERROR"
 S $E(MSGARRAY(2),5)="Accession:"_LRAS
 S $E(MSGARRAY(3),5)="UID:"_UID
 ;
 S SUBJECT="Error Finding "_SUBJECT_" in 90475.7 File"
 D MAILALMI^BLRUTIL3(SUBJECT,.MSGARRAY,"BLRLDFIS")
 Q
 ;
TESTSTOR ; EP - Test the STORDATA routine
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D ^LRWU4
 ;
 I $D(^LRO(68,LRAA,1,LRAD,1,LRAN))<1 D  Q
 . W !!,?4,"Invalid Accession.  Routine Ends.",!
 ;
 S LRDFN=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,0)),LRAS=$G(^(.2)),UID=+$G(^(.3)),LRIDT=+$P($G(^(3)),"^",5)
 S FIRST=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,4,0)),DATALN=+$G(^LAB(60,FIRST,.2)),LOINC=$G(^LAB(60,FIRST,1,70,95.3))
 S RESULTDT=+$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,4,FIRST,0)),"^",5)
 S:RESULTDT<1 RESULTDT=$$NOW^XLFDT
 S (ICD,SNOMED)=""
 ;
 D STORDATA
 Q
 ;
RETDATA(UID) ; EP - Given UID, retrieve all the informatoin that's available in ^BLRMULDA global
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,UID,XPARSYS,XQXFLG)
 ;
 Q
 ;
CHEK69 ; EP
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 S HEADER(1)="Laboratory Order File"
 ; S HEADER(2)="Orders with SIGN OR SYMPTOM Data"
 S HEADER(2)="Orders with Clinical Indication Data"   ; IHS/MSC/MKK - LR*5.2*1034
 S HEADER(3)=" "
 S $E(HEADER(4),5)="LRODT"
 S $E(HEADER(4),15)="LRSPN"
 S $E(HEADER(4),25)="LROT"
 S $E(HEADER(4),35)="SIGNSYMP"
 S $E(HEADER(4),45)="INDICATION CODE"
 ;
 D HEADERDT^BLRGMENU
 ;
 S (CNT,LRODT)=0
 F  S LRODT=$O(^LRO(69,LRODT))  Q:LRODT<1  D
 . S LRSPN=0
 . F  S LRSPN=$O(^LRO(69,LRODT,1,LRSPN))  Q:LRSPN<1  D
 .. S LROT=0
 .. F  S LROT=$O(^LRO(69,LRODT,1,LRSPN,2,LROT))  Q:LROT<1  D
 ... S STR=$G(^LRO(69,LRODT,1,LRSPN,2,LROT,9999999))
 ... Q:$L(STR)<1
 ... ;
 ... W ?4,LRODT,?14,LRSPN,?24,LROT,?34,$P(STR,"^"),?44,$P(STR,"^",2),!
 ... S CNT=CNT+1
 ;
 Q
