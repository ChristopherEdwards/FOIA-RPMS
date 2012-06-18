XBDIE(XBRET) ; IHS/ADC/GTH - NESTING OF DIE ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; Thanks to Paul Wesley, DSD, for providing the original
 ; routine.
 ;
 ; PROGRAMMERS NOTE:  PLEASE USE THE MORE GENERIC ^XBNEW.
 ;
 ; XBRET has the form "TAG^ROUTINE:VAR,NSVAR*"
 ; This allows for the nesting of die calls by
 ;
 ; 1. Building and executing an exclusive new from preselected
 ;    kernel variables and any local variables &/or name
 ;    spaces identified by the calling parameter.
 ; 2. After executing the new (....) XBDIE performs a DO call
 ;    to the program entry point identified by the calling
 ;    parameter. The entry point passed should build the
 ;    variables and execute the DIE call to be nested.
 ; 3. As XBDIE quits to return to the calling program it pops
 ;    the variable stack.
 ;
 ; The passing parameter is built by "tag^routine:var;vns*"
 ;
 ; The die call to be nested is structured with a tag entry
 ; and a Quit.
 ;
 ; The call is made with DO ^XBDIE("TAG^ROUTINE:AGSITE,ABM*")
 ; where the variable AGSITE and the namespace ABM is
 ; included in the exclusive new for illustration.
 ;
 ; Proper logic flow after the XBDIE call usually needs some
 ; attention.
 ;
 ; A TEST entry point is provided in this routine for
 ; illustration.
 ;
S ;
 I XBRET'[":" S XBRET=XBRET_":"
 S XBN="XBRET"
 S XBKVAR=$P($T(XBKVAR),";;",2)
 S XBNS=$P(XBRET,":",2)
 I XBNS="" G RETURN
 F XBI=1:1 S (XB,XBY)=$P(XBNS,";",XBI) Q:XB=""  D
 .I XB'["*" S XBN=XBN_","_XB Q
 .S (XB,XBY)=$P(XB,"*")
 .S XBN=XBN_","_XB,XBL=$L(XB)
 .F  S XBY=$O(@XBY) Q:((XBY="")!(XB'=$E(XBY,1,XBL)))  S XBN=XBN_","_XBY
 .Q
RETURN ;
 S XBN="("_XBN_","_XBKVAR_")"
 S $P(XBRET,":",2)=XBN
 KILL XBNS,XBN,XB,XBY,XBL,XBKVAR
 NEW @($P(XBRET,":",2))
 D @($P(XBRET,":",1))
 Q
 ;
END ;--------------------------------------------------------------
XBKVAR ;;DUZ,DTIME,DT,DISYS,IO,IOF,IOBS,IOM,ION,IOSL,IOST,IOT,IOS,IOXY,U,XRTL,ZTSTOP,ZTQUEUED,ZTREQ
 ;-------------------------------------------------------------- 
 Q
 ;
TEST ;    
 D ^XBDIE("T2^XBDIE:AG;PW")
 Q
 ;
T2 ;
 W !,"GOT TO T2",!
 W !,"Here is where the die call would be structured and called",!,"Following is a list of variables that were within the exclusive new",!
 D ^XBVL
 Q
 ;
