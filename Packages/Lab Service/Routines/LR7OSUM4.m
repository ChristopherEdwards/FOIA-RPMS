LR7OSUM4 ;VA/SLC/DCM - Silent Patient cum cont. ; 17-Oct-2014 09:22 ; MKK
 ;;5.2;LR;**1002,121,187,228,241,251,1018,1021,1028,1031,1033,1034**;NOV 01, 1997;Build 88
 ;
BS ; EP -- from LR7OSUM3
 ;----- BEGIN IHS/OIT/MKK MODIFICATIONS LR*5.2*1021
 NEW P3,P6
 ;----- END IHS/OIT/MKK MODIFICATIONS LR*5.2*1021
 K I,^TMP($J,"TY")
 S LRCW=10,LRHI="",LRLO="",LRTT=1,I=0,LRTY=GIOM-20\10,LRMU=LRMU+1,LRII=0
 F  S LRII=$O(^LAB(64.5,1,1,LRMH,1,LRSH,1,LRII)) Q:LRII<1  S Z=^(LRII,0),P3=$P(Z,U,3),P6=$P(Z,U,6),I=I+1,I(I)=LRII,^TMP($J,"TY",0,I)=P3 S:P6 ^TMP($J,"TY",I,"D")=P6
 ;----- BEGIN IHS/OIT/MKK MODIFICATIONS LR*5.2*1021
 ;K  P3,P6
 ;----- END IHS/OIT/MKK MODIFICATIONS LR*5.2*1021
 F K=1:1:(LRTY-1) S LRFDT=$O(^TMP($J,LRDFN,LRMH,LRSH,LRFDT)) Q:LRFDT<1  S Z=^(LRFDT,0),^TMP($J,"TY",K,"L")=$P(Z,U,1),LRTT=LRTT+1 S:LRFDT>LRLFDT LRLFDT=LRFDT D UDT^LR7OSUM3 D BS1
 S:LRTT>(LRTY-1)&(LRMULT=1) LRFULL=1
 S:LRTT>(LRTY-1)&(LRMU=(LRMULT-1)) LRFULL=1
 F I=1:1:LRSHD D LRLO^LR7OSUM5 S:$L(LRLOHI) ^TMP($J,"TY",(LRTT+1),I)=LRLOHI S:$L(P7) ^TMP($J,"TY",LRTT,I)=P7
 S ^TMP($J,"TY",LRTT,"T")="Units",^TMP($J,"TY",(LRTT+1),"T")="Ranges",^TMP($J,"TY",(LRTT+1),0)=$S($L($P(^LAB(64.5,"A",1,LRMH,LRSH,I(1)),U,11)):"Therapeutic",1:"Reference"),^TMP($J,"TY",LRTT,0)=""
 D LINE
 D LN
 S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(CCNT,CCNT,$E(LRTOPP,1,7))
 F I=1:1:(LRTT+1) S ^TMP("LRC",$J,GCNT,0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(I*10-4,CCNT,$J(^TMP($J,"TY",I,0),10))
 D LN
 S XZ="",$P(XZ," ",3)="",^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(CCNT,CCNT,XZ)
 F I=1:1:(LRTT-1) S ^TMP("LRC",$J,GCNT,0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(I*10-4,CCNT,$J(^TMP($J,"Y2K",I),10))
 D LN
 S XZ="",$P(XZ," ",3)="",^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(CCNT,CCNT,XZ)
 F I=1:1:(LRTT+1) S ^TMP("LRC",$J,GCNT,0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(I*10-4,CCNT,$J(^TMP($J,"TY",I,"T"),10))
 D LN
 S XZ="",$P(XZ,"-",GIOM)="",^TMP("LRC",$J,GCNT,0)=XZ
 F I=1:1:LRSHD S LRCL=8,LRG=^LAB(64.5,1,1,LRMH,1,LRSH,1,I(I),0) D LN S ^TMP("LRC",$J,GCNT,0)="" D BS4
 I $D(LRTX) D LN S LRTX="",^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"Comments: ") F I=1:1 S LRTX=$O(LRTX(LRTX)) Q:LRTX=""  S ^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(10*LRTX-6,CCNT,$C(96+(I#26))_$S(I\26>0:I\26,1:""))
 D TXT1^LR7OSUM5
 S LROFDT=LRFDT
 I $D(LRTX) S LRTX="" F I=1:1 S LRTX=$O(LRTX(LRTX)) Q:LRTX=""  D LN S LRFDT=LRTX(LRTX),^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,$C(96+(I#26))_$S(I\26>0:I\26,1:"")_". ") D TXT^LR7OSUM5
 S LRFDT=LROFDT
 K LRTY,LRTX,^TMP($J,"TY")
 I 'LRFDT G LRSH^LR7OSUM3
 I $O(^TMP($J,LRDFN,LRMH,LRSH,LRFDT))="" G LRSH^LR7OSUM3
 S LRFDT=LRLFDT
 I LRFULL D HEAD^LR7OSUM6,LRNP^LR7OSUM3 S LRFULL=0,LRMU=0
 G BS
BS1 ;
 S ^TMP($J,"TY",K,0)=$P(LRUDT," ",1),^TMP($J,"TY",K,"T")=$P(LRUDT," ",2),^TMP($J,"Y2K",K)=$E($P($P($$Y2K^LRX(9999999-LRFDT),"."),"/",3),1,4)
 F J=1:1:LRSHD S:$D(^TMP($J,LRDFN,LRMH,LRSH,LRFDT,I(J))) ^TMP($J,"TY",K,J)=^(I(J)) S:$D(^TMP($J,LRDFN,LRMH,LRSH,LRFDT,"TX"))&'$D(LRTX(LRTT)) LRTX(LRTT)=LRFDT
 Q
BS2 ;
 S X=$S($D(^TMP($J,"TY",J,I)):$P(^(I),U,1),1:""),X1=$S($L(X):$P(^TMP($J,"TY",J,I),U,2),1:""),LRDP=$S($D(^TMP($J,"TY",I,"D")):^("D"),1:""),LRCL=LRCL+10
 K T1,T3
 Q
BS4 F J=0:1:(LRTT+1) S XZ="",$P(XZ," ",LRCL)="" D
 . I J=0 S X=^TMP($J,"TY",J,I),^TMP("LRC",$J,GCNT,0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(J*10,CCNT,X) S:'$P($G(^TMP("LRT",$J,X)),"^",2) $P(^TMP("LRT",$J,X),"^",2)=GCNT
 . I J>0 D
 .. D BS2
 .. I J=(LRTT+1) D BS2RRCHK                      ; IHS/MSC/MKK - LR*5.2*1031 - Reference Range double-check
 .. I J<LRTT D BS2DPCHK                          ; IHS/MSC/MKK - LR*5.2*1031 - Leading and/or trailing zero(s) check
 .. I $L(X) S LRCW=10 D C1^LR7OSUM5(.X,.X1) S:$L($P(LRG,U,4))&(J<LRTT) @("X="_$P(LRG,"^",4)),^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(J*10-2,CCNT,X_X1) D
 ... ; S:'$L($P(LRG,U,4))!(J'<LRTT) ^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(J*10-2,CCNT,$J(X,LRCW))
 ... ; ----- BEGIN IHS/OIT/MKK - LR*5.2*1028
 ... I '$L($P(LRG,U,4))!(J'<LRTT)  D
 .... I J'<LRTT&(X=+X) S X=$P($G(^BLRUCUM(X,0)),U,3)
 .... S ^(0)=^TMP("LRC",$J,GCNT,0)_$$S^LR7OS(J*10-2,CCNT,$J(X,LRCW))
 ... ; ----- END IHS/OIT/MKK - LR*5.2*1028
 Q
LN ;Increment the counter
 S GCNT=GCNT+1,CCNT=1
 Q
LINE ;Fill in the global with blank lines
 N X
 D LN
 S X="",$P(X," ",GIOM)="",^TMP("LRC",$J,GCNT,0)=X
 Q
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1031
BS2RRCHK ; EP - Reference Range double-check: make sure they reflect values in File 60 if not in File 63
 NEW DATANAME,F6O,LRSS,OLDHI,OLDLO,OLDX,REFHI,REFLO,SITESPEC,STR
 NEW CNT,DN,DP
 ;
 ; Get Dataname Decimal definition
 S DN=+$P($P(LRG,"^",5),";",2)           ; Data Name number
 S STR=$P($G(^DD(63.04,DN,0)),"^",5)
 S DP=+$P($P(STR,",",3),$C(34))
 ;
 ; Save off old variables
 S OLDX=X
 S STR=$TR(X," ")
 S OLDLO=$P(STR,"-")
 S OLDHI=$P(STR,"-",2)
 ;
 ; First, check to see if Ref values are in file 63
 S LRSS=$P($P(LRG,"^",5),";")
 S LRSS=$S($L(LRSS):LRSS,1:"<NO>")       ; Make sure LRSS has a value
 S DATANAME=+$P($P(LRG,"^",5),";",2)
 S STR=$P($G(^LR(+LRDFN,LRSS,+LRLFDT,DATANAME)),"^",5)
 ;
 Q:STR["$S"   ; IHS/MSC/MKK - LR*5.2*1033 DEBUG - Skip if $SELECT statment -- cannot parse for all sites.
 Q:$L(STR)<1&(($G(REFLO)["$")!($G(REFHI)["$"))   ; IHS/MSC/MKK - LR*5.2*1034
 ;
 I $L(STR) D
 . S REFLO=$P(STR,"!",2)
 . S REFHI=$P(STR,"!",3)
 ;
 I $L(STR)<1 D
 . S F60=+$G(LRG)
 . S SITESPEC=+$G(LRSPM)
 . Q:F60<1!(SITESPEC<1)                  ; Skip if no test or no Site/Specimen
 . ;
 . S STR=$G(^LAB(60,F60,1,SITESPEC,0))
 . Q:$L(STR)<1                           ; Skip if no Reference Ranges
 . ;
 . S REFLO=$P(STR,"^",2)
 . S REFHI=$P(STR,"^",3)
 ;
 Q:$L($G(REFLO))<1&($L($G(REFHI))<1)     ; Skip if no Reference Ranges defined
 ;
 I $G(REFLO)["$S" D                      ; If $S in Reference Range, set to value
 . S REFLO="REFLO="_REFLO
 . S @REFLO
 ;
 I $G(REFHI)["$S" D                      ; If $S in Reference Range, set to value
 . S REFHI="REFHI="_REFHI
 . S @REFHI
 ;
 Q:$G(REFLO)[$C(34)&($L(REFHI)<1)        ; Skip if REFLO is a string & No REFHI
 Q:$G(REFHI)[$C(34)&($L(REFLO)<1)        ; Skip if REFHI is a string & No REFLO
 ;
 ; Make sure REFLO & REFHI have some sort of value
 S:$L(REFLO)<1 REFLO=OLDLO
 S:$L(REFHI)<1 REFHI=OLDHI
 ;
 ; Set up the decimals, if possible
 I DP>0 D
 . S:+REFLO>0 REFLO=$TR($FN(REFLO,"P",DP)," ")
 . S:+REFHI>0 REFHI=$TR($FN(REFHI,"P",DP)," ")
 ;
 Q:OLDLO=REFLO&(OLDHI=REFHI)        ; Skip if double-check is the same
 ;
 S X=REFLO_" - "_REFHI
 Q
 ;
 ;
BS2DPCHK ; EP - Check Result to determine if it needs leading and/or trailing zero(s)
 Q:$L(X)<1                          ; Skip if no result
 ;
 NEW DN,DP,ORIGRLST,RESULT,STR,SYMBOL
 S DN=+$P($P(LRG,"^",5),";",2)      ; Data Name number
 Q:DN<1                             ; Skip if no Data Name number
 ;
 Q:$G(^DD(63.04,DN,0))'["^LRNUM"         ; Skip if no numeric defintiion
 ;
 S STR=$P($P($G(^DD(63.04,DN,0)),"Q9=",2),$C(34),2)     ; Get numeric formatting
 ;
 S DP=+$P(STR,",",3)                ; Decimal Places
 Q:DP<1                             ; Skip if no Decimal Defintion
 ;
 S RESULT=$G(X)
 ;
 Q:$$UP^XLFSTR($G(RESULT))["SPECIMEN IN LAB"          ; Skip if not resulted
 ;
 S SYMBOL="",ORIGRSLT=RESULT
 F  Q:$E(RESULT)?1N!(RESULT="")  D       ; Adjust if ANY Non-Numeric is at the beginning of RESULT
 . S SYMBOL=SYMBOL_$E(RESULT)
 . S RESULT=$E(RESULT,2,$L(RESULT))
 ;
 I $E(RESULT)'?1N  S RESULT=ORIGRSLT  Q  ; Skip if RESULT has no numeric part
 ;
 S:$E(RESULT)="." RESULT="0"_RESULT      ; Leading Zero Fix
 ;
 S RESULT=$TR($FN(RESULT,"P",DP)," ")
 ;
 S:$L($G(SYMBOL)) RESULT=SYMBOL_RESULT   ; Restore "symbol", if necessary
 ;
 S X=RESULT                              ; Reset X
 Q
 ; ----- END IHS/MSC/MKK - LR*5.2*1031
