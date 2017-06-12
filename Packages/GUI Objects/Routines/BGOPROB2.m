BGOPROB2 ; IHS/MSC/PLS - Provide Map Advice ;24-Jun-2016 13:46;du
 ;;1.1;BGO COMPONENTS;**14,15,20,21**;Mar 20, 2007;Build 1
 ;---------------------------------------------
 ;Return the map advice for
MAP(DATA,LIST) ;EP GET MAP ADVICE
 N IN,OUT,SNO,ARR,X,CNT,ADV,CNT2,MCNT,I
 S DATA=$$TMPGBL
 S CNT=0
 S I="" F  S I=$O(LIST(I)) Q:I=""  D
 .S SNO=$G(LIST(I))
 .S CNT=CNT+1
 .S @DATA@(CNT)="C"_U_SNO
 .S IN=SNO_"^1"
 .S OUT="ARR"
 .;S X=$$MPADVICE^BSTSAPI(.OUT,.IN)
 .S X=$$I10ADV^BSTSAPI(.OUT,.IN)
 .S CNT2=0,MCNT=0
 .F  S CNT2=$O(ARR(CNT2)) Q:CNT2=""  D
 ..S ADV=$G(ARR(CNT2))
 ..S CNT=CNT+1
 ..S @DATA@(CNT)="~t"_U_CNT2_U_ADV
 .I CNT2=0 D
 ..S CNT=CNT+1
 ..S @DATA@(CNT)="~t"_U_1_U_"No Map advice available for this SNOMED term"
 Q
CHK(RET,PRIEN) ;Check to see if it is OK to delete a problem
 ;Check and see if there are any V Care Plan entries for this problem
 ;If there are, the problem cannot be deleted Patch 13&14
 N X,SIEN,STATUS
 I +$O(^AUPNPROB(+PRIEN,14,"B",0))!(+$O(^AUPNPROB(+PRIEN,15,"B",0))) S RET="-1^Problem has been used for a visit and cannot be deleted. Check Problem Details."  Q
 S X=0,RET=1
 F  S X=$O(^AUPNCPL("B",+PRIEN,X)) Q:X=""!(+RET<0)  D
 .S SIEN=$C(0) S SIEN=$O(^AUPNCPL(X,11,SIEN),-1)
 .S STATUS=$P($G(^AUPNCPL(X,11,SIEN,0)),U,1)
 .I STATUS'="E" S RET="-1^Care Plan entries are stored. Check Problem Details. Problem cannot be deleted"
 Q:+RET<0
 S X=0
 F  S X=$O(^AUPNVVI("B",+PRIEN,X)) Q:X=""!(+RET<0)  D
 .I $$GET1^DIQ(9000010.58,X,.06,"I")'=1 S RET="-1^Visit instructions are stored. Check Problem Details. Problem cannot be deleted"
 F  S X=$O(^AUPNVOB("B",+PRIEN,X)) Q:X=""!(+RET<0)  D
 .I $$GET1^DIQ(9000010.43,X,.06,"I")'=1 S RET="-1^OB notes are stored. Check Problem Details. Problem cannot be deleted"
 Q
CLASS(REC,DFN,ASM) ;Return asthma class information
 N CLASS,CONTROL,ASTHMA,DATA
 S DATA=""
 S CLASS=$P(REC,U,15)
 S ASM=$G(ASM)
 ;P20 removed check for classification
 ;I CLASS'="" D
 I ASM=1 D
 .;Return asthma data for this problem
 .;Patch 20 only return classification, not control
 .S ASTHMA=""
 .S CLASS=$S(CLASS=1:"INTERMITTENT",CLASS=2:"MILD PERSISTENT",CLASS=3:"MODERATE PERSISTENT",CLASS=4:"SEVERE PERSISTENT",1:"")
 .;D GET2^BGOVAST(.ASTHMA,DFN)
 .;S CONTROL=$P(ASTHMA,U,4)
 .;S DATA="A"_U_CLASS_U_CONTROL_U_$P(ASTHMA,U,2)
 .S DATA="A"_U_CLASS
 Q DATA
