AQALDG4 ; IHS/ORDC/LJF - AUTOLINK ADT OCCURRENCES ;
 ;;1;QI LINKAGES-RPMS;;AUG 15, 1994
 ;
 ;PRIVATE ENTRY POINT between QI LINKAGES and ADT packages
 ;Required input variables:  DFN=patient internal #
 ;                           AQALADM=admission entry #
 ;                           DUZ(2)=admission facility
 ;                           AQALEV=ADT event # (field # in ^AQAGP)
 ;                           AQALHSV=treating specialty
 ;                           AQALTR=ward transfer ifn if aqalev=1031
 ;
 G EXIT1:'$D(DFN),EXIT1:'$D(AQALADM),EXIT1:AQALADM="",EXIT1:'$D(DUZ(2))
 G EXIT1:'$D(AQALEV),EXIT1:'$D(AQALHSV)
 I AQALEV=1031 G EXIT1:'$D(AQALTR)
 I (AQALEV<1001)!(AQALEV>1061) G EXIT1
 ;
FIND ; >>> find variables for autolink rtn
 K AQALIFN,AQALNKF ;kill occ internal # variable
 G EXIT1:DFN="",EXIT1:'$D(^DPT(DFN,0)),EXIT1:$P(^(0),U,19)'=""
 S AQALNK("BUL")="AQAL ADT EROR"
 S AQALNK("PAT")=DFN ;patient
 ;
 ;check if event link turned on & find indicator # for event
 G EXIT1:'$D(^AQAGP(DUZ(2))) ;no parameters for facility
 I AQALEV=1031 D ICUCHK ;check which icu parameter applies
 K ^UTILITY("DIQ1",$J) S AQALF=9002166.4
 K DIC,DR S DIC="^AQAGP(",DA=DUZ(2)
 S DR="" F I=0:1:3 S DR=DR_(AQALEV+I)_";"
 D EN^DIQ1 G EXIT1:^UTILITY("DIQ1",$J,AQALF,DUZ(2),AQALEV)'="ON"
 G EXIT:^UTILITY("DIQ1",$J,AQALF,DUZ(2),AQALEV+1)="" S X=^(AQALEV+1)
 K DIC S DIC="^AQAO(2,",DIC(0)="" D ^DIC G EXIT:Y=-1 S AQALNK("IND")=+Y
 ;
 ;get occurrence date
 S X=^UTILITY("DIQ1",$J,AQALF,DUZ(2),AQALEV+2) G EXIT:X=""
 S Y="^DPT(DFN,""DA"",AQALADM,"_X_")"
 G EXIT:'$D(@Y) ;gbl ref not exist
 S AQALNK("DATE")=$P(+(@Y),".") ;occ date; full gbl above
 G EXIT:AQALNK("DATE")=""
 ;
 ;get pcc visit (optional variable)
 K AQALVST
 S X=+^DPT(DFN,"DA",AQALADM,0) ;get admit date/time
 S X=9999999-$P(X,".")_"."_$P(X,".",2),Y=0
 F  S Y=$O(^AUPNVSIT("AA",DFN,X,Y)) Q:Y=""  Q:$D(AQALVST)  D
 .Q:$P(^AUPNVSIT(Y,0),U,7)'="H"  ;make sure is hosp visit
 .Q:$P(^AUPNVSIT(Y,0),U,11)=1  ;make sure not deleted
 .S AQALVST=Y
 S:$D(AQALVST) AQALNK("VSIT")=AQALVST
 ;
 ;get ward
 S AQALNK("WARD")=$S($D(AQALWD):$P(^DIC(42,AQALWD,44),U),1:"")
 ;
 ;get hospital service linked to treating specialty
 S AQALNK("HSV")=$S(AQALHSV="":"",1:$P(^DIC(45.7,AQALHSV,0),U,4))
 S X=$O(^AQAGP(DUZ(2),"SRV","B",AQALNK("HSV"),0)) G EXIT1:X=""
 Q:$P($G(^AQAGP(DUZ(2),"SRV",X,0)),U,($E(AQALEV,3)+2))'=1  ;srv not lnkd
 ;
 ;get facility #
 G EXIT:'$D(DUZ(2)) S AQALNK("FAC")=DUZ(2)
 ;
 ;get duplicate flag (yes=okay to create duplicate entry)
 S AQALNK("DUP OK")=^UTILITY("DIQ1",$J,AQALF,DUZ(2),AQALEV+3)
 I AQALNK("DUP OK")'="YES" K AQALNK("DUP OK")
 ;
 ;
