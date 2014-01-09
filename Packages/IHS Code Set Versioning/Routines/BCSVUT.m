BCSVUT ;IHS/MSC/BWF - CSV Utility ;20-Mar-2008 13:34;AA
 ;;1.0;BCSV;;APR 23, 2010
 ;=================================================================
 ; Utility Routine
 Q
LCKFILES ;
 N DD
 F DD=80.3,80.2,81.11,80.1,80,81,81.3,9999999.88 D
 .S $P(^DD(DD,0,"DI"),"^",2)="Y"
 Q
UNLCKFLS ;
 N DD
 F DD=80.3,80.2,81.11,80.1,80,81,81.3,9999999.88 D
 .S $P(^DD(DD,0,"DI"),"^",2)="N"
 Q
UPDFWT ; Update IENS for Fiscal Weights and Trims on file 80.2
 N ICDIEN,FYIEN,NEWFYIEN,LASTITEM
 S ICDIEN=0
 F  S ICDIEN=$O(^ICD(ICDIEN)) Q:'ICDIEN  D
 .S FYIEN=0 F  S FYIEN=$O(^ICD(ICDIEN,"FY",FYIEN)) Q:'FYIEN  D
 ..S NEWFYIEN=$$CONVERT(FYIEN)
 ..I NEWFYIEN'?7N Q
 ..M ^ICD(ICDIEN,"FY",NEWFYIEN)=^ICD(ICDIEN,"FY",FYIEN)
 ..K ^ICD(ICDIEN,"FY",FYIEN)
 ..S LASTITEM=$O(^ICD(ICDIEN,"FY",9999999),-1)
 ..S $P(^ICD(ICDIEN,"FY",0),U,2)=LASTITEM
 Q
CONVERT(IEN) ;
 ; Convert IEN from IHS format into VA format.
 I IEN<100&(IEN>7) S IEN=2_IEN_0000 Q IEN
 I (IEN=0)!((IEN>0)&(IEN<8)) S IEN=3_IEN_0000 Q IEN
 Q
 ; Input
 ;    AGE - Value passed in to be converted into days (passed in value is in years)
AGECON(AGE) ;
 I 'AGE Q ""
 Q (AGE*365)
 ; Input
 ;    AGE - Value passed in to be converted into days (passed in value is in years)
 ;    IEN - IEN of the entry being evaluated
 ;    FLD - Field Number for file 80. This will be used to determine which IHS field the data should come from.
AGECON80(AGE,IEN,FLD) ;
 N IHSFLD,IHSAGE
 S IHSFLD=$S(FLD=14:9999999.01,FLD=15:9999999.02,1:0)
 Q:'IHSFLD ""
 S IHSAGE=$$GET1^DIQ(80,IEN,IHSFLD,"I")
 I IHSAGE Q IHSAGE
 Q:'AGE ""
 S IHSAGE=$$AGECON(AGE)
 Q IHSAGE
UPDBEFY ; Update Breakeven Fiscal Year/Quarter IEN'S in file 80.2
 N ICDIEN,BEFYIEN,NEWBEIEN,LASTITEM
 S ICDIEN=0
 F  S ICDIEN=$O(^ICD(ICDIEN)) Q:'ICDIEN  D
 .S BEFYIEN=0 F  S BEFYIEN=$O(^ICD(ICDIEN,"BE",BEFYIEN)) Q:'BEFYIEN  D
 ..S NEWBEIEN=$$NEWBEIEN(BEFYIEN)
 ..I NEWBEIEN'?5N Q
 ..M ^ICD(ICDIEN,"BE",NEWBEIEN)=^ICD(ICDIEN,"BE",BEFYIEN)
 ..K ^ICD(ICDIEN,"BE",BEFYIEN)
 ..S LASTITEM=$O(^ICD(ICDIEN,"BE",9999999),-1)
 ..S $P(^ICD(ICDIEN,"BE",0),U,2)=LASTITEM
 Q
