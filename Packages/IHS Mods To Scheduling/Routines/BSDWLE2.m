BSDWLE2 ; IHS/OIT/LJF - REMOVE WAIT LIST ENTRY AFTER MAKE APPT
 ;;5.3;PIMS;**1004,1005,1013**;MAY 28, 2004
 ;IHS/OIT/LJF 07/28/2005 PATCH 1004 routine added
 ;            12/29/2005 PATCH 1005 check for being called by event driver while auto-rebooking appt and
 ;                                   printing letters where IO is set to printer; SDMODE not set correctly
 ;
 Q:'$G(DFN)                                  ;bad call from protocol
 Q:$G(SDAMEVT)'=1                            ;skip if not make appt event
 Q:$P($G(^DPT(DFN,"S",+$G(SDT),0)),U,7)'=3   ;skip if not scheduled appt
 Q:$G(SDMODE)'=0                             ;skip if not in interactive mode
 Q:$E(IOST,1,2)'="C-"                        ;skip if IO is set to printer;IHS/OIT/LJF 12/29/2005 PATCH 1005
 ;
 NEW PROMPT,BSDR,IEN,X,Y,IENS,ARRAY,DIE,DA,DR,CNT
 Q:'$$ONWL^BSDWLV(DFN,"C")    ;not on active waiting list
 D WLDATA^BSDWLV(DFN,"C",.BSDR)    ;get list of active entries
 D FULL^VALM1
 ;
 D MSG^BDGF($$REPEAT^XLFSTR("-",10)_"Patient On These Waiting Lists"_$$REPEAT^XLFSTR("-",10),2,0)
 S (CNT,X)=0 F  S X=$O(BSDR(X)) Q:'X  D  ;ihs/cmi/maw added 10/18/2010
 . S BSDY=0 F  S BSDY=$O(BSDR(X,BSDY)) Q:'BSDY  D
 .. S CNT=CNT+1
 .. D MSG^BDGF(CNT_". "_$P(BSDR(X,BSDY),U,2),1,0)
 ;
 S PROMPT="Do you wish to REMOVE this patient from "_$S($$WLMANY(.BSDR):"one of these waiting lists",1:"this waiting list")
 Q:'$$READ^BDGF("Y",PROMPT)
 ;
 I '$$WLMANY(.BSDR) S IEN=$O(BSDR(0))   ;if only one, don't ask which one
 E  D  Q:Y<1                            ;else, ask which one
 . S (CNT,X)=0 F  S X=$O(BSDR(X)) Q:'X  S CNT=CNT+1,ARRAY(CNT)=X
 . S Y=$$READ^BDGF("NO^1:"_CNT,"Which One") Q:Y<1
 . S IEN=ARRAY(Y)
 ;
 N BSDSUB  ;ihs/cmi/maw added 10/18/2010
 S BSDSUB=$O(BSDR(IEN,0))  ;ihs/cmi/maw added 10/18/2010
 ;S IENS=$P(BSDR(IEN,1),U)  ;ihs/cmi/maw added 10/18/2010
 S IENS=$P(BSDR(IEN,BSDSUB),U)  ;ihs/cmi/maw added 10/18/2010
 S DA(1)=$P(IENS,",",2),DA=$P(IENS,","),DIE="^BSDWL("_DA(1)_",1,"
 S DR=".07;.08;I $P(^(0),U,11)]"""" S Y=""@1"";.11///`"_DUZ_";@1;1"
 D ^DIE
 Q
 ;
WLMANY(ARRAY) ; returns one if patient has more than one active waiting list entry
 I $O(ARRAY(+$O(ARRAY(0)))) Q 1
 Q 0
