AMEREDAU ; IHS/OIT/SCR - 03/25/06 -Primary routine for audit trail of edited ER VISIT fields
 ;;3.0;ER VISIT SYSTEM;**2**;FEB 23, 2009
 ;
EDAUDIT(FIELD,OLDVAL,NEWVAL,FLDNAME) ; EP From all AMERED* routines
 ; Provides audit trail interface
 ; INPUT:
 ;   FIELD  : the Field number of ER VISIT file that is being changed
 ;   OLDVAL : the original value of the field before editing
 ;   NEWVAL : the value that the field is being changed to
 ;   FLDNAME : User friendly field name for ease in creating readable audit trail reports
 ;
 N X,Y,%
 N DIC,DIR,DIE,AMERREAS,AMERDATE,AMERTIME,AMERCOMM,AMEREDAU,AMERDT
 S (AMERREAS,AMERCOMM)=""
 D NOW^%DTC   ;GET CURRENT DATE AND TIME - FM format is returned in X
 S (AMERDT,Y)=% D DD^%DT
 S AMERDATE=$P(Y,"@",1),AMERTIME=$P(Y,"@",2)
 D EN^DDIOL("EDIT DATE: "_AMERDATE,"","!!")
 D EN^DDIOL("EDIT TIME: "_AMERTIME,"","!!")
 D EN^DDIOL("FIELD NAME BEING EDITED: "_FLDNAME,"","!!")
 D EN^DDIOL("OLD VALUE: "_OLDVAL,"","!!")
 D EN^DDIOL("NEW VALUE: "_NEWVAL,"","!!")
 I FIELD="PCC" S AMERREAS="ADM"  ;hard code reason 
 E  S AMERREAS=$$EDREASON()
 I AMERREAS="^" S AMEREDAU="^" Q AMEREDAU
 K DIR("B"),%,Y,X
 S DIR(0)="FO^1:100",DIR("A")="Comment"
 S DIR("?")="Enter free text comment (200 characters max.)"
 D ^DIR K DIR
 I Y'=-1 S AMERCOMM=Y
 E  S AMERCOMM="^"
 I AMERCOMM="^"!(AMERREAS="^") S AMEREDAU="^"
 E  S AMEREDAU=FIELD_";"_AMERDT_";"_OLDVAL_";"_NEWVAL_";"_AMERREAS_";"_FLDNAME_";"_AMERCOMM
 Q AMEREDAU
 ;