INJCHK(PRIEN,VIEN) ;Return most recent injury information
 N DATA,OUTPT,VST,FNUM,REC,CAUSE,REVISIT,IDP,IPL,ICCIEN,FOUND,VDATE
 N ICCODE,ICAU,IDT
 S DATA="",FNUM=9000010.07,FOUND=0
 ;Get the latest visit where this problem was used as a POV
 S VST=$O(^AUPNPROB(PRIEN,14,"B",9999999),-1)  D
 .Q:'VST
 .S OUTPT="" S OUTPT=$O(^AUPNPROB(PRIEN,14,"B",VST,OUTPT))
 .I +OUTPT D
 ..N VPOV
 ..S FOUND=0
 ..;Find the POV from the visit that is attached to the correct problem
 ..S VPOV=0 F  S VPOV=$O(^AUPNVPOV("AD",VST,VPOV)) Q:VPOV=""!(FOUND=1)  D
 ...S (CAUSE,REVISIT,IDT,IPL,ICCIEN)=""
 ...I $P($G(^AUPNVPOV(VPOV,0)),U,16)=PRIEN D
 ....S REC=$G(^AUPNVPOV(VPOV,0))
 ....S VDATE=$$FMTDATE^BGOUTL($P($G(^AUPNVSIT(VST,0)),U))
 ....;Get the injury fields
 ....S CAUSE=$$EXTERNAL^DILFD(FNUM,.07,,$P(REC,U,7))
 ....S REVISIT=$$EXTERNAL^DILFD(FNUM,.08,,$P(REC,U,8))
 ....S IDT=$$FMTDATE^BGOUTL($P(REC,U,13))
 ....S IPL=$P(REC,U,11)
 ....I IPL'="" S IPL=$$EXTERNAL^DILFD(FNUM,.11,,IPL)_"~"_IPL
 ....S ICCIEN=$P(REC,U,9)
 ....S (ICCODE,ICAU)=""
 ....S:ICCIEN ICAU=$P($$ICDDX^ICDEX(ICCIEN,VDATE,"","I"),U,4),ICCODE=$P($$ICDDX^ICDEX(ICCIEN,VDATE,"","I"),U,2)
 ....I (CAUSE'="")!(REVISIT'="")!(IDT'="")!(IPL'="")!(ICCIEN'="") D
 .....S FOUND=1
 .....S DATA="H"_U_REVISIT_U_CAUSE_U_IDT_U_ICAU_U_ICCODE_U_IPL_U_VST
 Q DATA
 ;IHS/MSC/MGH check for duplicates
 ;INP=SNOMED Concept CT ^ laterality code | laterality type ^ PRIEN
DUPCHK(RET,INP) ;EP
 N ESNO,F,ELAT,EXMNOPRB,ENOD,PRIEN,EEXT,DFN,MATCH,CONCID,CNT,STAT,IEN,I2,I1,LAT,CHK,USES,ARR,FND,LST,CNT2,CNK2,ETRM
 S RET=$$TMPGBL^BGOUTL
 S CNT=0,FND=0,LST="",CNT2=0
 S DFN=$P(INP,U,1)
 S CONCID=$P(INP,U,2)
 S CHK=$P(INP,U,3)
 S LAT=$P(CHK,"|",2)
 I LAT="" S CHK=""
 S PRIEN=$P(INP,U,4)
 D EQUIV^BSTSAPI("ARR",CONCID_"^"_CHK)
 S I1="" F  S I1=$O(ARR(I1)) Q:I1=""  D
 .S ENOD=$G(ARR(I1))
 .S ESNO=$P(ENOD,U,1)
 .S ELAT=$P(ENOD,U,2)
 .S EEXT=$P(ENOD,U,3)
 .S ETRM=$P(ENOD,U,4)
 .I ELAT="" D
 ..S IEN="" F  S IEN=$O(^AUPNPROB("APCT",DFN,ESNO,IEN)) Q:'+IEN  D
 ...S STAT=$$GET1^DIQ(9000011,IEN,.12,"I")
 ...Q:STAT="D"
 ...S F=$$SETDATA(.LST,.CNT,IEN,ENOD,.EXFND)
 ...S:F FND=1
 .I ELAT'="" D
 ..S IEN="" F  S IEN=$O(^AUPNPROB("ASLT",DFN,ESNO,ELAT,IEN)) Q:'+IEN  D
 ...S STAT=$$GET1^DIQ(9000011,IEN,.12,"I")
 ...Q:STAT="D"
 ...S F=$$SETDATA(.LST,.CNT,IEN,ENOD,.EXFND)
 ...S:F FND=1
 .I FND=0,CONCID=ESNO,CHK=ELAT D
 .. NEW PDST,EXLAT,ICD,DSTS,DDATA,PRMLST,PMLT
 .. S PRMLST="" I $P(ELAT,"|",2)]"" S PRMLST="LAT="_$P(ELAT,"|",2)
 .. S DDATA=$$CONC^BSTSAPI(CONCID_"^^^1^^"_PRMLST)
 .. S PDST=$P(DDATA,U,4)
 .. S DESCID=$P(DDATA,U,1)
 .. ;
 .. ;Get external laterality
 .. S EXLAT="" I $TR(ELAT,"|")]"" S EXLAT=$$CVPARM^BSTSMAP1("LAT",$P(ELAT,"|"))_"|"_$$CVPARM^BSTSMAP1("LAT",$P(ELAT,"|",2))
 .. ;
 .. ;Get ICD, default status and prompt laterality
 .. S ICD=$P(DDATA,U,5)
 .. S DSTS=$P(DDATA,U,9)
 .. S PMLT=$P(DDATA,U,8)
 .. ;No match found - log that entry can be used
 .. S CNT=$G(CNT)+1,LST(CNT)=0_U_ESNO_U_ELAT_U_DESCID_U_PDST_U_EEXT_U_EXLAT_U_ICD_U_U_DSTS_U_$S(PMLT:"Y",1:"")_U_ETRM
 .. I EEXT S EXMNOPRB=1  ;Track if an exact match
 ;Loop through results - eliminate others if exact match found
 N TII,TNODE
 S TII="" F  S TII=$O(LST(TII)) Q:'TII  D
 . ;
 . NEW TNODE,CONC,LAT,LATCHK
 .S LATCHK=0
 . S TNODE=$G(LST(TII))
 .I +PRIEN D
 ..S LAT=$$GET1^DIQ(9000011,PRIEN,.22,"I")
 ..S CONC=$$GET1^DIQ(9000011,PRIEN,80001)
 ..I LAT'=$P(TNODE,U,3) S LATCHK=1
 ..I CONC'=$P(TNODE,U,1) S LATCHK=1
 . ;Special logic for exact match found on IPL - Only include it
 . I $D(LST("EXACT")) D  Q
 .. NEW EXNODE
 .. ;Get the exact match
 .. S EXNODE=$G(LST("EXACT"))
 .. ;
 .. ;If not an exact match do not include
 .. I '$P(TNODE,U,6) Q
 .. ;Passed in problem is the same as the exact match problem
 .. ;
 .. I +PRIEN,PRIEN=$P(EXNODE,U,5) D  Q
 ... ;
 ... ;The user switched to the equivalent concept - update original
 ... ;passed in problem info with new SNOMED/laterality information
 ... I $P(TNODE,U,6)=1,$P(TNODE,U,1)=0 D  Q
 .... NEW I
 .... S EXNODE=$G(LST("EXACT"))
 .... F I=5:1:9 S $P(TNODE,U,I)=$P(EXNODE,U,I)
 .... S CNT2=CNT2+1,@RET@(CNT2)=TNODE
 ... ;
 ... ;The user picked the same concept - return original
 ... I $P(TNODE,U,6)=1,$G(LST("EXACT"))=TII D  Q
 .... Q:CONCID'=$P(TNODE,U)  ;Concept not the same
 .... Q:LAT'=$P(TNODE,U,2)  ;Laterality not the same
 .... S TNODE=$G(LST("EXACT"))
 .... S CNT2=CNT2+1,@RET@(CNT2)=TNODE
 .. ;
 .. ;No passed in problem or not a match with exact
 .. ;
 .. ;If exact match, allow - GUI will utilize IPL problem returned
 .. I $G(LST("EXACT"))=TII D  Q
 ... S TNODE=$G(LST(TII))
 ... S CNT2=CNT2+1,@RET@(CNT2)=TNODE
 . ;
 . ;Problem edit - changed SNOMED and it isn't a match on IPL
 . ;update entry with passed in problem information
 . I +PRIEN,$P(TNODE,U,1)=0 D  Q
 .. S $P(TNODE,U,1)=+PRIEN
 ..I LATCHK=1 S $P(TNODE,U,6)=0
 .. S CNT2=CNT2+1,@RET@(CNT2)=TNODE
 . ;
 . ;Not an exact match on IPL, exact found by BSTS and edit fill entries
 . I EXMNOPRB D  Q        ;Edit and an exact match was saved
 .. I $P(TNODE,U,6) D  ;This is the exact match
 ... S $P(TNODE,U,1)=+PRIEN
 ... I +PRIEN=0 S EXMNOPRB=0
 ...I LATCHK=1 S $P(TNODE,U,6)=0
 ... S CNT2=CNT2+1,@RET@(CNT2)=TNODE
 . ;
 . ;No exact matches - save related ones
 . I EXMNOPRB=0 S CNT2=CNT2+1,@RET@(CNT2)=TNODE
 Q