CREATE ; >>> call ^aqalnk to create occurrence
 D CREATE^AQALNK
 G EXIT
 ;
 ;
CHECK ; >>> check results
 G ERRORMSG:'$D(AQALIFN) ;go print error messages
 ;print occ message and exit
 W !!,"QAI Occurrence entry created for this transaction: "
 W " (",$P($P(^DD(AQALF,AQALEV,0),U),"LINK"),")",! G EXIT
 ;
ERRORMSG ; >>> send bulletin if any error messages exist
 S XMB="AQAL ADT ERROR",XMDUZ="QI LINKAGES MESSENGER"
 S X=0 F  S X=$O(^AQAO(9,"AC","QA",X)) Q:X=""
 .S XMY(X)="",XMY(X,1)="I" ;set pkg admin as recipients-info only
 S AQALAR(1)="PATIENT IS "_$P($G(^DPT(AQALPAT,0)),U)
 S AQALAR(2)="CHART #"_$P($G(^AUPNPAT(AQALPAT,41,DUZ(2),0)),U,2)
 S X=0,Y=2 F  S X=$O(AQALNKF(X)) Q:X=""  S Y=Y+1,AQALAR(Y)=AQALNKF(X)
 S XMTEXT="AQALAR(" D ^XMB K XMB,XMDUX,XMY,XMTEXT
 ;
EXIT ; >>> eoj
 I '$D(AQALIFN),'$D(AQALNKF) W !!,*7,"ERROR IN QI PARAMETER FILE OR IN ADT CALL TO ^AQALDG. CALL YOUR SITE MANAGER.",!!
EXIT1 K ^UTILITY("DIQ1",$J)
 D ^AQALKILL
 Q
 ;
 ;
ICUCHK ; >>SUBRTN to see which ICU parameter applies
 Q:$P(^AQAGP(DUZ(2),"ADT"),U,71)'=1  ;return to icu not turned on
 N AQALDT,AQALX,Y,X
 S AQALDT=+$G(^DPT(DFN,41,AQALADM,2,AQALTR,0)) ;transfer date/time
 Q:AQALDT=0  S AQALX=10000000-AQALDT
 F  S AQALX=$O(^DPT(DFN,41,AQALADM,2,"ATT",AQALX)) Q:AQALX=""  D
 .S Y=$O(^DPT(DFN,41,AQALADM,2,"ATT",AQALX,0)) Q:Y=""
 .S X=$P(^DPT(DFN,41,AQALADM,2,Y,0),U,4) Q:X=""
 .Q:$P(^DIC(42,X,"IHS"),U)'="Y"  ;previous ward not icu
 .S X1=$P(^DPT(DFN,41,AQALADM,2,Y,0),U),X2=AQALDT D ^%DTC
 .I %Y,(X'>$P(^AQAGP(DUZ(2),"ADT"),U,75)) S AQALEV=1071
 Q:AQALEV=1071  ;return to icu within time limit
 S X=$P(^DPT(DFN,41,AQALADM,0),U,4) Q:X=""
 Q:$P(^DIC(42,X,"IHS"),U)'="Y"  ;admitting ward not icu
 S X1=+^DPT(DFN,41,AQALADM,0),X2=AQALDT D ^%DTC
 I %Y,(X'>$P(^AQAGP(DUZ(2),"ADT"),U,75)) S AQALEV=1071
 Q
