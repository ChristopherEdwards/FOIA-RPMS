INHVCRL3 ;KAC ; 8 Jul 95 15:58; Logon Server (LoS) Background Controller (continued)
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
 ;
RUNIN(INUIF,INPARMS,INDSTP,INOA,INODA,INHERR) ; $$function - Execute inbound script.
 ; Script sets up array w/ incoming data and calls lookup/store routine 
 ; for this msg.  Upon return from inbound script execution, logs msg 
 ; status (and any error text) in UNIVERSAL INTERFACE entry for this
 ; inbound msg.
 ;
 ; Input:
 ;   INDSTP   - (opt) INTERFACE DESTINATION IEN for original msg from 
 ;                    UNIVERSAL INTERFACE file
 ;   INHERR   - (pbr) array containing error msg used to log an error
 ;   INOA     - (pbr) array receiving application-specific information 
 ;                    from lookup/store routine
 ;   INODA    - (pbr) array receiving application-specific information 
 ;                    from lookup/store routine
 ;   INPARMS  - (opt) inbound msg parameter array
 ;                    INPARMS(INDSTP,"SCIN") = script # for inbound msg 
 ;                                             transaction type
 ;   INUIF    - (req) UNIVERSAL INTERFACE IEN for inbound msg
 ;
 ; Variables:
 ;   INERRSCR - flag - 0 = script executed w/out error
 ;                    >0 = script encountered errors during execution
 ;   INSTATUS - flag - UNIVERSAL INTERFACE file message status
 ;   C,Z      - scratch
 ;
 ; Output:
 ;   0 = script executed w/out error
 ;  >0 = script encountered errors during execution
 ;       e.g. failed input transform, required data is missing
 ;       INHERR = error msg
 ;
 N C,INERRSCR,INSTATUS,Z
 S C=","
 ;
 ; Get parameters associated with inbound msg (INUIF)
 Q:$$INPARMS^INHVCRL2(.INDSTP,.INPARMS,.INHERR,INUIF) 2
 ;
 ; Execute inbound script
 S Z="S INERRSCR=$$^IS"_$E(INPARMS(INDSTP,"SCIN")#100000+100000,2,6)_"("_INUIF_",.INOA,.INODA)"
 X Z
 ;
 ; Log msg status (and any error text) in UNIVERSAL INTERFACE entry
 ; for this inbound msg.  Script returns error msg text in INHERR if 
 ; script or lookup/store routine encounters error(s).
 S INSTATUS=$S(INERRSCR:"E",1:"C") ; E=error, C=Complete
 D ULOG^INHU(INUIF,INSTATUS,.INHERR) ; log msg status
 Q INERRSCR
 ;
RUNOUT(INDA,INA,INPARMS,INDSTP,INQUE,UIF,INHERR) ; $$function - Execute 
 ; outbound script.
 ; Script creates new outbound entry in UNIVERSAL INTERFACE file and 
 ; returns the IEN of this entry in the variable, UIF.  Upon return 
 ; from outbound script execution, logs msg status (and any error text) 
 ; in UNIVERSAL INTERFACE entry for this outbound msg.
 ;
 ; Input:
 ;   INA      - (req) array containing information to be sent to an
 ;                    outbound destination
 ;   INDA     - (opt) array containing information to be sent to an
 ;                    outbound destination
 ;                      INDA = IEN in base file used by outbound script
 ;                      Subscripts may hold subfile IENs in the format:
 ;                        INDA(subfile #,DA)=""
 ;                    If NOT passed, set to -1 prior to running outbound
 ;                    script.
 ;   INDSTP   - (req) INTERFACE DESTINATION IEN for original msg from 
 ;                    UNIVERSAL INTERFACE file
 ;   INHERR   - (pbr) array containing error msg used to log an error
 ;   INPARMS  - (req) inbound msg parameter array
 ;                    INPARMS(INDSTP,"DSOUT") = INTERFACE DESTINATION IEN
 ;                                              for outbound msg 
 ;                    INPARMS(INDSTP,"SCOUT") = script # for outbound 
 ;                                              msg transaction type
 ;                    INPARMS(INDSTP,"TTOUT") = INTERFACE TRANSACTION TYPE
 ;                                              IEN for outbound msg 
 ;                                              
 ;   INQUE    - (opt) flag - 1 = do NOT queue outbound msg to o/p ctlr
 ;                         - 0 = queue outbound msg to o/p ctlr
 ;   UIF      - (pbr) UNIVERSAL INTERFACE IEN for new outbound entry
 ;                    Returned by outbound script.
 ;
 ; Variables:
 ;   INERRSCR - flag - 0 = script executed w/out error
 ;                    >0 = script encountered errors during execution
 ;   Z        - scratch
 ;
 ; Output:
 ;   0 = script executed w/out error
 ;  >0 = script encountered errors during execution
 ;       e.g. UIF creation failed
 ;       INERR = error msg
 ;
 N DA,DIE,DR,DIC,INERRSCR,Z
 ;
 S:'$L($G(INDA)) INDA=-1
 S Z="S INERRSCR=$$^IS"_$E(INPARMS(INDSTP,"SCOUT")#100000+100000,2,6)_"("_INPARMS(INDSTP,"TTOUT")_",.INDA,.INA,"_INPARMS(INDSTP,"DSOUT")_","_$G(INQUE)_")"
 X Z
 I $G(UIF)<0 S UIF="" Q INERRSCR  ; failed to created UIF entry
 ;
 ; Log msg status (and any error text) in UNIVERSAL INTERFACE entry
 ; for this outbound msg.  Script returns error msg text in INHERR if 
 ; script routine encounters error(s).
 S INSTATUS=$S(INERRSCR:"E",$P(^INTHU(UIF,0),U,4):"S",1:"C")
 D ULOG^INHU(UIF,INSTATUS,.INHERR) ; log msg status
 Q INERRSCR
 ;
