BDGCPT1 ; IHS/ANMC/LJF - MORE CPT CODES FOR INPT STAY ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
 ;continuation of code in BDGCPT
 ;
AMB ;EP; find all ambulatory visits within hosp date range
 NEW DGADM,DGDSC,DGDT,DGVN,DGBEG,DGI
 S DGADM=$$GET1^DIQ(9000010,DGV,.01,"I")\1              ;admit date
 S DGBEG=$$FMADD^XLFDT(DGADM,-3)                        ;72/24 rule
 S DGDSC=$$GET1^DIQ(9000010.02,+$O(^AUPNVINP("AD",DGV,0)),.01,"I")
 I DGDSC="" S DGDSC=DT
 S DGBEG=(9999999-DGBEG)_".9999999",(DGDSC,DGDT)=9999999-DGDSC
 ;
 F  S DGDT=$O(^AUPNVSIT("AA",DFN,DGDT)) Q:'DGDT  Q:(DGDT>DGBEG)  D
 . S DGVN=0 F  S DGVN=$O(^AUPNVSIT("AA",DFN,DGDT,DGVN)) Q:'DGVN  D
 .. I "HICE"[$$GET1^DIQ(9000010,DGVN,.07,"I") Q
 .. S DGVV=DGVN
 .. ;
 .. ; if medicare sheet only pull radiology, tran codes and cpt codes
 .. I BDGFIN=3 F DGI="RAD","TRAN","CPT" S DGI=DGI_"^BDGCPT" D @DGI I 1
 .. ;
 .. ; else, pull all categories
 .. E  F DGI="CPT","TRAN","RAD","MED","SUP","LAB","IMM" S DGI=DGI_"^BDGCPT" D @DGI
 .. ;
 .. ;   and display basic visit info on each amb visit
 .. I BDGFIN=2 D VSIT
 Q
 ;
VSIT ; -- find visit data
 NEW DGN,LINE,FIRST,CNT,ARRPOV,ARRPRC,ARRPRV,X
 S LINE=$$FMTE^XLFDT(9999999-$P(DGDT,".")_"."_$P(DGDT,".",2))
 S LINE=$$PAD(LINE,20)_"Type/Clinic: "
 S LINE=LINE_$E($$GET1^DIQ(9000010,DGVV,.07),1,15)
 S X=$E($$GET1^DIQ(9000010,DGVV,.08),1,15) S:X="" X="NONE"
 S LINE=LINE_"/"_X
 ;
 ; -- find providers for visit
 S (CNT,DGN)=0
 F  S DGN=$O(^AUPNVPRV("AD",DGVV,DGN)) Q:'DGN  D
 . S X=$E($$GET1^DIQ(9000010.06,DGN,.01),1,17)  ;provider name
 . I $$GET1^DIQ(9000010.06,DGN,.04,"I")="P" S LINE=$$PAD(LINE,63)_X Q
 . S CNT=CNT+1,ARRPRV(CNT)=X
 ;
 D SET(LINE,"VSIT",DGDT,DGVV)
 ;
 ; -- find dx for visit
 S (CNT,DGN)=0
 F  S DGN=$O(^AUPNVPOV("AD",DGVV,DGN)) Q:'DGN  D
 . S CNT=CNT+1,ARRPOV(CNT)=$$GET1^DIQ(9000010.07,DGN,.01)
 . S ARRPOV(CNT)=$$PAD(ARRPOV(CNT),10)_$E($$GET1^DIQ(9000010.07,DGN,.04),1,30)
 I '$D(ARRPOV) S ARRPOV(1)="**UNCODED VISIT**"
 ;
 ; -- display all dx and other providers
 S (CNT,HIGH)=0
 F  S CNT=$O(ARRPOV(CNT)) Q:'CNT  D
 . S HIGH=CNT,LINE=$$PAD($$SP(20)_ARRPOV(CNT),63)_$G(ARRPRV(CNT))
 . D SET(LINE,"VSIT",DGDT,DGN_":"_CNT)
 ;
 S CNT=HIGH
 F  S CNT=$O(ARRPRV(CNT)) Q:'CNT  D
 . S LINE=$$SP(63)_ARRPRV(CNT) D SET(LINE,"VSIT",DGDT,DGN_":"_CNT)
 Q
 ;
 ;
PRV ; -- find all v provider entries for hospitalization
 NEW DGN,DGDT,LINE
 S DGN=0 F  S DGN=$O(^AUPNVPRV("AD",DGVV,DGN)) Q:'DGN  D
 . I $E($$GET1^DIQ(9000010.06,DGN,.019),2,3)="88" Q  ;coder
 . S DGDT=$$DATE^BDGCPT(9000010.06,DGN),LINE=$$FMTE^XLFDT(DGDT,"D")
 . S LINE=$$PAD(LINE,15)_$$GET1^DIQ(9000010.06,DGN,.01)
 . S LINE=$$PAD(LINE,40)_" "_$$GET1^DIQ(9000010.06,DGN,.04)
 . S LINE=LINE_"/"_$$GET1^DIQ(9000010.06,DGN,.05)
 . D SET(LINE,"PRV",DGDT,DGN)
 Q
 ;
 ;
TRAN ; -- find all trans codes & display in M/M format
 NEW DGN,DGDT,LINE,TRAN
 S DGN=0 F  S DGN=$O(^AUPNVTC("AD",DGVV,DGN)) Q:'DGN  D
 . Q:$$GET1^DIQ(9000010.33,DGN,.07)=""  ;only entries with CPT codes
 . S DGDT=$$DATE^BDGCPT(9000010.33,DGN),LINE=$$FMTE^XLFDT(DGDT,"D")
 . S LINE=$$PAD(LINE,15)_"CPT: "_$$GET1^DIQ(9000010.33,DGN,.07)
 . S LINE=$$PAD(LINE_$$GET1^DIQ(9000010.33,DGN,.08),27)  ;cpt modfier
 . S TRAN=$$GET1^DIQ(9000010.33,DGN,.01)
 . S LINE=LINE_"  "_$E($$GET1^DIQ(9000010.33,DGN,.11),1,23)
 . S LINE=$$PAD(LINE,54)_"DX:"
 . S LINE=$$PAD(LINE,60)_$E($$GET1^DIQ(9000010.33,DGN,1204),1,20)
 . D SET(LINE,"CPT",DGDT,DGN)  ;save in CPT section
 Q
 ;
SET(LINE,SECTION,DATE,IEN) ; -- put display line into date order under section
 S ^TMP("BDGCPT",$J,SECTION,DATE,IEN)=$E(LINE,1,80)
 Q
 ;
PAD(D,L) ; -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
