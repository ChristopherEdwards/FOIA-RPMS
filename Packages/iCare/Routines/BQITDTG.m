BQITDTG ;VNGT/HS/ALA-Update one tag ; 18 Aug 2008  12:15 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
POP(TAG) ;EP - Update a tag by population
 ;
 S TAG=$G(TAG,""),UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 I TAG'?.N S TAG=$$GDXN^BQITUTL(TAG)
 S BQTN=TAG
 S THCFL=+$P(^BQI(90506.2,BQTN,0),U,10)
 ; If hierachical, need to redo the higher order tags because
 ; the actual tag being recalculated is dependent on whether
 ; there is a higher active tag or not.
 I THCFL D
 . S HCIEN=$O(^BQI(90506.2,BQTN,4,"B",BQTN,""))
 . S ORD=$P(^BQI(90506.2,BQTN,4,HCIEN,0),U,2),HORD=ORD,QFL=0
 . F  S HORD=$O(^BQI(90506.2,BQTN,4,"AC",HORD)) Q:HORD=ORD  D  Q:QFL
 .. S HIEN=$O(^BQI(90506.2,BQTN,4,"AC",HORD,""))
 .. S HTAG=$P(^BQI(90506.2,BQTN,4,HIEN,0),U,1)
 .. D PTAG(HTAG)
 I 'THCFL D PTAG(TAG)
 Q
 ;
PTAG(BQTN) ; EP
 ; If the category is marked as inactive, ignore it
 I $$GET1^DIQ(90506.2,BQTN_",",.03,"I") Q
 ; If the category is a subdefinition, ignore it
 I $$GET1^DIQ(90506.2,BQTN_",",.05,"I")=1 Q
 S BQDEF=$$GET1^DIQ(90506.2,BQTN_",",.01,";E")
 S BQEXEC=$$GET1^DIQ(90506.2,BQTN_",",1,"E")
 S BQPRG=$$GET1^DIQ(90506.2,BQTN_",",.04,"E")
 ;
 ; Set the taxonomy array from the file definition
 S BQREF="BQIRY" K @BQREF
 D ARY^BQITUTL(BQDEF,BQREF)
 S BQGLB=$NA(^TMP("BQIPOP",UID))
 K @BQGLB
 ;
 ; Call the populate category code
 S PRGM="POP^"_BQPRG_"(BQREF,BQGLB)"
 D @PRGM
 ;
 ; Check if patient tagged but not found in criteria anymore
 S IEN=""
 F  S IEN=$O(^BQIREG("B",BQTN,IEN)) Q:IEN=""  D
 . S DFN=$P(^BQIREG(IEN,0),U,2)
 . I '$D(@BQGLB@(DFN)) D
 .. D NCR^BQITDUTL(DFN,BQTN)
 .. ; Remove previous criteria
 .. NEW DA,DIK
 .. S DA(2)=DFN,DA(1)=BQTN,DA=0,DIK="^BQIPAT("_DA(2)_",20,"_DA(1)_",1,"
 .. F  S DA=$O(^BQIPAT(DFN,20,TAG,1,DA)) Q:'DA  D ^DIK
 ; File the patients who met criteria
 S DFN=0
 F  S DFN=$O(@BQGLB@(DFN)) Q:DFN=""  D FIL^BQITASK(BQGLB,DFN)
 Q
 ;
PAT(TAG,DFN) ; EP - Update a tag by patient
 S TAG=$G(TAG,""),UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 I TAG'?.N S TAG=$$GDXN^BQITUTL(TAG)
 S BQTN=TAG
 S THCFL=+$P(^BQI(90506.2,BQTN,0),U,10)
 ; If hierachical, need to redo the higher order tags because
 ; the actual tag being recalculated is dependent on whether
 ; there is a higher active tag or not.
 I THCFL D
 . S HCIEN=$O(^BQI(90506.2,BQTN,4,"B",BQTN,""))
 . S ORD=$P(^BQI(90506.2,BQTN,4,HCIEN,0),U,2),HORD=ORD,QFL=0
 . F  S HORD=$O(^BQI(90506.2,BQTN,4,"AC",HORD)) Q:HORD=ORD  D  Q:QFL
 .. S HIEN=$O(^BQI(90506.2,BQTN,4,"AC",HORD,""))
 .. S HTAG=$P(^BQI(90506.2,BQTN,4,HIEN,0),U,1)
 .. D ITAG(HTAG,DFN)
 I 'THCFL D ITAG(TAG,DFN)
 Q
 ;
ITAG(BQTN,DFN) ; EP
 ; If the category is marked as inactive, ignore it
 I $$GET1^DIQ(90506.2,BQTN_",",.03,"I") Q
 ; If the category is a subdefinition, ignore it
 I $$GET1^DIQ(90506.2,BQTN_",",.05,"I")=1 Q
 S BQDEF=$$GET1^DIQ(90506.2,BQTN_",",.01,"E")
 S BQEXEC=$$GET1^DIQ(90506.2,BQTN_",",1,"E")
 S BQPRG=$$GET1^DIQ(90506.2,BQTN_",",.04,"E")
 ;
 S BQTGLB=$NA(^TMP("BQIPDXC",UID))
 K @BQTGLB
 ;
 ; Call the individual patient dx category code
 S PRGM="S VOK=""$$PAT^""_BQPRG_""(BQDEF,.BQTGLB,DFN)"""
 X PRGM
 ;
 ; File the returned data
 D CHK^BQITDPAT(BQTGLB,DFN)
 Q
