BDGAD2 ; IHS/ANMC/LJF - A&D WARD TRANSFERS ;  [ 02/10/2005  4:05 PM ]
 ;;5.3;PIMS;**1001,1002,1012**;APR 26, 2002
 ;
LOOP ;--loop ward transfers
 NEW DGDT,DFN,IFN
 S DGDT=DGBEG
 F  S DGDT=$O(^DGPM("AMV2",DGDT)) Q:'DGDT!(DGDT>DGEND)  D
 . S DFN=0 F  S DFN=$O(^DGPM("AMV2",DGDT,DFN)) Q:'DFN  D
 .. S IFN=0 F  S IFN=$O(^DGPM("AMV2",DGDT,DFN,IFN)) Q:'IFN  D GATHER
 Q
 ;
GATHER ; gather info on ward transfers and put counts into arrays
 NEW ADM,ADULT,NEWWD,OLDWD,OLDSV,OLDSVN,NEWSV,NEWSVN,X,NAME,LOS
 S ADM=$P(^DGPM(IFN,0),U,14)                                 ;admit ien
 S ADULT=$S($$AGE<$$ADULT^BDGPAR:0,1:1)              ;1=adult, 0=peds
 ;
 ;S NEWWD=$P($G(^DGPM(IFN,0)),U,6) I 'NEWWD S NEWWD="??"        ;new ward  cmi/maw 4/23/2010 orig line
 S NEWWD=$P($G(^DGPM(IFN,0)),U,6) Q:'NEWWD        ;new ward  cmi/maw 4/23/2010 new ling
 S OLDWD=$P($G(^DGPM(+$$PRIORMVT^BDGF1(DGDT,ADM,DFN),0)),U,6)  ;old ward
 Q:'$G(OLDWD)  ;cmi/maw 4/23/2010 if old ward is blank patch 1012
 ;
 S OLDSV=$P(^DGPM(+$$PRIORTXN^BDGF1(DGDT,ADM,DFN),0),U,9)  ;old srv
 Q:'$G(OLDSV)  ;cmi/maw 4/23/2010 if old service is blank PATCH 1012
 S X=$O(^DGPM("AMV6",DGDT,DFN,0))
 S NEWSV=$S('X:OLDSV,X:$P($G(^DGPM(X,0)),U,9),1:OLDSV)    ;new srv
 ;IHS/ITSC/WAR 1/21/2005 PATCH #1002 Added next line, defensive code for Pc9 being NULL (only a bed change on transfer record)
 ; Interward change - has no ward change, nor srv change
 I 'NEWSV S NEWSV=OLDSV
 S OLDSVN=$$GET1^DIQ(45.7,OLDSV,.01)
 S NEWSVN=$$GET1^DIQ(45.7,NEWSV,.01)
 ;
 S LOS=$$FMDIFF^XLFDT(DGDT,+$G(^DGPM(+$$PRIORMVT^BDGF1(DGDT,ADM,DFN),0)))
 ;
 ;  collect patient data for report
 S NAME=$$GET1^DIQ(2,DFN,.01)
 S ^TMP("BDGAD",$J,"WARD",NAME,DFN,IFN)=OLDWD_U_NEWWD
 I OLDSV'=NEWSV S ^TMP("BDGAD",$J,"SERV",NAME,DFN,IFN)=OLDSV_U_NEWSV   ;IHS/ITSC/LJF 7/7/2004 PATCH #1001
 Q:$G(BDGREP)                              ;reprint, not recalculating
 ;
 ; -- increment counts in ADT Census files
 ; --- transfer in to new ward
 S $P(^BDGCWD(NEWWD,1,BDGT,0),U,5)=$P($G(^BDGCWD(NEWWD,1,BDGT,0)),U,5)+1
 ;
 ; --- transfer in for service within ward by age
 ; ---- set zero node if needed
 I '$D(^BDGCWD(NEWWD,1,BDGT,1,NEWSV)) D
 . S ^BDGCWD(NEWWD,1,BDGT,1,NEWSV,0)=NEWSV
 . S $P(^BDGCWD(NEWWD,1,BDGT,1,0),U,3,4)=NEWSV_U_($P(^BDGCWD(NEWWD,1,BDGT,1,0),U,4)+1)
 ;
 I '$D(^BDGCTX(NEWSV,1,BDGT,0)) D
 . S ^BDGCTX(NEWSV,1,BDGT,0)=BDGT
 I ADULT D
 . S $P(^BDGCWD(NEWWD,1,BDGT,1,NEWSV,0),U,5)=$P($G(^BDGCWD(NEWWD,1,BDGT,1,NEWSV,0)),U,5)+1
 . I NEWSV'=OLDSV S $P(^BDGCTX(NEWSV,1,BDGT,0),U,5)=$P($G(^BDGCTX(NEWSV,1,BDGT,0)),U,5)+1
 I 'ADULT D
 . S $P(^BDGCWD(NEWWD,1,BDGT,1,NEWSV,0),U,15)=$P($G(^BDGCWD(NEWWD,1,BDGT,1,NEWSV,0)),U,15)+1
 . I NEWSV'=OLDSV S $P(^BDGCTX(NEWSV,1,BDGT,0),U,15)=$P($G(^BDGCTX(NEWSV,1,BDGT,0)),U,15)+1
 ;
 ;
 ; --- transfer out of old ward
 S $P(^BDGCWD(OLDWD,1,BDGT,0),U,6)=$P($G(^BDGCWD(OLDWD,1,BDGT,0)),U,6)+1
 ;  ---- increment LOS for old ward
 S $P(^BDGCWD(OLDWD,1,BDGT,0),U,9)=$P($G(^BDGCWD(OLDWD,1,BDGT,0)),U,9)+LOS
 ;
 ; --- increment transfer out for service with in ward by age
 ; ---- set zero node if needed
 I '$D(^BDGCWD(OLDWD,1,BDGT,1,OLDSV)) D
 . S ^BDGCWD(OLDWD,1,BDGT,1,OLDSV,0)=OLDSV
 . S $P(^BDGCWD(OLDWD,1,BDGT,1,0),U,3,4)=OLDSV_U_($P(^BDGCWD(OLDWD,1,BDGT,1,0),U,4)+1)
 ;
 I ADULT D
 . S $P(^BDGCWD(OLDWD,1,BDGT,1,OLDSV,0),U,6)=$P($G(^BDGCWD(OLDWD,1,BDGT,1,OLDSV,0)),U,6)+1
 . S $P(^BDGCWD(OLDWD,1,BDGT,1,OLDSV,0),U,9)=$P($G(^BDGCWD(OLDWD,1,BDGT,1,OLDSV,0)),U,9)+LOS
 . I OLDSV'=NEWSV S $P(^BDGCTX(OLDSV,1,BDGT,0),U,6)=$P($G(^BDGCTX(OLDSV,1,BDGT,0)),U,6)+1
 . I OLDSV'=NEWSV S $P(^BDGCTX(OLDSV,1,BDGT,0),U,9)=$P($G(^BDGCTX(OLDSV,1,BDGT,0)),U,9)+LOS
 ;
 I 'ADULT D
 . S $P(^BDGCWD(OLDWD,1,BDGT,1,OLDSV,0),U,16)=$P($G(^BDGCWD(OLDWD,1,BDGT,1,OLDSV,0)),U,16)+1
 . S $P(^BDGCWD(OLDWD,1,BDGT,1,OLDSV,0),U,19)=$P($G(^BDGCWD(OLDWD,1,BDGT,1,OLDSV,0)),U,19)+LOS
 . I OLDSV'=NEWSV S $P(^BDGCTX(OLDSV,1,BDGT,0),U,16)=$P($G(^BDGCTX(OLDSV,1,BDGT,0)),U,16)+1
 . I OLDSV'=NEWSV S $P(^BDGCTX(OLDSV,1,BDGT,0),U,19)=$P($G(^BDGCTX(OLDSV,1,BDGT,0)),U,19)+LOS
 ;
 Q
 ;
AGE() ;--age at admit
 NEW X,X1,X2
 S X1=+$G(^DGPM(ADM,0))                  ;admit date
 S X2=$P($G(^DPT(DFN,0)),U,3) D ^%DTC    ;date of birth
 Q:'X "" Q X\365.25
 ;
