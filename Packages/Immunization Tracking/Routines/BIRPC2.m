BIRPC2 ;IHS/CMI/MWR - REMOTE PROCEDURE CALLS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  RETURNS LISTS OF VACCINES, LOT NUMBERS, LOCATIONS FOR SELECTION.
 ;
 ;
 ;----------
VACNAMS(BIGBL) ;EP
 ;---> Return list of available Vaccine Names delimited by
 ;---> "^" into 4 pieces:
 ;--->   1 - IEN of Vaccine Name.
 ;--->   2 - Vaccine Name Short in IMMUNIZATION File #9999999.14.
 ;--->   3 - Default Lot Number for this vaccine.
 ;--->   4 - Maximum Dose# for the vaccine.
 ;
 ;---> Parameters:
 ;     1 - BIGBL  (ret) Result global for Broker (last node=||error).
 ;
 ;---> Generic Fileman file Lookup.  (Can be called from client side.)
 N A,B,C,D,E,F,G
 S BIGBL=""
 ;
 S A=9999999.14                   ;Immunization Table File.
 S B=".02;.04;.05"                ;Fields to return w/each entry.
 ;                                ;   IEN;Short Name;Default Lot#;
 ;                                ;   Max in Vaccine Group (Series).
 S BIINPUT=""                     ;Retrieve all.
 S C=""                           ;Flags for lookup.
 S D=""                           ;Max number of entries (*=all).
 S E="B"                          ;Indexes to search.
 S F="I '$P(^AUTTIMM(Y,0),U,7)"   ;Screen (Eliminate "Inactives".)
 ;
 D LOOKUP^BIXRPC(.BIGBL,A,B,C,BIINPUT,D,E,F)
 Q
 ;
 ;
 ;----------
LOTNUMS(BIGBL,BIVAC) ;EP
 ;---> Return list of available Lot Numbers for the Vaccine passed.
 ;---> Delimited by "^" into 2 pieces:
 ;--->   1 - IEN of Lot Number.
 ;--->   2 - Lot Number (text).
 ;
 ;---> Parameters:
 ;     1 - BIGBL  (ret) Result global for Broker (last node=||error).
 ;     2 - BIVAC  (req) IEN of the Vaccine to match Lot Number on.
 ;
 S BIGBL=""
 ;
 ;---> If Vaccine IEN not provided, set Error Code and quit.
 I '$G(BIVAC) D  Q
 .N BIERR S BIERR=""
 .;---> Get text of Error Code.
 .D ERRCD^BIUTL2(502,.BIERR)
 .;---> Set error text in temp global and quit.
 .D PASSERR^BIXRPC(.BIGBL,BIERR)
 ;
 ;---> Generic Fileman file Lookup.  (Can be called from client side.)
 N A,B,C,D,E,F,G
 ;
 S A=9999999.41                         ;Immunization Lot Number file.
 S B=".01;.02"                          ;Fields to return w/each entry.
 ;                                      ;   IEN;Lot Number;Manufacturer
 S BIINPUT=""                           ;Retrieve all.
 S C=""                                 ;Flags for lookup.
 S D=""                                 ;Max number of entries (*=all).
 S E=""                                 ;Indexes to search.
 ;                                      ;Only ACTIVE Lot Numbers for
 ;                                      ;the Vaccine provided.
 S F="I $P(^AUTTIML(Y,0),U,3),$P(^(0),U,4)="_BIVAC
 ;
 D LOOKUP^BIXRPC(.BIGBL,A,B,C,BIINPUT,D,E,F)
 Q
 ;
 ;
 ;----------
LOCATION(BIGBL,BIINPUT) ;EP
 ;---> Return list of available Locations for an Immunization visit.
 ;---> in the global @BIGBL.  Each matching entry has a node in
 ;---> in @BIGBL.  The last node contains the error delimiter
 ;---> BI31 and an error (text) if one exists.
 ;
 ;---> Parameters:
 ;     1 - BIGBL   (ret) Result global for Broker (last node=||error).
 ;     2 - BIINPUT (opt) Input string to match Location on.
 ;
 ;---> Generic Fileman file Lookup.  (Can be called from client side.)
 N A,B,C,D,E,F,G
 ;
 S A=9999999.06                   ;IHS Location File.
 S B=".01;.04;.05;.07"            ;Fields to return w/each entry.
 ;                                ;Return value for each entry:
 ;                                ;   IEN;Name;State;Service Unit;Code
 S C="M"                          ;Flags for lookup.
 S D="20"                         ;Max number of entries (*=all).
 S E="B^C^D"                      ;Indexes to search.
 S F="I '$P(^AUTTLOC(Y,0),U,21)"  ;Screen (Eliminate "Inactives".)
 S G=1                            ;Mixed Case: 1=mixed, 0=no change
 ;
 D LOOKUP^BIXRPC(.BIGBL,A,B,C,BIINPUT,D,E,F,G)
 Q
