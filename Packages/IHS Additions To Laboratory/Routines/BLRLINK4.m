BLRLINK4 ; IHS/MSC/MKK - CONT. OF BLR - IHS LABORATORY VISIT CREATION ; 02-Nov-2015 13:44 ; MKK
 ;;5.2;IHS LABORATORY;**1031,1032,1033,1034,1037**;NOV 01, 1997;Build 4
 ;;
 ;; Parts of original BLRLINK3 moved to here due to BLRLINK3 becoming too large.
 ;;
 ; IF and ONLY IF the transaction is tied to an incoming HL7 message
 ; get Reference Ranges & Units from HL7 message
HL7REFLR(REFLABF) ; EP 
 NEW ABNFLAG,REFHIGH,REFLOW,UNITS,WOT
 S WOT=$$CHKINHL7(BLRLOGDA,.REFLABF)
 Q:WOT<1
 ;
 S:$G(UNITS)'="" APCDALVR("APCDTUNI")=UNITS
 S:$G(REFLOW)'="" APCDALVR("APCDTRFL")=REFLOW
 S:$G(REFHIGH)'="" APCDALVR("APCDTRFH")=REFHIGH
 D ENTRYAUD^BLRUTIL("HL7REFLR^BLRLINK4 9.0","APCDALVR")
 Q
 ;
CHKINHL7(BLRLOGDA,REFLABF) ; EP
 NEW DNIEN,DNDESC,F60IEN,HL7TEST,LRAA,LRAD,LRAN,LRAS,STR,UID
 ;
 Q:+$G(BLRLOGDA)<1 0                               ; Skip if no Txn #
 ;
 S F60IEN=+$P($G(^BLRTXLOG(BLRLOGDA,0)),"^",6)     ; File 60 IEN
 ;
 S LRAS=$P($G(^BLRTXLOG(BLRLOGDA,12)),"^",2)       ; Accession Number
 D GETACCCP^BLRUTIL3(LRAS,.LRAA,.LRAD,.LRAN)
 Q:LRAA<1!(LRAD<1)!(LRAN<1) 0                      ; Skip if no Accession
 ;
 D REFLAB68^BLRLINKU                               ; Check on ^XTMP("BLRLINKU")
 Q:$D(^XTMP("BLRLINKU",+$G(DUZ(2)),LRAA))<1 0      ; Skip if not a Ref Lab Accession
 ;
 S REFLABF=1                                       ; Set the Ref Lab Flag
 ;
 S UID=+$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,.3)),"^")
 Q:UID<1 0                                         ; Skip if no UID
 ;
 Q:$$GETINTHU^BLRLINKU(UID)<1 0                    ; Reference Ranges in File 4001 (UNIVERSAL INTERFACE)
 ;
 S STR=$G(^TMP("BLR",$J,UID,F60IEN))
 Q:$L(STR)<1 0                                     ; Skip if no data found
 ;
 S ABNFLAG=$P(STR,"^",2)
 S REFLOW=$P(STR,"^",3)
 S REFHIGH=$P(STR,"^",4)
 S UNITS=$P(STR,"^",5)
 ;
 S:$L(ABNFLAG) APCDALVR("APCDTABN")=$G(ABNFLAG)
 S:$L(UNITS) APCDALVR("APCDTUNI")=$G(UNITS)
 S:$L(REFLOW) APCDALVR("APCDTRFL")=$G(REFLOW)
 S:$L(REFHIGH) APCDALVR("APCDTRFH")=$G(REFHIGH)
 ;
 D ENTRYAUD^BLRUTIL("CHKINHL7^BLRLINK4 9.0","APCDALVR")
 Q 1
 ;
 ;