NEWBEIEN(BEIEN) ;
 N NEWBEIEN,NEWFYIEN,NEWIEN
 I BEIEN>799 S NEWIEN=19_BEIEN
 I BEIEN<800 S NEWIEN=10_BEIEN
 Q BEIEN
 ;
 ;    Input   FILE - File number for moving data into the versioning multiple
 ;            DAT - Data indicating which fields need to be pulled, and where they will be placed.
 ;            INACT - Inactivate this entry?
 ;                    0 or "" - Inactivate
 ;                    1 - Skip inactivation
 ;                    
VERSION(IEN,FUNC,INACT) ; Place information into versioning mutiples for unmapped entries.
 ;    Entries that are not mapped will be inactivated.
 I FUNC="" Q
 S INACT=+$G(INACT)
 S FUNC=FUNC_"("_IEN_","_INACT_")"
 D @FUNC
 Q
 ; INPUT  IEN   - IEN to entry in target file
 ;        INACT - Inactive this entry?
 ;                0 or "" - Inactive
 ;                1 - skip inactivation
VER801(IEN,INACT) ;
 N PROC,DESC,ACTDT,FDA,NEWIEN
 ; Get procedure name and activation date for versioned information.
 S PROC=$$GET1^DIQ(80.1,IEN,4,"E")
 S DESC=$$GET1^DIQ(80.1,IEN,10,"E")
 S ACTDT=$$GET1^DIQ(80.1,IEN,12,"I")
 I 'ACTDT S ACTDT=DT
 S FDA(80.167,"+1,"_IEN_",",.01)=ACTDT
 D UPDATE^DIE(,"FDA","NEWIEN") K FDA
 I $D(NEWIEN) D
 .S FDA(80.167,NEWIEN(1)_IEN_",",1)=PROC
 .D FILE^DIE(,"FDA")
 K FDA,NEWIEN
 S FDA(80.168,"+1,"_IEN_",",.01)=ACTDT
 D UPDATE^DIE(,"FDA","NEWIEN")
 I $D(NEWIEN) D
 .S FDA(80.168,NEWIEN(1)_","_IEN_",",1)=DESC
 .D UPDATE^DIE(,"FDA")
 K FDA,NEWIEN
 I $G(INACT)!($D(^XCSV("ICD0","MAP","Z",IEN))) D FILE^DIE(,"FDA") Q
 S FDA(80.1,IEN_",",100)=1
 I '$$GET1^DIQ(80.1,IEN,102,"I") S FDA(80.1,IEN_",",102)=DT
 D FILE^DIE(,"FDA")
 Q
 ; INPUT  IEN   - IEN to entry in target file
 ;        INACT - Inactive this entry?
 ;                0 or "" - Inactive
 ;                1 - skip inactivation
VER80(IEN,INACT) ;
 N DIAG,DESC,ACTDT,FDA,NEWIEN,EFFDT
 S DIAG=$$GET1^DIQ(80,IEN,3,"E")
 S DESC=$$GET1^DIQ(80,IEN,10,"E")
 S (ACTDT,EFFDT)=$$GET1^DIQ(80,IEN,16,"I")
 I 'ACTDT S ACTDT=DT,EFFDT=2700101
 S FDA(80.066,"+1,"_IEN_",",.01)=EFFDT
 D UPDATE^DIE(,"FDA","NEWIEN") K FDA
 I $D(NEWIEN) D
 .S FDA(80.066,NEWIEN(1)_","_IEN_",",.02)=$S(INACT=1:1,1:0)
 S FDA(80.067,"+1,"_IEN_",",.01)=ACTDT
 D UPDATE^DIE(,"FDA","NEWIEN") K FDA
 I $D(NEWIEN) D
 .S FDA(80.067,NEWIEN(1)_","_IEN_",",1)=DIAG
 .D FILE^DIE(,"FDA")
 K FDA,NEWIEN
 S FDA(80.068,"+1,"_IEN_",",.01)=ACTDT
 D UPDATE^DIE(,"FDA","NEWIEN") K FDA
 I $D(NEWIEN) D
 .S FDA(80.068,NEWIEN(1)_","_IEN_",",1)=DESC
 .D UPDATE^DIE(,"FDA")
 K FDA,NEWIEN
 I $G(INACT)!($D(^XCSV("ICD9","MAP","Z",IEN))) D FILE^DIE(,"FDA") Q
 S FDA(80,IEN_",",100)=1
 I '$$GET1^DIQ(80,IEN,102,"I") S FDA(80,IEN_",",102)=DT
 D FILE^DIE(,"FDA")
 Q
 ; INPUT  IEN (required)   - IEN to entry in target file
 ;        INACT (optional) - Inactive this entry?
 ;                         0 or "" - Inactive
 ;                         1 - skip inactivation
