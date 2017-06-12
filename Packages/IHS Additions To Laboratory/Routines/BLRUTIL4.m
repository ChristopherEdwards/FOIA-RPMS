BLRUTIL4 ;IHS/MSC/MKK - MISC IHS LAB UTILITIES (Cont) ; 17-Jul-2015 06:30 ; MKK
 ;;5.2;LR;**1031,1033,1034,1035**;NOV 01, 1997;Build 5
 ;
 ; Determines if MODULE exists on server
MODEXIST(MODULE) ; EP
 NEW HEREYAGO,NAME,PATCH,PTR,SYSVER,VERSION
 ;
 D FIND^DIC(9.4,"",,,MODULE,,"C",,,"HEREYAGO")
 S PTR=+$G(HEREYAGO("DILIST",2,1))
 ;
 Q:PTR<1 "0^NOT ON THIS SERVER^"
 ;
 ; Special logic for INTEGRATED BILLING
 I $G(HEREYAGO("DILIST",1,1))["INTEGRATED BILL" Q "0^NOT ON THIS SERVER^"
 I $G(HEREYAGO("DILIST",1,1))["IB ENCOUNTER" Q "0^NOT ON THIS SERVER^"
 ;
 S SYSVER=+$$VERSION^XPDUTL(MODULE)      ; Get Current Version #
 ;
 ; Special logic for VA Clinical Reminders
 Q:MODULE="PXRM"&(SYSVER<2) "0^NOT ON THIS SERVER^"
 ;
 ; Special logic for VA Patient Encounter module
 I MODULE="PCE"!(MODULE="PX") D
 . Q:MODULE="PXRM"                       ; Skip Clinical Reminders
 . S MODULE="PX"
 . S VERSION="1.0"
 . S PATCH=168       ; Latest VA Patch as of 5/1/2009
 . S PATCH=197       ; IHS/MSC/MKK - LR*5.2*1033 - Latest VA Patch as of 2011
 . S PATCH=203       ; IHS/MSC/MKK - LR*5.2*1034 - Seq 152, June 2014
 . S SYSPATCH=$$PATCH^XPDUTL(MODULE_"*"_VERSION_"*"_PATCH)
 . S:SYSPATCH<1 SYSVER=0
 ;
 ; If PTR>0 but SYSVER<1, then Module is a stub.
 ; Full Module (with all of its routines) does not exist on the server.
 Q:SYSVER<1 "0^NOT ON THIS SERVER^"
 ;
 S NAME=$G(HEREYAGO("DILIST",1,1))
 ;
 Q PTR_"^"_NAME_"^"_SYSVER
 ;
 ; Get Health Record Number -- see LA7UID2 routine
GETHRCN(LRDFN,INHRCN) ; EP
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1033
 ; Check to make sure the HRCN is the correct one for the Ordering Location
 I +$G(INHRCN) D
 . NEW DFN,IENS,ORDHRCN,ORDLOC,OLINST
 . S IENS=LA76802_","_LA76801_","_LA768_","
 . S ORDLOC=+$$GET1^DIQ(68.02,IENS,94,"I")
 . S OLINST=+$$GET1^DIQ(44,ORDLOC,3,"I")
 . Q:OLINST<1
 . ;
 . S DFN=+$P($G(^LR(LRDFN,0)),"^",3)
 . S ORDHRCN=+$$HRN^AUPNPAT(DFN,OLINST)
 . Q:ORDHRCN<1
 . ;
 . S:ORDHRCN'=INHRCN INHRCN=ORDHRCN
 ; ----- END IHS/MSC/MKK - LR*5.2*1033
 ;
 Q:+$G(INHRCN) +$G(INHRCN)       ; If #, just return it
 ;
 ; If LRDFN not from VA Patient file, return passed variable.
 I $P($G(^LR(LRDFN,0)),"^",2)'=2 Q $G(INHRCN)
 ;
 ; New variables
 NEW ACCINST,DFN,HRCN,LRIDT,LRSS
 ;
 ; Get Patient file IEN
 S DFN=+$P($G(^LR(LRDFN,0)),"^",3)
 ;
 ; Use IHS DICTIONARIES function call
 S HRCN=$$HRN^AUPNPAT(DFN,DUZ(2))
 ;
 Q:+HRCN HRCN
 ;
 ; DUZ(2) did not return the HRCN.
 ; Use the Lab Data File's ACCESSIONING INSTITUTION field.
 ;
 ; Get Lab Data File Subscript
 S LRSS=$P($G(^LRO(68,+$G(LRAA),0)),"^",2)
 ;
 ; If LRSS still null, try LA7UID accession variable
 S:LRSS="" LRSS=$P($G(^LRO(68,+$G(LA768),0)),"^",2)
 ;
 ; Could not retrieve Subscript, so return passed variable.
 Q:$L(LRSS)<1 $G(INHRCN)
 ;
 ; Try to get LRIDT using LRAA,LRAD,LRAN variables
 S LRIDT=$P($G(^LRO(68,+$G(LRAA),1,+$G(LRAD),1,+$G(LRAN),3)),"^",5)
 ;
 ; If LRIDT still null, try LA7UID accession variables
 S:LRIDT="" LRIDT=$P($G(^LRO(68,+$G(LA768),1,+$G(LA76801),1,+$G(LA76802),3)),"^",5)
 ;
 ; If LRIDT still null, return passed variable.
 Q:$L(LRIDT)<1 $G(INHRCN)
 ;
 ; Get ACCessioning INSTitution
 S ACCINST=+$P($G(^LR(LRDFN,LRSS,+$G(LRIDT),0)),"^",14)
 ; 
 S HRCN=$$HRN^AUPNPAT(DFN,ACCINST)
 ;
 Q:+HRCN HRCN
 ;
 D ENTRYAUD^BLRUTIL("GETHRCN^BLRUTIL4 8.5")
 ;
 ; Could not retrieve HRCN, so return passed variable.
 Q $G(INHRCN)
 ;
 ; Generic "Find RPMS Module's Version and (perhaps) Patch number"
 ; The MODULE variable MUST be the PREFIX name from the PACKAGE file (9.4).
NEEDIT(MODULE,VERSION,PATCH)      ; EP
 NEW NAME                ; Name of PACKAGE
 NEW HEREYAGO,STR1,STR2  ; Scratch variables/arrays
 NEW SYSVER,SYSPATCH     ; System Version & System Patch variables
 ;
 D FIND^DIC(9.4,"","","",MODULE,"","C","","","HEREYAGO")
 S NAME=$G(HEREYAGO("DILIST",1,1))
 ;
 S SYSVER=$$VERSION^XPDUTL(MODULE)     ; Get the System's Version
 ;
 ; If System Version < Needed Version, write message and quit
 I SYSVER<VERSION D  Q
 . W !,?4,"Need "_NAME_" "_VERSION_" & "_NAME_" "_SYSVER_" found!",!!
 ;
 D OKAY^BLRKIDSU(NAME_" "_SYSVER_" found.")
 I VERSION<SYSVER Q     ; If Version needed is lower, skip Patch check
 ;
 I $G(PATCH)="" Q   ; If no Patch check, just exit
 ;
 D BMES^XPDUTL("     Need "_NAME_" "_VERSION_" Patch "_PATCH)
 S SYSPATCH=$$PATCH(MODULE_"*"_VERSION_"*"_PATCH)
 I SYSPATCH'=1 D  Q
 . S ERRARRAY(MODULE,NAME,VERSION)=$G(PATCH)
 . D MES^XPDUTL($J("",10)_" & Patch "_PATCH_" WAS NOT installed!")
 ;
 D OKAY^BLRKIDSU("& Patch "_PATCH_" found.",10)
 ;
 Q
 ;
PACKSTR(X) ; EP - Remove Extra Spaces from within string
 F  Q:X'["  "  S X=$P(X,"  ",1)_" "_$P(X,"  ",2,9999)
 Q X
 ;
 ; Code cloned from PATCH^XPDUTL
PATCH(X) ;EP - Return 1 if patch X was installed, X=aaaa*nn.nn*nnn
 Q:X'?1.4UN1"*"1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.6N 0
 N %,I,J
 S I=$O(^DIC(9.4,"C",$P(X,"*"),0)) Q:'I 0
 S J=$O(^DIC(9.4,I,22,"B",$P(X,"*",2),0)),X=$P(X,"*",3) Q:'J 0
 ;check if patch is just a number
 ;
 Q:$O(^DIC(9.4,I,22,J,"PAH","B",X,0)) 1
 ;
 S %=$O(^DIC(9.4,I,22,J,"PAH","B",X_" SEQ"))
 Q (X=+%)
 ;
CURLABP() ; EP - Return current Lab Patch
 NEW LABPATCH,PTR,STATUS,WOTPATCH
 ;
 S LABPATCH="<UNK>",STATUS=0,WOTPATCH="LR*5.2*1099"
 F  S WOTPATCH=$O(^XPD(9.7,"B",WOTPATCH),-1)  Q:WOTPATCH=""!($E(WOTPATCH,1,2)'="LR")!(STATUS=3)  D
 . S PTR="AAA"
 . F  S PTR=$O(^XPD(9.7,"B",WOTPATCH,PTR),-1)  Q:PTR=""!(STATUS=3)  D
 .. S STATUS=$P($G(^XPD(9.7,PTR,0)),"^",9)
 .. S:STATUS=3 LABPATCH=WOTPATCH
 ;
 Q LABPATCH
 ;
 ; The following moved from LRRP1 because LRRP1 became > 15000 bytes
 ; The following moved from LRRP1 because LRRP1 became > 15000 bytes
GETCOMPD() ; EP -- Get Completion Date for test
 NEW COMPD,D3,DATALN,LRAA,LRAD,LRAN,LRAS,LRAT,LRSS,LOG,STR,TESTIEN,TMPDT,VLABIEN
 ;
 D ENTRYAUD^BLRUTIL("GETCOMPD^BLRUTIL4 0.0")     ; IHS/MSC/MKK - LR*5.2*1034
 ;
 S LRAS=$P(LR0,"^",6)
 Q:'$L(LRAS) " "
 ;
 D ENTRYAUD^BLRUTIL("GETCOMPD^BLRUTIL4 1.0")     ; IHS/MSC/MKK - LR*5.2*1034
 ;
 ; If no Pointer to file 60, return null
 S TESTIEN=+$P($G(LRDATA),"^",1)
 Q:TESTIEN<1 " "
 ;
 D ENTRYAUD^BLRUTIL("GETCOMPD^BLRUTIL4 2.0")     ; IHS/MSC/MKK - LR*5.2*1034
 ;
 ; If test PENDING, there is no complete date -- return null
 S DATALN=+$P($P($G(^LAB(60,+$G(LRTSTS),0)),"^",5),";",2)
 I $$UP^XLFSTR($P($G(^LR(LRDFN,"CH",LRIDT,DATALN)),"^",1))["PEND" Q " "
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1033
 ; Try to get COMPLETE DATE from Lab Data File
 ; S COMPD=+$G(^LR(LRDFN,"CH",LRIDT,+$P(LRDATA,U,10),"IHS"))
 S COMPD=$G(^LR(LRDFN,"CH",LRIDT,+$P(LRDATA,U,10),"IHS"))  ; IHS/MSC/MKK - LR*5.2*1035
 ;
 D ENTRYAUD^BLRUTIL("GETCOMPD^BLRUTIL4 3.0")     ; IHS/MSC/MKK - LR*5.2*1035
 ;
 I +COMPD,COMPD["," S COMPD=$$HTFM^XLFDT(COMPD)  ; IHS/MSC/MKK - LR*5.2*1035
 ;
 D ENTRYAUD^BLRUTIL("GETCOMPD^BLRUTIL4 3.5")     ; IHS/MSC/MKK - LR*5.2*1035
 ;
 Q:+$G(COMPD)>2000000 $$FMTE^XLFDT(COMPD,"2MZ")
 ; ----- END IHS/MSC/MKK - LR*5.2*1033
 ;
 ; Break out Accession variables
 I $$GETACCCP^BLRUTIL3(LRAS,.LRAA,.LRAD,.LRAN)<1 Q " "
 ;
 ; If Accession Date (LRAD) year not the same as the collection date year, set LRAD = 0
 I $E(LRAD,1,3)'=$E($P($G(LRCDT),"."),1,3) S LRAD=0
 ;
 ; Try to get COMPLETE DATE for the test from Accession file
 S COMPD=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,4,TESTIEN,0)),"^",5)
 ;
 D ENTRYAUD^BLRUTIL("GETCOMPD^BLRUTIL4 4.0")     ; IHS/MSC/MKK - LR*5.2*1035
 ;
 Q:+$G(COMPD)>2000000 $$FMTE^XLFDT(COMPD,"2MZ")
 ;
 ; Completed date is null in Accession file; will try to get date
 ; from the BLRTXLOG file
 S (COMPD,VLABIEN,LOG)=0
 F  S LOG=$O(^BLRTXLOG("D",LRAS,LOG))  Q:LOG<1!(COMPD>0)  D
 . I $P($G(^BLRTXLOG(LOG,1)),"^",2)'="R" Q        ; Not RESULTED
 . I $P($G(^BLRTXLOG(LOG,0)),"^",6)'=TESTIEN Q    ; Wrong test
 . I $E(LRAD,1,3)'=$E($P($P($G(^BLRTXLOG(LOG,12)),"^"),"."),1,3) Q   ; Wrong year
 . ;
 . S COMPD=+$P($G(^BLRTXLOG(LOG,13)),"^",9)
 ;
 D ENTRYAUD^BLRUTIL("GETCOMPD^BLRUTIL4 5.0")     ; IHS/MSC/MKK - LR*5.2*1034
 ;
 Q:+$G(COMPD)>2000000 $$FMTE^XLFDT(COMPD,"2MZ")
 ;
 ; Still null. Try to find the test in the V LAB file and use test's
 ; Accession #, IEN, and Collection Date to match
 ;
 S VLABIEN=.9999999
 F  S VLABIEN=$O(^AUPNVLAB("ALR0",LRAS,VLABIEN))  Q:VLABIEN<1!(COMPD>0)  D
 . I $P($G(^AUPNVLAB(VLABIEN,0)),"^")'=TESTIEN Q      ; If TEST doesn't match, skip
 . ; Collection Date/Time match only down to minutes, not seconds
 . I $E($P($G(^AUPNVLAB(VLABIEN,12)),"^",1),1,12)'=$E($P(LR0,"^"),1,12) Q
 . ;
 . S COMPD=+$P($G(^AUPNVLAB(VLABIEN,12)),"^",12)      ; V LAB Result Date
 ;
 D ENTRYAUD^BLRUTIL("GETCOMPD^BLRUTIL4 6.0")     ; IHS/MSC/MKK - LR*5.2*1034
 ;
 Q:+$G(COMPD)>2000000 $$FMTE^XLFDT(COMPD,"2MZ")
 ;
 ; If still null, try the Lab Data File's DATE REPORT COMPLETED Date
 ; that's stored in the LR0 variable
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1034
 ; Don't use DATE REPORT COMPLETED because it's NOT at the test level.
 ; S COMPD=$P(LR0,"^",3)
 ; ----- END IHS/MSC/MKK - LR*5.2*1034
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1035
 ; The Lab Data File's DATE REPORT COMPLETED Date must be used
 ; otherwise tests on a panel will never have a completed date.
 S COMPD=$P(LR0,"^",3)
 ; ----- END IHS/MSC/MKK - LR*5.2*1035
 ;
 D ENTRYAUD^BLRUTIL("GETCOMPD^BLRUTIL4 7.0")     ; IHS/MSC/MKK - LR*5.2*1034
 ;
 Q:+$G(COMPD)>2000000 $$FMTE^XLFDT(COMPD,"2MZ")
 ;
 D ENTRYAUD^BLRUTIL("GETCOMPD^BLRUTIL4 8.0")     ; IHS/MSC/MKK - LR*5.2*1035
 ;
 ; All results dates checked and nothing found, so quit with null
 Q " "
 ;
 ;
ENTRYAUD(LABEL,TMPNODE) ; EP - Audit ^TMP global
 NEW ENTRYNUM,NOW,NOWTIM
 ;
 S NOW=$$NOW^XLFDT
 S ENTRYNUM=$G(^BLRENTRY)+1
 S $P(^BLRENTRY,U)=ENTRYNUM
 M ^BLRENTRY(DUZ,NOW,ENTRYNUM,LABEL_" ^TMP")=^TMP(TMPNODE)
 Q
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1033
 ; Given an UID, return the LRAA,LRAD,LRAN,LRDFN,LRSS,LRIDT variables
RETACCV(UID,LRAA,LRAD,LRAN,LRDFN,LRSS,LRIDT,LRAS) ; EP
 S (LRAA,LRAD,LRAN,LRAS,LRDFN,LRSS,LRIDT)=""  ; Initialize all the variables
 ;
 S X=$Q(^LRO(68,"C",UID,0))
 Q:$L(X)<1                               ; Skip if no accession data
 ;
 S LRAA=+$QS(X,4),LRAD=+$QS(X,5),LRAN=+$QS(X,6)
 S LRDFN=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,0))
 S LRSS=$$GET1^DIQ(68,LRAA,.09,"I")
 S LRIDT=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,3)),"^",5)
 ;
 S LRAS=$$GET1^DIQ(68.02,LRAN_","_LRAD_","_LRAA,"ACCESSION")
 Q
 ;