CHSETCOD ; EP - Check to see if SET OF CODES & "Change" Result, if Necessary
 NEW CHANGED,DATANAME,F60PTR,LRPIECE,LRSET,Q2
 ;
 S F60PTR=+$TR($G(APCDALVR("APCDTLAB")),"`")
 S DATANAME=$G(^LAB(60,F60PTR,.2))
 Q:DATANAME<1                                 ; Skip if no Dataname
  ;
 Q:$P($G(^DD(63.04,DATANAME,0)),"^",2)'="S"   ; Skip if NOT Set of Codes
 ;
 S Q2=$P(^DD(63.04,DATANAME,0),U,3)
 S CHANGED=0
 F LRPIECE=1:1 S LRSET=$P(Q2,";",LRPIECE)  Q:LRSET'[":"!(CHANGED)  D
 . Q:$P(LRSET,":")'=BLRRES     ; Quit if NOT code
 . ;
 . S BLRRES=$P(LRSET,":",2)
 . S CHANGED=1
 ;
 Q
 ;
 ; Double check Ref Ranges & Units.  If null, reset -- if possible.
 ; Need to do this because POC tests' Ref Ranges & Units variables are cleared out somewhere.
 ; Also, reset Lab POV if necessary.
CHKPCCRU ; EP
 NEW PCCLOW,PCCHIGH,PCCUNITS
 NEW ABNFLAG,CPTCODE,CRITLOW,CRITHIGH,LABPOV,REFLOW,REFHIGH,STR,UNITS
 NEW LABTIEN,IHSLCPTP,IHSLCPT
 NEW LRAA,LRAD,LRAN,LRASUB
 ;
 S X=$$GETACCCP^BLRUTIL3(BLRACC,.LRAA,.LRAD,.LRAN)      ; Get Accession variables
 Q:X<1     ; Skip if cannot "break out" Accession variables
 ;
 S LRASUB=$P($G(^LRO(68,LRAA,0)),"^",2)  ; Get Accession's Lab Data Subscript
 Q:LRASUB'="CH"                          ; Only "CH" subscripted tests will have Ref Ranges
 ;
 S PCCLOW=$G(APCDALVR("APCDTRFL"))
 S PCCHIGH=$G(APCDALVR("APCDTRFH"))
 S PCCUNITS=$G(APCDALVR("APCDTUNI"))
 ;
 ; If Ref Low, Ref High Ranges & Units already filled out, just return
 Q:$L(PCCLOW)&($L(PCCHIGH))&($L(PCCUNITS))
 ;
 ; If the test is part of a panel being processed, the BLRTLAB variable
 ; has the ATOMIC test's IEN.  If the test is not part of a panel, the
 ; BLRTLAB variable doesn't exist.
 S LABTIEN=$S(+$G(BLRTLAB):BLRTLAB,1:BLRTEST)
 ;
 S STR=$G(^LAB(60,+$G(LABTIEN),1,+$G(BLRSITE),0))     ; Ref Ranges & Units from File 60
 ;
 D ENTRYAUD^BLRUTIL("CHKPCCRU^BLRLINK4 4.0","APCDALVR")
 ;
 Q:$L($TR(STR,"^"))<1       ; If no Ref Ranges nor units, skip
 ;
 S REFLOW=$P(STR,"^",2)
 S REFHIGH=$P(STR,"^",3)
 S CRITLOW=$P(STR,"^",4)
 S CRITHIGH=$P(STR,"^",5)
 S UNITS=$P(STR,"^",7)
 ;
 ; Reset PCC array if and only if PCC Ref Ranges or Units "empty".  Reset ^BLRTXLOG entries, if possible
 I '$L(PCCLOW)&($L(REFLOW)) S APCDALVR("APCDTRFL")=REFLOW  S:+$G(BLRIEN) $P(^BLRTXLOG(BLRIEN,20),"^",8)=REFLOW
 I '$L(PCCHIGH)&($L(REFHIGH)) S APCDALVR("APCDTRFH")=REFHIGH  S:+$G(BLRIEN) $P(^BLRTXLOG(BLRIEN,20),"^",9)=REFHIGH
 I '$L(PCCUNITS)&($L(UNITS)) S APCDALVR("APCDTUNI")=UNITS  S:+$G(BLRIEN) $P(^BLRTXLOG(BLRIEN,20),"^",3)=UNITS
 ;
 ; If LAB Point Of View has ` and IS NOT an ICD code, just make it a string.
 S LABPOV=$G(APCDALVR("APCDTLPV"))
 I LABPOV["`" D
 . S LABPOV=$P(LABPOV,"`",2)
 . ; I $$ICDDX^ICDCODE(LABPOV)<1 S APCDALVR("APCDTLPV")=LABPOV
 . I $$ICDDX^ICDEX(LABPOV)<1 S APCDALVR("APCDTLPV")=LABPOV      ; IHS/MSC/MKK - LR*5.2*1034
 ;
 ; The following have to be rechecked due to POC tests
 ;
 ; NO CPT code in APCDALVR array
 D:$L($G(APCDALVR("APCDTCPT")))<1 APCDPCCR
 ;
 D ENTRYAUD^BLRUTIL("CHKPCCRU^BLRLINK4 9.0","APCDALVR")
 Q
 ;