SETDATA(LST,CNT,IEN,DATA,EXFND) ;Get the needed data
 N STRING,DESCID,PLAT,PCNC,PNAR,PDSC,PDST,ICD,PRMLST,DDATA,DSTS,PMLT
 S STRING=""
 ;If matching concept id and no laterality passed in, filter out those with laterality
 S PLAT=$$GET1^DIQ(9000011,IEN_",",.22,"I") ;Laterality
 I $P(DATA,U,2)="",PLAT]"" Q 0
 S PCNC=$$GET1^DIQ(9000011,IEN_",",80001,"I") ;Concept ID
 S PDSC=$$GET1^DIQ(9000011,IEN_",",80002,"I") ;Description ID
 S PDST=$P($$DESC^BSTSAPI(PDSC_"^^1"),U,2) ;Description Term
 S PNAR=$$GET1^DIQ(9000011,IEN_",",.05)
 S EEXT=$P(DATA,U,3)
 S EXFND=1  ;Record that an exact IPL match was found
 ;Get external laterality
 S EXLAT="" I $TR(PLAT,"|")]"" S EXLAT=$$CVPARM^BSTSMAP1("LAT",$P(PLAT,"|"))_"|"_$$CVPARM^BSTSMAP1("LAT",$P(PLAT,"|",2))
 ;
 ;Get ICD and default status
 S PRMLST="" I $P(PLAT,"|",2)]"" S PRMLST="LAT="_$P(PLAT,"|",2)
 S DDATA=$$DESC^BSTSAPI(PDSC_"^^1^^^"_PRMLST)
 ;
 ;Get ICD, default status, and prompt laterality
 S ICD=$P(DDATA,U,3)
 S DSTS=$P(DDATA,U,7)
 S PMLT=$P(DDATA,U,6)
 ;Save the entry
 S CNT=$G(CNT)+1,LST(CNT)=IEN_U_PCNC_U_PLAT_U_PDSC_U_PNAR_U_EEXT_U_EXLAT_U_ICD_U_STAT_U_DSTS_U_$S(PMLT:"Y",1:"")_U_$P(DATA,U,4)
 I EEXT S LST("EXACT")=CNT ;Record if this was an exact match
 Q 1
 ;Return data for sorting P20
 ;1)Number of times the code has been used as POV
 ;2)If it is an eye DX
 ;3)The IEN of the inpt visit it was used last
