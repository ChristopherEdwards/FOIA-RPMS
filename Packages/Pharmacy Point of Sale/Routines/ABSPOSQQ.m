ABSPOSQQ ; IHS/FCS/DRS - VTL 05:51 PM 20 Jan 1997 ;   
 ;;1.0;PHARMACY POINT OF SALE;**17,18,40,41**;JUN 21, 2001
 Q
 ; billable/unbillable drugs  ; called from ABSPOSQA from ABSPOSQ1
 ;  $$BILLABLE() to determine if the drug is billable
 ;   Parameters are all optional, so long as you provide at least one.
 ;  INSIEN = pointer to insurance
 ;  DRUGIEN = pointer to drug file
 ;  NDC = NDC #, 11 digits
 ;
 ;   Name comparisons are done non-case sensitive.
 ;   If the NDC number is given and the AWP-MED TRANSACTION file is
 ;   present, then that name is used for testing as well as the drug
 ;   name.  (Two name tests are run.)
 ;
 ;  Return value:  result^result text
 ;     result = 1 billable or 0 not billable
 ;
 ;---------------------------------------------------------------
 ;IHS/SD/RLT - 04/07/06 - Patch 17
 ;                        Added drug name display to SETNDC.
 ;---------------------------------------------------------------
 ;IHS/SD/RLT - 09/01/06 - Patch 18
 ;                        Fixed OTC UNBILLABE for insurers
 ;                        in tag SETOTC.
 ;---------------------------------------------------------------
 ;IHS/OIT/CNI/RAN - Patch 40 - Rewrote entire BILLABLE subroutine to fix logic issues
BILLABLE(INSIEN,DRUGIEN,NDC) ;EP - ABSPOSQA
 N RESULT
 I '$G(INSIEN) S RESULT="1^no insurance goes through as billable" Q RESULT
 N X S X=$P($G(^AUTNINS(INSIEN,0)),U)
 I X="" S RESULT="1^INSIEN="_INSIEN_" not found in ^AUTNINS?" Q RESULT
 I X?1"SELF"0.1" PAY" S RESULT="1^SELF PAY goes through as billable" Q RESULT
 N DRUGNAME,MEDTNAME
 I $G(DRUGIEN) S DRUGNAME=$P(^PSDRUG(DRUGIEN,0),U)
 E  S DRUGNAME=""
 I $D(NDC),NDC]"" D
 . N X S X=$O(^APSAMDF("B",NDC,0))
 . I X S MEDTNAME=$P(^APSAMDF(X,2),U)
 . E  S MEDTNAME=""
 E  S NDC="",MEDTNAME=""
 ;
 ;First check insurance level...
 ;NDC first
 S RESULT=$$GETNDC(INSIEN,DRUGIEN,NDC,9002313.4,0)
 I ($P(RESULT,U,1)=1)!($P(RESULT,U,1)=0) Q RESULT
 S RESULT=$$GETNDC(INSIEN,DRUGIEN,NDC,9002313.4,1)
 I ($P(RESULT,U,1)=1)!($P(RESULT,U,1)=0) Q RESULT
 ;Now Drug Name
 S RESULT=$$GETDRNAM(INSIEN,DRUGIEN,DRUGNAME,MEDTNAME,9002313.4,0)
 I ($P(RESULT,U,1)=1)!($P(RESULT,U,1)=0) Q RESULT
 S RESULT=$$GETDRNAM(INSIEN,DRUGIEN,DRUGNAME,MEDTNAME,9002313.4,1)
 I ($P(RESULT,U,1)=1)!($P(RESULT,U,1)=0) Q RESULT
 ;Next check system wide settings for same
 ;NDC first
 S RESULT=$$GETNDC(1,DRUGIEN,NDC,9002313.99,0)
 I ($P(RESULT,U,1)=1)!($P(RESULT,U,1)=0) Q RESULT
 S RESULT=$$GETNDC(1,DRUGIEN,NDC,9002313.99,1)
 I ($P(RESULT,U,1)=1)!($P(RESULT,U,1)=0) Q RESULT
 ;Now Drug Name
 S RESULT=$$GETDRNAM(1,DRUGIEN,DRUGNAME,MEDTNAME,9002313.99,0)
 I ($P(RESULT,U,1)=1)!($P(RESULT,U,1)=0) Q RESULT
 S RESULT=$$GETDRNAM(1,DRUGIEN,DRUGNAME,MEDTNAME,9002313.99,1)
 I ($P(RESULT,U,1)=1)!($P(RESULT,U,1)=0) Q RESULT
 ;Then OTC Check Insurance level first
 S RESULT=$$GETOTC(INSIEN,DRUGIEN,9002313.4,0)
 I ($P(RESULT,U,1)=1)!($P(RESULT,U,1)=0) Q RESULT
 S RESULT=$$GETOTC(INSIEN,DRUGIEN,9002313.4,1)
 I ($P(RESULT,U,1)=1)!($P(RESULT,U,1)=0) Q RESULT
 ;Then system level
 S RESULT=$$GETOTC(1,DRUGIEN,9002313.99,0)
 I ($P(RESULT,U,1)=1)!($P(RESULT,U,1)=0) Q RESULT
 S RESULT=$$GETOTC(1,DRUGIEN,9002313.99,1)
 I ($P(RESULT,U,1)=1)!($P(RESULT,U,1)=0) Q RESULT
 ;If we got this far...there are no rules prohibiting this...so it's billable
 S RESULT=1
 Q RESULT