SETUCUM ; EP - Set value into IHS UCUM dictionary
 NEW FDA,IEN,UCUM,UDESC,UPRNITN
 ;
 W !!
 ;
 S UCUM=$$GETSTRNG("UCUM Definitiion")
 Q:UCUM="Q"
 ;
 S UDESC=$$GETSTRNG("UCUM Description")
 Q:UDESC="Q"
 ;
 S UPRINTN=$$GETSTRNG("UCUM Print Name")
 Q:UPRINTN="Q"
 ;
 S FDA(90475.3,"+1,",.01)=UCUM
 S FDA(90475.3,"+1,",1)=UDESC
 S FDA(90475.3,"+1,",3)=UPRINTN
 ;
 D UPDATE^DIE("S","FDA",,"ERRS")
 ;
 I $D(ERRS)  D  Q
 . W !,?4,"Error adding UCUM.  Error Message Follows:"
 . D ARRYDUMP("ERRS")
 . D PRESSKEY^BLRGMENU(9)
 ;
 S IEN=$$FIND1^DIC(90475.3,,,UCUM)
 K FDA,ERRS
 S FDA(90475.32,"+1,"_IEN_",",.01)=UPRINTN
 D UPDATE^DIE("S","FDA",,"ERRS")
 ;
 I $D(ERRS)  D  Q
 . W !,?4,"Error adding ",UPRINTN," as a SYNONYM.  Error Message Follows:"
 . D ARRYDUMP("ERRS")
 . D PRESSKEY^BLRGMENU(9)
 ;
 W !!,?4,"Succesfully added UCUM at IEN:",IEN,!
 D PRESSKEY^BLRGMENU(9)
 ;
 Q
 ;