P1(RET,CNT,DFN,PRIEN,DESCT) ;EP
 N FREQ,EYE,INPT,ARR,X,X1,PAR
 Q:'+DESCT
 S (FREQ,EYE,INPT,X,X1)=0
 S PAR=$$GET^XPAR("ALL","BGO IPL EYE DX",1,"E")
 I PAR="YES" D
 .S OUT="ARR"
 .S IN=DESCT_"^EHR IPL EYE FILTER"
 .S X=$$VALSBTRM^BSTSAPI(.OUT,.IN)
 .I +X S X1=$G(@OUT)
 .I +X1 S EYE=1
 .E  S EYE=0
 S FREQ=$$FREQ(PRIEN)
 S PAR=$$GET^XPAR("ALL","BGO IPL INPT TAB",1,"E")
 I PAR="YES" D
 .S INPT=$$LASTIP(PRIEN,DFN)
 S CNT=CNT+1
 S @RET@(CNT)="P1"_U_FREQ_U_EYE_U_INPT
 Q
FREQ(PRIEN) ;P20 Find how many times a problem was used as POV
 N USED,CNT,IEN
 S USED=0
 S IEN=0 F  S IEN=$O(^AUPNPROB(PRIEN,14,IEN)) Q:'+IEN  D
 .S USED=USED+1
 Q USED
LASTIP(PRIEN,DFN) ;P20 Find if problem was used as IP DX in last hospitalization
 N USED,INVDT,IEN,INPT
 S USED=""
 S INVDT=""
 S INVDT=$O(^AUPNVSIT("AAH",DFN,INVDT))
 I '+INVDT Q USED
 S IEN=0 S IEN=$O(^AUPNVSIT("AAH",DFN,INVDT,IEN))
 I '+IEN Q USED
 S INPT="" S INPT=$O(^AUPNPROB(PRIEN,15,"B",IEN,INPT))
 I +INPT S USED=$$GET1^DIQ(9000010,IEN,.01,"I")
 Q USED
UPSTAT(PRIEN,STAT) ;Update the status of a problem P20
 N FDA,IENS,FNUM
 S FNUM=9000011
 S IENS=PRIEN_","
 S FDA=$NA(FDA(FNUM,IENS))
 S @FDA@(.12)=STAT
 D FILE^DIE("","FDA","ERR")
 Q
TMPGBL(X) ;EP
 K ^TMP("BGOMAP",$J) Q $NA(^($J))
