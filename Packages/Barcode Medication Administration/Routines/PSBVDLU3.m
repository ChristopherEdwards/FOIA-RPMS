PSBVDLU3 ;BIRMINGHAM/TEJ-BCMA VDL UTILITIES 3 ;Mar 2004
 ;;3.0;BAR CODE MED ADMIN;;Mar 2004
 ;
 ;This routine file has been created to serve as a container
 ;for Extrinsic Variables/Functions
 ;
 ; Reference/IA
 ; EN^PSJBCMA/2828
 ;
IVPTAB(PSBORTYP,PSBIVTYP,PSBINTSY,PSBCHMTY,PSBMROUT)  ;
 ;
 ; This function will return
 ; the value 1 (one) if the
 ; specified order input will cause
 ; the order to display on the "IVP/IVPB"
 ; tab of the VDL BCMA Virtual Due List (VDL)
 ; else return the value 0 (zero).
 ;
 ; Input Parameters:
 ;
 ;     PSBORTYP - Order type (e.g. "U","V")
 ;     PSBIVTYP - IV Type (e.g. "P","S","C")
 ;     PSBINTSY - Intermittent Syringe value
 ;     PSBCHMTY - Chemo type (e.g. "P","S")
 ;     PSBMROUT - Med Route value (e.g. "IVP","IV PUSH","IVPB")
 ;
 ; Output:
 ;     1 - order will display on the "IVP/IVPB" Tab of BCMA VDL
 ;     0 - order will NOT display on the "IVP/IVPB" Tab of BCMA VDL
 ;    -1 - error processed
 ;
 Q:'$D(PSBORTYP) "-1^Missing Parameter"
 I PSBORTYP="U"&(($G(PSBMROUT)="IV PUSH")!($G(PSBMROUT)="IVP")) Q 1
 I '(PSBORTYP="V") Q 0
 I $G(PSBIVTYP)="P" Q 1
 I $G(PSBIVTYP)="S",$G(PSBINTSY)=1 Q 1
 I $G(PSBIVTYP)="C",$G(PSBCHMTY)="P" Q 1
 I $G(PSBIVTYP)="C",$G(PSBCHMTY)="S",$G(PSBINTSY)=1 Q 1
 Q 0
 ;
SHOVDL(DFN,BDATE,OTDATE,PSBTAB) ;
 ;
 ; This function will find orders such as discontinued or expired infusing IV bags 
 ; or discontinued or expired "given" patches.  Recognizing these types of orders
 ; will allow these orders to be displayed on the VDL and permits the user to take 
 ; action on them.  This routine determines if such orders exist for patient,
 ; time, and "BCMA VDL tab."  This routine is an "extention" to the API EN^PSJBCMA.
 ;
 ; INPUT Parameters:
 ;    DFN           (req)   Patient Internal File Number.
 ;    BDATE         (opt)   Start searching for "order stop" after this date. 
 ;    OTDATE        (opt)   Include One-Time orders from this date.
 ;    PSBTAB        (opt)   "UDTAB" or "IVTAB" - expedites process if specific tab
 ;                            is given.
 ;
 ; OUTPUT Values
 ;    0               absolutely no orders to display on VDL
 ;    1               displayable orders have been located.
 ;
 ;
 D EN^PSJBCMA(DFN,$G(BDATE),$G(OTDATE))
 ; any active Patch orders to show on VDL?
 S PSBFLG=0
 I $G(^TMP("PSJ",$J,1,0))=-1 D
 .;  
 .; Check the indexice for given patches or infusing IVs
 .;
 .; Check APATCH
 .D:($G(PSBTAB)="UDTAB")!($G(PSBTAB)="")  Q:PSBFLG
 ..S PSBGNODE="^PSB(53.79,"_"""APATCH"""_","_DFN_")" Q:'$D(PSBGNODE)
 ..F  S PSBGNODE=$Q(@PSBGNODE) Q:PSBGNODE=""  Q:$QS(PSBGNODE,3)'=DFN  Q:PSBFLG  S PSBIEN=$QS(PSBGNODE,5),PSBFLG=$S($P(^PSB(53.79,PSBIEN,0),U,9)="G":1,1:0)
 .;
 .; Check AUID
 .;
 .D:(($G(PSBTAB)="IVTAB")!($G(PSBTAB)=""))&('PSBFLG)  Q:PSBFLG
 ..S PSBGNODE="^PSB(53.79,"_"""AUID"""_","_DFN_")" Q:'$D(PSBGNODE)
 ..F  S PSBGNODE=$Q(@PSBGNODE) Q:PSBGNODE=""  Q:$QS(PSBGNODE,3)'=DFN  Q:PSBFLG  S PSBIEN=$QS(PSBGNODE,6),PSBFLG=$S($P(^PSB(53.79,PSBIEN,0),U,9)="I":1,1:0)
 .;
 .;  NOTE: Infusing bags will not display if DCed more than 3 days ago!
 .;
 S:$G(^TMP("PSJ",$J,1,0))'=-1 PSBFLG=1
 ;
 Q PSBFLG
 ;
