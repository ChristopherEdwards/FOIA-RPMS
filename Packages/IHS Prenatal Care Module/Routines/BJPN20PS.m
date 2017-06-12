BJPN20PS ;GDIT/HS/BEE-Prenatal Care Module 2.0 Post Install ; 08 May 2012  12:00 PM
 ;;2.0;PRENATAL CARE MODULE;;Feb 24, 2015;Build 63
 ;
 Q
 ;
PST ;EP - Prenatal 2.0 Post Installation Code
 ;
 NEW BI,TEXT,DIK,DA
 ;
 ;If PRENATAL 1.0 was installed, perform conversion
 D CONV
 ;
 ;Recompile the new "E" index (by PROBLEM)
 I +$O(^BJPNPL(0))>0 D
 . W !!,"Recompiling cross references"
 . S DIK="^BJPNPL(" D IXALL2^DIK
 . S DIK="^BJPNPL(" D IXALL^DIK
 ;
 ;Recompile the new "E" index (by PROBLEM)
 S DIK="^BJPNPL(",DIK(1)=".1^F" D ENALL^DIK
 ;
 ; UPDATE THE VUECENTRIC REGISTERED OBJECTS FILE
 D REG^BJPN20RG
 ;
XPST Q
 ;
CONV ;Convert existing PIP/VOB entries to use new BJPN SNOMED TERMS entries
 ;
 NEW DIK
 ;
 ;Only convert if backup from pre-install is present
 Q:'$D(^XTMP("BJPN"))
 ;
 ;Process each panel entry
 K ^TMP("BJPNCVVOB",$J)
 S BJPNPL=0 F  S BJPNPL=$O(^BJPNPL(BJPNPL)) Q:'BJPNPL  D
 . NEW STS
 . S STS=$$PRC1PIP(BJPNPL)
 K ^TMP("BJPNCVVOB",$J)
 ;
 Q
 ;