APCDPCCR ; EP - Reset CPT nodes, if Possible.
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1033
 ;       Do not try to reset the CPT codes because it will "unbundle"
 ;       all the Atomic tests that should be under one CPT code
 ;       for a Cosmic test.  This subroutine was a mistake.
 Q
 ; ----- END IHS/MSC/MKK - LR*5.2*1033
 ;
 ;
 I $L($G(BLRCPT)),$L($G(BLRCPTST)) D  Q   ; Reset from BLR variables, if possible
 . S APCDALVR("APCDTCPS")=BLRCPTST
 . S APCDALVR("APCDTCPT")="`"_BLRCPT
 ;
 I $L($G(BLRCPT))  S APCDALVR("APCDTCPT")="`"_BLRCPT  Q  ; If only BLRCPT, reset
 ;
 ; At this point, use Lab Test IEN, if possible
 NEW BLRCPT,BLRCPTST,CNT,IHSCPTLP,STR1,STR2
 ;
 S IHSCPTLP=+$O(^BLRCPT("C",+$G(LABTIEN),0))
 I IHSCPTLP D
 . S STR1=$G(^BLRCPT(IHSCPTLP,11,+$O(^BLRCPT(IHSCPTLP,11,0)),0))
 . S STR2=$P(STR1,"^",2)
 . S BLRCPTST=""
 . S BLRCPT="`"_IHSCPTLP
 . I $L(STR2) D
 .. F CNT=1:1:5 S BLRCPTST=BLRCPTST_$P(STR2,"^",CNT)_"|"
 . I $L(STR2)<1 S BLRCPTST=+STR1_"|||||"
 . ;
 . S APCDALVR("APCDTCPS")=BLRCPTST
 . S APCDALVR("APCDTCPT")=BLRCPT
 ;
 Q:$L($G(APCDALVR("APCDTCPT")))
 ;
 ; Still empty, so KILL off the nodes
 K APCDALVR("APCDTCPS")
 K APCDALVR("APCDTCPT")
 Q
 ;
