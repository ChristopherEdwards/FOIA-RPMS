BDGAD3 ; IHS/ANMC/LJF - A&D SERV TRANSFERS ;  [ 04/16/2004  4:39 PM ]
 ;;5.3;PIMS;**1013**;APR 26, 2002
 ;
LOOP ;--loop service transfers
 NEW DGDT,DFN,IFN
 S DGDT=DGBEG
 F  S DGDT=$O(^DGPM("AMV6",DGDT)) Q:'DGDT!(DGDT>DGEND)  D
 . S DFN=0 F  S DFN=$O(^DGPM("AMV6",DGDT,DFN)) Q:'DFN  D
 .. S IFN=0 F  S IFN=$O(^DGPM("AMV6",DGDT,DFN,IFN)) Q:'IFN  D GATHER
 Q
 ;
GATHER ; gather info on service transfers and put counts into arrays
 NEW ADULT,ADM,OLDSV,NEWSV,OLDSVN,NEWSVN,X,NAME,LOS,WARD
 I $D(^DGPM("AMV2",DGDT,DFN)) Q    ;also ward transfer-already counted
 S LJF=DGDT_U_DFN_U_IFN
 S ADM=$P(^DGPM(IFN,0),U,14)                   ;admit ien
 I IFN=$$ADMTXN^BDGF1(ADM,DFN) Q               ;don't use admit service
 S ADULT=$S($$AGE<$$ADULT^BDGPAR:0,1:1)        ;1=adult, 0=peds
 ;
 Q:'+$$PRIORTXN^BDGF1(DGDT,ADM,DFN)  ;ihs/cmi/maw 10/29/2010 patch 1014
 S OLDSV=$P(^DGPM(+$$PRIORTXN^BDGF1(DGDT,ADM,DFN),0),U,9)  ;old srv
 I +OLDSV=0 W !,DFN_"    "_ADM
 S X=$O(^DGPM("AMV6",DGDT,DFN,0)) Q:'X
 S NEWSV=$P($G(^DGPM(X,0)),U,9) Q:'NEWSV  Q:(OLDSV=NEWSV)
 S OLDSVN=$$GET1^DIQ(45.7,OLDSV,.01)
 S NEWSVN=$$GET1^DIQ(45.7,NEWSV,.01)
 S X=$$PRIORMVT^BDGF1(DGDT,ADM,DFN) Q:'X   ;prior physical mvmt
 S WARD=$$GET1^DIQ(405,X,.06,"I")
 ;
 S LOS=$$FMDIFF^XLFDT(DGDT,+$G(^DGPM(+$$PRIORTXN^BDGF1(DGDT,ADM,DFN),0)))
 ;  collect patient data for report
 S NAME=$$GET1^DIQ(2,DFN,.01)
 S ^TMP("BDGAD",$J,"SERV",NAME,DFN,IFN)=OLDSV_U_NEWSV
 Q:$G(BDGREP)                              ;reprint, not recalculating
 ;
 ; -- increment counts in ADT Census files
 ;  -- set up services within wards if not already there
 I '$D(^BDGCWD(WARD,1,BDGT,1,NEWSV)) D
 . S ^BDGCWD(WARD,1,BDGT,1,NEWSV,0)=NEWSV
 . S $P(^BDGCWD(WARD,1,BDGT,1,0),U,3,4)=NEWSV_U_($P(^BDGCWD(WARD,1,BDGT,1,0),U,4)+1)
 I '$D(^BDGCWD(WARD,1,BDGT,1,OLDSV)) D
 . S ^BDGCWD(WARD,1,BDGT,1,OLDSV,0)=OLDSV
 . S $P(^BDGCWD(WARD,1,BDGT,1,0),U,3,4)=OLDSV_U_($P(^BDGCWD(WARD,1,BDGT,1,0),U,4)+1)
 ;
 I ADULT D
 . ; --- transfer in to new service
 . S $P(^BDGCTX(NEWSV,1,BDGT,0),U,5)=$P($G(^BDGCTX(NEWSV,1,BDGT,0)),U,5)+1
 . S $P(^BDGCWD(WARD,1,BDGT,1,NEWSV,0),U,5)=$P(^BDGCWD(WARD,1,BDGT,1,NEWSV,0),U,5)+1
 . ;
 . ; transfer out of old service
 . S $P(^BDGCTX(OLDSV,1,BDGT,0),U,6)=$P($G(^BDGCTX(OLDSV,1,BDGT,0)),U,6)+1
 . S $P(^BDGCWD(WARD,1,BDGT,1,OLDSV,0),U,6)=$P(^BDGCWD(WARD,1,BDGT,1,OLDSV,0),U,6)+1
 . S $P(^BDGCTX(OLDSV,1,BDGT,0),U,9)=$P($G(^BDGCTX(OLDSV,1,BDGT,0)),U,9)+LOS
 . S $P(^BDGCWD(WARD,1,BDGT,1,OLDSV,0),U,9)=$P(^BDGCWD(WARD,1,BDGT,1,OLDSV,0),U,9)+LOS
 . ;
 I 'ADULT D
 . ; --- transfer in to new service
 . S $P(^BDGCTX(NEWSV,1,BDGT,0),U,15)=$P($G(^BDGCTX(NEWSV,1,BDGT,0)),U,15)+1
 . S $P(^BDGCWD(WARD,1,BDGT,1,NEWSV,0),U,15)=$P(^BDGCWD(WARD,1,BDGT,1,NEWSV,0),U,15)+1
 . ; transfer out of old service
 . S $P(^BDGCTX(OLDSV,1,BDGT,0),U,16)=$P($G(^BDGCTX(OLDSV,1,BDGT,0)),U,16)+1
 . S $P(^BDGCWD(WARD,1,BDGT,1,OLDSV,0),U,16)=$P(^BDGCWD(WARD,1,BDGT,1,OLDSV,0),U,16)+1
 . S $P(^BDGCTX(OLDSV,1,BDGT,0),U,19)=$P($G(^BDGCTX(OLDSV,1,BDGT,0)),U,19)+LOS
 . S $P(^BDGCWD(WARD,1,BDGT,1,OLDSV,0),U,19)=$P(^BDGCWD(WARD,1,BDGT,1,OLDSV,0),U,19)+LOS
 ;
 Q
 ;
AGE() ;--age at admit
 NEW X,X1,X2
 S X1=+$G(^DGPM(ADM,0))                  ;admit date
 S X2=$P($G(^DPT(DFN,0)),U,3) D ^%DTC    ;date of birth
 Q:'X "" Q X\365.25
 ;
