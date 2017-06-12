BLRPOC2 ;IHS/MSC/PLS - EHR POC Component support, part 2 ; 17-Oct-2014 09:22 ; MKK
 ;;5.2;IHS LABORATORY;**1029,1031,1033,1034**;NOV 01, 1997;Build 88
 ;
 ; IHS/OIT/MKK
 ;      Entries from BLRPOC were moved to this routine due to the BLRPOC routine
 ;      becoming too large (i.e., violated SAC guidelines).
 ;
 ; ==============================================================
 ; 
 ; ARY("CD")=Collection Date/Time FM Format
 ; ARY("ORDTST")=Test IEN^Test Name
 ; ARY("TST",n)=Test IEN^Test Name
 ; ARY("CM")=Collection Method IEN^Collection Method Name
 ; ARY("COL")=Collection Sample IEN^Collection Sample Name
 ; ARY("LOC")=Hospital Location (File 44) IEN^Hospital Location Name
 ; ARY("PRV")=Provider (File 200) IEN^Provider Name
 ; ARY("NOO")=Nature of Order IEN^Nature of Order Name
 ; ARY("URG")=Urgency IEN^Urgency Name
 ; ARY("SYMP")=Symptom Text^Indication code
 ; ARY("RES",n)=Result^Result Flag
 ; ARY("CMT",n)=Array of comment text
 ; SAVE(DATA,DFN,ARY) ; EP - original SAVE label from BLRPOC
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1033
 ;       The ARY("SYMP") has been changed to:
 ;           ARY("SYMP")=SNOMED Descriptive Text^ICD Indication code^SNOMED Concept ID
 ; ----- END IHS/MSC/MKK - LR*5.2*1033
 ;
