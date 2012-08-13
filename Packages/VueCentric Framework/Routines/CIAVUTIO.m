CIAVUTIO ;MSC/IND/DKM - VueCentric Host IO Support ;04-May-2006 08:19;DKM
 ;;1.1V2;VUECENTRIC FRAMEWORK;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Capture output to HFS and redirect to global
OUTPUT(EXEC,ROOT,RM) ;
 D CAPTURE^CIAUHFS(.EXEC,.ROOT,.RM)
 Q
 ; Print report to specified device.  Supports multiple calls to
 ; build large reports before printing.  Specifying DEV parameter
 ; signals the report is complete and ready to print.
 ;   CTL = Unique handle for this report.  Pass 0 on initial call.
 ;   RPT = Array containing block of report text
 ;   DEV = IEN of output device (pass on final call only)
 ;         or negative value to abort print
 ;   TTL = Title of report (default=none)
 ;   BRK = Line break placeholder (default=none)
 ;   IND = Left indent (default=none)
 ;  DATA = Unique handle assigned to this report or, if this is
 ;         final call, the id # of the submitted task.
PRINT(DATA,CTL,RPT,DEV,TTL,BRK,IND) ;
 N X,SB,$ET
 S SB="CIAVUTIO."_$S($G(CIA("UID")):CIA("UID"),1:"J"_$J)
 S $ET="",@$$TRAP^CIAUOS("PRERR^CIAVUTIO")
 I '$G(CTL) D                                                          ; Initialize report buffer
 .L +^XTMP(SB):5
 .S ^XTMP(SB,0)=$$FMADD^XLFDT(DT,2)_U_DT,CTL=$O(^(""),-1)+1,^(CTL)=""
 .L -^XTMP(SB)
 S DATA=CTL,X=$O(^XTMP(SB,CTL,""),-1)+1                                ; X = current block #
 M ^XTMP(SB,CTL,X)=RPT                                                 ; Copy the current block
 Q:'$G(DEV)
 I DEV<0 K ^XTMP(SB,CTL)
 E  S DATA=$$QUEUE^CIAUTSK("PRTASK^CIAVUTIO",$G(TTL,"Print Job #"_CTL),,"BRK^IND^CTL^SB","`"_+DEV)
 Q
 ; Entry point for tasked print job
PRTASK N X,Y,Z,$ET
 U IO
 S IND=$$REPEAT^XLFSTR(" ",+$G(IND)),X=0,$ET="",@$$TRAP^CIAUOS("PRERR^CIAVUTIO")
 F  S X=$O(^XTMP(SB,CTL,X)),Y=0 Q:'X  D
 .F  S Y=$O(^XTMP(SB,CTL,X,Y)) Q:'Y  S Z=^(Y) D
 ..I $L(BRK),Z=BRK W @IOF,!
 ..E  W IND,Z,!
 K ^XTMP(SB,CTL)
 S IO("C")=""
 D ^%ZISC
 S ZTREQ="@"
 Q
 ; Exception handler for print errors
PRERR K ^XTMP(SB,CTL)
 D ^%ZTER
 Q
 ; Local printer is default?
PRTISLCL(DATA,LOC) ;
 D PRTGETDF(.DATA,.LOC)
 S DATA=$S('$L(DATA):0,1:'DATA)
 Q
 ; Returns current default printer for user
PRTGETDF(DATA,LOC) ;
 N IEN,DEV,ENT
 S ENT="ALL"
 S:$G(LOC) LOC=+LOC_";SC(",ENT=ENT_U_LOC
 S DATA=$$GET^XPAR(ENT,"CIAVUTIO DEFAULT PRINTER",1),IEN=+DATA
 S:IEN $P(DATA,";",2)=$P($G(^%ZIS(1,IEN,0)),U)
 Q
 ; Save new default printer for user
