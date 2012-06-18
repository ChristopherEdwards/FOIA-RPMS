AGEVLM1 ; cmi/flag/maw - AGEV Eligibility Verification Events ; 
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 ;this routine has several entry points that are called by actions
 ;on the eligibility list template.  It processes entries from the
 ;INSURANCE ELIGIBILITY HOLDING file.
 ;
DELETE1 ;-- this will delete one insurance entry from a patient
 D SELECT
 Q:'$G(AGEVPIEN)
 S DIK="^AGEVH(",DA=AGEVPIEN
 D ^DIK
 Q
 ;
DELETEA ;-- this will delete all insurance entries from a patient
 S AGEVIDA=0
 F  S AGEVIDA=$O(^AGEVH("B",AGEVPLPT,AGEVIDA)) Q:'AGEVIDA  D
 . S DIK="^AGEVH(",DA=AGEVIDA
 . D ^DIK
 .Q
 Q
 ;
FILE1 ;-- this will file one entry into the appropriate insurance file
 D SELECT,PRS(AGEVPIEN)
 Q
 ;
PRS(AGEVPIEN) ;-- parse the information from the holding file
 ;we need to put some sort of verify information here
 Q
 I '$G(AGEVPIEN) W !,"Error Processing Entry" Q
 S AGEVP0=$G(^AGEVH(AGEVPIEN,0))
 I '$G(^AGEVH(AGEVPIEN,0)) W !,"Error Processing Entry" Q
 S AGEVP1=$G(^AGEVH(AGEVPIEN,1))
 I '$G(^AGEVH(AGEVPIEN,1)) W !,"Invalid Insurance Information" Q
 S AGEVP2=$G(^AGEVH(AGEVPIEN,2))
 S AGEVIIEN=$P(AGEVH0,U)
 S (AGEVICN,AGEVINSU)=$P(AGEVP0,U,2)
 I AGEVINSU="" W !,"Invalid Insurer, cannot update" Q
 S AGEVGN=$P(AGEVP1,U,4)
 S AGEVPED=$S($P($G(AGEVP2),U,3):$P(AGEVP2,U,3),1:$P(AGEVP1,U,11))
 S AGEVPED=$$FMTE^XLFDT(AGEVPED)
 S AGEVPEXD=$S($P($G(AGEVP2),U,4):$P(AGEVP2,U,4),1:$P(AGEVP1,U,12))
 S AGEVPEXD=$$FMTE^XLFDT(AGEVPEXD)
 S AGEVNOI=$P(AGEVP1,U)
 S AGEVIDOB=$P(AGEVP1,13)
 S AGEVSTR=$P(AGEVP1,6)
 S AGEVCTY=$P(AGEVP1,7)
 S AGEVST=$P(AGEVP1,8)
 S AGEVZP=$P(AGEVP1,9)
 S AGEVGNM=$P(AGEVP1,10)
 S AGEVCT=$P(AGEVP1,14)
 S AGEVSUF=$P(AGEVP1,16)
 S AGEVIID=$P(AGEVP1,3)
 S AGEVMST=$P(AGEVP1,15)
 S AGEVSX=$P(AGEVP1,5)
 S AGEVUP="PI"
 I AGEVINSU["MEDICARE" S AGEVUP="MCR"
 I AGEVINSU["MEDICAID" S AGEVUP="MCD"
 I AGEVINSU["RAILROAD" S AGEVUP="RR"
 D @AGEVUP(AGEVIIEN)
 Q
 ;
FILEA ;-- this will file all entries into the appropriate insurance files
 S AGEVIDA=0
 F  S AGEVIDA=$O(^AGEVH("B",AGEVPLPT,AGEVIDA)) Q:'AGEVIDA  D
 . D PRS(AGEVIDA)
 .Q
 Q
 ;
SELECT ;get record
 S AGEVPIEN=0
 D EN^VALM2(XQORNOD(0),"OS") ;this allows user to select an entry
 I '$D(VALMY) W !,"No entry selected." Q
 S AGEVP=$O(VALMY(0))
 I 'AGEVP KILL AGEVP,VALMY,XQORNOD W !,"No record selected." Q
 S (X,Y)=0
 F  S X=$O(^TMP("AGEV",$J,"IDX",X)) Q:X'=+X!(AGEVPIEN)  I $O(^TMP("AGEV",$J,"IDX",X,0))=AGEVP S Y=$O(^TMP("AGEV",$J,"IDX",X,0)),AGEVPIEN=^TMP("AGEV",$J,"IDX",X,Y)
 I '$D(^AGEVH(AGEVPIEN,0)) D  Q
 . W !,"Not a valid entry."
 . KILL APCDP
 . S APCDPIEN=0
 .Q
 D FULL^VALM1 ;give me full control of screen
 Q
 ;
MCR(AGEVIIEN) ;-- update medicare
 D MCR^AGEVINU(AGEVIIEN)
 Q
 ;
MCD(AGEVIIEN) ;-- update medicaid
 D MCD^AGEVINU(AGEVIIEN)
 Q
 ;
RR(AGEVIIEN) ;-- update railroad
 ;D RR^AGEVINU(AGEVIIEN)  ;not implemented yet
 Q
 ;
PI(AGEVIIEN) ;-- update private insurance and policy holder
 D PI^AGEVINU(AGEVIIEN)
 Q