EDDISPL(AMERVAL,AMERTYPE) ; EP from multiple AMERED* routines
 ; Provides a user friendly format for audit trail interface
 ;AMERVAL IS THE VALUE THAT IS BEING DISPLAYED
 ;AMER TYPE IS ONE OF:
 ;          D - DATE   AMERVAL IS A DATE IN FILE MAN FORMAT
 ;          B - BOOLEAN
 ;          P - PATIENT AMERVAL IS A POINTER TO THE PERSON FILE
 ;          T - TRANSFER AMERVAL IS A POINTER TO THE ER OPTIONS FILE
 ;          M - MODE OF TRANSPORT AMERVAL IS A POINTER TO ER OPTIONS FILE
 ;          A - AMBULANCE COMPANY AMERVAL IS A POINTER TO ER OPTIONS FILE
 ;          N - PROVIDER - AMERVAL IS A POINTER TO NEW PERSON FILE
 ;          S - SETTING OF ACCIDENT OR INJURY - AMERVAL IS A POINTER TO ER OPTIONS FILE
 ;          C - CAUSE OF INJURY
 ;          Q - SAFETY EQUIPMENT
 ;          R - PROCEDURES - AMERVAL IS A POINTER TO THE ER OPTIONS FILE
 ;          X - DIAGNOSIS - AMERVAL IS A POINTER TO THE ICD9 FILE
 ;          I - DISPOSITION AMERVAL IS A POINTER TO ER OPTIONS FILE
 ;          F - FOLLOW UP INSTRUCTIONS AMERVAL IS A POINTER TO ER OPTIONS FILE
 ;          E - ER CONSULTANT - AMERVAL IS A POINTER TO THE ER CONSULTANT FILE
 ;          V - VISIT TYPE - AMERVAL IS A POINTER TO THE ER OPTIONS FILE
 ;          L - CLINIC TYPE - AMERVAL IS APOINTER TO THE ER OPTIONS FILE
 ;
 Q:AMERVAL="" AMERVAL  ;IF THERE IS NO VALUE, DON'T TRY TO MAKE IT PRETTY
 N AMERNVAL,DIC,X,Y,AMERTEMP
 S AMERNVAL=""
 I AMERTYPE="D" D   ;DATE
 .S Y=AMERVAL D DD^%DT S AMERNVAL=Y
 .Q
 I AMERTYPE="B" D  ;BOOLEON
  .S AMERNVAL=$S(AMERVAL=1:"YES",1:"NO")
  .Q
 I AMERTYPE="P" D  ;PATIENT
  .S:AMERVAL'="" AMERNVAL=$P($G(^DPT(AMERVAL,0)),U,1)
  .Q
 I AMERTYPE="M" D  ;MODE OF TRANSPORT
  .S DIC="^AMER(3,",DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("MODE OF TRANSPORT")
  .S DIC(0)="OXN"
  .S X=AMERVAL
  .D ^DIC K DIC
  .S AMERNVAL=$P($G(Y),U,2)
  .Q
 I AMERTYPE="T" D  ;TRANSFER
  .S DIC="^AMER(3,",DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("TRANSFER DETAILS")
  .S DIC(0)="OXN"
  .S X=AMERVAL
  .D ^DIC K DIC
  .S AMERNVAL=$P($G(Y),U,2)
  .Q
 I AMERTYPE="A" D  ;AMBULANCE COMPANY
  .S DIC="^AMER(3,"
  .S DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("AMBULANCE COMPANY")
  .S DIC(0)="OXN"
  .S X=AMERVAL
  .D ^DIC K DIC
  .S AMERNVAL=$P($G(Y),U,2)
  .Q
 I AMERTYPE="N" D  ;PROVIDER
  .S AMERNVAL=$P($G(^VA(200,AMERVAL,0)),U,1)
  .Q
 I AMERTYPE="S" D
  .S DIC="^AMER(3,"
  .S DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("SCENE OF INJURY")
  .S DIC(0)="OXN"
  .S X=AMERVAL
  .D ^DIC K DIC
  .S AMERNVAL=$P($G(Y),U,2)
  .Q
 I AMERTYPE="C" D  ;CAUSE OF INJURY
  .;IHS/OIT/SCR use option to 'allow local codes' for this function since default screens valid codes
  .;S:AMERVAL'="" AMERNVAL=$P($$ICDDX^ICDCODE(+AMERVAL),U,4)
  .S:AMERVAL'="" AMERNVAL=$P($$ICDDX^ICDCODE(+AMERVAL,,,1),U,4)
  .Q
 I AMERTYPE="Q" D  ;SAFETEY EQUIPMENT
  .S DIC="^AMER(3,"
  .S DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("SAFETY EQUIPMENT")
  .S DIC(0)="OXN"
  .S X=AMERVAL
  .D ^DIC K DIC
  .S AMERNVAL=$P($G(Y),U,2)
  .Q
 I AMERTYPE="R" D
  .S DIC="^AMER(3,"
  .S DIC("S")="I $P(^(0),U,2)=20"
  .S DIC(0)="OXN"
  .S X=AMERVAL
  .D ^DIC K DIC
  .S AMERNVAL=$P($G(Y),U,2)
  .Q
 I AMERTYPE="X" D
 .I AMERVAL="" S AMERNVAL="" Q
 .S AMERNVAL=$P($$ICDDX^ICDCODE(AMERVAL,,,1),U,2)
 .S AMERNVAL=AMERNVAL_" {"_$P($$ICDDX^ICDCODE(AMERVAL,,,1),U,4)_"}"
 .Q
 I AMERTYPE="I" D  ;DISPOSITION
 .S DIC="^AMER(3,"
  .S DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("DISPOSITION")
  .S DIC(0)="OXN"
  .S X=AMERVAL
  .D ^DIC K DIC
  .S AMERNVAL=$P($G(Y),U,2)
  .Q
 I AMERTYPE="F" D  ;FOLLOW-UP INSTRUCTIONS
 .S DIC="^AMER(3,"
 .S DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("FOLLOW UP INSTRUCTIONS")
 .S DIC(0)="OXN"
 .S X=AMERVAL
 .D ^DIC K DIC
 .S AMERNVAL=$P($G(Y),U,2)
 .Q
 I AMERTYPE="E" D  ;CONSULTANT
 .S DIC="^AMER(2.9,"
 .S DIC(0)="OXN"
 .S X=AMERVAL
 .D ^DIC K DIC
 .S AMERNVAL=$P($G(Y),U,2)
 .Q
 I AMERTYPE="V" D  ;VISIT TYPE
 .S DIC="^AMER(3,"
 .S DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("VISIT TYPE")
 .S DIC(0)="OXN"
 .S X=AMERVAL
 .D ^DIC K DIC
 .S AMERNVAL=$P($G(Y),U,2)
 .Q
 I AMERTYPE="L" D  ;CLINIC TYPE
 .S DIC="^AMER(3,"
 .S DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("CLINIC TYPE")
 .S DIC(0)="OXN"
 .S X=AMERVAL
 .D ^DIC K DIC
 .;S AMERNVAL=$P($G(Y),U,1)
 .S AMERNVAL=$P($G(Y),U,2)  ;SCR/OIT/IHS 071509 PATCH 2
 .Q
 Q AMERNVAL
 ;
