BLRPOC2 ;IHS/MSC/PLS - EHR POC Component support, part 2 ; MAY 06, 2009 9:58 AM;bf
 ;;5.2;IHS LABORATORY;**1030**;NOV 01, 1997
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
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) ENTRYAUD^BLRUTIL("SAVER^BLRPOC2 1.0","ARY")
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
 ; Call the test function as is done in LRVRPOC
 D TEST^LRVR1
 ;
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) ENTRYAUD^BLRUTIL("SAVER^BLRPOC2 5.0","LRSB")
 ;
 ; File the result data with the reference ranges in ^LR
 F LRSB=1:0 S LRSB=$O(LRSB(LRSB)) Q:LRSB<1  S:LRSB(LRSB)'="" ^LR(LRDFN,LRSS,LRIDT,LRSB)=LRSB(LRSB)
 S (LRUSI,LRINI)=$$GET1^DIQ(200,$G(DUZ),1,"E")
 ;
 ; File the comments with the test results
 S LRCOM=0 F  S LRCOM=$O(ARY("CMT",LRCOM)) Q:'LRCOM  D
 .S LRCMT=$G(ARY("CMT",LRCOM))
 .D FILECOM^LRVR4(LRDFN,LRIDT,LRCMT)
 ; File Sign/Symptom
 S FDA(69.03,$O(^LRO(69,LRODT,1,LRSN,2,"B",+ARY("ORDTST"),0))_","_LRSN_","_LRODT_",",9999999.1)=$P($G(ARY("SYMP")),U,1)
 D FILE^DIE(,"FDA","ERR") K FDA
 S $P(^LRO(69,LRODT,1,LRSN,2,$O(^LRO(69,LRODT,1,LRSN,2,"B",+ARY("ORDTST"),0)),9999999),U,2)=$P($G(ARY("SYMP")),U,2)
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
