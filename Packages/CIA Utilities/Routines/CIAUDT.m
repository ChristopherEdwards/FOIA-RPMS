CIAUDT ;MSC/IND/DKM - FM date to formatted date;04-May-2006 08:19;DKM
 ;;1.2;CIA UTILITIES;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Inputs:
 ;   CIADAT = date to format (DHCP format or $H format)
 ;   CIAFMT = date and time format control (optional)
 ;      xxx0 = dd-mmm-yyyy
 ;      xxx1 = mmm dd,yyyy
 ;      xxx2 = mm/dd/yyyy
 ;      xxx3 = mm-dd-yyyy
 ;      xx0x = hh:mm
 ;      xx1x = hh:mm xx
 ;      x0xx = use space to separate date/time
 ;      x1xx = use @ to separate date/time
 ;      0xxx = allow leading zeros
 ;      1xxx = remove leading zeros
 ; Outputs:
 ;   Returns formatted date
 ;=================================================================
ENTRY(CIADAT,CIAFMT) ; EP
 S CIADAT=$G(CIADAT,$H)
 Q:'CIADAT ""
 N CIAZ1,CIAZ2,CIAZ3,CIAZ4,CIADLM,CIATM
 S:CIADAT?1.N1",".N CIADAT=$$HTFM^XLFDT(CIADAT)
 S CIAFMT=$G(CIAFMT)#100000,CIAFMT=CIAFMT#10000,CIAZ4=CIAFMT\1000,CIAFMT=CIAFMT#1000,CIADLM=$S(CIAFMT>99:"@",1:" "),CIAFMT=CIAFMT#100,CIATM=CIAFMT\10,CIAFMT=CIAFMT#10
 I CIADAT\1 D
 .S CIAZ3=CIADAT\1+17000000,CIAZ1=$E(CIAZ3,7,8),CIAZ2=$E(CIAZ3,5,6),CIAZ3=$E(CIAZ3,1,4)
 .S:CIAZ4 CIAZ1=+CIAZ1,CIAZ2=+CIAZ2
 .S:CIAFMT<2 CIAZ2=$P("Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec",",",CIAZ2)
 .S CIAZ1=$S('CIAFMT:CIAZ1_"-"_CIAZ2_"-"_CIAZ3,CIAFMT=1:CIAZ2_" "_CIAZ1_","_CIAZ3,CIAFMT=2:CIAZ2_"/"_CIAZ1_"/"_CIAZ3,1:CIAZ2_"-"_CIAZ1_"-"_CIAZ3)
 E  S CIAZ1=""
 S CIAZ2=CIADAT#1*10000+10000\1
 I CIAZ2=10000!(CIAZ2>12400) S CIAZ2=""
 E  D
 .S:CIATM CIAZ2=$S(CIAZ2=12400:CIAZ2-1200_" am",CIAZ2>11299:CIAZ2-1200_" pm",CIAZ2>11199:CIAZ2_" pm",CIAZ2<10099:CIAZ2+1200_" am",1:CIAZ2_" am")
 .S CIAZ3=$S(CIAZ4:+$E(CIAZ2,2,3),1:$E(CIAZ2,2,3)),CIAZ2=CIAZ3_":"_$E(CIAZ2,4,8)
 Q CIAZ1_$S('$L(CIAZ2):"",$L(CIAZ1):CIADLM,1:"")_CIAZ2
