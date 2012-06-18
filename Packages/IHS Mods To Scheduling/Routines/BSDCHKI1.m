BSDCHKI1 ; cmi/anch/maw  - BSD CHECKIN LIST CONTINUED 1/30/2007 3:14:06 PM
 ;;5.3;PIMS;**1007**;FEB 27, 2007
 ;
 ;
 ;
 ;
INIT ; -- get init pat appt data
 ;  input:          DFN := ifn of pat
 ; output:  ^TMP("SDAM" := appt array
 ;
 ;IHS/ITSC/LJF 6/17/2005 PATCH 1003
 ;S X=$P($G(^DG(43,1,"SCLR")),U,12),SDPRD=$S(X:X,1:2)
 S X=$P($G(^DG(43,1,"SCLR")),U,12),SDPRD=$S(X]"":X,1:2)
 ;
 S X1=DT,X2=-SDPRD D C^%DTC S SDBEG=X
 S X1=DT,X2=999 D C^%DTC S SDEND=X
 D CHGCAP^VALM("NAME","Clinic")
 S X="ALL" D LIST^SDAM
 Q
 ;
BLD ; -- scan apts
 N SDAMDD,SDNAME,SDMAX,SDLARGE,DFN,SDCL,BL,XC,XW,AC,AW,TC,TW,NC,NW,SC,SW,SDT ; done for speed see INIT
 D INIT^SDAM10
 S DFN=SDFN
 F SDT=SDBEG:0 S SDT=$O(^DPT(DFN,"S",SDT)) Q:'SDT!($P(SDT,".",1)>SDEND)  I $D(^(SDT,0)) S SDATA=^(0),SDCL=+SDATA,SDNAME=$P($G(^SC(SDCL,0)),U) D BLD1
 ;
 I $O(^TMP("SDAM",$J,0)) D WLDIS^BSDAM(DFN)  ;IHS/OIT/LJF 7/28/2005 PATCH 1004
 ;
 D NUL^SDAM10,LARGE^SDAM10:$D(SDLARGE)
 S $P(^TMP("SDAM",$J,0),U,4)=VALMCNT
 Q
 ;