SAVER ; EP - 
 NEW %,BLRDH,BLRGUI,BLRLOG,BLRPCC,BLRQSITE,BLRSTOP,BLRSTOP,BPCACC,BPCCOM
 NEW LRAA,LRACC,LRAHEAD,LRAN,LRARY,LRBLOOD,LRCCOM,LRCDT,LRCMT,LRCOM,LRDEFSP
 NEW LRDFN,LRDPF,LRDTO,LREAL,LREND,LRFDEFSP,LRFLOC,LRFNODE,LRGCOM,LRI,LRIDIV
 NEW LRIDT,LRINI,LRJ,LRLABKY,LRLBLBP,LRLCSIEN,LRLLOC,LRLWC,LRNATURE,LRNG2
 NEW LRNG3,LRNG4,LRNG5,LRNT,LRODT,LROLDIV,LROLLOC,LRORDR,LRORDTIM,LRORDTST
 NEW LROT,LROUTINE,LRPARAM,LRPCEVSO,LRPLASMA,LRPOVREQ,LRPR,LRPRAC,LRSAMP
 NEW LRSB,LRSERUM,LRSN,LRSPEC,LRSPEC0,LRSS,LRTFLG,LRTIEN,LRTRES,LRTSEQ
 NEW LRTST,LRUNKNOW,LRURG,LRURINE,LRUSI,LRVF,LRVF,LRVIDO,LRVIDOF,LRWLC,LRWLO
 NEW PNLINPNL,PNM,RES,RET,XQY,XQY0,ZTQUEUED
 ;
 D ENTRYAUD^BLRUTIL("SAVER^BLRPOC2 0.0","ARY")    ; IHS/MSC/MKK - LR*5.2*1033
 ;
 S LRNOLABL="" ; SUPPRESS LABEL PRINTING
 I $G(^LAB(69.9,1,"RO"))=""  S RES="0^Rollover has never been run. Please contact National Lab User Support." G END
 I $P($G(^LAB(69.9,1,"RO")),U,2) S RES="0^Accessioning is currently running, please wait a few minutes and try again." G END
 S RES=0,ZTQUEUED=1,BLRGUI=1,BPCACC=""
 S XQY=$O(^DIC(19,"B","CIAV VUECENTRIC",""))
 S XQY0=$G(^DIC(19,XQY,0))
 S ARY("CM")="WC"
 S LRORDTST=+$G(ARY("ORDTST"))
 D ^LRPARAM
 S $P(LRPARAM,U,4)=0  ; Force to NO LABELS
 S LROUTINE=$P(^LAB(69.9,1,3),"^",2)
 ;
 S LRSAMP=+$G(ARY("COL"))
 S LRSPEC=+$P(^LAB(62,LRSAMP,0),U,2)
 S LRDFN=$$GETPAT^BLRPOC(DFN)
 ;
 D ENTRYAUD^BLRUTIL("SAVER^BLRPOC2 2.0")    ; IHS/MSC/MKK - LR*5.2*1034
 ;
 I 'LRDFN D  G END
 . S RES="0^Failed to find patient in Lab Data File"
 ;
 S LRDPF=2  ; indicates LRDFN represents a patient
 S PNM=$$GET1^DIQ(2,DFN,.01)
 S LROT(LRSAMP,LRSPEC,1)=+$G(ARY("ORDTST"))
 S LRTST=+$G(ARY("ORDTST"))_U_+$G(ARY("URG"))
 S LRLWC="WC"
 S LRPRAC=+$G(ARY("PRV"))
 S LROLLOC=+$G(ARY("LOC"))
 S LRLLOC=$$GET1^DIQ(44,+LROLLOC,1)
 S LRCDT=$G(ARY("CD"))_"^" ; note, this has 2 pieces due to the way the data is filed in ^LRORDST
 S LRODT=$P($P(LRCDT,"^"),".")    ; IHS/OIT/MKK - LR*5.2*1029 - Fix if ARY("CD") = just date (no seconds)
 S LRORDTIM=$P(+LRCDT,".",2)
 ; S LRNATURE=$G(ARY("NOO"))
 S LRNATURE=$G(ARY("NOO"))_"^99ORN"    ; BEGIN IHS/MSC/BF - IHS Lab Patch 1026
 S LRURG=+$G(ARY("URG"))
 S BPCCOM=""
 S LRORDR=""
 ;S LRORDR="P" ; this will make the software error, due to the ,1) node not being defined.
 D NOW^%DTC S LRNT=%
 ;
 D ENTRYAUD^BLRUTIL("SAVER^BLRPOC2 5.0")    ; IHS/MSC/MKK - LR*5.2*1034
 ;
 D ORDER^LROW2
 D ^LRORDST  ; Create order and accession
 N LRSPEC,LRSAMP
 D ^LRWLST   ; Accession setup
 S LRTST=+$G(ARY("ORDTST"))
 ;
 ; Using the test data passed in, build the data that will be placed into the LRSB array.
 S LRTSEQ=0 F  S LRTSEQ=$O(ARY("TST",LRTSEQ)) Q:'LRTSEQ  D
 .; Get the individual test ien
 .S LRTIEN=+$G(ARY("TST",LRTSEQ)) Q:'LRTIEN
 .S LRTRES=$P($G(ARY("RES",LRTSEQ)),"^")
 .S LRTFLG=$P($G(ARY("RES",LRTSEQ)),"^",2)
 .; Get location data from file 60, field 5, then the second piece for the subscript in the data array.
 .S LRFLOC=$$GET1^DIQ(60,LRTIEN,5,"E")
 .S LRFNODE=$P(LRFLOC,";",2)
 .S LRDEFSP=$$GET1^DIQ(62,+$G(ARY("COL")),2,"I")
 .; Now use the pointer to the TOPOGRAPHY FIELD file to locate the appropriate SITE/SPECIMEN from the LABORATORY TEST file (#60)
 .S LRSPEC0=$G(^LAB(60,LRTIEN,1,LRDEFSP,0)),LRSPEC0=$TR(LRSPEC0,"^","!")
 .S LRNG4=$P(LRSPEC0,"!",4),LRNG4=$$REFRES^BLRPOC(LRNG4),$P(LRSPEC0,"!",4)=LRNG4
 .S LRNG5=$P(LRSPEC0,"!",5),LRNG5=$$REFRES^BLRPOC(LRNG5),$P(LRSPEC0,"!",5)=LRNG5
 .S LRNG2=$P(LRSPEC0,"!",2),LRNG2=$$REFRES^BLRPOC(LRNG2),$P(LRSPEC0,"!",2)=LRNG2
 .S LRNG3=$P(LRSPEC0,"!",3),LRNG3=$$REFRES^BLRPOC(LRNG3),$P(LRSPEC0,"!",3)=LRNG3
 . ;
 . D REVAL(LRTRES,.LRTFLG)         ; IHS/MSC/MKK - LR*5.2*1031
 . ;
 .S UCUM=$P(LRSPEC0,"!",7) I UCUM=+UCUM S UCUM=$P(^BLRUCUM(UCUM,0),U,1),$P(LRSPEC0,"!",7)=UCUM
 .D BLDARY^BLRPOC(LRFNODE,LRSPEC0,LRTRES,LRTFLG)
 ;
 S LRAA=$P($G(^LAB(60,+$G(ARY("ORDTST")),8,$G(DUZ(2)),0)),U,2)
 I LRAA="" S RES="0^No Accession area defined for this test." G END
 ;
 ;S LRAD=DT
 ;S LRAN=+$P(LRACC," ",3)
 S LRAN=+$P($G(LRACC)," ",3)   ; See Heat Ticket # 16352
 I LRAN<1 S RES="0^No Accession number defined for this test." G END
 ;
 I $G(LRLLOC)="" S RES="0^Unable to resolve location. Please insure your location has an abbreviation set up." D END Q
 ;
 ; Merge array into LSRB as it is done in LRVRPOC
 M LRSB=LRARY
 ;
 D ENTRYAUD^BLRUTIL("SAVER^BLRPOC2 5.0","LRARY") ; IHS/MSC/MKK - LR*5.2*1033
 ;
 ; Call the test function as is done in LRVRPOC
 D TEST^LRVR1
 ;
 D LRHACK31        ; IHS/MSC/MKK - LR*5.2*1031
 ;
 ; File the result data with the reference ranges in ^LR
 F LRSB=1:0 S LRSB=$O(LRSB(LRSB)) Q:LRSB<1  S:LRSB(LRSB)'="" ^LR(LRDFN,LRSS,LRIDT,LRSB)=LRSB(LRSB)
 S (LRUSI,LRINI)=$$GET1^DIQ(200,$G(DUZ),1,"E")
 ;
 ; File the comments with the test results
 S LRCOM=0 F  S LRCOM=$O(ARY("CMT",LRCOM)) Q:'LRCOM  D
 .S LRCMT=$G(ARY("CMT",LRCOM))
 .D FILECOM^LRVR4(LRDFN,LRIDT,LRCMT)
 ;
 ; File Sign/Symptom
 ; S FDA(69.03,$O(^LRO(69,LRODT,1,LRSN,2,"B",+ARY("ORDTST"),0))_","_LRSN_","_LRODT_",",9999999.1)=$P($G(ARY("SYMP")),U,1)
 ; D FILE^DIE(,"FDA","ERR") K FDA
 ; S $P(^LRO(69,LRODT,1,LRSN,2,$O(^LRO(69,LRODT,1,LRSN,2,"B",+ARY("ORDTST"),0)),9999999),U,2)=$P($G(ARY("SYMP")),U,2)
 ;
 D SIGNSYMP   ; IHS/MSC/MKK - LR*5.2*1033
 ;
 ; Verify the entry
 D EXP^LRVER1
 S LRVF=1
 D V11^LRVER3
 S RES="1^Filed"
END ; EP
 S DATA=RES
 D CLEAN^LRVRPOCU
 K ARY
 Q
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1031
LRHACK31 ; EP
 ; There appears to be a defect brought about by a change to a VA routine that is included
 ; in IHS Lab Patch 1031.  The defect causes the Lab Data File's SPECIMEN TYPE field to be null
 ; as well as the Accession File's Collection Specimen.  This subroutine is a fix, not a solution.
 NEW LRAA,LRAD,LRAN,LRAS
 ;
 Q:$L($G(ARY("COL")))<1      ; If ARY("COL") is null, skip
 ;
 ; Set the Lab Data File's Speciment Type, if necessary
 I +$P($G(^LR(LRDFN,"CH",LRIDT,0)),"^",5)<1 D
 . S $P(^LR(LRDFN,"CH",LRIDT,0),"^",5)=$P($G(^LAB(62,+$G(ARY("COL")),0)),"^",2)
  ;
 ; Set Accession file's Collection Specimen, if necessary
 S LRAS=$P($G(^LR(LRDFN,"CH",LRIDT,0)),"^",6)
 D GETACCCP^BLRUTIL3(LRAS,.LRAA,.LRAD,.LRAN)
 I LRAA,LRAD,LRAN  D
 . I $P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,5,1,0)),"^",2)="" D
 .. S $P(^LRO(68,LRAA,1,LRAD,1,LRAN,5,1,0),"^",2)=+$G(ARY("COL"))
 Q
 ;
