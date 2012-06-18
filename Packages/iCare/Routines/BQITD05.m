BQITD05 ;PRXM/HC/ALA-CVD Significant Risk ; 02 Mar 2006  1:17 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
 ;
POP(BQARY,TGLOB) ; EP -- By population
 ;
 ;Description
 ;  Finds all patients who meet the criteria for CVD Significant Risk
 ;Input
 ;  BQARY - Array of taxonomies and other information
 ;  TGLOB - Global where data is to be stored and passed back
 ;          to calling routine
 ;          Structure:
 ;          TGLOB(DFN,"CRITERIA",criteria or taxonomy,visit or problem ien)=date/time
 ;Variables
 ;  TAX - Taxonomy name
 ;  NIT - Number of iterations
 ;  TMFRAME - Time frame of check
 ;  FREF - File Number reference
 ;  PLFLG - Problem File flag
 ;  GREF - Global reference
 ;  TREF - Taxonomy temp reference
 ;
 ;  Clean up all current entries
 NEW DXNN,TDFN,DA,DIK,TMGLB,SEX,AGE,TXDXCN,TXDXCT
 NEW SERV,VSERV,PRIM,MFL
 ;
 S TMGLBB=$NA(^TMP("BQICHRF",UID)) K @TMGLBB
 D EN^BQITRSK(.TMGLBB)
 S TDFN=""
 F  S TDFN=$O(@TMGLBB@(TDFN)) Q:TDFN=""  D
 . S SEX=$$GET1^DIQ(2,TDFN,.02,"I")
 . S AGE=$$AGE^BQIAGE(TDFN)
 . I SEX="M" D
 .. ; If males are less than 19 years old, kill risk factors and quit
 .. I AGE<19 K @TMGLBB@(TDFN) Q
 .. ; If males are 19-44 and have less than 2 risk factors, kill risk factors and quit
 .. I AGE>18,AGE<45,@TMGLBB@(TDFN)<2 K @TMGLBB@(TDFN)
 .. ;  Assumes that left over data meets criteria of
 .. ;      AGE=19-44 and at least 2 risk factors
 .. ;      AGE>=45 and at least 1 risk factor
 . I SEX="F" D
 .. ;  If females are less than 19 years old, kill risk factors and quit  
 .. I AGE<19 K @TMGLBB@(TDFN) Q
 .. ;  If females are 19-54 and have less than 2 risk factors, kill risk factors and quit
 .. I AGE>18,AGE<55,@TMGLBB@(TDFN)<2 K @TMGLBB@(TDFN)
 .. ;  Assumes that left over data meets criteria of
 .. ;      AGE=19-54 and at least 2 risk factors
 .. ;      AGE>=55 and at least 1 risk factor
 ;
 ;  Even if they meet the criteria, they cannot also have been
 ;  identified as CVD Known or CVD Highest Risk.  If they are,
 ;  kill their entry.
 S TDFN=""
 F  S TDFN=$O(@TMGLBB@(TDFN)) Q:TDFN=""  D
 . F TXDXCT="CVD Known","CVD Highest Risk" D
 .. ; If the person has an active tag at a higher level
 .. I $$ATAG^BQITDUTL(TDFN,TXDXCT) K @TMGLBB@(TDFN)
 ;
 S TDFN=""
 F  S TDFN=$O(@TMGLBB@(TDFN)) Q:TDFN=""  M @TGLOB@(TDFN)=@TMGLBB@(TDFN)
 K @TMGLBB,TMGLBB
 Q
 ;
