INHUTC2 ;bar; 29 May 97 14:50; Interface Criteria Internal Utilities (DD)
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;;COPYRIGHT 1997 SAIC
 Q
 ;
CLRLK(INOPT,INDA) ; clear all accumulated locks
 ;
 ; input:   INOPT array
 ;          INDA = optional entry to not clear
 ; return:  none
 ;
 N H,I,Y
 S Y=0 F  S Y=$O(INOPT("LOCK",Y)) Q:'Y  D
 . S H=INOPT("LOCK",Y)
 . I Y=$G(INDA) S H=H-1,INOPT("LOCK",Y)=1
 . E  K INOPT("LOCK",Y)
 . F I=1:1:H S %=$$LOCK^INHUTC(Y,0)
 Q
 ;
TASK ; this tag is the entry point when called thru taskman
 ; input: INOPT array as described at the top of INHUTC, required.
 S %=$$RUN^INHUTC(.INOPT)
 Q
 ;
AUSER(INDA,INDUZ,INTYPE,INCTRL,INAPP,INFUNC,INDEL) ; manage AUSER x-ref
 ;
 ; input: INDA = ien to 4001.1 file, required
 ;               at least one of the next four is required
 ;        INTYPE = value of CRITERIA TYPE field
 ;        INCTRL = value of CONTROL field
 ;        INAPP = value of APPLICATION field
 ;        INFUNC = value of FUNCTION field
 ;        INDEL = if TRUE kill x-ref, otherwize set x-ref, optional
 ;
 Q:$G(INDA)<1
 N INNULL S INNULL="INNULL"
 I '$G(INDUZ) S INDUZ=$P(^DIZ(4001.1,INDA,0),U,2) S:'INDUZ INDUZ="NULL"
 E  S INNULL="INDUZ"
 I '$L($G(INTYPE)) S INTYPE=$P(^DIZ(4001.1,INDA,0),U,5) S:'$L(INTYPE) INTYPE="NULL"
 E  S INNULL="INTYPE"
 I '$L($G(INCTRL)) S INCTRL=$P(^DIZ(4001.1,INDA,0),U,3) S:'$L(INCTRL) INCTRL="NULL"
 E  S INNULL="INCTRL"
 I '$L($G(INAPP)) S INAPP=$P(^DIZ(4001.1,INDA,0),U,8) S:'$L(INAPP) INAPP="NULL"
 E  S INNULL="INAPP"
 I '$L($G(INFUNC)) S INFUNC=$P(^DIZ(4001.1,INDA,0),U,6) S:'$L(INFUNC) INFUNC="NULL"
 E  S INNULL="INFUNC"
 I $G(INDEL) D  Q
 . K ^DIZ(4001.1,"AUSER",INDUZ,INTYPE,INCTRL,INAPP,INFUNC,INDA)
 . ; W !,"K ^DIZ(4001.1,""AUSER"","_INDUZ_","_INTYPE_","_INCTRL_","_INAPP_","_INFUNC_","_INDA_")"
 D
 . N @INNULL Q:'$D(INNULL)  S @INNULL="NULL"
 . D AUSER(INDA,INDUZ,INTYPE,INCTRL,INAPP,INFUNC,1)
 S ^DIZ(4001.1,"AUSER",INDUZ,INTYPE,INCTRL,INAPP,INFUNC,INDA)=""
 ; W !,"S ^DIZ(4001.1,""AUSER"","_INDUZ_","_INTYPE_","_INCTRL_","_INAPP_","_INFUNC_","_INDA_")="""""
 Q
 ;
TYPE(INTYPE,INSRCH) ; validate CRITERIA TYPE field
 ; called from input transform file 4001.1, field .05
 ; also used in criteria mgmt functions
 ;
 ; input: INTYPE = value to validate
 ;        INSRCH - 0 = validate for any type
 ;                 1 = validate for search types only
 ; return: boolean TRUE or FALSE
 ;
 Q:'$L($G(INTYPE)) 0
 I $G(INSRCH) Q "^TRANSACTION^ERROR^"[(U_INTYPE_U)
 Q "^TRANSACTION^ERROR^TEST^"[(U_INTYPE_U)
 ;
SPACEBAR(X) ; return x for spacebar in lookup
 ; called from PRELK node for file 4001.1, also used in criteria mgmt
 ; functions. INOPT array must be defined in env.
 ;
 ; input:  X = input value from read
 ; returns: `ien or X if working entry was not created
 ;
 I $D(INOPT)<10 Q X
 N INY S INY=$$WORKREC^INHUTC1(.INOPT,0)
 ; kill screen, it won't let "W" go thru
 I INY>0 S INY="`"_INY,DIC("S")="" Q INY
 Q X
 ;
RDTGET ; update a WindowMan Screen while editing, PART 1
 ; assumes being called from WindowMan and those variables are defined
 ; Called before RDTSET to setup the proper values
 ;
 ; get start/end relative date
 S DWDIPA(24.01,"STDTR")="",DWDIPA(24.02,"ENDTR")=""
 ; get aux start/end relative date
 S DWDIPA(24.05,"AUSTDTR")="",DWDIPA(24.06,"AUENDTR")=""
 Q
 ;
RDTSET ; update a WindowMan Screen while editing, PART 2
 ; assumes being called from WindowMan and those variables are defined
 ; RDTGET must be called first and on a separate line in a POST field
 ;
 S:$L($G(DIPA("STDTR"))) DWSFLD(1)=$$RELDT^INHUTC2(DIPA("STDTR"),"PU")
 S:$L($G(DIPA("ENDTR"))) DWSFLD(1.1)=$$RELDT^INHUTC2(DIPA("ENDTR"),"PU")
 S:$L($G(DIPA("AUSTDTR"))) DWSFLD(15.01)=$$RELDT^INHUTC2(DIPA("AUSTDTR"),"PU")
 S:$L($G(DIPA("AUENDTR"))) DWSFLD(15.02)=$$RELDT^INHUTC2(DIPA("AUENDTR"),"PU")
 Q
 ;
RELDATE(INCRITDA) ; update relative date for start and end date
 ;
 Q:'$G(INCRITDA)
 N INS,INE,INAS,INAE
 ; relative date for start and end date
 S INS=$G(^DIZ(4001.1,INCRITDA,24)),INE=$P(INS,U,2),INAS=$P(INS,U,5),INAE=$P(INS,U,6),INS=$P(INS,U,1)
 S:$L(INS) ^DIZ(4001.1,INCRITDA,1)=$$RELDT^INHUTC2(INS)
 S:$L(INE) ^DIZ(4001.1,INCRITDA,1.1)=$$RELDT^INHUTC2(INE)
 ; relative date for aux start and end date
 S:$L(INAS) $P(^DIZ(4001.1,INCRITDA,15),U,1)=$$RELDT^INHUTC2(INAS)
 S:$L(INAE) $P(^DIZ(4001.1,INCRITDA,15),U,2)=$$RELDT^INHUTC2(INAE)
 Q
 ;
RELDT(INSTR,INFMT,INPMT) ; convert a relative date text string to FM
 ;
 ; this entry point is used from the DD which does not contain S and T
 ; Use $$RELDT^INHUTC21 entry point not this entry point
 ;
 S INFMT=$G(INFMT)
 ; allow time in input string
 S:'$F(INFMT,"T") INFMT=INFMT_"T"
 ; allow seconds in input string
 S:'$F(INFMT,"S") INFMT=INFMT_"S"
 Q $$RELDT^INHUTC21($G(INSTR),INFMT,$G(INPMT))
