AMHGEGP ; IHS/CMI/MAW - AMHG Save Group Encounter 3/8/2009 7:41:21 PM ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**2**;JUN 18, 2010;Build 23
 ;
 ;
 ;
DEBUG(RETVAL,AMHSTR)  ;replace tag below to allow Serenji debug of GUI
 D DEBUG^%Serenji("TAG^AMHGU(.AMHRET,.AMHSTR)")
 Q
 ;
POV(D,RC,P,A2) ;EP -- add/modify pov
 N AMHDA,R
 S R="~"
 S AMHDA=0 F  S AMHDA=$O(A2(AMHDA)) Q:'AMHDA  D
 . N STR,PIEN,PCODE,PNARR
 . S STR=$G(A2(AMHDA))
 . S PIEN=$P(STR,R)
 . S PCODE=$P(STR,R,2)
 . S PNARR=$P(STR,R,3)
 . I $G(PNARR)]"" D
 ..S AMHN=$$FNDNARR^AMHGU(PNARR,1)
 . I D="A" D ADDPOV^AMHGEVF(PIEN,P,RC,AMHN) Q
 . I D="E" D  Q
 .. N AMHPREC
 .. S AMHPREC=$$FNDPOV^AMHGU(PIEN,RC)
 .. I 'AMHPREC D ADDPOV^AMHGEVF(PIEN,P,RC,AMHN) Q
 .. D EDITPOV^AMHGEVF(AMHPREC,AMHN)
 I D="E" D  Q
 . D DELPOV^AMHGEVF(RC,.A2)
 Q
 ;
GP(AMHIEN,DM,REC,PRG,GN,CL,NS,TOC,EL,ED,CS,ACT,AT,CC) ;EP -- group add/edit
 N AMHFDA,AMHIENS,AMHERRR,FL
 S AMHIENS=$S(DM="A":"+1,",1:REC_",")
 S FL=9002011.67
 S AMHFDA(FL,AMHIENS,.01)=ED
 S AMHFDA(FL,AMHIENS,.02)=PRG
 S AMHFDA(FL,AMHIENS,.03)=GN
 S AMHFDA(FL,AMHIENS,.05)=EL
 S AMHFDA(FL,AMHIENS,.14)=CL
 I DM="A" D  ;v4.0p2 ihs/cmi/maw added
 . S AMHFDA(FL,AMHIENS,.06)=CS
 . S AMHFDA(FL,AMHIENS,.07)=ACT
 . S AMHFDA(FL,AMHIENS,.08)=TOC
 . S AMHFDA(FL,AMHIENS,.11)=AT
 . S AMHFDA(FL,AMHIENS,.13)=DT
 . S AMHFDA(FL,AMHIENS,.15)=DUZ
 . S AMHFDA(FL,AMHIENS,1200)=CC
 I DM="A" D
 . ;S AMHFDA(FL,AMHIENS,.01)=ED
 . S AMHFDA(FL,AMHIENS,.04)=DT
 . S AMHFDA(FL,AMHIENS,.12)=DUZ
 . D UPDATE^DIE("","AMHFDA","AMHIENS","AMHERRR(1)")
 . I '$D(AMHERRR) S AMHIEN=$G(AMHIENS(1)) Q
 . S AMHER="0~Add Group"
 I DM="E" D
 . D FILE^DIE("K","AMHFDA","AMHERRR(1)")
 . I $D(AMHERRR) S AMHER="0~Edit Group"
 Q
 ;
MODPRV(P,D,RC,PAT,TYP) ;EP -- modify the provider based on data mode
 N AMHFDA,AMHIENS,AMHERRR,AMHPIEN
 S AMHIENS="+2,"_RC_","
 S AMHFDA(9002011.6711,AMHIENS,.01)=P
 S AMHFDA(9002011.6711,AMHIENS,.02)=TYP
 D UPDATE^DIE("","AMHFDA","AMHIENS","AMHERRR(1)")
 I $D(AMHERRR) S AMHER="0~Add "_$G(TYP)_" Provider"
 S AMHPIEN=$G(AMHIENS(2))
 Q
 ;