PAT(DEF,BTGLOB,BDFN) ; EP -- By patient
 NEW DXOK,BQDXN,TMGLB,TX,BQREF,TAX,GREF,TREF,FREF,NIT,PLFLG,BQGLB
 NEW IEN,TIEN,VISIT,VSDTM,DXNN,BMID,VIENS,TDXNCN,ENDT,STDT,DTDIF,QFL
 NEW SERV,VSERV,PRIM,MFL
 S DXOK=0
 ; if the person has already been identified as CVD Known OR CVD Highest Risk
 S QFL=0 F TDXNCN="CVD Highest Risk","CVD Known" D  Q:QFL
 . I $$ATAG^BQITDUTL(BDFN,TDXNCN) S QFL=1
 I QFL Q DXOK
 ;
 S TMGLB=$NA(^TMP("BQICHR",UID)) K @TMGLB
 S DXOK=0
 S BQDXN=$$GDXN^BQITUTL("Current Smoker")
 S BQREF="BQIRY"
 D GDF^BQITUTL(BQDXN,BQREF)
 I $$PAT^BQITDGN(BQREF,TMGLB,BDFN) D
 . S TX=$O(@TMGLB@(BDFN,"CRITERIA",""))
 . D STOR(BDFN,TX,TMGLB)
 K @TMGLB
 ;
 S BQDXN=$$GDXN^BQITUTL("PreDM Metabolic Syndrome")
 S BQREF="BQIRY"
 D GDF^BQITUTL(BQDXN,BQREF)
 ; Set to primary and secondary instead of primary only
 I $G(BQIRY(1))'="",$P(BQIRY(1),U,1)["DX" S $P(BQIRY(1),U,8)=0
 I $$PAT^BQITDGN(BQREF,TMGLB,BDFN) D
 . S TX=$O(@TMGLB@(BDFN,"CRITERIA",""))
 . D STOR(BDFN,TX,TMGLB)
 K @TMGLB
 ;
 S TAX="BGP HYPERTENSION DXS",NIT=3,FREF=9000010.07,PLFLG=1,ENDT=""
 S GREF=$$ROOT^DILFD(FREF,"",1),TREF=$NA(^TMP("BQITAX",UID))
 S SERV="A;H",PRIM=0,EXDT=""
 S BQGLB=$NA(^TMP("BQITMP",UID))
 K @TREF,@BQGLB
 D BLD^BQITUTL(TAX,TREF)
 ;D PPRB^BQITRSK(BDFN)
 D PPRB^BQITD03(BDFN,BQGLB)
 S IEN="",EXDT=""
 F  S IEN=$O(@GREF@("AC",BDFN,IEN),-1) Q:IEN=""  D
 . S TIEN=$$GET1^DIQ(FREF,IEN,.01,"I") I TIEN="" Q
 . I '$D(@TREF@(TIEN)) Q
 . I $G(@BTGLOB@(BDFN))'<2 Q
 . ;I $G(@BQGLB@(BDFN))>NIT Q
 . S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") Q:VISIT=""
 . I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 . ;  check clinical ranking if diagnosis (9000010.07)
 . I FREF=9000010.07,PRIM I $P(@GREF@(IEN,0),U,12)'="P" S MFL=0 D  Q:'MFL
 .. I $O(@GREF@("AD",VISIT,""))=IEN S MFL=1
 . ;  if service categories, check the visit for the service category
 . S VSERV=$$GET1^DIQ(9000010,VISIT,.07,"I")
 . I $G(SERV)'="",SERV'[VSERV Q
 . S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 Q:VSDTM=0
 . S @BQGLB@(BDFN,VSDTM,TIEN)="V"_U_VISIT_U_EXDT_U_IEN_U_FREF
 . S @BQGLB@(BDFN)=$G(@BQGLB@(BDFN))+1
 ;
 D HYP^BQITRSK(BDFN,TMGLB,BQGLB)
 I $D(@TMGLB)>0 D STOR(BDFN,TAX,TMGLB)
 K @BQGLB,@TREF
 ;
 NEW DXNN,AGE,BMI,MIENS
 S BMID=$$OBMI^BQITBMI(BDFN,"T-60M")
 S BMI=$P(BMID,"^",1),AGE=$P(BMID,"^",2),VIENS=$P(BMID,"^",3),MIENS=$P(BMID,"^",4)
 I BMI'="",$$OB^BQITBMI(BDFN,BMI,AGE) D
 . F I=1:1 S VST=$P(VIENS,",",I) Q:VST=""  D
 .. NEW IEN
 .. S IEN=$P(MIENS,",",I),FREF=9000010.01
 .. S @TMGLB@(BDFN,"CRITERIA","Risk Factor-Obese BMI","V",VST,IEN)=$P($G(^AUPNVSIT(VST,0)),U,1)_U_EXDT_U_IEN_U_FREF
 . D STOR(BDFN,"Risk Factor-Obese BMI",TMGLB)
 K @TMGLB
 ;
 NEW BCLN,BTYP,RDT,CT,N,BP,SYS,DIA,RESULT,HDATA
 S BQGLB1=$NA(^TMP("BQITMP",UID))
 K @BQGLB1
 S BCLN=$$FIND1^DIC(40.7,"","Q","EMERGENCY","B","","ERROR")
 S BTYP=$$FIND1^DIC(9999999.07,,"X","BP")
 S RDT=""
 F  S RDT=$O(^AUPNVMSR("AA",BDFN,BTYP,RDT)) Q:RDT=""  D
 . S CT=0,N=""
 . F  S N=$O(^AUPNVMSR("AA",BDFN,BTYP,RDT,N)) Q:N=""!(CT>3)  D
 .. S VISIT=$P($G(^AUPNVMSR(N,0)),U,5) Q:VISIT=""
 .. ; if the new ENTERED IN ERROR field exists, exclude the record if it is marked as an error
 .. I $$VFIELD^DILFD(9000010.01,2) Q:$$GET1^DIQ(9000010.01,IEN_",",2,"I")=1
 .. I $P($G(^AUPNVSIT(VISIT,0)),U,8)=BCLN Q
 .. I $P($G(^AUPNVSIT(VISIT,0)),U,11)=1 Q
 .. S CT=CT+1
 .. S BP=$P($G(^AUPNVMSR(N,0)),U,4),SYS=$P(BP,"/",1),DIA=$P(BP,"/",2)
 .. I SYS=""!(DIA="") Q
 .. I SYS<140!(DIA<90) Q
 .. S @BQGLB1@(BDFN)=$G(@BQGLB1@(BDFN))+1,FREF=9000010.01
 .. S @BQGLB1@(BDFN,"CRITERIA","Risk Factor-High Blood Pressure","V",VISIT,N)=$P($G(^AUPNVIST(VISIT,0)),U,1)_U_EXDT_U_N_U_FREF
 I $G(@BQGLB1@(BDFN))>1 D STOR(BDFN,"Risk Factor-High Blood Pressure",TMGLB)
 K @BQGLB1
 ;
 S HDATA=$NA(^TMP("BQIHDL",UID)),TMFRAME="",ENDT=""
 K @HDATA
 S FREF=9000010.09,GREF=$$ROOT^DILFD(FREF,"",1),TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 F TAX="BGP HDL LOINC CODES","DM AUDIT HDL TAX" D BLD^BQITUTL(TAX,TREF)
 S IEN=""
 F  S IEN=$O(@GREF@("AC",BDFN,IEN),-1) Q:IEN=""  D
 . S TIEN=$$GET1^DIQ(FREF,IEN,.01,"I") I TIEN="" Q
 . I '$D(@TREF@(TIEN)) Q
 . S SEX=$$GET1^DIQ(2,BDFN,.02,"I")
 . S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") Q:VISIT=""
 . I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 . S RESULT=$$GET1^DIQ(FREF,IEN,.04,"E") Q:RESULT=""
 . S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 Q:'VSDTM
 . I $G(TMFRAME)'="",VSDTM<ENDT Q
 . S @HDATA@(BDFN,VSDTM)=RESULT_"^"_SEX_"^"_VISIT_"^"_IEN_"^"_FREF
 S DATE="",DATE=$O(@HDATA@(BDFN,DATE),-1)
 I DATE'="" D
 . S RESULT=$P(@HDATA@(BDFN,DATE),"^",1)
 . S SEX=$P(@HDATA@(BDFN,DATE),"^",2)
 . S VISIT=$P(@HDATA@(BDFN,DATE),"^",3)
 . S IEN=$P(@HDATA@(BDFN,DATE),"^",4)
 . S FREF=$P(@HDATA@(BDFN,DATE),"^",5)
 . K @TMGLB
 . I SEX="M",RESULT<40 D
 .. S @TMGLB@(BDFN,"CRITERIA","Risk Factor-HDL Lab Test","V",VISIT,IEN)=VSDTM_U_EXDT_U_IEN_U_FREF
 .. D STOR(BDFN,"Risk Factor-HDL Lab Test",TMGLB)
 . I SEX="F",RESULT<45 D
 .. S @TMGLB@(BDFN,"CRITERIA","Risk Factor-HDL Lab Test","V",VISIT,IEN)=VSDTM_U_EXDT_U_IEN_U_FREF
 .. D STOR(BDFN,"Risk Factor-HDL Lab Test",TMGLB)
 K @HDATA
 ;
 ;High Cholesterol
 D PAT^BQITHCH(BDFN,.BTGLOB)
 ;
 ;Nephropathy
 D PAT^BQITNPH(BDFN,.BTGLOB)
 ;
 S DXOK=0
 S SEX=$$GET1^DIQ(2,BDFN,.02,"I")
 S AGE=$$AGE^BQIAGE(BDFN)
 I SEX="M" D
 . I AGE<19 K @BTGLOB@(BDFN) Q
 . I AGE>18,AGE<45,$G(@BTGLOB@(BDFN))<2 Q
 . I +$G(@BTGLOB@(BDFN))=0 Q
 . S DXOK=1
 I SEX="F" D
 . I AGE<19 K @BTGLOB@(BDFN) Q
 . I AGE>18,AGE<55,$G(@BTGLOB@(BDFN))<2 Q
 . I +$G(@BTGLOB@(BDFN))=0 Q
 . S DXOK=1
 ;
 Q DXOK
 ;
STOR(SDFN,CRIT,BQQGLB) ;EP - Store the patient's met criteria
 I $G(@BTGLOB@(SDFN))'<2 Q
 I $D(@BTGLOB@(SDFN,"CRITERIA",CRIT))>0 Q
 S @BTGLOB@(SDFN)=$G(@BTGLOB@(SDFN))+1
 ;S @BTGLOB@(SDFN,"CRITERIA",CRIT)=""
 I $D(@BQQGLB@(SDFN)) M @BTGLOB@(SDFN,"CRITERIA")=@BQQGLB@(SDFN,"CRITERIA")
 Q
