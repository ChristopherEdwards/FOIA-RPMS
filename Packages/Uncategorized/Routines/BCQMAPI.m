BCQMAPI ; IHS/OIT/FBD - MAGIC MAPPER API ;
 ;;1.0;IHS CODE MAPPING;;MAR 19, 2014;Build 13
 ;
MM(BCQMF,LOOKUP,LKFORM,VALUE1,VALUE2,VALUE3,VALUE4,VALUE5,VALUE6,BCQMDATE,RETVAL) ;PEP; table oriented magic mapper
 ;this API will be called to obtained code values based
 ;on an entry in a that file that is passed
 ;  input:
 ;  1  -  File number in which the code lives
 ;  2  -  lookup value into the table in file 
 ;        the caller must pass a value that will not fail a DIC lookup into the table
 ;        must be a unique lookup value
 ;        EXAM - pass standard IHS code, e.g. 34
 ;        NOTE:  there is no unique lookup value in EDUCATION topics so caller must pass the IEN of the topic
 ;               there are tons of dupes
 ;  3  -  lookup value format, is this an I (internal value IEN) or E - External value  DEFAULT IS "E"
 ;  VALUE1 - VALUE6  -  additional values to check (e.g exam result), these values
 ;  will be used in the MUMPS code field as additional checks
 ;  caller will have to be told what order to pass the values in for each table
 ;  that will be in the technical documentation
 ;  E.g.  MEASUREMENT TYPE:  VALUE1=RESULT, VALUE2=QUALIFIER;QUALIFIER;QUALIFIER, VALUE3=visit ien
 ;        EXAM:  VALUE1=RESULT, VALUE2=visit ien
 ;        HEALTH FACTOR:  == NO OTHER VALUES NEEDED
 ;        EDUCATION:  ==== NO OTHER VALUES NEEDED
 ;        IMMUNIZATION: VALUE1=VISIT SERVICE CATEGORY
 ;
 ;SEE THE USER MANUAL FOR COMPLETE DESCRIPTION OF THIS API
 ;
 K @RETVAL
 ;I BCQMF'?.N1.".".N S BCQMF=$O(^DIC("B",BCQMF,0))
 I '$G(BCQMF) Q "-1^invalid file number"  ;no valid file # passed
 I '$D(^DD(BCQMF,0)) Q "-1^invalid file number"
 I '$D(^DIC(BCQMF,0)) Q "-1^invalid file number"
 S LOOKUP=$G(LOOKUP)
 I $G(LOOKUP)="" Q "-1^no lookup valued passed"
 S LKFORM=$G(LKFORM)
 S BCQMDATE=$G(BCQMDATE)
 I BCQMDATE="" S BCQMDATE=DT
 S VALUE1=$G(VALUE1)
 S VALUE2=$G(VALUE2)
 S VALUE3=$G(VALUE3)
 S VALUE4=$G(VALUE4)
 S VALUE5=$G(VALUE5)
 S VALUE6=$G(VALUE6)
 ;NEW BCQMFIEL,BCQMFV,BCQMX,BCQMY,BCQMMAP,BCQMC,BCQMZ,S,BCQMS,D,C,X,Y
 S BCQMC=0
 S BCQMX=$O(^BCQM(9002023,"B",BCQMF,0))
 I 'BCQMX Q "-1^Table File not supported"
 ;do a DIC lookup of LOOKUP value into table BCQMF, then get the appropriate piece
 S DIC=BCQMF,DIC(0)="M",X=$S(LKFORM="I":"`"_LOOKUP,1:LOOKUP) D ^DIC
 I Y=-1 Q "-1^invalid lookup value"
 S BCQMFV=+Y
 S BCQMFIEL=$P(^BCQM(9002023,BCQMX,0),U,2)
 I BCQMFIEL]"" S BCQMFV=$$GET1^DIQ(BCQMF,BCQMFV,BCQMFIEL)
 I BCQMFV="" Q "-1^something went wrong"
 I $D(^BCQM(9002023,BCQMX,2)) X ^BCQM(9002023,BCQMX,2)  ;CODE PUT IN FOR EDUCATION TOPIC BUT MIGHT BE ABLE TO BE USED FOR OTHER TABLES
 ;Now go through all entries in 9002023 for this file and execute M logic for value checks
 ;I BCQMF=9999999.09 S BCQMZ=VALUE1 D PROCESS S BCQMZ=VALUE2 D PROCESS S BCQMZ="*ANY*" D PROCESS Q BCQMC
 F BCQMZ=BCQMFV,"*ANY*" D PROCESS
 Q BCQMC