CLNPRV(RC) ;EP -- clean out provider multiple
 S DA(1)=RC
 S DIK="^AMHGROUP("_DA(1)_",11,"
 N PDA
 S PDA=0 F  S PDA=$O(^AMHGROUP(RC,11,PDA)) Q:'PDA  D
 . S DA=PDA D ^DIK
 Q
 ;
SP(D,RC,P,SP) ;EP -- file secondary providers from activity tab
 N ASP
 D ARRAY^AMHGU(.ASP,.SP)
 N AMHDA
 S AMHDA=0 F  S AMHDA=$O(ASP(AMHDA)) Q:'AMHDA  D
 . N PRV
 . S PRV=+$G(ASP(AMHDA))
 . D MODPRV(PRV,D,RC,P,"S")
 Q
 ;
GPOV(D,RC,PV) ;EP -- file the purpose of visit
 D CLNPV(RC)
 N PVDA,R
 S R="~"
 S PVDA=0 F  S PVDA=$O(PV(PVDA)) Q:'PVDA  D
 . N PVSTR,PVI,PVN,AMHN
 . S PVSTR=$G(PV(PVDA))
 . S PVI=$P(PVSTR,R)
 . S PVN=$P(PVSTR,R,3)
 . I $G(PVN)]"" D
 .. S AMHN=$$FNDNARR^AMHGU(PVN,1)
 . N AMHFDA,AMHIENS,AMHERRR,FL
 . S AMHIENS="+2,"_RC_","
 . S FL=9002011.6721
 . S AMHFDA(FL,AMHIENS,.01)=PVI
 . S AMHFDA(FL,AMHIENS,.02)=$G(AMHN)
 . D UPDATE^DIE("","AMHFDA","AMHIENS","AMHERRR(1)")
 . I $D(AMHERRR) S AMHER="0~Add Group POV" Q
 . S AMHPVIEN=$G(AMHIENS(2))
 Q
 ;
CLNPV(RC) ;EP -- clean the pov multiple out first
 S DA(1)=RC
 S DIK="^AMHGROUP("_DA(1)_",21,"
 N PDA
 S PDA=0 F  S PDA=$O(^AMHGROUP(RC,21,PDA)) Q:'PDA  D
 . S DA=PDA D ^DIK
 Q
 ;
PN(D,RC,PN,P) ;EP -- file the progress notes
 Q:$G(PN)=""
 N AMHWP
 D ARRAYT^AMHGU(.AMHWP,PN)  ;parse the text into an array
 N AMHFDA,AMHIENS,AMHERRR
 S AMHIENS=RC_","
 D WP^AMHGU(.AMHERRR,9002011.67,AMHIENS,3101,.AMHWP)
 Q
 ;
CPT(RC,CI) ;EP -- add a cpt
 D CLNCPT(RC)
 N CDA,R
 S R="~"
 S CDA=0 F  S CDA=$O(CI(CDA)) Q:'CDA  D
 . N CSTR,CIEN
 . S CSTR=$G(CI(CDA))
 . S CIEN=$P(CSTR,R)
 . N AMHFDA,AMHIENS,AMHERRR
 . S AMHIENS="+2,"_RC_","
 . S AMHFDA(9002011.6741,AMHIENS,.01)=CIEN
 . D UPDATE^DIE("","AMHFDA","AMHIENS","AMHERRR(1)")
 . I $D(AMHERRR) S AMHER="0~Add Activity CPT" Q
 . S AMHCIEN=$G(AMHIENS(2))
 Q
 ;
CLNCPT(RC) ;EP -- clean cpt multiple
 S DA(1)=RC
 S DIK="^AMHGROUP("_DA(1)_",41,"
 N CDA
 S CDA=0 F  S CDA=$O(^AMHGROUP(RC,41,CDA)) Q:'CDA  D
 . S DA=CDA D ^DIK
 Q
 ;