EDREASON() ; 
  ; Returns user selected edit reason code
  ;       DE     Data entry error
  ;       ADM    Administrative
  ;       ID     Mistaken patient ID
  ;       PT     Patient corrected
  ;       OT     Other
 N DIR,REASON
 S DIR(0)="SO^DE:Data entry error;ADM:Administrative;ID:Mistaken patient ID;"
 S DIR(0)=DIR(0)_"PT:Patient corrected;OT:Other"
 S DIR("A")="PLEASE ENTER A PRIMARY REASON FOR CHANGE",DIR("?")="Enter '^' to leave with out changing"
 S DIR("B")="ADM"
 D ^DIR K DIR
 I Y=""!(Y="^") S REASON="^"
 E  S REASON=Y
 Q REASON
 ;
DIEREC(AMERAIEN,AMERSTRG) ; EP from multiple AMERED* routines
 ;UPDATES  ^AMERAUDT WITH A SINGLE AUDIT LINE
 ;INPUT:
 ; AMERIEN : The ien of the ER AUDIT FILE record being updated
 ; AMERSTRG : a single audit line to be associated with this record
 N DR,DIC,DIE
 S DA(1)=AMERAIEN,DIC="^AMERAUDT(DA(1),2,",DIC(0)="L"
 S X=$P(AMERSTRG,";",1)
 D ^DIC I Y=-1 Q   ;create the multiple record
 S DIE=DIC,DA(1)=AMERAIEN,DA=+Y  ;edit the newly created muliple record
 S DR=".02////"_$P(AMERSTRG,";",2)  ;the time of edit
 S DR=DR_";.03////"_$P(AMERSTRG,";",3)  ;the value originally in this field
 S DR=DR_";.04////"_$P(AMERSTRG,";",4)  ;the value that was saved during edit
 S DR=DR_";.05////"_$P(AMERSTRG,";",5)  ;the edit-reason code
 S DR=DR_";1.2////"_$P(AMERSTRG,";",6)  ;the name of the modified field
 S DR=DR_";1////"_$P(AMERSTRG,";",7)    ;the free-text comment
 L +^AMERAUDT:3 E  Q
 D ^DIE
 L -^AMERAUDT
 K DIC,DIE,DA(1)
 Q
 ;
CREATAUD(ERVSTIEN,USERID)  ; EP FROM AMEREDIT
 N X,Y,%
 N AMERDR,AMERAUID
 D NOW^%DTC   ;GET CURRENT DATE AND TIME - FM format is returned in X
 S AMERAUID=$$DIC(%)
 I AMERAUID>0 D
 .S AMERDR=".02////"_ERVSTIEN_";.03////"_USERID
 .D DIE(AMERAUID,AMERDR)
 .Q
 K AMERDR,X,%,%H,%I
 Q AMERAUID
 ;
DIC(AMERSTMP) ; 
 ; GIVEN AN AUDIT TIMESTAMP CREATE AN ENTRY IN THE ER AUDIT FILE AND RETURN THE IEN
 N DIC,Y,AMERAUDT
 I '$G(AMERSTMP) Q ""
 S X=AMERSTMP
 N Y,DIC
 S DIC="^AMERAUDT(",DIC(0)="L",DIADD=1
 K DD,DO
 D FILE^DICN
 I Y=-1 S AMERAUDT=""
 E  S AMERAUDT=+Y
 K DIC,DIADD
 Q AMERAUDT
 ;
DIE(DA,DR) ; GIVEN AN ENTRY NUMBER AND A DR STRING, EDIT THE ER AUDIT FILE
 N DIE,X,Y,%
 N D,D0,DI,DIC,DICR,DIE,DIG,DIH,DIV,DIU,DIW,DQ
 S DIE="^AMERAUDT("
DIE1 L +^AMERAUDT:3 E  Q
 D ^DIE
 L -^AMERAUDT
 K DIE,X,Y,%
 Q
 ;
MULTAUDT(AMEREDTS,AMERAIEN)  ; EP from multiple AMERED* routines
 ;Inserts multiple audit records into ER VISIT AUDIT file
 ;INPUT: 
 ; AMEREDTS : a "^" deliniated string of audit records for insertion
 ; AMERAIEN : The IEN of the ER VISIT AUDIT record being updated
 ;
 N AMEREDTN,AMERSTRG
 F AMEREDTN=1:1 S AMERSTRG=$P(AMEREDTS,U,AMEREDTN) Q:AMERSTRG=""  D DIEREC(AMERAIEN,AMERSTRG)
 Q
