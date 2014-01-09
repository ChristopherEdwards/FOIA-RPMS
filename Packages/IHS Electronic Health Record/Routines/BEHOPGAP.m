BEHOPGAP ;IHS/MSC/MGH - PATIENT GOALS APIs;05-Dec-2011 13:44;DU
 ;;1.1;BEH COMPONENTS;**058001**;MAY 14, 2009;Build 2
 ;
 ;
ADDGOAL(RETVAL,DFN,GDAT) ;PEP -- add Patient Goal
 ;This API is called to add a new entry to the PATIENT GOALS file
 ;Input:
 ;  - DFN = Patient DFN
 ;  - GDAT = array of field data
 ;    Details:
 ;       DATA(0)=?GOAL?^ GOAL SET STATUS^WHERE SET^GOAL NUMBER^PROVIDER^START DATE^FOLLOWUP DATE^ USER
 ;       DATA(1)=?TYPE?^ GOAL TYPE^GOAL TYPE^GOAL TYPE ETC  ÁGOAL TYPES ARE FROM A SEPARATE FILE
 ;       DATA(2)=?NAME?^GOAL NAME (FREE TEXT)
 ;       DATA(3)=?REASON?^GOAL REASON(FREE TEXT)
 ;       note:  field .11 is always stuffed with A (Active) on an add so no need to pass in that field value
 ;       note:  field .02  is always stuffed with the value of DFN
 ;       note:  fields .03 and .05 are stuffed with DT and $$NOW
 ;       note:  fields .04 and .12 area stuffed with DUZ
 ;
 ;  - RETVAL = string that returns value of call success/failure
 ;
 ;RETURN VALUE - RETVAL=ien of patient goal entry created OR 0^error message
 ;
 ;
 S RETVAL=""
 N GARRAY,I,J,DATA,FAC
 S I="" F  S I=$O(GDAT(I)) Q:I=""  D
 .I $P($G(GDAT(I)),U,1)="GOAL" D
 ..S DATA=$G(GDAT(I))
 ..S GARRAY(".01",1)=$P(DATA,U,2)    ;goal set status
 ..I $P(DATA,U,3)="" S GARRAY(".06",1)=+$G(DUZ(2))
 ..E  S GARRAY(".06",1)=$P(DATA,U,3) ;facility, DUZ(2) used if not sent
 ..S GARRAY(".07",1)=$P(DATA,U,4)    ;goal number
 ..S GARRAY(".08",1)=$P(DATA,U,5)    ;provider documenting, DUZ used if not sent
 ..S GARRAY(".09",1)=$P(DATA,U,6)    ;goal start date    ,date only
 ..S GARRAY(".1",1)=$P(DATA,U,7)     ;goal followup date ,date only
 ..S GARRAY(".12",1)=$P(DATA,U,8)    ;user last updated, DUZ used if not sent
 .I $P($G(GDAT(I)),U,1)="TYPE" D
 ..S J=2 F  S TYPE=$P($G(GDAT(I)),U,J) Q:TYPE=""  D
 ...S GARRAY("1000",J-1)=TYPE                 ;goal type can be multiple
 ...S J=J+1
 .I $P($G(GDAT(I)),U,1)="NAME" D              ;goal name
 ..S GARRAY("1101",1)=$P($G(GDAT(I)),U,2)
 .I $P($G(GDAT(I)),U,1)="REASON" D            ;goal reason
 ..S GARRAY("1201",1)=$P($G(GDAT(I)),U,2)
 D ADDGOAL^APCDGAPI(DFN,.GARRAY,.RETVAL)
 I +RETVAL=0 D
 .I $P(RETVAL,U,1)'=0 S RETVAL=0_U_RETVAL
 Q
DELGOAL(RETVAL,GIEN,PRV,DDTE,DREA,DOTHER) ;PEP - called to delete a goal
 ;marks the goal status as "deleted", does not physically delete the goal
 ;INPUT -
 ; GIEN=goal IEN
 ; PRV= Provider who deleted goal uses DUZ if not passed
 ; DDTE=Date deleted, uses NOW If nothing passed
 ; DREA=Reason deleted (set of codes)
 ; DOTHER=Text if reason chosen is other
 ;
 ;OUTPUT - return value is 1 if delete successful or 0^error message if not successful
 I '$G(GIEN) S RETVAL="0^invalid ien" Q
 N APCDGIEN
 S APCDGIEN=GIEN
 I (DREA="O"!(DREA="OTHER"))&(DOTHER="") S RETVAL="0^Other delete reason needs a comment" Q
 D DELGOAL^APCDGAPI(APCDGIEN,PRV,DDTE,DREA,DOTHER,.RETVAL)
 Q