PRC1PIP(BJPNPL) ;EP - Process one PIP entry
 ;
 ;In a number of cases FileMan sets cannot be used as they would cause invalid audit entries
 ;to be generated.  The audit entries get set up manually where needed
 ;
 NEW BJPNSMD,CONCID,CONSTR,DESCID,DFN,PIEN,PRBIEN,PROBLEM,STS,ICD,AUPNPROB,CPREG
 NEW PEDD,DEDD,ERROR,DESCSTR,IENS,DA,DIK,NEWPRB,LMB,LMD,ENB,END
 ;
 ;Check to see if the PROBLEM field is populated, if so conversion completed
 S PROBLEM=$$GET1^DIQ(90680.01,BJPNPL_",",".1","I") I PROBLEM]"" S STS="2^PIP entry already converted" Q STS
 ;
 ;Skip deleted problem entries
 I $$GET1^DIQ(90680.01,BJPNPL_",","2.02","I")]"" S STS="0^PIP Problem has been deleted" Q STS
 ;
 ;Get the SNOMED 90620.02 file pointer
 S BJPNSMD=$$GET1^DIQ(90680.01,BJPNPL_",",".03","I") I BJPNSMD="" S STS="0^Invalid SNOMED pointer" Q STS
 ;
 ;Get the Concept ID - Quit if invalid
 W !,"Processing Prenatal PIP entry: ",BJPNPL
 S CONCID=$$GET1^DIQ(90680.02,BJPNSMD_",",".07","I") I CONCID="" S STS="0^Missing Concept ID" Q STS
 S CONSTR=$$CONC^BSTSAPI(CONCID_"^^^1") I $P(CONSTR,U,2)="" S STS="0^DTS could not find Concept ID" Q STS
 ;
 ;Get the description ID - If invalid, use preferred term
 S DESCID=$$GET1^DIQ(90680.02,BJPNSMD_",",".03","I")
 S:DESCID="" DESCID=$P(CONSTR,U,3) I DESCID="" S STS="0^Could not locate Description ID" Q STS
 S DESCSTR=$$DESC^BSTSAPI(DESCID_"^^1") I $P(DESCSTR,U)="" S STS="0^DTS could not find Description ID" Q STS
 ;
 ;Valid Concept ID and Description Id found - ok to continue
 ;
 ;Get the patient DFN
 S DFN=$$GET1^DIQ(90680.01,BJPNPL_",",".02","I") I DFN="" S STS="0^Missing DFN in ^BJPNPL" Q STS
 ;
 ;Check to see if we have a problem on the IPL already
 S (PRBIEN,PIEN,NEWPRB)="" F  S PIEN=$O(^AUPNPROB("APCT",DFN,CONCID,PIEN)) Q:'PIEN  D  I PRBIEN]"" Q
 . NEW DELPRB
 . S DELPRB=$$GET1^DIQ(9000011,PIEN_",",2.02,"I") I DELPRB]"" Q  ;Skip deletes
 . S PRBIEN=PIEN  ;Found a match
 ;
 ;Get the ICD code
 S DA=1,DA(1)=BJPNSMD S IENS=$$IENS^DILF(.DA)
 S ICD=$$GET1^DIQ(90680.21,IENS,".01","I")
 ;
 I ICD="" D  I ICD="" S STS="0^Missing ICD Code" Q STS
 . NEW X,DIC,X,Y
 . S X=".9999" I $$VERSION^XPDUTL("AICD")>3.51,$T(IMP^ICDEXA)]"",$$IMP^ICDEXA(30)>DT S X="ZZZ.999"
 . S DIC="^ICD9(",DIC(0)="XMO" D ^DIC I +Y<0 S ICD="" Q
 . S ICD=+Y
 ;
 ;If new problem, create new entry, quit if one wasn't created
 I PRBIEN="" D  Q:'+STS
 . S NEWPRB=1 ;Record that this is a new problem being added
 . NEW RET,VIEN,FRSTIEN,LIST,NARR,LOC,PRBCNT,Y,PIP,DA,DIK
 . ;
 . S STS=0
 . ;
 . ;Get the visit IEN that the problem was added
 . S FRSTIEN=$O(^AUPNVOB("B",BJPNPL,""))
 . S VIEN=$$GET1^DIQ(9000010.43,FRSTIEN_",",".03","I") I VIEN="" S STS="0^No visit found" Q
 . ;
 . ;Get the provider text - now provider text | descriptive SNOMED CT
 . S NARR=$$GET1^DIQ(90680.01,BJPNPL_",",".05","E")
 . ;
 . ;Get the location
 . S LOC=$$GET1^DIQ(9000010,VIEN_",",".06","I")
 . ;
 . ;Get the next problem #
 . D NEXTID^BGOPROB(.RET,DFN)
 . S PRBCNT=+$P(RET,"-",2)
 . ;
 . ;  DFN   = Patient IEN
 . ;  PRIEN = IEN of problem, null if new
 . ;  VIEN  = Needed if asthma DX
 . ;  List(n)
 . ;        "P"[1] ^ SNOMED CT [2] ^ Descriptive CT [3] ^ Provider text [4] ^ Mapped ICD [5]
 . ;        ^ Location [6] ^ Date of Onset [7] ^ Status [8] ^ Class [9] ^Problem # [10] ^ Priority [11] ^ INP DX [12]
 . ;        "A"[1] ^ Classification [2] ^ Control [3] ^ V asthma IEN [4]
 . ;        "Q"[1] ^ TYPE [2] ^ Qualifier IEN [3] ^ Qual SNOMED [4] ^ By [5] ^ When [6] ^ Delete [7]
 . ;SET(RET,DFN,PRIEN,VIEN,ARRAY) ;EP
 . S LIST(0)="P"_U_CONCID_U_DESCID_U_NARR_U_ICD_U_LOC_U_U_"Episodic"_U_U_PRBCNT_U_"0"
 . ;
 . ;Turn off auditing
 . NEW AFLD,AI,RES F AI=.01,.03,.05,.12,80001,80002,"1401,.01","1501,.01" S RES=$$OFF^BJPN20AU(9000011,AI) S:RES]"" AFLD(AI)=RES
 . ;
 . ;Log the problem
 . D SET^BGOPROB(.RET,DFN,"",VIEN,.LIST)
 . ;
 . ;Perform BUSA audit
 . D LOG^BJPNUTIL("P","A","BJPN20PS","Added problem to IPL/PIP",DFN)
 . ;
 . ;Turn auditing back on
 . S AI="" F  S AI=$O(AFLD(AI)) Q:AI=""  D ON^BJPN20AU(9000011,AI,AFLD(AI))
 . K AFLD,AI,RES
 . ;
 . I '+RET S STS="0^Could not create new problem entry" Q
 . S PRBIEN=+RET
 . ;
 . ;Return success
 . S STS=1
 ;
 ;If Problem IEN present, update PIP file
 I PRBIEN]"" S $P(^BJPNPL(BJPNPL,0),U,10)=PRBIEN
 ;
 ;Determine whether to check the PIP box in the problem file
 S CPREG=$$GET1^DIQ(9000017,DFN_",",1101,"I")  ;Currently pregnant
 S DEDD=$$GET1^DIQ(9000017,DFN_",",1311,"I")   ;Definitive EDD
 S PEDD=$$DEDD^BJPNPDET(DFN)                   ;Definitive EDD - PIP
 ;
 ;If we have currently pregnant and definitive EDD, mark PIP
 S PIP="" I CPREG="Y",DEDD]"" S PIP=1
 ;
 ;Not pregnant, but PIP EDD is still defined - meaning PIP has not been closed
 I CPREG'="Y",PEDD]"" S PIP=1
 ;
 ;PIP entry is inactive - never mark PIP
 I $$GET1^DIQ(90680.01,BJPNPL_",",".08","I")'="A" S PIP=""
 ;
 ;File the entry
 S $P(^AUPNPROB(PRBIEN,0),U,19)=PIP
 ;
 ;If existing problem retrieve modified/entered info
 I 'NEWPRB D
 . S LMB=$$GET1^DIQ(9000011,PRBIEN,".14","I")
 . S LMD=$$GET1^DIQ(9000011,PRBIEN,".03","I")
 . S END=$$GET1^DIQ(9000011,PRBIEN,".08","I")
 . S ENB=$$GET1^DIQ(9000011,PRBIEN,"1.03","I")
 ;
 ;If existing problem, back up current POVs)
 I 'NEWPRB D
 . NEW TYPE,VSIEN
 . F TYPE=14,15 S VSIEN="" F  S VSIEN=$O(^AUPNPROB(PRBIEN,TYPE,"B",VSIEN)) Q:VSIEN=""  S ^TMP("BJPNCVVOB",$J,PRBIEN,TYPE,VSIEN)=""
 ; 
 ;Copy Care Plan Notes to Visit Instructions, POV info, auditing
 D VOB^BJPN20P1(BJPNPL,PRBIEN,NEWPRB)
 ;
 ;Turn off auditing
 NEW AFLD,AI,RES F AI=.01,.03,.05,.12,80001,80002,"1401,.01","1501,.01" S RES=$$OFF^BJPN20AU(9000011,AI) S:RES]"" AFLD(AI)=RES
 ;
 ;Get the current problem ICD - we may need to change it to the one passed in
 NEW CICD
 S CICD=$$GET1^DIQ(9000011,PRBIEN_",",.01,"I")
 I CICD'=ICD,ICD]"" D
 . NEW AUPN,ERROR
 . S AUPN(9000011,PRBIEN_",",".01")=ICD
 . D FILE^DIE("","AUPN","ERROR")
 K CICD
 ;
 ;Now re-index again
 S DA=PRBIEN,DIK="^AUPNPROB(" D IX^DIK
 ;
 ;Determine which enter/last modified information to use
 I 'NEWPRB D
 . NEW CLMD,CEND,AUPN,ERROR
 . ;
 . ;Use latest last modified information
 . S CLMD=$$GET1^DIQ(9000011,PRBIEN,".03","I")
 . I CLMD]"",CLMD<$G(LMD) D
 .. S AUPN(9000011,PRBIEN_",",".03")=LMD
 .. S AUPN(9000011,PRBIEN_",",".14")=$G(LMB)
 .;
 .;Use earliest entered by information
 . S CEND=$$GET1^DIQ(9000011,PRBIEN,".08","I")
 . I $G(END)]"",END<CEND D
 .. S AUPN(9000011,PRBIEN_",",".08")=END
 .. S AUPN(9000011,PRBIEN_",","1.03")=$G(ENB)
 . ;
 . ;File any changes
 . I $D(AUPN) D FILE^DIE("","AUPN","ERROR")
 ;
 ;Turn auditing back on
 S AI="" F  S AI=$O(AFLD(AI)) Q:AI=""  D ON^BJPN20AU(9000011,AI,AFLD(AI))
 K AFLD,AI,RES
 ;
 Q 1
