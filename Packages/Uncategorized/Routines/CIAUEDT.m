CIAUEDT ;MSC/IND/DKM - Screen-oriented line editor;14-Aug-2006 09:35;DKM
 ;;1.2;CIA UTILITIES;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Inputs:
 ;   CIADATA  = Data to edit
 ;   CIALEN   = Maximum length of data
 ;   CIAX     = Starting column position
 ;   CIAY     = Starting row position
 ;   CIAVALD  = List of valid inputs (optional)
 ;   CIADISV  = DISV node to save under (optional)
 ;   CIATERM  = Valid input terminators (default=<CR>)
 ;   CIAABRT  = Valid input abort characters (default=none)
 ;   CIARM    = Right margin setting (default=IOM or 80)
 ;   CIAQUIT  = Exit code (returned)
 ;   CIAOPT   = Input options
 ;      C = Mark <CR> with ~
 ;      E = Echo off
 ;      H = Horizontal scroll
 ;      I = No timeout
 ;      L = Lowercase only
 ;      O = Overwrite mode
 ;      Q = Quiet mode
 ;      R = Reverse video
 ;      T = Auto-terminate
 ;      U = Uppercase only
 ;      V = Up/down cursor keys terminate input
 ;      X = Suppress auto-erase
 ; Outputs:
 ;   Return value = Edited data
 ;=================================================================