EDITGOAL(RETVAL,GIEN,FUD,STAT,REVD,REVT) ;PEP- edit a goal entry
 ;only the following fields can be edited per requirements:  F/U DATE (.09), STATUS (.11)
 ;you can also add a review date and review/follow up text, to edit a review comment use EDITREV API
 ;INPUT :
 ; GIEN=ien of goal
 ; FUD= new followup date
 ; STAT= new status
 ; REVD= review date (optional)
 ; REVT= review comment (optional)
 ;        if adding a review both review date and comment are required, if both are not passed they
 ;        are ignored
 ;OUTPUT :  1 if edit successful, 0^error message if not successful
 ;
 S RETVAL=""
 I '$G(GIEN) S RETVAL="0^invalid ien" Q
 S REVD=$G(REVD)
 S REVT=$G(REVT)
 D EDITGOAL^APCDGAPI(GIEN,FUD,STAT,REVD,REVT,.RETVAL)
 I RETVAL="" S RETVAL=1
 Q
 ;
NEXTGN(RET,DFN,FAC) ;PEP - return next available goal number for patient P, facility F
 S RET=$$NEXTGN^APCDGAPI(DFN,FAC)
 Q
 ;
GETGOAL(RET,DFN) ;PEP Return a list of a patient's goals
 ; (goal no,0)=IEN(1)^GSET(2)^CREATED(3)^BY(4)^LASTMODIFIED(5)^FACILITY(6)
 ; ^PROVIDER(7)^STARTDT(8)^FOLLOWUPDT(9)^STATUS(10)^GOAL NUMBER (11)
 ; (goal no,10)=TYPE1^TYPE2^TYPE3...
 ; (goal no,11)=GOALNAME
 ; (goal no,12)=GOALREASON
 ; (goal no,13,n)=REVIEW DATE(1)^NOTE(2)
 N GRIEN,FILE,FIELDS,IEN,ARRAY,ERRARRY,GNAME,GTYP,CNT,SFAC,REV,REVDT,REVTXT,CNT,TIEN
 N GSET,GOALNO,GDATE,GBY,GMOD,GFAC,GPROV,GSTART,GFUP,GSTAT,GTYPE,GREASON,GSTATE
 S FILE=9000093
 S RET=$$TMPGBL,GRIEN=""
 F  S GRIEN=$O(^AUPNGOAL("AC",DFN,GRIEN)) Q:'GRIEN  D
 .S IEN=GRIEN_","
 .;Get all the data that is needed for the zero nodes
 .D GETS^DIQ(FILE,GRIEN,"*","IE","ARRAY","ERRARRY")
 .S GSET=$G(ARRAY(FILE,IEN,.01,"E"))
 .S GDATE=$G(ARRAY(FILE,IEN,.03,"I"))
 .S GBY=$G(ARRAY(FILE,IEN,.04,"E"))
 .S GMOD=$G(ARRAY(FILE,IEN,.05,"I"))
 .S GFAC=$G(ARRAY(FILE,IEN,.06,"E"))
 .S GOALNO=$G(ARRAY(FILE,IEN,.07,"E"))
 .S GPROV=$G(ARRAY(FILE,IEN,.08,"E"))
 .S GSTART=$G(ARRAY(FILE,IEN,.09,"I"))
 .S GFUP=$G(ARRAY(FILE,IEN,.1,"I"))
 .S GSTAT=$G(ARRAY(FILE,IEN,.11,"I"))
 .S GSTATE=$G(ARRAY(FILE,IEN,.11,"E"))
 .I GSTAT'="" S GSTAT=GSTAT_";"_GSTATE
 .Q:GSTAT="D"
 .;Get the text needed for the 11 and 12 nodes
 .S GNAME=$G(ARRAY(FILE,IEN,1101,"E"))
 .S GREASON=$G(ARRAY(FILE,IEN,1201,"E"))
 .S @RET@(GOALNO,0)=GRIEN_U_GSET_U_GDATE_U_GBY_U_GMOD_U_GFAC_U_GPROV_U_GSTART_U_GFUP_U_GSTAT_U_GOALNO
 .;Get the data from the goal type multiple (goals may have more than 1 type)
 .S GTYPE=""
 .S TIEN=0 F  S TIEN=$O(^AUPNGOAL(GRIEN,10,TIEN)) Q:'+TIEN  D
 ..S GTYP=$G(^AUPNGOAL(GRIEN,10,TIEN,0))
 ..I GTYPE="" S GTYPE=$P($G(^APCDTPGT(GTYP,0)),U,1)
 ..E  S GTYPE=GTYPE_U_$P($G(^APCDTPGT(GTYP,0)),U,1)
 .S @RET@(GOALNO,10)=GTYPE
 .S @RET@(GOALNO,11)=GNAME
 .S @RET@(GOALNO,12)=GREASON
 .S CNT=0,REV=0 F  S REV=$O(^AUPNGOAL(GRIEN,13,REV)) Q:'+REV  D
 ..S REVDT=$P($G(^AUPNGOAL(GRIEN,13,REV,0)),U,1)
 ..S REVTXT=$P($G(^AUPNGOAL(GRIEN,13,REV,0)),U,2)
 ..S CNT=CNT+1
 ..S @RET@(GOALNO,13,CNT)="REVIEW"_U_REVDT_U_REVTXT
 Q