BLD1 ;EP - build array
 N SDX,X,Y,Y1,SDSTAT,SDELIG
 S SDSTAT=$$STATUS(DFN,SDT,SDCL,SDATA,$S($D(SDDA):SDDA,1:""))
 G BLD1Q:'$$CHK(DFN,SDT,SDCL,SDATA,.SDAMLIST,SDSTAT)
 ;; Changes for GAF enhancement
 S SDGAFREQ=" "
 S SDELIG=$$ELSTAT^SDUTL2(DFN)
 I $$MHCLIN^SDUTL2(SDCL),'($$COLLAT^SDUTL2(SDELIG)!$P(SDATA,U,11)) D
 .S SDGAF=$$NEWGAF^SDUTL2(DFN),SDGAFST=$P(SDGAF,"^")
 .S:SDGAFST SDGAFREQ="*"
 S SDACNT=SDACNT+1,X="",$P(X," ",VALMWD+1)=""
 W:(SDACNT#10)=0 "."
 I SDACNT=SDMAX,$P(SDT,".")'=SDEND S SDEND=$P(SDT,"."),SDLARGE=""
 S X=SDGAFREQ_$E(X,2,AC-1)_$E(SDACNT_BL,1,AW)_$E(X,AC+AW+1,VALMWD)
 S X=$E(X,1,NC-1)_$E($$LOWER(SDNAME)_BL,1,NW)_$E(X,NC+NW+1,VALMWD)
 S X=$E(X,1,XC-1)_$E($$FMTE^XLFDT(SDT,"5Z")_BL,1,XW)_$E(X,XC+XW+1,VALMWD)  ;to make date field work for SD*5.3*189 - uses FM List Template
 S Y=$P(SDSTAT,";",3)
 ;
 I (Y["CHECKED"),$P(SDATA,U,7)=4,('$P(SDSTAT,";",6)) S Y="WALK IN/"_Y   ;IHS/OIT/LJF 12/29/2005 PATCH 1005
 ;
 I Y'["FUTURE" S X=$E(X,1,SC-1)_$E($$LOWER(Y)_BL,1,SW)_$E(X,SC+SW+1,VALMWD)
 I Y["FUTURE" S X=$E(X,1,SC-1)_$E($$LOWER(Y)_$$ANC_BL,1,SW+TW+1)
 S Y1=$S($P(SDSTAT,";",5):$P(SDSTAT,";",5),1:$P(SDSTAT,";",4)),Y1=$S($P(Y1,".")=DT:$$TIME($P(Y1,".",2)),1:"")
 S:Y1]"" X=$E(X,1,TC-1)_$E(Y1_BL,1,TW)_$E(X,TC+TW+1,VALMWD)
 D SET(X)
 I $D(SDAMBOLD(DFN,SDT,SDCL)) D FLDCTRL^VALM10(VALMCNT,"STAT",IOINHI,IOINORM),FLDCTRL^VALM10(VALMCNT,"TIME",IOINHI,IOINORM)
 S ^TMP("SDAMIDX",$J,SDACNT)=VALMCNT_U_DFN_U_SDT_U_SDCL_U_$S($D(SDDA):SDDA,1:"")
BLD1Q Q
 ;
ANC() ; -- set ancillary info
 N I,Y,C
 S Y="",C=0
 F I=3:1:5 I $P(SDATA,U,I)]"" S Y=Y_" "_$P("^^Lab^XRay^EKG",U,I)_"@"_$$TIME($P($P(SDATA,U,I),".",2)),C=C+1 Q:C=2
 I Y]"" S Y="/"_$E(Y,2,99)
 Q Y
 ;  
SET(X) ;EP
 S VALMCNT=VALMCNT+1,^TMP("SDAM",$J,VALMCNT,0)=X
 S:SDACNT ^TMP("SDAM",$J,"IDX",VALMCNT,SDACNT)=""
 Q
 ;
CHK(DFN,SDT,SDCL,SDATA,SDAMLIST,SDSTAT,SDDA) ; -- does appt meet criteria
 ;   input:        DFN := ifn of pat.
 ;                 SDT := appt d/t
 ;                SDCL := ifn of clinic
 ;               SDATA := 0th node of pat appt entry
 ;            SDAMLIST := list definition
 ;              SDSTAT := appt status data from $$STATUS call
 ;                SDDA := ifn for ^SC(clinic,"S",date,1,ifn) {optional}
 ;  output: [returned] := meets criteria for list [0 - no | 1 - yes ]
 ;
 S Y=0
 I $D(SDAMLIST(+SDSTAT)) S Y=1 G CHKQ
 I $G(SDSTAT)[$P($G(SDAMLIST),U) S Y=1  ;cmi/anch/maw 3/26/2007 for patch 1007 item 1007.06
 I $P(SDAMLIST,U)="ALL" S Y=1
CHKQ I Y,$D(SDAMLIST("SCR")) X SDAMLIST("SCR") S Y=$T
 Q Y
 ;
STATUS(DFN,SDT,SDCL,SDATA,SDDA) ; -- return appt status
 ;   input:        DFN := ifn of pat.
 ;                 SDT := appt d/t
 ;                SDCL := ifn of clinic
 ;               SDATA := 0th node of pat appt entry
 ;                SDDA := ifn for ^SC(clinic,"S",date,1,ifn) {optional}
 ;  output: [returned] := appt status ifn ^ status name ^ print status ^
 ;                        check in d/t ^ check out d/t ^ adm mvt ifn
 ;
 ;S = status ; C = ci/co indicator ; Y = 'C' node ; P = print status
 N S,C,Y,P,VADMVT,VAINDT
 ;
 ; -- get data for evaluation
 S:'$G(SDDA) SDDA=+$$FIND^SDAM2(DFN,SDT,SDCL)
 S Y=$G(^SC(SDCL,"S",SDT,1,SDDA,"C"))
 ;
 ; -- set initial status value ; non-count clinic?
 S S=$S($P(SDATA,"^",2)]"":$P($P($P(^DD(2.98,3,0),"^",3),$P(SDATA,"^",2)_":",2),";"),$P($G(^SC(SDCL,0)),U,17)="Y":"NON-COUNT",1:"")
 ;
 ; -- inpatient?
 S VAINDT=SDT D ADM^VADPT2
 I S["INPATIENT",$S('VADMVT:1,'$P(^DG(43,1,0),U,21):0,1:$P($G(^DIC(42,+$P($G(^DGPM(VADMVT,0)),U,6),0)),U,3)="D") S S=""
 ;
 ; -- determine ci/co indicator
 S C=$S($P(Y,"^",3):"CHECKED OUT",Y:"CHECKED IN",S]"":"",SDT>(DT+.2359):"FUTURE",1:"NO ACTION TAKEN") S:S="" S=C
 I S="NO ACTION TAKEN",$P(SDT,".")=DT,C'["CHECKED" S C="TODAY"
 ; -- $$REQ & $$COCMP in SDM1A not used for speed
 ;I S="CHECKED OUT"!(S="CHECKED IN"),SDT'<$P(^DG(43,1,"SCLR"),U,23),'$P($G(^SCE(+$P(SDATA,U,20),0)),U,7) S S="NO ACTION TAKEN"  ;IHS/ANMC/LJF 4/11/2002
 ;
 ; -- determine print status
 S P=$S(S=C!(C=""):S,1:"")
 I P="" D
 .I S="NO ACTION TAKEN",C="CHECKED OUT"!(C="CHECKED IN") S P="ACT REQ/"_C Q
 .S P=$S(S="NO ACTION TAKEN":S,1:$P(S," "))_"/"_C
 ;
STATUSQ Q +$O(^SD(409.63,"AC",S,0))_";"_S_";"_P_";"_$P(Y,"^")_";"_$P(Y,"^",3)_";"_+VADMVT
 ;
 ;
LOWER(X) ; convert to lowercase ; same as LOWER^VALM1 ; here for speed
 N Y,C,I
 S Y=$E(X)_$TR($E(X,2,999),"ABCDEFGHIJKLMNOPQRSTUVWXYZ@","abcdefghijklmnopqrstuvwxyz ")
 F C=" ",",","/" S I=0 F  S I=$F(Y,C,I) Q:'I  S Y=$E(Y,1,I-1)_$TR($E(Y,I),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")_$E(Y,I+1,999)
 Q Y
 ;
TIME(X) ; -- format time only :=   hr:min
 Q $E(X_"0000",1,2)_":"_$E(X_"0000",3,4)