GETNDC(INSIEN,DRUGIEN,NDC,FILE,FOR) ;CHECK FOR NDC RULES
 N ROOT,SUB,SUBNDC,SUBNAME,RESULT
 S RESULT=""
 S ROOT=^DIC(FILE,0,"GL")_INSIEN_")"
 S SUB=$S(FOR:"",1:"UN")_"BILLABLE"
 S SUBNDC=SUB_" NDC #"
 I NDC]"",$D(@ROOT@(SUBNDC,"B",NDC)) D  Q RESULT
 . S $P(RESULT,U)=FOR ; mark it as unbillable or billable
 . N X S X=$P(RESULT,U,2) ; previous commentary
 . I X]"" S X=X_"; " ; separate the pieces
 . S X=X_"NDC "_NDC_" is "_$S(FOR:"",1:"un")_"billable "_$$HOW(FILE)
 . S $P(RESULT,U,2)=X
 Q RESULT
 ;
GETDRNAM(INSIEN,DRUGIEN,DRUGNAME,MEDTNAME,FILE,FOR) ;CHECK FOR DRUG NAME RULES
 N ROOT,SUB,SUBNDC,SUBNAME,NAME,RESULT
 S RESULT=""
 ;IHS/OIT/CASSEVER/RAN - 02/07/2011 - patch 41 Should check based on file, not just hardcoded insurance file
 ;S ROOT=^DIC(9002313.4,0,"GL")_INSIEN_")"
 S ROOT=^DIC(FILE,0,"GL")_INSIEN_")"
 S SUB=$S(FOR:"",1:"UN")_"BILLABLE"
 S SUBNAME=SUB_" DRUG NAME"
 F NAME=DRUGNAME,MEDTNAME I NAME]"" I $$NAMETEST D  Q
 . S $P(RESULT,U)=FOR
 . N X S X=$P(RESULT,U,2) S:X]"" X=X_"; "
 . S X=X_"Drug "_NAME_" is "_$S(FOR:"",1:"un")_"billable "_$$HOW(FILE)
 . S $P(RESULT,U,2)=X
 Q RESULT
 ;
GETOTC(INSIEN,DRUGIEN,FILE,FOR) ;CHECK FOR OTC RULES
 N ROOT,SUB,SUBNDC,SUBNAME,RESULT
 S ROOT=^DIC(FILE,0,"GL")_INSIEN_")"
 S SUB=$S(FOR:"",1:"UN")_"BILLABLE"
 S SUBNDC=SUB_" NDC #",SUBNAME=SUB_" DRUG NAME"
 S RESULT=""
 I $G(DRUGIEN),$P(^PSDRUG(DRUGIEN,0),U,3)["9" D
 . N OTC S OTC=$P($G(@ROOT@("UNBILLABLE OTC")),U)
 . I OTC="" Q  ; not specified, so don't alter result
 . ; OTC=1 if unbillable, =0 if billable
 . I OTC]"" S OTC='OTC ; =1 if billable, 0 if not billable
 . I OTC=FOR D
 . . S $P(RESULT,U)=FOR
 . . N X S X=$P(RESULT,U,2) S:X]"" X=X_"; "
 . . S X="OTCs are "_$S(FOR:"",1:"un")_"billable "_$$HOW(FILE)
 . . S $P(RESULT,U,2)=X
 Q RESULT
 ;
