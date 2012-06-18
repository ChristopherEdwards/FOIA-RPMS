AQALDG51 ; IHS/ORDC/LJF - AUTOLINK ADT OCCURRENCES ;
 ;;1;QI LINKAGES-RPMS;;AUG 15, 1994
 ;
 ;This rtn set the common variables & calls the PUBLISHED ENTRY POINT
 ;CREATE^AQALNK to create an occurrence.
 ;
FIND ; >>> find variables for autolink rtn
 K AQALIFN,AQALNKF,AQALNK ;kill occ ifn, error flags, input varbls
 G EXIT1:DFN="",EXIT1:'$D(^DPT(DFN,0)),EXIT1:$P(^(0),U,19)'=""
 S AQALNK("BUL")="AQAL ADT ERROR"
 S AQALNK("PAT")=DFN ;patient
 ;
 ; find indicator # for event
 K ^UTILITY("DIQ1",$J),DIQ
 S (AQALF,DIC)=9002166.4,DA=DUZ(2),DR=(AQALEV+1)_";"_(AQALEV+3)
 D EN^DIQ1 S X=^UTILITY("DIQ1",$J,AQALF,DA,AQALEV+1) G EXIT:X=""
 K DIC S DIC="^AQAO(2,",DIC(0)="" D ^DIC G EXIT:Y=-1
 S AQALNK("IND")=+Y,AQALNK("IND1")=$P(Y,U,2)
 ;
 ;get occurrence date
 S AQALNK("DATE")=$P(+DGPMA,".")
 G EXIT:AQALNK("DATE")=""
 ;
 ;get pcc visit (optional variable)
 S AQALNK("VSIT")=$P($G(^DGPM(DGPMCA,"IHS")),U)
 ;
 ;get hospital service linked to treating specialty
 S AQALNK("HSV")=AQALSV
 S X=$O(^AQAGP(DUZ(2),"SRV","B",AQALNK("HSV"),0)) G EXIT1:X=""
 Q:$P($G(^AQAGP(DUZ(2),"SRV",X,0)),U,($E(AQALEV,3)+2))'=1  ;srv not lnkd
 ;
 ;get ward name
 S X=$S($D(AQALWD):AQALWD,1:$P(DGPMA,U,6)) G EXIT:X=""
 S AQALNK("WARD")=$S(X="":"",1:$P($G(^DIC(42,X,44)),U))
 ;
 ;get facility #
 G EXIT:'$D(DUZ(2)) S AQALNK("FAC")=DUZ(2)
 ;
 ;get duplicate flag (yes=okay to create duplicate entry)
 S AQALNK("DUP OK")=^UTILITY("DIQ1",$J,AQALF,DUZ(2),AQALEV+3)
 I AQALNK("DUP OK")'="YES" K AQALNK("DUP OK")
 K ^UTILITY("DIQ1",$J)
 ;
 ;
CREATE ; >>> call ^aqalnk to create occurrence
 I $D(AQALAUT(AQALNK("IND1"))) D  I 1
 .I DGPMT=2 S AQALNK("OCC")=$O(^AQAOC("AA",AQALNK("IND"),AQALNK("DATE"),AQALNK("PAT"),0))
 .I DGPMT'=2 S AQALNK("OCC")=AQALAUT(AQALNK("IND1"))
 .I +AQALNK("OCC") D EDIT^AQALNK1 I 1
 .E  D CREATE^AQALNK
 E  D CREATE^AQALNK
 ;
 ;
EXIT ; >>> eoj
 I '$D(AQALIFN),'$D(AQALNKF) W !!,*7,"ERROR IN QI PARAMETER FILE OR IN ADT CALL TO ^AQALDG5. CALL YOUR SITE MANAGER.",!!
EXIT1 K ^UTILITY("DIQ1",$J)
 K DIC,X,Y
 K AQALAUT(AQALNK("IND1"))
 Q
