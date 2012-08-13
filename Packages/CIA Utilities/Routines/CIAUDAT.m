CIAUDAT ;MSC/IND/DKM - Date range input;14-Aug-2006 09:35;DKM
 ;;1.2;CIA UTILITIES;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Prompt for date range (normal format)
NORMAL D D1("P1"),D2("P2"):CIADAT1
 Q
 ; Prompt for date range (inverse format)
INVRSE D D1("PI1"),D2("PI2"):CIADAT1
 Q
 ; Prompt for starting date
D1(CIAOPT) ;
 S CIADAT1=$$ENTRY("Start date: ",.CIAOPT,"",0,$Y)
 Q
 ; Prompt for ending date
D2(CIAOPT) ;
 S CIADAT2=$$ENTRY("End date  : ",.CIAOPT,"",0,$Y+1)
 Q
 ; Prompt for a date
ENTRY(%CIAP,%CIAOPT,%CIADAT,%CIAX,%CIAY,%CIATRP,%CIAHLP) ;
 N %CIAD,%CIAI,%CIADT,%CIAZ,%CIADISV
 S %CIAX=$G(%CIAX,$X),%CIAY=$G(%CIAY,$Y),DUZ=+$G(DUZ),DTIME=$G(DTIME,99999999),%CIAOPT=$$UP^XLFSTR($G(%CIAOPT)),%CIADISV=""
 S %CIATRP=$G(%CIATRP),%CIADAT=$G(%CIADAT)
 S:$G(%CIAHLP)="" %CIAHLP="HELP^CIAUDAT"
 S:$G(%CIAP)="" %CIAP="Enter date: "
 F %CIAZ=0:1:9 I %CIAOPT[%CIAZ S %CIADISV="CIADAT"_%CIAZ Q
DAT1 S %CIADT="",@$$TRAP^CIAUOS("DAT1^CIAUDAT")
 F %CIAZ="P","T","F","X" S:%CIAOPT[%CIAZ %CIADT=%CIADT_%CIAZ
 F  D  Q:$D(%CIAI)
 .W $$XY^CIAU(%CIAX,%CIAY)_%CIAP,*27,"[J"
 .S $X=%CIAX+$L(%CIAP)
 .I %CIAOPT["E" S %CIAI=$$ENTRY^CIAUEDT(%CIADAT,79-$X,$X,$Y,"","R")
 .E  I %CIADAT'="" S %CIAI=%CIADAT,%CIADAT=""
 .E  R %CIAI:DTIME
 .I $E(%CIAI)="?" D  Q
 ..W !
 ..I %CIAI["??" D HELP
 ..E  D @%CIAHLP
 ..D PAUSE()
 ..K %CIAI
 .I %CIAI=" " S %CIAI=$S(%CIADISV="":"",1:$G(^DISV(DUZ,%CIADISV))) K:%CIAI="" CIAZ1
 .W $$XY^CIAU(%CIAX+$L(%CIAP),%CIAY),*27,"[K"
 I %CIAI="",%CIATRP'="" S %CIAI=$G(@%CIATRP@(" "))
 S %CIAI=$$UP^XLFSTR(%CIAI),%CIAD=""
 Q:"^^"[%CIAI -$L(%CIAI)
 I %CIATRP'="" D  I %CIAD'="" S %CIAOPT=$TR(%CIAOPT,"I") G DAT2
 .I $D(@%CIATRP@(%CIAI)) S %CIAD=@%CIATRP@(%CIAI)
 .E  D
 ..N X
 ..S X=%CIAI,%CIAZ=""
 ..F  S %CIAZ=$O(@%CIATRP@("?",%CIAZ)) Q:%CIAZ=""  I %CIAI?@%CIAZ D  Q
 ...S %CIAD=$$MSG^CIAU($G(@%CIATRP@("?",%CIAZ)))
 S %CIAI=$$DT^CIAU(%CIAI,%CIADT)
 G:%CIAI=-1 DAT1
 I %CIAOPT["+",%CIAI<$S(%CIAI=%CIAI\1:$$DT^XLFDT,1:$$NOW^XLFDT) D  G DAT1
 .D PAUSE("Must be on or after current date.")
 I %CIAOPT["-",%CIAI>$S(%CIAI=%CIAI\1:$$DT^XLFDT,1:$$NOW^XLFDT) D  G DAT1
 .D PAUSE("Must be on or before current date.")
 S %CIAD=$$ENTRY^CIAUDT(%CIAI)
DAT2 W %CIAD
 S:%CIADISV'="" ^DISV(DUZ,%CIADISV)=%CIAI
 Q $S(%CIAOPT["I":9999999-%CIAI,1:%CIAI)
HELP W ?2,"Enter a valid ",$S(%CIAOPT["+":"future ",%CIAOPT["-":"past ",1:""),"date using one of the following formats:",!!
 W ?5,"Format",?20,"Example",?35,"Explanation",?60,"Comments",!
 W ?5,"------",?20,"-------",?35,"-----------",?60,"--------",!
 W ?5,"mm/dd/yy",?20,"6/20/93",?35,"June 20, 1993",?60,"If you omit the",!
 W ?5,"dd-mmm-yy",?20,"27-JUL-58",?35,"July 27, 1958",?60,"year, the "_$S(%CIAOPT["P":"most",%CIAOPT["F":"closest",1:"current"),!
 W ?5,"mmddyy",?20,"070457",?35,"July 4, 1957",?60,$S(%CIAOPT["P":"recent past date",%CIAOPT["F":"future date",1:"calendar year"),!
 W ?5,"mmm dd yyyy",?20,"JAN 5, 1984",?35,"January 5, 1984",?60,"is assumed.",!
 W ?5,"T-n",?20,"T-5",?35,"Today's date - 5 days.",!!
 Q
PAUSE(%CIAZ) ;
 W $$XY^CIAU(0,22),$G(%CIAZ)
 I $$PAUSE^CIAU
 Q