PRTSETDF(DATA,DEV) ;
 D EN^XPAR("USR","CIAVUTIO DEFAULT PRINTER",1,DEV,.DATA)
 Q
 ; Return a subset of entries from the Device file
 ;   DATA(n)=IEN;Name^DisplayName^Location^RMar^PLen
DEVICE(DATA,FROM,DIR,MAX) ;
 N CNT,IEN,X,Y,X0,XLOC,XSEC,XTYPE,XSTYPE,XTIME,XOSD,MW,PL,DEV
 S CNT=0,MAX=$G(MAX,20)
 S:FROM["  <" FROM=$RE($P($RE(FROM),"<  ",2))
 F  Q:CNT'<MAX  S FROM=$O(^%ZIS(1,"B",FROM),DIR),IEN=0 Q:FROM=""  D
 .F  S IEN=$O(^%ZIS(1,"B",FROM,IEN)) Q:'IEN  D
 ..S DEV="",X0=$G(^%ZIS(1,IEN,0)),XLOC=$P($G(^(1)),U),XOSD=+$G(^(90)),MW=$G(^(91)),XSEC=$G(^(95)),XSTYPE=+$G(^("SUBTYPE")),XTIME=$P($G(^("TIME")),U),XTYPE=$P($G(^("TYPE")),U)
 ..Q:$E($G(^%ZIS(2,XSTYPE,0)))'="P"                                    ; Printers only
 ..Q:"^TRM^HG^CHAN^OTH^"'[(U_XTYPE_U)
 ..Q:$P(X0,U,2)="0"!($P(X0,U,12)=2)                                    ; Queuing allowed
 ..I XOSD,XOSD'>DT Q                                                   ; Out of Service
 ..I $L(XTIME) D  Q:'$L(XTIME)                                         ; Prohibited Times
 ...S Y=$P($H,",",2),Y=Y\60#60+(Y\3600*100),X=$P(XTIME,"-",2)
 ...S:X'<XTIME&(Y'>X&(Y'<XTIME))!(X<XTIME&(Y'<XTIME!(Y'>X))) XTIME=""
 ..I $L(XSEC),$G(DUZ(0))'="@",$TR(XSEC,$G(DUZ(0)))=XSEC Q
 ..S PL=$P(MW,U,3),MW=$P(MW,U),X=$G(^%ZIS(2,XSTYPE,1))
 ..S:'MW MW=$P(X,U)
 ..S:'PL PL=$P(X,U,3)
 ..S X=$P(X0,U)
 ..Q:$E(X,1,4)["NULL"
 ..S:X'=FROM X=FROM_"  <"_X_">"
 ..S CNT=CNT+1,DATA(CNT)=IEN_";"_$P(X0,U)_U_X_U_XLOC_U_MW_U_PL
 Q
 ; Preopen code for tech support device
TSOPEN S %ZIS("HFSNAME")=$$PWD^%ZISH_$$UFN^CIAU,%ZIS("HFSMODE")="W",%ZTYPE="HFS"
 S ^TMP("CIAVUTIO",$J)=%ZIS("HFSNAME")
 Q
 ; Postclose code for tech support device
TSCLOSE N DATA,HFS,SUB
 S HFS=$G(^TMP("CIAVUTIO",$J)),SUB=$G(^($J,"SUB"),"VUECENTRIC TECH SUPPORT REQUEST")
 Q:'$L(HFS)
 K ^TMP("CIAVUTIO",$J) S DATA=$NA(^($J,1))
 I $$FTG^%ZISH(HFS,"",DATA,3) D
 .N XMTEXT,XMY,XMSUB,XMDUZ
 .S XMTEXT="^TMP(""CIAVUTIO"",$J,",XMDUZ=DUZ,XMY="G.VUECENTRIC TECH SUPPORT",XMSUB=SUB
 .D ^XMD
 K DATA,^TMP("CIAVUTIO",$J)
 S DATA(HFS)=""
 I $$DEL^%ZISH("","DATA")
 Q