PROCESS ;
 S BCQMY=0 F  S BCQMY=$O(^BCQM(9002023,BCQMX,1,"B",BCQMZ,BCQMY)) Q:BCQMY'=+BCQMY  D
 .S X=0 I $D(^BCQM(9002023,BCQMX,1,BCQMY,1)) X ^BCQM(9002023,BCQMX,1,BCQMY,1) I 'X Q  ;doesn't match
 .;looks like we got a match so set up codes in retval arry
 .S BCQMS=0 F  S BCQMS=$O(^BCQM(9002023,BCQMX,1,BCQMY,2,BCQMS)) Q:BCQMS'=+BCQMS  D
 ..S D=$$GET1^DIQ(9002023.12,BCQMS_","_BCQMY_","_BCQMX,.03)
 ..I D]"",BCQMDATE'>D Q  ;inactive
 ..S S=$$GET1^DIQ(9002023.12,BCQMS_","_BCQMY_","_BCQMX,.01)
 ..S C=$$GET1^DIQ(9002023.12,BCQMS_","_BCQMY_","_BCQMX,.02)
 ..I S]"",C]"" S BCQMC=BCQMC+1,@RETVAL@(BCQMC,S)=C
 Q
MMMEAS ;test
 S X=$$MM(9999999.07,"BP","E","120/80",,,,,,DT,"OUT")
 W !,X,!
 ;ZW OUT
 Q
MMEXAM ;test
 S X=$$MM("EXAM","09",,"RF",,,,,,DT,"OUT")
 W !,X,!
 ;ZW OUT
 Q
MMEDUC ;test
 KILL OUT
 S X=$$MM(9999999.09,1109,"I",,,,,,,DT,"OUT")
 W !,X,!
 ;ZW OUT
 Q
PRIMPOV() ;PEP - return SNOMED to use for primary pov
 Q $$GET1^DIQ(9002022,1,.02)
 ;
HANDED(V,D,RETVAL) ;PEP = get snomed handedness
 K @RETVAL
 NEW X,Y,BCQMC
 I $G(V)="" Q ""
 S BCQMC=0
 S X=$O(^BCQM(9002022,1,1,"B",V,0))
 I 'X Q ""
 S Y=0 F  S Y=$O(^BCQM(9002022,1,1,X,1,Y)) Q:Y'=+Y  D
 .S BCQMC=BCQMC+1,@RETVAL@(BCQMC,"SNOMED")=$P($G(^BCQM(9002022,1,1,X,1,Y,0)),U,1)
 Q BCQMC
TESTIMM ;
 S X=$$MM^BCQMAPI(9002084.81,16,"I",10,,,,,,DT,"CODES")
 ;input :
 ; 1 - file number of BI TABLE CONTRA REASON
 ; 2 - ien of entry in BI TABLE CONTRA REASON
 ; 3 - "I" - this tells the mapper you are passing internal ien vs external value
 ; 4 - ien of entry in the BI TABLE VACCINE GROUP
 ; 5-9 ARE BLANK
 ; 10 - date contraindication documented
 ; 11 - array you want the snomed codes to be passed back in
 ; output:
 ;  E.G. CODES(1,"SNOMED")=315640000
 ;       CODES(2,"SNOMED")=1111111
 ; you will only get back 1 or more snomed codes e.g. for flu anaphylaxsis you will get back 2
 ; we have the second parameter to tell what coding system as some mappings also pass back "LOINC" codes
 ;  although so far, imm contraindications will not pass back loinc codes.
 Q