NAMETEST() ; Execute the tests in order; stop when you get a TRUE result
 ; Given NAME - return value is 1 if any test was TRUE, 0 if all FALSE
 ; and SUBNAME needed too
 I '$O(@ROOT@(SUBNAME,0)) Q 0 ; quick out for when no rules are there
 N ABSBPOS2,DOLLART,X S (DOLLART,ABSBPOS2)=0
 ; the tests are in terms of a variable X; assumed to be uppercase
 S X=$TR(NAME,"qwertyuiopasdfghjklzxcvbnm","QWERTYUIOPASDFGHJKLZXCVBNM")
 F  S ABSBPOS2=$O(@ROOT@(SUBNAME,ABSBPOS2)) Q:'ABSBPOS2  D  Q:DOLLART
 . X @ROOT@(SUBNAME,ABSBPOS2,0) S DOLLART=$T
 Q DOLLART
HOW(FILE)          I FILE=9002313.99 Q "for all companies"
 I FILE=9002313.4 Q "for "_$P(^AUTNINS(INSIEN,0),U)
 Q "HOW^"_$T(+0)_"??"
 ; Interactive routines
 ; Entry point:  set OTC field, system-wide (9002313.99)
SETOTC ;EP - option ABSP UNBILLABLE OTC
 W !!,"This setting determines whether OTC drugs are UNbillable.",!
 W "First, the default setting which applies to all insurances:",!
 N DIE,DR,DA,DUOUT,DTOUT,DIC,Y,X,DINUM,DLAYGO,DTIME
 S DIE=9002313.99,DA=1,DR=2128.13 D ^DIE
 ;
 W !!,"Next, you may make any insurer-specific settings.  This is",!
 W "for situations where an insurer has a different policy on OTCs.",!
 F  S (DIC,DLAYGO)=9002313.4,DIC(0)="AE" D ^DIC Q:Y<1  D
 . ;IHS/SD/RLT - 9/1/06 - Patch 18
 . ;S DA=+Y,DR=2128.13 D ^DIE
 . S DIE=9002313.4,DA=+Y,DR=2128.13 D ^DIE   ;write to ABSP INSURER file
 Q
SETNAME ;EP - option ABSP UNBILLABLE DRUG ; the name-based rules
 I DUZ(0)'["@" D  Q
 . W !,"You have to have a programmer enter these rules.",!
 N DIE,DR,DA,DUOUT,DTOUT,DIC,Y,X,DINUM,DLAYGO,DTIME
 W !!?15,"*****  Name-based rules for billable insurances  *****",!
 W "Enter Mumps IF commands to set $T true or false",!
 W "(True means Unbillable if you're entering Unbillable rules;",!
 W " True means Billable   if you're entering Billable   rules)",!
 W "The variable X contains the drug name, converted to uppercase.",!
 W !!?5,"**  First, the system-wide defaults:  **",!
 S DIE=9002313.99,DA=1,DR=2128.12 D ^DIE
 W !!?5,"**  Rules for specific insurances  **",!
 D NOTE
 F  S (DIC,DLAYGO)=9002313.4,DIC(0)="AE" D ^DIC Q:Y<1  D
 . S DIE=9002313.4,DA=+Y,DR=2128.12 D ^DIE
 . S DR=228.12 D ^DIE
 . W !!
 Q
NOTE ;
 W "(Note:  if the system-wide rule says the drug is billable,",!
 W " then only the insurer's unbillable test is made,",!
 W " and conversely, if the system-wide test says unbillable",!
 W " then only the insurer's billable test is made.)",!
 Q