GETSTEP(RET,GIEN) ;Get the step data
 ;Input GIEN=goal IEN
 ;Ouptut global array of steps for a particular goal
 ;format equals
 ;zero node=Goal ien [1] ^ facility [2] ^ step ien [3] ^ Step number [4] ^ Created by [5] ^ created date [6] ^
 ;Step type [7] ^ step start dt [8] ^ step followup date [9] ^ user last modififed [10] ^ last modified date [11]
 ;^ step status [12] ^ provider [13]
 ;one node= Step text
 N FILE,SFAC,CNT
 S FILE=9000093,CNT=0
 S RET=$$TMPGBL
 S SFAC=0 F  S SFAC=$O(^AUPNGOAL(GIEN,21,SFAC)) Q:'+SFAC  D
 .S FAC=$P($G(^AUPNGOAL(GIEN,21,SFAC,0)),U,1)
 .S FNAME=$P($G(^DIC(4,FAC,0)),U,1)
 .D STEPS(GIEN,SFAC,FAC,FNAME)
 Q
STEPS(GOAL,SFAC,FAC,FNAME) ;Get the step data for each goal
 N SIEN,LKP,GFLDS,FILE1,GDATA,GERR,STATUS
 N STEPNO,SBY,SWHEN,STYPE,SSTART,SFUP,SUPD,SMOD,SSTATUS,SPROV,STEXT
 S SIEN=0 F  S SIEN=$O(^AUPNGOAL(GOAL,21,SFAC,11,SIEN)) Q:'+SIEN  D
 .S LKP=SIEN_","_SFAC_","_GOAL_",",FILE1=9000093.211101
 .S STEPNO=$$GET1^DIQ(FILE1,LKP,".01")
 .S SBY=$$GET1^DIQ(FILE1,LKP,".02")
 .S SWHEN=$$GET1^DIQ(FILE1,LKP,".03","I")
 .S STYPE=$$GET1^DIQ(FILE1,LKP,".04")
 .S SSTART=$$GET1^DIQ(FILE1,LKP,".05","I")
 .S SFUP=$$GET1^DIQ(FILE1,LKP,".06","I")
 .S SUPD=$$GET1^DIQ(FILE1,LKP,".07")
 .S SMOD=$$GET1^DIQ(FILE1,LKP,".08","I")
 .S SSTATUS=$$GET1^DIQ(FILE1,LKP,".09")
 .Q:SSTATUS="DELETED"
 .S STATUS=$$GET1^DIQ(FILE1,LKP,".09","I")
 .S SPROV=$$GET1^DIQ(FILE1,LKP,".1")
 .S @RET@(SIEN,0)=GIEN_U_FAC_";"_FNAME_U_SIEN_U_STEPNO_U_SBY_U_SWHEN_U_STYPE_U_SSTART_U_SFUP_U_SUPD_U_SMOD_U_STATUS_";"_SSTATUS_U_SPROV
 .S STEXT=$$GET1^DIQ(FILE1,LKP,1101)
 .S @RET@(SIEN,1)=STEXT
 Q
