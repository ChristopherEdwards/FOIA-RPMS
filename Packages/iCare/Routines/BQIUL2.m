BQIUL2 ;PRXM/HC/ALA-Miscellaneous BQI utilities ; 01 Nov 2007  2:20 PM
 ;;2.2;ICARE MANAGEMENT SYSTEM;**1**;Jul 28, 2011;Build 25
 ;
STC(FIL,FLD,VAL) ; EP - Find a value for a set of codes code
 ;  Input Parameters
 ;    FIL = FileMan File Number
 ;    FLD = FileMan Field Number
 ;    VAL = Code Value
 ;
 NEW VEDATA,VEQFL,VEVL,VALUE
 S VEDATA=$P(^DD(FIL,FLD,0),U,3),VEQFL=0
 ;
 F I=1:1 S VEVL=$P(VEDATA,";",I) Q:VEVL=""  D  Q:VEQFL
 . S VALUE=$P(VEVL,":",2) I VAL=$P(VEVL,":",1) S VEQFL=1
 ;
 Q VALUE
 ;
PTR(FIL,FLD,VVAL,VPEC) ;EP - Find alternate value for a pointer
 ;
 ;  Input Parameters
 ;    FIL = FileMan File #
 ;    FLD = FileMan Field #
 ;    VAL = Data Value
 ;    VPEC = Field from pointed to file, defaults to .01 if not defined
 ;
 NEW ARR1,VEDATA,VFILN,VEHDTA,VVALUE,VEPAR,ARR,PEC
 I $G(VPEC)="" S VPEC=.01
 ;
 I $G(VVAL)="" Q ""
 ;  Get the Pointer Global Reference
 D FIELD^DID(FIL,FLD,"","POINTER","VEPAR")
 S VEDATA=$G(VEPAR("POINTER")),VEHDTA="^"_VEDATA_"0)"
 S VFILN=$P($G(@VEHDTA),U,2),VFILN=$$UP^XLFSTR(VFILN)
 S VFILN=$$STRIP^XLFSTR(VFILN,"ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 K VEPAR
 ;
 D FIELD^DID(VFILN,VPEC,"N","GLOBAL SUBSCRIPT LOCATION","ARR")
 S ARR1=ARR("GLOBAL SUBSCRIPT LOCATION")
 ;
 I VVAL'="" S VEHDTA="^"_VEDATA_VVAL_","_$P(ARR1,";",1)_")"
 ;
 S PEC=$P(ARR1,";",2)
 I VVAL'="" S VVALUE=$P($G(@VEHDTA),U,PEC)
 Q VVALUE
 ;
PRIMVPRV(PXUTVST) ; EP - Returns the primary provider if there is one
 ; for the passed visit otherwise returns 0.
 N PXCATEMP
 S PXCATEMP=$$PRIMSEC(PXUTVST,"^AUPNVPRV",0,4)
 Q $S(PXCATEMP>0:$P(^AUPNVPRV(PXCATEMP,0),"^"),1:0)
 ;
PRIMVPOV(PXUTVST) ; EP - Returns the primary diagnosis if there is one
 ; for the passed visit otherwise returns 0.
 N PXCATEMP
 S PXCATEMP=$$PRIMSEC(PXUTVST,"^AUPNVPOV",0,12)
 Q $S(PXCATEMP>0:$P(^AUPNVPOV(PXCATEMP,0),"^"),1:0)
 ;
PRIMSEC(PXUTVST,PXUTAUPN,PXUTNODE,PXUPIECE) ; EP - Returns ien of the primary one
 ; if there is one for the passed visit otherwise returns 0.
 ; Parameters:
 ;   PXUTVST   Pointer to the visit
 ;   PXUTAUPN  V-File global e.g. "^AUPNVPRV"
 ;   PXUTNODE  The node that the Primary/Secondary field is on
 ;   PXUPIECE  The piece of the Primary/Secondary field
 ;
 N PXUTPRIM
 S PXUTPRIM=0
 F  S PXUTPRIM=$O(@(PXUTAUPN_"(""AD"",PXUTVST,PXUTPRIM)")) Q:PXUTPRIM'>0  I "P"=$P(@(PXUTAUPN_"(PXUTPRIM,PXUTNODE)"),"^",PXUPIECE) Q
 Q +PXUTPRIM
 ;