GETSTRNG(STR) ; EP
 D ^XBFMK
 S DIR(0)="FO"
 S DIR("A")=STR
 D ^DIR
 I $G(X)=""!(+$G(DIRUT)) D  Q "Q"
 . W !!,?4,"No/Invalid/Quit Entry.  Routine Ends."
 . D PRESSKEY^BLRGMENU(9)
 ;
 Q $G(X)
 ;
 ; "Dump" an array
ARRYDUMP(ARRY) ; EP
 NEW COL,MESSAGE,STR1,TOOWIDE,WIDTH
 ;
 S STR1=$Q(@ARRY@(""))
 S MESSAGE=@STR1
 ;
 W !,?5,ARRY,!
 W ?10,STR1,"="
 S COL=$X
 D ARRYDMP2(COL,MESSAGE)
 ;
 F  S STR1=$Q(@STR1)  Q:STR1=""  D
 . S MESSAGE=@STR1
 . W ?10,STR1,"="
 . S COL=$X
 . D ARRYDMP2(COL,MESSAGE)
 Q
 ;
ARRYDMP2(COL,MESSAGE) ; EP - Output string.  If too wide, wrap it.
 S WIDTH=(IOM-COL-1)
 S TOOWIDE=$S((COL+$L(MESSAGE))<IOM:0,1:1)
 ;
 I 'TOOWIDE W MESSAGE,!  Q
 ;
 I TOOWIDE D LINEWRAP^BLRGMENU(COL,MESSAGE,WIDTH)  W !
 Q
 ;
NOPCEINS ; EP - NO PCE INStalled notice
 W !,?4,"VA Patient Encounter module does NOT exist on this sytem."
 D PRESSKEY^BLRGMENU
 Q
 ; ----- END IHS/MSC/MKK - LR*5.2*1033