ADDREV(RETVAL,GIEN,REVD,REVT) ;PEP - ADD A REVIEW TO A GOAL 9000093.13
 ;INPUT:
 ;GIEN= ien of goal
 ;REVD= review date
 ;REVT= review text
 ;OUTPUT:  ien of review entry in multiple or 0^error text
 ;
 I '$G(GIEN) S RETVAL="0^invalid ien" Q
 D ADDREV^APCDGAP2(GIEN,REVD,REVT,.RETVAL)
 Q
 ;
ADDSTEP(RETVAL,GIEN,SDAT) ;PEP - add a step to a goal
 ;Add a Step to an existing goal
 ;  SDAT - array of steps to be added if adding steps
 ;      SDAT(n)=facility^step number^step type^step start date^step f/u date^provider^step text
 ;              one entry in array for each step being added
 ;              step number is optional, if not passed the next available step number will be used
 ;              values can be internal or external
 ;              user created / user last update fields auto stuffed with DUZ
 ;              date created / date last updated fields auto stuffed with DT and NOW^XLFDT
 ;
 ;              Example:
 ;              SDAT(1)="5217^1^NUTRITION^3101029^3101231^1239^EAT LESS THAN 1200 CAAPCDTESTES PER DAY
 ;              SDAT(2)="5217^2^PHYSICAL ACTIVITY^3101029^3101231^1239^WALK 60 MINUTES PER DAY
 N I,J,SDAT2
 S I="" F  S I=$O(SDAT(I)) Q:I=""  D
 .S J=I+1
 .S SDAT2(J)=SDAT(I)
 D ADDSTEP^APCDGAP2(GIEN,.SDAT2,.RETVAL)
 S RETVAL=RETVAL(1)
 Q
DELSTEP(RET,GIEN,LIEN,SIEN,PRV,SDTE,SREA,SOTHER) ;PEP - DELETE A STEP
 ;delete a step
 ;  INP =
 ;    GIEN=Goal IEN
 ;    LINE=Location
 ;    SIEN=Step IEN
 ;    PRV= Who deleted (defaults to DUZ if not sent)
 ;    SDTE= When deleted (defaults to NOW If not sent)
 ;    SREA= Reason deleted (set of codes)
 ;    SOTHER=Text if reason is other
 ;  OUTPUT = 1 if delete successful or 0^error message
 S RET=""
 I '$G(GIEN) S RET="0^invalid goal ien" Q
 S SOTHER=$G(SOTHER)
 S X=SDTE D ^%DT S SDTE=Y
 I (SREA="O"!(SREA="OTHER"))&(SOTHER="") S RET="0^Text must be sent with OTHER reason" Q
 D DELSTEP^APCDGAP2(GIEN,LIEN,SIEN,PRV,SDTE,SREA,SOTHER,.RET)
 Q
EDITSTEP(RETVAL,GIEN,LIEN,SIEN,FUD,STAT) ;PEP - edit a step entry
 ;edit a step entry
 ;per requirements only the followup date and status can be edited
 ;INPUT:
 ; GIEN=goal ien
 ; LIEN=location ien
 ; SIEN=Step ien
 ; FUD= new f/u date
 ; STAT=status
 ;OUTPUT:  1 if edit successful, 0^error message if not successful
 I '$G(GIEN) S RETVAL="0^invalid ien" Q
 D EDITSTEP^APCDGAP2(GIEN,LIEN,SIEN,FUD,STAT,.RETVAL)
 Q
NEXTSN(RET,GIEN,FAC) ;PEP - return next step number for this goal, facility
 S RET=$$NEXTSN^APCDGAP2(GIEN,FAC)
 Q
TMPGBL() ;EP
 K ^TMP("BEHOGOAL",$J) Q $NA(^($J))
