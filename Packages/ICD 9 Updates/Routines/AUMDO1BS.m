AUMDO1BS ; IHS/OIRM/DSD/JCM,AEF - UPDATE ICD GLOBAL (SUBROUTINE OF AUMDO1B) ;  [ 12/03/1998   2:35 PM ]
 ;;99.1;ICD UPDATE;;DEC 03, 1998
 W !,"ENTRY NOT PERMITTED HERE (AUMDO1BS)",! Q
PGRNOTE ; This module contains two subroutines called from AUMDO1B
 ; (COMMON and DSPSTAT) becuase AUMDO1B got too big after the
 ; dictionary change in 92.2 distribution.
 ; Added to new fields to the ICD file dictionaries:
 ;   - DATE LAST UPDATE
 ;   - UPDATE CYCLE #
 ; COMMON sub-rtn adds these to the DR string
 ;
COMMON ; ENTRY POINT from EN+5^AUMDO1B-update common fields to each ICD file
 ; process the INACTIVE FLAG and DATE fields
 D  ; SETSTAT subroutine from AUMDO1B
 . S AUMDO("STAT FLAG")=$P(@(AUMDO("UPD GL REF")_AUMDO("UPD DFN")_",0)"),U,9) ; save INACTIVE STATUS FLAG field
 . S AUMDO("STAT FLAG DATE")=$P(@(AUMDO("UPD GL REF")_AUMDO("UPD DFN")_",0)"),U,11) ; save DATE INACTIVATED field
 . I AUMDO("ADD!A/R") D  Q
 .. I AUMDO("STAT FLAG")="" D  Q
 ... S DR=DR_"100///@;102///@;" ;force nulls to the flag and date fields
 .. S DR=DR_"100////1;"
 .. S:AUMDO("STAT FLAG DATE")]"" DR=DR_"102////"_AUMDO("STAT FLAG DATE")_";"
 . I AUMDO("CHANGE") D
 .. Q:AUMDO("STAT FLAG")=""
 .. S DR=DR_"100////1;"
 .. S:AUMDO("STAT FLAG DATE")]"" DR=DR_"102////"_AUMDO("STAT FLAG DATE")_";"
 ;                                .01 Code Number
 S:$D(@(AUMDO("UPD GL REF")_AUMDO("UPD DFN")_",1)")) $P(@(AUMDO("ICD GL REF")_AUMDO("ICD DFN")_",1)"),U)=$P(^(1),U)
 ;                                2 Identifier
 S:$P(@(AUMDO("UPD GL REF")_AUMDO("UPD DFN")_",0)"),U,2)]"" DR=DR_"2////"_$P(^(0),U,2)_";"
 ;                                8 ICD expanded
 S:$P(@(AUMDO("UPD GL REF")_AUMDO("UPD DFN")_",0)"),U,8)]"" DR=DR_"8////"_$P(^(0),U,8)_";"
 ;                                9.5 Use only with sex
 S:$P(@(AUMDO("UPD GL REF")_AUMDO("UPD DFN")_",0)"),U,10)]"" DR=DR_"9.5////"_$P(^(0),U,10)_";"
 ;                                100 Inactive Flag & 102 Inactive Date
 I $P(@(AUMDO("UPD GL REF")_AUMDO("UPD DFN")_",0)"),U,9)]"" S DR=DR_"100////1;" S:$P(^(0),U,11)]"" DR=DR_"102////"_$P(^(0),U,11)_";"
 ;                                2100000 Date Last Update (new field)
 S:$P(@(AUMDO("UPD GL REF")_AUMDO("UPD DFN")_",2100000)"),U,1)]"" DR=DR_"2100000////"_$P(^(2100000),U,1)_";"
 ;                                2100002 Update Cycle # (new field)
 S:$P(@(AUMDO("UPD GL REF")_AUMDO("UPD DFN")_",2100000)"),U,3)]"" DR=DR_"2100002////"_$P(^(2100000),U,3)_";"
 I '$D(@(AUMDO("UPD GL REF")_AUMDO("UPD DFN")_",9999999)"))
 E  D
 . ;                              set common fields for 9999999 node
 . S:$P(@(AUMDO("UPD GL REF")_AUMDO("UPD DFN")_",9999999)"),U)]"" DR=DR_"9999999.01////"_$P(^(9999999),U)_";"
 . S:$P(^(9999999),U,2)]"" DR=DR_"9999999.02////"_$P(^(9999999),U,2)_";" S:$P(^(9999999),U,3)]"" DR=DR_"9999999.03////"_$P(^(9999999),U,3)_";"
 S DR=$E(DR,1,$L(DR)-1) ;         remove trailing semicolon
 Q
DSPSTAT ; ENTRY POINT from EN+7^AUMDO1B to display status of icd code
 D:$Y>55 HDR^AUMDO
 I AUMDO("ADD/REPLACE") W !,?27,"Old status was "_$S(AUMDO("OLD STATUS")="":"active",1:"inactive")
 W !,?27,"Status is "
 W $S(AUMDO("SUPERCEDED"):"inactive - (Superceded code)",AUMDO("VA EXPANDED"):"inactive - (VA Expanded code)",AUMDO("INACTIVE"):"inactive",AUMDO("ACTIVE"):"active",1:"unchanged")
 Q