SETNDC ;EP - option ABSP UNBILLABLE NDC ; the NDC number rules
 N DIE,DR,DA,DUOUT,DTOUT,DIC,Y,X,DINUM,DLAYGO,DTIME
 N NEWREC,INSIEN      ;RLT
 W !!,"*****  Specifying unbillable and billable NDC numbers",!!
 W "The numbers you enter must be 11-digit numbers, without dashes.",!!
 W "First, NDC numbers that are unbillable, system-wide",!
 ;IHS/SD/RLT - 04/27/06 - Patch 17 - BEGIN PART 1
 ;S DIE=9002313.99,DA=1,DR=2128.11 D ^DIE
 F  D  Q:X=""!($G(DTOUT))!($G(DUOUT))
 . D ^XBFMK       ;kill FileMan variables
 . S DA(1)=1
 . S DIC="^ABSP(9002313.99,"_DA(1)_",""UNBILLABLE NDC #"","
 . S DIC(0)="AELMQZ"
 . S DIC("W")="D GETNAME^ABSPOSQQ(1)"
 . D ^DIC
 . S NEWREC=$P(Y,U,3)
 . I Y>0&('$G(DTOUT))&('$G(DUOUT))&('NEWREC) D
 . . S DIE="^ABSP(9002313.99,"_DA(1)_",""UNBILLABLE NDC #"","
 . . S DA=+Y
 . . S DR=.01
 . . D ^DIE
 ;IHS/SD/RLT - 04/27/06 - Patch 17 - END PART 1
 W !!,"Now, NDC numbers that are unbillable/billable",!
 W "for specific insurers",!
 D NOTE
 ;IHS/SD/RLT - 04/07/06 - Patch 17 - BEGIN PART 2
 D ^XBFMK       ;kill FileMan variables
 F  S (DIC,DLAYGO)=9002313.4,DIC(0)="AE" D ^DIC Q:Y<1  D
 . ;S DIE=9002313.4,DA=+Y,DR="2128.11;228.11" D ^DIE
 . S INSIEN=+Y
 . F  D  Q:X=""!($G(DTOUT))!($G(DUOUT))
 . . D ^XBFMK       ;kill FileMan variables
 . . S DA(1)=INSIEN
 . . S DIC="^ABSPEI("_DA(1)_",""UNBILLABLE NDC #"","
 . . S DIC(0)="AELMQZ"
 . . S DIC("W")="D GETNAME^ABSPOSQQ(2)"
 . . D ^DIC
 . . S NEWREC=$P(Y,U,3)
 . . I Y>0&('$G(DTOUT))&('$G(DUOUT))&('NEWREC) D
 . . . S DIE="^ABSPEI("_DA(1)_",""UNBILLABLE NDC #"","
 . . . S DA=+Y
 . . . S DR=.01
 . . . D ^DIE
 . F  D  Q:X=""!($G(DTOUT))!($G(DUOUT))
 . . D ^XBFMK
 . . S DA(1)=INSIEN
 . . S DIC="^ABSPEI("_DA(1)_",""BILLABLE NDC #"","
 . . S DIC(0)="AELMQZ"
 . . S DIC("W")="D GETNAME^ABSPOSQQ(3)"
 . . D ^DIC
 . . S NEWREC=$P(Y,U,3)
 . . I Y>0&('$G(DTOUT))&('$G(DUOUT))&('NEWREC) D
 . . . S DIE="^ABSPEI("_DA(1)_",""BILLABLE NDC #"","
 . . . S DA=+Y
 . . . S DR=.01
 . . . D ^DIE
 ;IHS/SD/RLT - 04/07/06 - Patch 17 - END PART 2
 Q
GETNAME(TAG) ;
 ;IHS/SD/RLT - 04/07/06 - Patch 17 - BEGIN PART 3
 N NDC,NDCIEN,DRUGNAME
 S:TAG=1 NDC=$P($G(^ABSP(9002313.99,DA(1),"UNBILLABLE NDC #",Y,0)),U)
 S:TAG=2 NDC=$P($G(^ABSPEI(DA(1),"UNBILLABLE NDC #",Y,0)),U)
 S:TAG=3 NDC=$P($G(^ABSPEI(DA(1),"BILLABLE NDC #",Y,0)),U)
 S NDCIEN=$O(^APSAMDF("B",NDC,0))
 S:NDCIEN="" DRUGNAME="NDC NOT FOUND IN AWP TRANSACTION FILE"
 S:NDCIEN'="" DRUGNAME=$P($G(^APSAMDF(NDCIEN,2)),U)
 W DRUGNAME
 Q
 ;IHS/SD/RLT - 04/07/06 - Patch 17 - END PART 3
ANYSET(N) ;EP - are any of the billable/unbillable fields set for 
 ; ^ABSPEI(N ?
 ;  Used by computed field 2128.99
 I $P($G(^ABSPEI(N,"UNBILLABLE OTC")),U)]"" Q 1
 N RET,X,Y S RET=0
 F X="","UN" F Y="DRUG NAME","NDC #" D
 . I $O(^ABSPEI(N,X_"BILLABLE "_Y,0)) S RET=1
 Q RET
