ABSPOSAA ; IHS/FCS/DRS - JWS, ;   [ 09/12/2002  10:05 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 Q
 ;  $$CONNECT(DIALOUT)  - initialize modem and dial 
 ;  Called from ABSPOSAQ from ABSPOSAM
 ;  Various errors can be returned
 ;  Future:  put a field in the 9002313.55 record to put these
 ;   stages as you progress through establishing the connection.
 ;  Future:  tap into that field when constructing display message
 ;   for the data entry / status display screen.
 ;   That is, show more than just "Waiting to transmit" - show
 ;   it going through stages like "Initializing modem",
 ;   "Dialing", "Waiting for remote connect", etc.
 ;   And tack on "Failed while " in front, when something goes wrong.
 ;
CONNECT(DIALOUT) ;EP - 
 ; Open the device 
 N RET
 S RET=$$OPEN^ABSPOSAB(DIALOUT)
 I RET Q 20999_",OPEN^ABSPOSAB(),"_RET
 S RET=$$STATUS(DIALOUT) I RET Q "20998,STATUS^"_$T(+0)_","_RET_",0"
 ;
 ;Flush input buffer
 S RET=$$FLUSH^ABSPOSAB(DIALOUT)
 I RET Q 20997_",FLUSH^ABSPOSAB(),"_RET_",1"
 S RET=$$STATUS(DIALOUT) I RET Q "20998,STATUS^"_$T(+0)_","_RET_",1"
 ;
 ; if it's a direct T1 line connection, we are done - return success
 ;
 I $$T1DIRECT^ABSPOSA(DIALOUT) Q 0
 ;
 ; First, ATZ command to reset the modem
 ; And flush the buffer, too.
 S RET=$$ATZ^ABSPOSAB(DIALOUT)
 I RET Q 20008_",ATZ^ABSPOSAB(),"_RET
 S RET=$$STATUS(DIALOUT) I RET Q "20998,STATUS^"_$T(+0)_","_RET_",2"
 S RET=$$FLUSH^ABSPOSAB(DIALOUT)
 I RET Q 20997_",FLUSH^ABSPOSAB(),"_RET_",2"
 S RET=$$STATUS(DIALOUT) I RET Q "20998,STATUS^"_$T(+0)_","_RET_",3"
 ;
 ; Then send the initialization string, and flush
 ;
 S RET=$$INIMODEM^ABSPOSAB(DIALOUT)
 I RET Q 20009_",INIMODEM^ABSPOSAB(),"_RET
 S RET=$$STATUS(DIALOUT) I RET Q "20998,STATUS^"_$T(+0)_","_RET_",4"
 S RET=$$FLUSH^ABSPOSAB(DIALOUT)
 I RET Q 20997_",FLUSH^ABSPOSAB(),"_RET_",3"
 S RET=$$STATUS(DIALOUT) I RET Q "20998,STATUS^"_$T(+0)_","_RET_",5"
 ;
 ; Diagnostics: query the modem for its status
 ;
 S RET=$$MODEMSTS^ABSPOSAB(DIALOUT)
 I RET Q 20997_",MODEMSTS^ABSPOSAB(),"_RET_",31"
 S RET=$$STATUS(DIALOUT) I RET Q "20998,STATUS^"_$T(+0)_","_RET_",32"
 S RET=$$FLUSH^ABSPOSAB(DIALOUT)
 I RET Q 20997_",FLUSH^ABSPOSAB(),"_RET_",31"
 S RET=$$STATUS(DIALOUT) I RET Q "20998,STATUS^"_$T(+0)_","_RET_",33"
 ;
 ; Now we can dial the phone, and flush
 ;
 S RET=$$DIAL^ABSPOSAB(DIALOUT)
 I RET Q 20010_",DIAL^ABSPOSAB(),"_RET
 S RET=$$STATUS(DIALOUT) I RET Q "20998,STATUS^"_$T(+0)_","_RET_",6"
 S RET=$$FLUSH^ABSPOSAB(DIALOUT)
 I RET Q 20997_",FLUSH^ABSPOSAB(),"_RET_",4"
 S RET=$$STATUS(DIALOUT) I RET Q "20998,STATUS^"_$T(+0)_","_RET_",7"
 Q 0
 ;
STATUS(DIALOUT) ;check status of IO
 ;  Always returns 0 (OK) for direct-connect Modem.
 ; Returns $ZB value for terminal server.
 ; Development:  $$STATRPT^ABSPOSAZ, $$GETSTAT^ABSPOSAZ may be useful
 ;
 I '$$TCP^ABSPOSA(DIALOUT) Q 0 ; relevant only to term server and T1
 ; if last operation timed out (-3), that's okay
 ; maybe we should also skim past "end of input" (-1), too
 N IO S IO=$$IO^ABSPOSA(DIALOUT)
 U IO N ZB S ZB=$ZB S:ZB=-3 ZB=0 Q ZB