CHKREFA ; EP - Make sure Reference Ranges are not formulas
 NEW OKAYFLAG,PCCLOW,PCCHIGH,SHOULDBE,TESTIT,X
 ;
 S PCCLOW=$G(APCDALVR("APCDTRFL"))
 S PCCHIGH=$G(APCDALVR("APCDTRFH"))
 ;
 Q:$G(PCCLOW)'["$S"&($G(PCCHIGH)'["$S")
 ;
 D ENTRYAUD^BLRUTIL("CHKREFA^BLRLINK4 0.0")
 ;
 S OKAYFLAG=0
 ;
 I $G(PCCLOW)["$S" D
 . S X=PCCLOW
 . D ^DIM          ; Make sure M code in Reference Value is valid
 . Q:$D(X)
 . ;
 . S SHOULDBE="SHOULDBE="_PCCLOW
 . S @SHOULDBE
 . Q:$L(SHOULDBE)<1
 . ;
 . S APCDALVR("APCDTRFL")=SHOULDBE
 . S:+$G(BLRIEN) $P(^BLRTXLOG(BLRIEN,20),"^",8)=SHOULDBE
 ;
 I $G(PCCHIGH)["$S" D
 . S X=PCCHIGH
 . D ^DIM
 . Q:$D(X)
 . ;
 . S SHOULDBE="SHOULDBE="_PCCHIGH
 . S @SHOULDBE
 . Q:$L(SHOULDBE)<1
 . ;
 . S APCDALVR("APCDTRFH")=SHOULDBE
 . S:+$G(BLRIEN) $P(^BLRTXLOG(BLRIEN,20),"^",9)=SHOULDBE
 ;
 D ENTRYAUD^BLRUTIL("CHKREFA^BLRLINK4 8.8")
 ;
 Q
 ;
LOTZERO(ARRAY)  ; EP - Leading and/Or Trailing ZERO(s) for PCC
 NEW (ARRAY,DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D ENTRYAUD^BLRUTIL("LOTZERO^BLRLINK4 0.0","ARRAY")
 ;
 S L60IEN=$P($G(ARRAY("APCDTLAB")),"`",2)
 Q:+L60IEN<1  ; IHS/MSC/MKK - LR*5.2*1037
 ;
 S DN=+$G(^LAB(60,L60IEN,.2))
 Q:+$G(DN)<1                        ; Skip if no Data Name number
 ;
 S STR=$P($G(^DD(63.04,DN,0)),"^",5)
 Q:$L(STR)<1                        ; Skip if no numeric defintiion
 ;
 ; S DP=+$P($P(STR,",",3),$C(34))
 S DP=+$P($P(STR,"Q9=",2),",",3)    ; IHS/MSC/MKK - LR*5.2*1032 -- Need to take into account INPUT TRANSFORM code
 Q:DP<1                             ; Skip if no Decimal Defintion
 ;
 S RESULT=$G(ARRAY("APCDTRES"))
 ;
 S SYMBOL="",ORIGRSLT=RESULT
 F  Q:$E(RESULT)="."!($E(RESULT)?1N)!(RESULT="")  D       ; Adjust if ANY Non-Numeric is at the beginning of RESULT
 . S SYMBOL=SYMBOL_$E(RESULT)
 . S RESULT=$E(RESULT,2,$L(RESULT))
 ;
 S:$E(RESULT)="." RESULT="0"_RESULT      ; Leading Zero Fix
 ;
 I $E(RESULT)'?1N  S RESULT=ORIGRSLT  Q  ; Skip if RESULT has no numeric part
 ;
 S RESULT=$TR($FN(RESULT,"P",DP)," ")
 ;
 S:$L($G(SYMBOL)) RESULT=SYMBOL_RESULT   ; Restore "symbol", if necessary
 ;
 S ARRAY("APCDTRES")=RESULT
 ;
 S PCCLOW=$G(ARRAY("APCDTRFL"))
 S PCCHIGH=$G(ARRAY("APCDTRFH"))
 ;
 I $L($G(PCCLOW)) D
 . S:$E(PCCLOW,1)="." PCCLOW="0"_PCCLOW
 . S PCCLOW=$TR($FN(PCCLOW,"P",DP)," ")
 . S ARRAY("APCDTRFL")=PCCLOW
 ;
 I $L($G(PCCHIGH)) D
 . S:$E(PCCHIGH,1)="." PCCHIGH="0"_PCCHIGH
 . S PCCHIGH=$TR($FN(PCCHIGH,"P",DP)," ")
 . S ARRAY("APCDTRFH")=PCCHIGH
 ;
 Q
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1033
RESETPOV ; EP -- Reset "Provider Narrative"
 D ENTRYAUD^BLRUTIL("RESETPOV^BLRLINK4 0.0","APCDALVR")
 ;
 ; NEW FDA,ICD,ICDCODE,IENS,LRORD,LRORDT,LRSP,LRTN,LRTST,ORDNUM,POV,POVICD,PROVNAR,SNOMED,TESTIEN
 NEW (APCDALVR,BLRLOGDA,DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,X,XPARSYS,XQXFLG)   ; IHS/MSC/MKK - LR*5.2*1034
 ;
 D ENTRYAUD^BLRUTIL("RESETPOV^BLRLINK4 0.1","APCDALVR")
 ;
 ; S ORDNUM=+$G(APCDALVR("APCDTORD"))
 ; Q:ORDNUM<1          ; If no Order Number, skip
 ;
 ; S TESTIEN=+$P($G(APCDALVR("APCDTLAB")),"`",2)
 ; Q:TESTIEN<1         ; If no Lab Test IEN, skip
 ;
 ; S LRODT=+$O(^LRO(69,"C",ORDNUM,0))
 ; S LRSP=+$O(^LRO(69,"C",ORDNUM,LRODT,0))
 ; S LRTN=+$O(^LRO(69,LRODT,1,LRSP,2,"B",TESTIEN,0))
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1034
 S ORDNUM=+$$GET1^DIQ(9009022,BLRLOGDA,"ORDER NUMBER")
 Q:ORDNUM<1
 ;
 S TESTIEN=+$$GET1^DIQ(9009022,BLRLOGDA,"PANEL/TEST POINTER","I")
 Q:TESTIEN<1
 ;
 ; Because there can be multiple tests on an order, find entry
 ; in file 69 that matches the TESTIEN.
 S (FOUNDIT,LRODT)=0
 S LRODT=$O(^LRO(69,"C",ORDNUM,LRODT))  Q:LRODT<1!(FOUNDIT)  D
 . S LRSP=0
 . F  S LRSP=$O(^LRO(69,"C",ORDNUM,LRODT,LRSP))  Q:LRSP<1!(FOUNDIT)  D
 .. S LROT=0
 .. F  S LROT=$O(^LRO(69,LRODT,1,LRSP,2,LROT))  Q:LROT<1!(FOUNDIT)  D
 ... S:+$G(^LRO(69,LRODT,1,LRSP,2,LROT,0))=TESTIEN FOUNDIT=FOUNDIT+1,FOUNDIT("LRSP")=LRSP,FOUNDIT("LRTN")=LROT
 S LRSP=+$G(FOUNDIT("LRSP")),LRTN=+$G(FOUNDIT("LRTN"))
 ;
 Q:LRTN<1            ; If no entry in Lab Order Entry file, skip
 ;
 ; S ICD=+$O(^LRO(69,LRODT,1,LRSP,2,LRTN,2,0))
 ; S ICDPTR=+$P($G(^LRO(69,LRODT,1,LRSP,2,LRTN,2,ICD,0)),"^")
 ; S ICDSTR=$$ICDDX^ICDCODE(ICDPTR)         ; Currently, ICD Description & Code
 ; S ICDCODE=$P(ICDSTR,"^",2),ICDDESC=$P(ICDSTR,"^",4)
 ;
 ; S ICDCODE=$$UP^XLFSTR($P(ICDSTR,"^",2)),ICDDESC=$P(ICDSTR,"^",4)
 ;
 ; S IENS=LRTN_","_LRSP_","_LRODT
 ; S PROVNAR=$$GET1^DIQ(69.03,IENS,9999999.1)
 ; S SNOMED=$$GET1^DIQ(69.03,IENS,9999999.2)
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1034
 S IEN=LRTN_","_LRSP_","_LRODT_","
 S PROVNAR=$$GET1^DIQ(69.03,IEN,"PROVIDER NARRATIVE")
 S SNOMED=$$GET1^DIQ(69.03,IEN,"SNOMED")
 ; S ICDCODE=$$GET1^DIQ(69.05,1_","_IEN,"ICD-9 CODES")
 ; S ICDPTR=+$P($G(^LRO(69,LRODT,1,LRSP,2,LRTN,2,ICD,0)),"^")
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1034
 S ICDCODE=$$GET1^DIQ(69.05,1_","_IEN,"ICD CODES")
 S ICDIEN=$$GET1^DIQ(69.05,1_","_IEN,"ICD CODES","I")
 S ICDDESC=$$VLTD^ICDEX(ICDIEN)
 S:$L(ICDDESC)<1 ICDDESC=$$VLTP^ICDEX(ICDIEN)
 ; ----- END IHS/MSC/MKK - LR*5.2*1034
 ;
 D ENTRYAUD^BLRUTIL("  RESETPOV^BLRLINK4 5.0")
 ;
 ; Skip if no data in the Lab Order Entry file
 I $L(PROVNAR)<1,$L(SNOMED)<1,$L(ICDCODE)<1 Q
 ;
 S:$L(PROVNAR) APCDALVR("APCDTLPV")=PROVNAR
 D:$L(SNOMED) FMSNOMED
 ; S:$L(ICDCODE)&(ICDCODE'["INVALID") APCDALVR("APCDTICD")=ICDCODE
 ; S:$L(ICDCODE)&(ICDCODE'["INVALID") APCDALVR("APCDTICD")="`"_ICDPTR
 ;
 S:ICDIEN APCDALVR("APCDTICD")="`"_ICDIEN   ; IHS/MSC/MKK - LR*5.2*1034 - Use ICD Code's IEN to store into PCC
 ;
 D ENTRYAUD^BLRUTIL("  RESETPOV^BLRLINK4 5.5")
 ;
 K:$G(APCDALVR("APCDTICD"))["INVALID" APCDALVR("APCDTICD")
 ;
 ; Reset ^BLRTXLOG, if necessary. Skip if No BLRLOGDA variable.
 I +$G(BLRLOGDA) D
 . NEW BLRPROVN,BLRSNOM,BLRICD,BLRPROVN,BLRSNOM,BLRICD
 . S BLRPROVN=$$GET1^DIQ(9009022,BLRLOGDA_",",1601)
 . S BLRSNOM=$$GET1^DIQ(9009022,BLRLOGDA_",",1602)
 . S BLRICD=$$GET1^DIQ(9009022,BLRLOGDA_",",1603)
 . ;
 . I BLRPROVN=PROVNAR,BLRSNOM=SNOMED,BLRICD=ICDCODE Q
 . ;
 . K FDA,ERRS
 . S:$L(PROVNAR)&(BLRPROVN'=PROVNAR) FDA(9009022,BLRLOGDA_",",1601)=PROVNAR
 . S:$L(SNOMED)&(BLRSNOM'=SNOMED) FDA(9009022,BLRLOGDA_",",1602)=SNOMED
 . ; S:$L(ICDCODE)&(BLRICD'=ICDCODE) FDA(9009022,BLRLOGDA_",",1603)=ICDCODE
 . ;
 . S:$L(ICDCODE)&(ICDCODE'["INVALID")&(BLRICD'=ICDCODE) FDA(9009022,BLRLOGDA_",",1603)=ICDCODE
 . ;
 . Q:$D(FDA)<1
 . ;
 . D UPDATE^DIE("S","FDA",,"ERRS")
 ;
 D ENTRYAUD^BLRUTIL("    RESETPOV^BLRLINK4 9.0","APCDALVR","ERRS","VERRS")
 Q
 ;
FMSNOMED ; EP - SNOMED codes to be done via FileMan
 NEW IEN,VLABFILE,VLABIEN
 ;
 S VLABFILE=+$$GET1^DIQ(9009022,BLRLOGDA_",",104,"I")
 Q:VLABFILE<1
 ;
 S VLABIEN=+$$GET1^DIQ(9009022,BLRLOGDA_",",105)
 Q:VLABIEN<1
 ;
 S FDA(VLABFILE_"26","?+1,"_VLABIEN_",",.01)=SNOMED
 ;
 D UPDATE^DIE("ES","FDA",,"VERRS")
 Q
 ;
 ; If SNOMED is in 9009029 & missing in the PCC file, then fix it.  Done for BYPASS entries.
MSNOMED ; EP - Called from BLRLINK3
 NEW ERRS,FDA,SNOMED,VFILENUM,VFILEIEN
 ;
 ; Note -- When this routine is called, the V File data are not in the ^BLRTXLOG global yet, but are in the APCDALVR array.
 ;
 ; Skip if there is a PCC error
 Q:+$G(APCDALVR("APCDAFLG"))>0
 ;
 ; Get V File #
 S VFILENUM=+$G(APCDALVR("APCDAVF"))
 Q:VFILENUM<1
 ;
 ; Get V File IEN
 S VFILEIEN=+$G(APCDALVR("APCDADFN"))
 Q:VFILEIEN<1
 ;
 ; If SNOMED already in V File, skip
 S SNOMED=$$GET1^DIQ(VFILENUM,VFILEIEN,1602)
 Q:$L(SNOMED)
 ;
 ; Get SNOMED code
 ; S SNOMED=+$$GET1^DIQ(9009022,BLRLOGDA_",",1602)
 S SNOMED=$$GET1^DIQ(9009022,BLRLOGDA_",",1602)  ; IHS/MSC/MKK - LR*5.2*1037
 Q:$L(SNOMED)<1
 ;
 S FDA(VFILENUM_"26","?+1,"_VFILEIEN_",",.01)=SNOMED
 ;
 D UPDATE^DIE("S","FDA",,"ERRS")
 ;
 Q
 ;
 ; ----- END IHS/MSC/MKK - LR*5.2*1033
