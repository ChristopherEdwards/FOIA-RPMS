BQIDCDF ;PRXM/HC/ALA-Predefined Panel Definition ; 24 Oct 2005  6:21 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
GET(DATA,PPIEN) ;EP -- **not called by any RPC at this time**
 ;
 ;Description
 ;  Get the definition of a predefined panel
 ;Input
 ;  PPIEN - Internal entry number of a predefined panel
 ;Output
 ;  DATA - Global reference to store data
 ;
 NEW UID,JJ,IEN,GLOBREF
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIDCDF",UID))
 K @DATA
 ;
 S JJ=0
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIDCDF D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S JJ=JJ+1,@DATA@(JJ)="I00010PREPANEL_IEN^T00030PANEL_NAME^T00250DESCRIPTION"_$C(30)
 S JJ=JJ+1
 S @DATA@(JJ)=PPIEN_"^"_$$GET1^DIQ(90506,PPIEN_",",.01,"E")
 S @DATA@(JJ)=@DATA@(JJ)_"^"_$$GET1^DIQ(90506,PPIEN_",",1,"E")_$C(30)
 ;
 S JJ=JJ+1,@DATA@(JJ)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 S JJ=JJ+1,@DATA@(JJ)=$C(31)
 Q
 ;
PP(SOURCE) ;EP - Get the IEN of a predefined panel
 ;
 ;Input
 ;  SOURCE - Predefined panel name
 ;
 NEW X,Y,DIC
 S DIC(0)="NZ",X=SOURCE,DIC="^BQI(90506,"
 D ^DIC
 Q +Y
 ;
PTYP(SOURCE,PNAME) ;EP - Return the parameter type
 ;
 ;Input
 ;  SOURCE - Predefined panel name
 ;  PNAME  - Parameter name
 ;
 NEW PPIEN,DA,IENS,BQN
 S PPIEN=$$PP(SOURCE)
 S BQN=$O(^BQI(90506,PPIEN,3,"B",PNAME,""))
 I BQN="" Q ""
 S DA(1)=PPIEN,DA=BQN,IENS=$$IENS^DILF(.DA)
 I $$GET1^DIQ(90506.03,IENS,.13,"I")=1 Q ""
 Q $$GET1^DIQ(90506.03,IENS,.02,"I")
 ;
FILN(SOURCE,PNAME) ;EP - Return the filenumber
 ;
 ;Input
 ;  SOURCE - Predefined panel name
 ;  PNAME  - Parameter name
 ;
 NEW PPIEN,DA,IENS,BQN
 S PPIEN=$$PP(SOURCE)
 S BQN=$O(^BQI(90506,PPIEN,3,"B",PNAME,""))
 I BQN="" Q ""
 S DA(1)=PPIEN,DA=BQN,IENS=$$IENS^DILF(.DA)
 Q $$GET1^DIQ(90506.03,IENS,.08,"I")
 ;
MPF(SOURCE,PNAME) ; EP - Return mapping flag
 ;Input
 ;  SOURCE - Predefined panel name
 ;  PNAME  - Parameter name
 ;
 NEW PPIEN,DA,IENS,BQN
 S PPIEN=$$PP(SOURCE)
 S BQN=$O(^BQI(90506,PPIEN,3,"B",PNAME,""))
 I BQN="" Q ""
 S DA(1)=PPIEN,DA=BQN,IENS=$$IENS^DILF(.DA)
 Q $$GET1^DIQ(90506.03,IENS,.11,"I")
 ;
MPN(SOURCE,PNAME) ; EP - Return map parameter name
 ;Input
 ;  SOURCE - Predefined panel name
 ;  PNAME  - Parameter name
 ;
 NEW PPIEN,DA,IENS,BQN
 S PPIEN=$$PP(SOURCE)
 S BQN=$O(^BQI(90506,PPIEN,3,"B",PNAME,""))
 I BQN="" Q ""
 S DA(1)=PPIEN,DA=BQN,IENS=$$IENS^DILF(.DA)
 Q $$GET1^DIQ(90506.03,IENS,.12,"E")