VER802(IEN,INACT) ;
 N DESC,FDA,ACTDT,NEWIEN,DNODE,LOOP
 S DNODE=0 F  S DNODE=$O(^ICD(IEN,1,DNODE)) Q:'DNODE  D
 .S DESCARY(DNODE)=$G(^ICD(IEN,1,DNODE,0))
 S ACTDT=$$GET1^DIQ(80.2,IEN,14,"I")
 I 'ACTDT S ACTDT=DT
 S FDA(80.268,"+1,"_IEN_",",.01)=ACTDT
 D UPDATE^DIE(,"FDA","NEWIEN")
 I $D(NEWIEN) D
 .S LOOP=0
 .F  S LOOP=$O(DESCARY(LOOP)) Q:'LOOP  D
 ..S FDA(80.2681,"+"_LOOP_","_NEWIEN(1)_","_IEN_",",.01)=$G(DESCARY(LOOP))
 .D UPDATE^DIE(,"FDA")
 K FDA,NEWIEN
 I $G(INACT)!($D(^XCSV("ICD","MAP","Z",IEN))) D FILE^DIE(,"FDA") Q
 S FDA(80.2,IEN_",",15)=1
 I '$$GET1^DIQ(80.2,IEN,16,"I") S FDA(80.2,IEN_",",16)=DT
 D FILE^DIE(,"FDA")
 Q
VER803(IEN,INACT) ;
 ; Nothing to do here.
 Q
 ; INPUT  IEN (required)   - IEN to entry in target file
 ;        INACT (optional) - Inactive this entry?
 ;                         0 or "" - Inactive
 ;                         1 - skip inactivation
VER81(IEN,INACT) ;
 N SHNAME,DESCARY,ACTDT,FDA,NEWIEN,LOOP,DNODE,NEWIEN
 S SHNAME=$$GET1^DIQ(81,IEN,2,"E")
 S DNODE=0 F  S DNODE=$O(^ICPT(IEN,"D",DNODE)) Q:'DNODE  D
 .S DESCARY(DNODE)=$G(^ICPT(IEN,"D",DNODE,0))
 S ACTDT=$$GET1^DIQ(81,IEN,8,"I")
 I 'ACTDT S ACTDT=DT
 S FDA(81.061,"+1,"_IEN_",",.01)=ACTDT
 D UPDATE^DIE(,"FDA","NEWIEN")
 I $D(NEWIEN) D
 .S FDA(81.061,NEWIEN(1)_IEN_",",1)=SHNAME
 .D FILE^DIE(,"FDA")
 K FDA,NEWIEN
 S FDA(81.062,"+1,"_IEN_",",.01)=ACTDT
 D UPDATE^DIE(,"FDA","NEWIEN") K FDA
 I $D(NEWIEN) D
 .S LOOP=0
 .F  S LOOP=$O(DESCARY(LOOP)) Q:'LOOP  D
 ..S FDA(81.621,"+"_LOOP_","_NEWIEN(1)_","_IEN_",",.01)=$G(DESCARY(LOOP))
 D UPDATE^DIE(,"FDA") K FDA
 I $G(INACT)!($D(^XCSV("ICPT","MAP","Z",IEN))) D FILE^DIE(,"FDA") Q
 S FDA(81,IEN_",",5)=1
 I '$$GET1^DIQ(81,IEN,7,"I") S FDA(81,IEN_",",7)=DT
 D FILE^DIE(,"FDA")
 Q
VER811(IEN,INACT) ;
 ; Nothing to do.
 Q
 ; INPUT  IEN (required)   - IEN to entry in target file
 ;        INACT (optional) - Inactive this entry?
 ;                         0 or "" - Inactive
 ;                         1 - skip inactivation