REVAL(LRTRES,LRTFLG) ; EP - Re-validate abnormal flag
 ;
 ; Take into account results that begin with ">" or "<"
 S:$E(LRTRES)=">" LRTRES=$P(LRTRES,">",2)+1
 S:$E(LRTRES)="<" LRTRES=$P(LRTRES,"<",2)-1
 ;
 S LRTFLG=""                                  ; Initialize every time
 I $L(LRNG4)&(LRTRES<LRNG4) S LRTFLG="L*"  Q
 I $L(LRNG5)&(LRTRES>LRNG5) S LRTFLG="H*"  Q
 I $L(LRNG2)&(LRTRES<LRNG2) S LRTFLG="L"  Q
 I $L(LRNG3)&(LRTRES>LRNG3) S LRTFLG="H"
 Q
 ;
 ; ----- END IHS/MSC/MKK - LR*5.2*1031
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1033
SIGNSYMP ; EP - Sign or Symptom for Incoming POC test
 D ENTRYAUD^BLRUTIL("SIGNSYMP^BLRPOC2 0.0","ARY")
 ;
 NEW ARYSYMP,ERRS,FDA,ICD,ICDCNT,ICDSTR,IENS,IN,OUT,PROVNARR,SNOMED,STR,VARS
 ;
 D ENTRYAUD^BLRUTIL("SIGNSYMP^BLRPOC2 1.0","ARY")
 ;
 S PROVNARR=$P($G(ARY("SYMP")),"^")
 S ICDSTR=$P($G(ARY("SYMP")),"^",2)
 S SNOMED=$P($G(ARY("SYMP")),"^",3)
 ;
 I SNOMED="" D  ; Only SNOMED or SNOMED Concept ID received
 . S STR=$$CONC^BSTSAPI(+PROVNARR)     ; SNOMED Concept ID check
 . I $TR(STR,"^")="" D
 .. S OUT="VARS",IN=+PROVNARR
 .. Q:+$$DSCLKP^BSTSAPI(OUT,IN)<1      ; SNOMED code check
 .. ;
 .. K STR
 .. S $P(STR,"^",3)=+PROVNARR
 .. S $P(STR,"^",4)=$$TRIM^XLFSTR($P($G(VARS(1,"FSN","TRM")),"("),"LR"," ")
 .. S $P(STR,"^",5)=$G(VARS(1,"ICD",1,"COD"))
 . S SNOMED=$P(STR,"^",3)
 . S PROVNARR=$P(STR,"^",4)
 . S ICDSTR=$P(STR,"^",5)
 ;
 D ENTRYAUD^BLRUTIL("SIGNSYMP^BLRPOC2 4.0") ; IHS/MSC/MKK - LR*5.2*1034
 ;
 Q:$L(PROVNARR)<1&($L(ICDSTR)<1)&($L(SNOMED)<1)    ; Skip if nothing to store
 ;
 S IENS=$O(^LRO(69,LRODT,1,LRSN,2,"B",+ARY("ORDTST"),0))_","_LRSN_","_LRODT_","
 ;
 D ENTRYAUD^BLRUTIL("SIGNSYMP^BLRPOC2 5.0")
 ;
 S:$L(PROVNARR) FDA(69.03,IENS,9999999.1)=PROVNARR
 S:$L(SNOMED) FDA(69.03,IENS,9999999.2)=SNOMED
 ;
 D:$D(FDA) FILE^DIE(,"FDA","ERRS")
 ;
 Q:$L(ICDSTR)<1      ; Skip if no ICD
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1034
 NEW F60PTR
 S F60PTR=$$GET1^DIQ(69.03,IENS,.01,"I")
 ; ----- END IHS/MSC/MKK - LR*5.2*1034
 ;
 F ICDCNT=1:1:$L(ICDSTR,";")  D
 . S ICD=$P(ICDSTR,";",ICDCNT)
 . K FDA,ERRS
 . S FDA(69.05,"?+1,"_IENS,.01)=ICD
 . D UPDATE^DIE("EKS","FDA",,"ERRS")
 ;
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1034
 Q:$$REFLABCK^BLRUTIL6(+ARY("ORDTST"),LRODT,LRSN)<1   ; Quit if Test is NOT a Ref Lab Test
 ;
 ; Store ICD codes into BLR REFERENCE LAB ORDER/ACCESSION (#9009026.3) file
 NEW DFN,LRDFN,ORDERN
 S ORDERN=$$GET1^DIQ(69.01,LRSN_","_LRODT,9.5)
 S LRDFN=$$GET1^DIQ(69.01,LRSN_","_LRODT,.01,"I")
 S DFN=$$GET1^DIQ(63,LRDFN,.03,"I")
 ;
 S X=$$ORD^BLRRLEDI(ORDERN,DFN)
 S ORDIEN=$$FIND1^DIC(9009026.3,,,ORDERN)
 Q:ORDIEN<1     ; If order not in 9009026.3, skip
 ;
 F ICDCNT=1:1:$L(ICDSTR,";")  D
 . S ICDCODE=$P(ICDSTR,";",ICDCNT)
 . Q:ICDCODE=".9999"!(ICDCODE="ZZZ.999") ; Don't store "Un-coded" ICDs
 . ;
 . S ICDIEN=+$$ICDDX^ICDEX(ICDCODE)
 . ;
 . K FDA,ERRS
 . S FDA(9009026.31,"?+1,"_ORDIEN_",",.01)=ICDIEN
 . S:$L(F60PTR) FDA(9009026.31,"?+1,"_ORDIEN_",",1)=F60PTR      ; IHS/MSC/MKK - LR*5.2*1034
 . D UPDATE^DIE(,"FDA",,"ERRS")
 ;
 D ENTRYAUD^BLRUTIL("SAVER^BLRPOC2 0.0","ARY")    ; IHS/MSC/MKK - LR*5.2*1033
 ;
 ; Store the Accession number
 NEW LRUID
 S LRUID=$G(^LR(+$G(LRDFN),$S($L($G(LRSS)):LRSS,1:" "),+$G(LRIDT),"ORU"))
 I $L(LRUID) D
 . K ERRS,FDA
 . S FDA(9009026.33,"?+1,"_ORDIEN_",",.01)=LRUID
 . D UPDATE^DIE(,"FDA",,"ERRS")
 ; ----- END IHS/MSC/MKK - LR*5.2*1034
 Q
 ;
 ; ----- END IHS/MSC/MKK - LR*5.2*1033