EDU(RC,EDU) ;EP -- file the education topics
 D CLNEDU(RC)
 N EDA,R
 S R="~"
 S EDA=0 F  S EDA=$O(EDU(EDA)) Q:'EDA  D
 . N ESTR,ED,L,LOU,CM,CP,ST,G,PR
 . S ESTR=$G(EDU(EDA))
 . S ED=$P(ESTR,R)
 . I ED]"" S ED=$O(^AUTTEDT("B",ED,0))  ;get internal value to file
 . S L=$P(ESTR,R,2)
 . S LOU=$$SCI^AMHGT(9002011.05,.08,$P(ESTR,R,3))
 . S CM=$P(ESTR,R,4)
 . S CP=$P(ESTR,R,5)
 . I $G(CP)]"" S CP=$O(^ICPT("B",CP,0))
 . S ST=$$SCI^AMHGT(9002011.05,.11,$P(ESTR,R,6))
 . S G=$P(ESTR,R,7)
 . S PR=$S($P(ESTR,R,8):$P(ESTR,R,8),1:DUZ)
 . N AMHFDA,AMHIENS,AMHERRR
 . S AMHIENS="+2,"_RC_","
 . S AMHFDA(9002011.6771,AMHIENS,.01)=ED
 . S AMHFDA(9002011.6771,AMHIENS,.02)=PR
 . S AMHFDA(9002011.6771,AMHIENS,.03)="G"
 . S AMHFDA(9002011.6771,AMHIENS,.04)=L
 . S AMHFDA(9002011.6771,AMHIENS,.05)=CP
 . S AMHFDA(9002011.6771,AMHIENS,.06)=LOU
 . S AMHFDA(9002011.6771,AMHIENS,.07)=G
 . S AMHFDA(9002011.6771,AMHIENS,.08)=ST
 . S AMHFDA(9002011.6771,AMHIENS,1101)=CM
 . D UPDATE^DIE("","AMHFDA","AMHIENS","AMHERRR(1)")
 . I $D(AMHERRR) S AMHER="0~Add Education Topic" Q
 . S AMHEIEN=$G(AMHIENS(2))
 Q
 ;
CLNEDU(RC) ;EP -- clean the edu topic multiple
 S DA(1)=RC
 S DIK="^AMHGROUP("_DA(1)_",71,"
 N EDA
 S EDA=0 F  S EDA=$O(^AMHGROUP(RC,71,EDA)) Q:'EDA  D
 . S DA=EDA D ^DIK
 Q
 ;
PATS(RC,PTS) ;EP -- add patients to multiple
 D CLNPAT(RC)
 N PTDA
 S PTDA=0 F  S PTDA=$O(PTS(PTDA)) Q:'PTDA  D
 . N PAT
 . S PAT=$G(PTS(PTDA))
 . N AMHFDA,AMHIENS,AMHERRR
 . S AMHIENS="+2,"_RC_","
 . S AMHFDA(9002011.6751,AMHIENS,.01)=PAT
 . D UPDATE^DIE("","AMHFDA","AMHIENS","AMHERRR(1)")
 Q
 ;
CLNPAT(RC) ;EP -- clean out the patient multiple
 S DA(1)=RC
 S DIK="^AMHGROUP("_DA(1)_",51,"
 N PDA
 S PDA=0 F  S PDA=$O(^AMHGROUP(RC,51,PDA)) Q:'PDA  D
 . S DA=PDA D ^DIK
 Q
 ;
MH(RC,MHR) ;EP -- add mhss recs to multiple
 D CLNMH(RC)
 N MHDA
 S MHDA=0 F  S MHDA=$O(MHR(MHDA)) Q:'MHDA  D
 . N MHI
 . S MHI=$G(MHR(MHDA))
 . N AMHFDA,AMHIENS,AMHERRR
 . S AMHIENS="+2,"_RC_","
 . S AMHFDA(9002011.6761,AMHIENS,.01)=MHI
 . D UPDATE^DIE("","AMHFDA","AMHIENS","AMHERRR(1)")
 Q
 ;
CLNMH(RC) ;EP -- clean out mental health
 S DA(1)=RC
 S DIK="^AMHGROUP("_DA(1)_",61,"
 N MDA
 S MDA=0 F  S MDA=$O(^AMHGROUP(RC,61,MDA)) Q:'MDA  D
 . S DA=MDA D ^DIK
 Q
 ;