VER813(IEN,INACT) ;
 N NAME,DESC,ACTDT,FDA,NEWIEN
 S NAME=$$GET1^DIQ(81.3,IEN,.02,"E")
 S DNODE=0 F  S DNODE=$O(^DIC(81.3,IEN,"D",DNODE)) Q:'DNODE  D
 .S ^TMP($J,DNODE,0)=$G(^DIC(81.3,IEN,"D",DNODE,0))
 S ACTDT=$$GET1^DIQ(81.3,IEN,8,"I")
 I 'ACTDT S ACTDT=DT
 S FDA(81.361,"+1,"_IEN_",",.01)=ACTDT
 D UPDATE^DIE(,"FDA","NEWIEN")
 I $D(NEWIEN) D
 .S FDA(81.361,NEWIEN(1)_IEN_",",1)=NAME
 .D FILE^DIE(,"FDA",)
 K FDA,NEWIEN
 S FDA(81.362,"+1,"_IEN_",",.01)=ACTDT
 D UPDATE^DIE(,"FDA","NEWIEN") K FDA
 ; set up wp field using WP^DIE
 I '$D(NEWIEN) Q
 D WP^DIE(81.362,NEWIEN(1)_","_IEN_",",1,"","^TMP($J)")
 Q
 ;
UPDCODES ;
 N FIL,QUIT,LINE,DAT,FILDAT,VADAT,VAXLOC,FDA,VAXFIL,NEWIEN,J,VAIEN,DA,DIK,FLD
 N GLOBPATH,AGELOW,AGEHI
 S QUIT=0
 F J=1:1 D  Q:QUIT
 .S LINE=$T(FILES+J^BCSVMP)
 .S DAT=$P(LINE,";;",2)
 .I DAT="" S QUIT=1 Q
 .S FILDAT=$P(DAT,"||"),VADAT=$P(FILDAT,"/",2)
 .S VAXLOC=$P(VADAT,";"),VAXFIL=$P(VADAT,";",2)
 .I VAXLOC["|" S GLOBPATH="^"_$TR(VAXLOC,"|","(")_")"
 .E  S GLOBPATH="^"_VAXLOC
 .S VAIEN=0
 .F  S VAIEN=$O(^XCSV(VAXLOC,"DATA",VAIEN)) Q:'VAIEN  D
 ..; If the VAIEN has an entry that has been mapped to it (i.e, the "B" x-ref exists), quit.
 ..K NEWIEN
 ..S FLD=$P($G(^XCSV(VAXLOC,"DATA",VAIEN,0)),"^")
 ..I $D(^XCSV(VAXLOC,"MAP","B",VAIEN)) Q
 ..; Add the new entry
 ..S FDA(VAXFIL,"+1,",.01)=FLD
 ..I VAXFIL=80 S FDA(VAXFIL,"+1,",3)="HOLD TEXT"
 ..I VAXFIL=81.3 S FDA(VAXFIL,"+1,",.02)="HOLD TEXT"
 ..I VAXFIL=80.2 S NEWIEN(1)=$P(FLD,"DRG",2)
 ..I VAXFIL=81 D
 ...S NEWIEN(1)=$S(FLD?5N:+FLD,FLD?1U4N:$A($E(FLD))_$E(FLD,2,5),1:1000000)
 ...I $G(NEWIEN(1))=1000000 N I S I=999999 F  S I=$O(^ICPT(I)) Q:I<999999  S NEWIEN(1)=I+1
 ..D UPDATE^DIE(,"FDA","NEWIEN") K FDA
 ..; Use the new IEN value to merge data
 ..Q:'$G(NEWIEN(1))
 ..M @GLOBPATH@(NEWIEN(1))=^XCSV(VAXLOC,"DATA",VAIEN)
 ..S ^XCSV(VAXLOC,"MAP","B",VAIEN)=NEWIEN(1),^XCSV(VAXLOC,"NEW",NEWIEN(1))=""
 ..; Set the "Z" x-ref to hold a list of entries that are new.
 ..; Used to resolve pointers in the next step.
 ..S ^XCSV(VAXLOC,"MAP","Z",NEWIEN(1))=""
 ..; Reset the ptr value for fld 3 in 81.1
 ..S (AGELOW,AGEHI)=0
 ..I VAXFIL=80 D
 ...S AGELOW=$P($G(^ICD9(NEWIEN(1),0)),U,14) I AGELOW S $P(^ICD9(NEWIEN(1),0),U,14)=$$AGECON(AGELOW)
 ...S AGEHI=$P($G(^ICD9(NEWIEN(1),0)),U,15) I AGEHI S $P(^ICD9(NEWIEN(1),0),U,15)=$$AGECON(AGEHI)
 ..I VAXFIL=81 D
 ...S AGELOW=$P($G(^ICPT(NEWIEN(1),10)),U) I AGELOW S $P(^ICPT(NEWIEN(1),10),U)=$$AGECON(AGELOW)
 ...S AGEHI=$P($G(^ICPT(NEWIEN(1),10)),U,2) I AGEHI S $P(^ICPT(NEWIEN(1),10),U,2)=$$AGECON(AGEHI)
 ..I VAXFIL=81.1 D
 ...S CURPTR=$$GET1^DIQ(81.1,NEWIEN(1),.01,"I")
 ...S FDA(VAXFIL,NEWIEN(1),3)=$G(^XCSV(VAXLOC,"MAP",CURPTR)) D FILE^DIE(,"FDA") K FDA
 ..I GLOBPATH[")" S DIK=$P(GLOBPATH,")")_","
 ..E  S DIK=GLOBPATH_"("
 ..S DA=NEWIEN(1) D IX1^DIK
 ..K NEWIEN,DA,DIK
 Q
RPALL ;
 D RP802,RP801,RP80
 Q
RP802 ;
 N IEN,SUBIEN,OVAL,NVAL
 S IEN=0 F  S IEN=$O(^ICD(IEN)) Q:'IEN  D
 .S SUBIEN=0 F  S SUBIEN=$O(^ICD(IEN,66,SUBIEN)) Q:'SUBIEN  D
 ..S OVAL=$$GET1^DIQ(80.266,SUBIEN_","_IEN,.05,"I")
 ..Q:'OVAL
 ..S NVAL=$G(^XCSV("ICD","MAP","B",OVAL))
 ..S FDA(80.266,SUBIEN_","_IEN_",",.05)=NVAL D FILE^DIE(,"FDA") K FDA
 Q
RP801 ;
 N IEN,DATA,LOOP,MDCPTR,NEWPTR,NEWDAT,VAL,NVAL,SIEN1,SIEN2,SIEN3,SIEN2PTR,SIEN3PTR,NIEN2PTR,NIEN3PTR,CNT
 S IEN=0 F  S IEN=$O(^ICD0(IEN)) Q:'IEN  D
 .; Correct pointers in field 7 multiple
 .K DATA,DATA71,NEWDAT
 .M DATA71=^ICD0(IEN,2)
 .M DATA=^ICD0(IEN,"MDC")
 .S LOOP=0 F  S LOOP=$O(DATA(LOOP)) Q:'LOOP  D
 ..S MDCPTR=$G(DATA(LOOP,0)),NEWPTR=$G(^XCSV("ICM","MAP","B",LOOP))
 ..S NEWDAT(0)=DATA(0)
 ..Q:'NEWPTR
 ..S NEWDAT(NEWPTR,0)=NEWPTR
 ..F I=1:1:6 D
 ...I '$D(DATA(LOOP,"DRG")) Q
 ...S VAL=$P(DATA(LOOP,"DRG"),U,I) Q:VAL=""
 ...S NVAL=$G(^XCSV("ICD","MAP","B",VAL))
 ...Q:NVAL=""
 ...S $P(NEWDAT(NEWPTR,"DRG"),U,I)=NVAL
 .S Z2=$O(^ICD0(IEN,"MDC",""),-1)
 .S CNT=0
 .S CNTLP=0 F  S CNTLP=$O(^ICD0(IEN,"MDC",CNTLP)) Q:'CNTLP  D
 ..S CNT=CNT+1
 .S:$D(^ICD0(IEN,"MDC")) $P(NEWDAT(0),U,4)=CNT
 .; Now handle field 66
 .S SIEN=0 F  S SIEN=$O(^ICD0(IEN,66,SIEN)) Q:'SIEN  D
 ..F I=1:1:5 D
 ...Q:'$D(^ICD0(IEN,66,SIEN,"DRG"))
 ...S VAL=$P(^ICD0(IEN,66,SIEN,"DRG"),U,I) Q:VAL=""
 ...S NVAL=$G(^XCSV("ICD","MAP","B",VAL))
 ...S $P(^ICD0(IEN,66,SIEN,"DRG"),U,I)=NVAL
 ..; Now handle field 71 and all subfiles
 .S SIEN1=0 F  S SIEN1=$O(DATA71(SIEN1)) Q:'SIEN1  D
 ..S SIEN2=0 F  S SIEN2=$O(DATA71(SIEN1,1,SIEN2)) Q:'SIEN2  D
 ...S SIEN2PTR=$G(DATA71(SIEN1,1,SIEN2,0))
 ...S NIEN2PTR=$G(^XCSV("ICM","MAP","B",SIEN2PTR))
 ...; If the pointer values are the same, do not change anything.
 ...;Q:NIEN2PTR=SIEN2PTR
 ...K DATA71(SIEN1,1,"B",SIEN2PTR,SIEN2)
 ...I 'NIEN2PTR K DATA71(SIEN1,1,SIEN2) Q
 ...S DATA71(SIEN1,1,SIEN2,0)=NIEN2PTR
 ...S DATA71(SIEN1,1,"B",NIEN2PTR,SIEN2)=""
 ...S SIEN3=0 F  S SIEN3=$O(DATA71(SIEN1,1,SIEN2,1,SIEN3)) Q:'SIEN3  D
 ....S SIEN3PTR=$G(DATA71(SIEN1,1,SIEN2,1,SIEN3,0))
 ....S NIEN3PTR=$G(^XCSV("ICD","MAP","B",SIEN3PTR))
 ....I 'NIEN3PTR K DATA71(SIEN1,1,SIEN2,1,SIEN3) Q
 ....I SIEN3PTR=NIEN3PTR Q
 ....S DATA71(SIEN1,1,SIEN2,1,SIEN3,0)=NIEN3PTR
 ....K DATA71(SIEN1,1,SIEN2,1,"B",SIEN3PTR,SIEN3)
 ....S DATA71(SIEN1,1,SIEN2,1,"B",NIEN3PTR,SIEN3)=""
 .S:$D(^ICD0(IEN,"MDC")) ($P(NEWDAT(0),U,2),$P(NEWDAT(0),U,3))=$O(NEWDAT(""),-1)
 .; Merge updated array back into multiple.
 .K ^ICD0(IEN,"MDC") M ^ICD0(IEN,"MDC")=NEWDAT
 .K ^ICD0(IEN,2) M ^ICD0(IEN,2)=DATA71
 Q
RP80 ;
 N IEN,ZNODE,CNT,NPTR,P3,I,J,SIEN,NIEN,DATA,ODAT,NPTR,OPTR,SIEN2,VAL,NVAL,SSCNT
 S IEN=0 F  S IEN=$O(^ICD9(IEN)) Q:'IEN  D
 .F J="N","R"  D
 ..I '$D(^ICD9(IEN,J)) Q
 ..I '$O(^ICD9(IEN,J,0)) Q
 ..S ZNODE=$G(^ICD9(IEN,J,0))
 ..S ^TMP("BCSVUT",$J,0)=ZNODE
 ..S (SIEN,CNT)=0 F  S SIEN=$O(^ICD9(IEN,J,SIEN)) Q:'SIEN  D
 ...S NPTR=$G(^XCSV("ICD9","MAP","B",SIEN)) Q:'NPTR
 ...S CNT=CNT+1
 ...S ^TMP("BCSVUT",$J,NPTR,0)=NPTR,^TMP("BCSVUT",$J,"B",NPTR,NPTR)=""
 ..S P3=$O(^TMP("BCSVUT",$J,"B"),-1)
 ..S:$D(^ICD9(IEN,J)) $P(^TMP("BCSVUT",$J,0),U,3)=P3,$P(^TMP("BCSVUT",$J,0),U,4)=CNT
 ..K ^ICD9(IEN,J)
 ..M ^ICD9(IEN,J)=^TMP("BCSVUT",$J)
 ..K ^TMP("BCSVUT",$J)
 .S SIEN=0 F  S SIEN=$O(^ICD9(IEN,2,SIEN)) Q:'SIEN  D
 ..S OPTR=$G(^ICD9(IEN,2,SIEN,0))
 ..S NPTR=$G(^XCSV("ICD9","MAP","B",OPTR))
 ..I NPTR=OPTR Q
 ..I NPTR="" K ^ICD9(IEN,2,SIEN),^ICD9("ACC",IEN,OPTR) Q
 ..S ^ICD9(IEN,2,SIEN,0)=NPTR
 ..K ^ICD9("ACC",IEN,OPTR) S ^ICD9("ACC",IEN,NPTR)=""
 .S SSCNT=0
 .S SIEN=0 F  S SIEN=$O(^ICD9(IEN,2,SIEN)) Q:'SIEN  D
 ..S SSCNT=SSCNT+1
 .S:$D(^ICD9(IEN,2)) $P(^ICD9(IEN,2,0),U,3)=-$O(^ICD9(IEN,2,"")),$P(^ICD9(IEN,2,0),U,4)=$G(SSCNT)
 .S SIEN=0 F  S SIEN=$O(^ICD9("ACC",IEN,SIEN)) Q:'SIEN  D  ; codes not CC with
 ..S NIEN="",NIEN=$G(^XCSV("ICD9","MAP","B",SIEN)) I 'NIEN K ^ICD9("ACC",IEN,SIEN)
 ..I SIEN=NIEN Q
 ..K ^ICD9("ACC",IEN,SIEN)
 ..I NIEN S ^ICD9("ACC",IEN,NIEN)=""
 .S SIEN=0 F  S SIEN=$O(^ICD9(IEN,66,SIEN)) Q:'SIEN  D  ; Now handle field 66 - Effective Date multiple
 ..F I=1:1:5 D
 ...S VAL=$P($G(^ICD9(IEN,66,SIEN,"DRG")),U,I) Q:VAL=""
 ...S NVAL=$G(^XCSV("ICD","MAP","B",VAL))
 ...S $P(^ICD9(IEN,66,SIEN,"DRG"),U,I)=NVAL
 .S SIEN=0 F  S SIEN=$O(^ICD9(IEN,3,SIEN)) Q:'SIEN  D   ; Next we do the DRG GROUPER multiple #71
 ..S ZNODE=$G(^ICD9(IEN,3,SIEN,0))
 ..S SIEN2=0 F  S SIEN2=$O(^ICD9(IEN,3,SIEN,1,SIEN2)) Q:'SIEN2  D
 ...S OPTR=$G(^ICD9(IEN,3,SIEN,1,SIEN2,0)) Q:'OPTR
 ...S NPTR=$G(^XCSV("ICD","MAP","B",OPTR))
 ...I OPTR=NPTR Q
 ...I 'NPTR K ^ICD9(IEN,3,SIEN,1,"B",OPTR,SIEN2) Q
 ...S ^ICD9(IEN,3,SIEN,1,SIEN2,0)=NPTR
 ...K ^ICD9(IEN,3,SIEN,1,"B",OPTR,SIEN2)
 ...S ^ICD9(IEN,3,SIEN,1,"B",NPTR,SIEN2)=""
 .S SIEN=0 F  S SIEN=$O(^ICD9(IEN,4,SIEN)) Q:'SIEN   ; Now do the DRG GROUPER multiple #72
 ..S ODAT=$G(^ICD9(IEN,4,SIEN,0))
 ..S OPTR=$P(ODAT,U,2)
 ..S NPTR=$G(^XCSV("ICM","MAP","B",OPTR))
 ..S $P(^ICD9(IEN,4,SIEN,0),U,2)=NPTR
 Q