ENTRY(CIADATA,CIALEN,CIAX,CIAY,CIAVALD,CIAOPT,CIADISV,CIATERM,CIAABRT,CIARM,CIAQUIT) ;
 N CIAZ,CIAZ1,CIAZ2,CIASAVE,CIAINS,CIAAE,CIABUF,CIATAB,CIAPOS,CIAEON,CIALEFT,CIABEL,CIAMAX,CIARVON,CIARVOFF,CIAC,CIAW
 S CIAVALD=$G(CIAVALD),CIAOPT=$$UP^XLFSTR($G(CIAOPT)),CIABEL=$S(CIAOPT'["Q":$C(7),1:""),CIADISV=$G(CIADISV)
 S:$G(CIATERM)="" CIATERM=$C(13)                                         ; Valid line terminators
 S CIAABRT=$G(CIAABRT)                                                   ; Valid input abort keys
 S CIARVON=$C(27,91,55,109),CIARVOFF=$C(27,91,109)                       ; Reverse video control
 S CIAINS=CIAOPT'["O"                                                    ; Default mode = insert
 S CIAAE=CIAOPT'["X"                                                     ; Auto-erase option
 S CIAEON=CIAOPT'["E"                                                    ; No echo option
 I CIAOPT["I"!'$D(DTIME) N DTIME S DTIME=99999999                        ; Suppress timeout option
 S CIABUF=""
 S CIARM=$G(CIARM,$G(IOM,80))                                            ; Display width
 S CIATAB=$C(9)                                                         ; Tab character
 S CIAX=$G(CIAX,$X),CIAY=$G(CIAY,$Y),CIAW=CIARM-CIAX
 S:CIAW'>0 CIAW=1
 S:'$G(CIALEN) CIALEN=CIAW                                                ; Default field width
 S CIAMAX=$S(CIAOPT["H":250,1:CIALEN)                                     ; Maximum data length
 S (CIASAVE,CIADATA)=$E($G(CIADATA),1,CIAMAX)                              ; Truncate data if too long
 I $$NEWERR^%ZTER N $ET S $ET=""
 S @$$TRAP^CIAUOS("ERROR^CIAUEDT")
 D RM^CIAUOS(0)
 X ^%ZOSF("EOFF")
 F  Q:CIADATA'[CIATAB  S CIAZ=$P(CIADATA,CIATAB),CIADATA=CIAZ_$J("",8-($L(CIAZ)#8))_$P(CIADATA,CIATAB,2,999)
RESTART D RESET
AGAIN F CIAQUIT=0:0 Q:CIAQUIT  D NXT S CIAAE=0
 X ^%ZOSF("EON")
 W $$XY^CIAU(CIAX,CIAY),$S(CIAOPT["R":CIARVOFF,1:"")
 I CIADISV'="" Q:"^^"[CIADATA CIADATA S:CIADATA=" " CIADATA=$G(^DISV(DUZ,CIADISV))
 S:CIADISV'="" ^DISV(DUZ,CIADISV)=CIADATA
 Q CIADATA                                                              ; Return to calling routine
NXT D POSCUR()                                                            ; Position cursor
 R *CIAC:DTIME                                                          ; Next character typed
 I CIAC=27 D ESC Q:'CIAC
 I CIAC<1!(CIAABRT[$C(CIAC)) S CIADATA=U,CIAQUIT=1 Q
 I CIATERM[$C(CIAC) D TERM Q
 I CIAC<28 D:CIAC'=27 @("CTL"_$C(CIAC+64)) Q
 I CIAC=127!(CIAC=240) D CTLH Q
 I CIAC>64,CIAC<91,CIAOPT["L" S CIAC=CIAC+32
 E  I CIAC>96,CIAC<123,CIAOPT["U" S CIAC=CIAC-32
 I $L(CIAVALD),CIAVALD'[$C(CIAC) D RAISE^CIAUOS()
 D:CIAAE CTLK,POSCUR()                                                  ; Erase buffer if auto erase on
 D INSW($C(CIAC))
 S CIAQUIT=CIAPOS=CIALEN&(CIAOPT["T")
 Q
CTLA S CIAINS='CIAINS                                                        ; Toggle insert mode
 Q
CTLB D MOVETO(0)                                                           ; Move cursor to beginning
 Q
CTLX S CIADATA=CIASAVE                                                       ; Restore buffer to original
 G RESET
CTLE D MOVETO($L(CIADATA))                                                  ; Move cursor to end
 Q
CTLI D INSW($J("",8-(CIAPOS#8)))                                            ; Insert expanded tab
 Q
CTLJ F CIAZ=CIAPOS:-1:1 Q:$A(CIADATA,CIAZ)'=32                                     ; Find previous nonspace
 F CIAZ=CIAZ:-1:1 Q:$A(CIADATA,CIAZ)=32                                          ; Find previous space
 S CIABUF=$E(CIADATA,CIAZ,CIAPOS)                                            ; Save deleted portion
 S CIADATA=$E(CIADATA,1,CIAZ-1)_$E(CIADATA,CIAPOS+1,CIALEN)                    ; Remove word
 D MOVETO(CIAZ-1)
 Q
CTLK S CIABUF=CIADATA                                                        ; Save buffer
 S CIADATA=""                                                           ; Erase buffer
 D RESET
 Q
CTLL S CIABUF=$E(CIADATA,CIAPOS+1,CIALEN)                                      ; Save deleted portion
 S CIADATA=$E(CIADATA,1,CIAPOS)                                           ; Truncate at current position
 D DSPLY(CIAPOS)
 Q
CTLM D POSCUR(CIAPOS),INSW("~"):CIAOPT["C",MOVETO(CIAPOS-$X+CIAX+CIAW)
 Q
CTLR D INSW(CIABUF)                                                         ; Insert at current position
 Q
CTLT D CTLL
 Q
CTLU S CIABUF=$E(CIADATA,1,CIAPOS)                                            ; Save deleted portion
 S CIADATA=$E(CIADATA,CIAPOS+1,CIALEN)                                     ; Remove to left of cursor
 D RESET
 Q
CTLH I 'CIAPOS W CIABEL Q
 D LEFT
CTLD S CIADATA=$E(CIADATA,1,CIAPOS)_$E(CIADATA,CIAPOS+2,CIAMAX)                  ; Delete character to left
 D DSPLY(CIAPOS,1)
 Q
TERM S CIAQUIT=2
 Q
ESC R *CIAZ:1
 R:CIAZ>0 *CIAZ:1
 S CIAC=0
 G UP:CIAZ=65,DOWN:CIAZ=66,RIGHT:CIAZ=67,LEFT:CIAZ=68                              ;Execute code
 S CIAC=27
 Q
DSPLY(CIAP1,CIAP2) ;
 Q:'CIAEON                                                              ; Refresh buffer display starting at position CIAP1
 N CIAZ,CIAZ1
 S CIAP1=+$G(CIAP1,CIALEFT),CIAZ=$E(CIADATA,CIAP1+1,CIALEFT+CIALEN),CIAP2=$S($D(CIAP2):CIAP2+$L(CIAZ),1:CIALEN-CIAP1+CIALEFT)
 S:CIAP2>CIALEN CIAP2=CIALEN
 S CIAZ=CIAZ_$J("",CIAP2-$L(CIAZ))
 F  D  Q:CIAZ=""
 .D POSCUR(CIAP1)
 .S CIAZ1=CIARM-$X
 .S:CIAZ1<1 CIAZ1=1
 .W $E(CIAZ,1,CIAZ1)
 .S CIAZ=$E(CIAZ,CIAZ1+1,999),CIAP1=CIAP1+CIAZ1
 Q
INSW(CIATXT) ;
 S:CIAPOS>$L(CIADATA) CIADATA=CIADATA_$J("",CIAPOS-$L(CIADATA))              ; Pad if past end of buffer
 S CIADATA=$E($E(CIADATA,1,CIAPOS)_CIATXT_$E(CIADATA,CIAPOS+2-CIAINS,CIAMAX),1,CIAMAX)
 D DSPLY(CIAPOS,0),MOVETO(CIAPOS+$L(CIATXT))
 Q
POSCUR(CIAP) ;
 N CIAZX,CIAZY
 S CIAP=+$G(CIAP,CIAPOS),CIAZX=CIAP-CIALEFT,CIAZY=CIAZX\CIAW+CIAY,CIAZX=CIAZX#CIAW+CIAX
 W $$XY^CIAU(CIAZX,CIAZY)
 Q
MOVETO(CIAP) ;
 I CIAP>CIAMAX!(CIAP<0) W CIABEL Q
 S CIAPOS=CIAP,CIAP=CIALEFT
 S:CIAPOS<CIALEFT CIALEFT=CIAPOS-CIAW-1
 S:CIALEFT+CIALEN<CIAPOS CIALEFT=CIAPOS-CIAW+1
 S:CIALEFT'<CIAMAX CIALEFT=CIAMAX-CIAW
 S:CIALEFT<0 CIALEFT=0
 D DSPLY():CIALEFT'=CIAP,POSCUR()
 Q
UP I CIAOPT["V" S CIAQUIT=3
 E  D MOVETO(CIAPOS-CIAW)
 Q
DOWN I CIAOPT["V" S CIAQUIT=4
 E  D MOVETO(CIAPOS+CIAW)
 Q
RIGHT D MOVETO(CIAPOS+1)
 Q
LEFT D MOVETO(CIAPOS-1)
 Q
RESET W $S(CIAOPT["R":CIARVON,1:CIARVOFF)
 S (CIAPOS,CIALEFT)=0                                                    ; Current edit offset
 D DSPLY()                                                             ; Refresh display
 Q
ERROR W CIABEL                                                               ; Sound bell
 S @$$TRAP^CIAUOS("ERROR^CIAUEDT")
 G AGAIN
